# PMF for small molecule permeation through lipid bilayer

# Input parameters
MOL=$1
MOL_Z=8
LIPID="DOPC"
NCL=1 # Neutralise CA or NA only

# Setup case directory 
CASENAME="${MOL}-mol-pmf"
mkdir $CASENAME
cd $CASENAME

# Copy over required files
cp ../includes/gromos*itp .
cp ../includes/dopc-bilayer.gro ./bilayer.gro
cp ../includes/${MOL}.gro .
cp ../includes/${MOL}.itp .
cp ../includes/minim.mdp .
cp ../includes/pull_eq.mdp .
cp ../includes/pull_md.mdp .

# Figure out resname of molecule
if [ $MOL != "NA" ] && [ $MOL != "CA" ]; then
RESNAME=$(grep "moleculetype" ${MOL}.itp -A 2 | tail -n 1 | awk '{print $1}')
else
RESNAME=$MOL
fi

# Setup system (small molecule over membrane)
BOX_X=$(tail -n 1 bilayer.gro | awk '{print $1}') 
BOX_Y=$(tail -n 1 bilayer.gro | awk '{print $2}') 
BOX_Z=$(tail -n 1 bilayer.gro | awk '{print $3}') 
MOL_X=$(echo "$BOX_X / 2" | bc -l)
MOL_Y=$(echo "$BOX_Y / 2" | bc -l)
echo "mol over bilayer" > merged.gro
if [ $MOL != "NA" ] && [ $MOL != "CA" ]; then
editconf -f ${MOL}.gro -o mol.gro -box $BOX_X $BOX_Y $BOX_Z -center $MOL_X $MOL_Y $MOL_Z
cat mol.gro | tail -n+3 | head -n-1 >> merged.gro
fi
cat bilayer.gro | tail -n+3 >> merged.gro
sed -i "2i $(printf "%5d" "$(echo "$(cat merged.gro | wc -l) - 2" | bc)")" merged.gro
genconf -f merged.gro -o merged.gro -renumber

# Setup topology and index files
NMOL=$(cat merged.gro | awk '{print $1}' | grep $RESNAME | uniq | wc -l)
NLIPID=$(grep ${LIPID} merged.gro | awk '{print $1}' | uniq | wc -l)
NSOL=$(grep SOL merged.gro | awk '{print $1}' | uniq | wc -l)
cat > solution.top <<EOF
#include "gromos_54a7.itp"
#include "gromos_54a7_spc.itp"
#include "gromos_54a7_ions.itp"
#include "gromos_54a7_${LIPID,,}.itp"
#include "${MOL}.itp"

[ system ]
molecule through bilayer

[ molecules ]
$RESNAME    $NMOL
$LIPID      $NLIPID
SOL         $NSOL
EOF

# Add counterions
grompp -f minim.mdp -c merged.gro -p solution.top -o dummy
if [ ${MOL} != "NA" ] && [ ${MOL} != "CA" ]; then
genion -s dummy.tpr -o merged.gro -p solution.top -pname NA -neutral <<INPUT
SOL
INPUT
else
# If NA or CA added, update solution.top manually. (delete line, recount SOL, reorder top file)
genion -s dummy.tpr -o merged.gro -pname $MOL -pq 2 -nname CL -np 1 -nn $NCL <<INPUT
SOL
INPUT
sed -i "/${RESNAME}/d" solution.top
NSOL=$(grep SOL merged.gro | awk '{print $1}' | uniq | wc -l)
sed -i "s/SOL .*/SOL $NSOL/" solution.top
cat >> solution.top <<INPUT
CA     1
CL     $NCL
INPUT
fi

# Generate index file
make_ndx -f merged.gro -o solution.ndx <<EOF
keep 0
r $RESNAME
name 1 Pull
r $LIPID
name 2 Lipids
r $RESNAME SOL NA CL
name 3 Solvent
q
EOF

# Energy minimization
grompp -f minim.mdp -c merged.gro -p solution.top -n solution.ndx -o solution_em
mdrun -v -deffnm solution_em

# Setup umbrella sampling simulations
for i in $(seq 0 35); do
INIT1=$(echo "${i} * 0.1" | bc -l)

cp pull_eq.mdp pull_eq_${i}.mdp
cp pull_md.mdp pull_md_${i}.mdp
sed -i -e "s/TBD/${INIT1}/g" pull_eq_${i}.mdp
sed -i -e "s/TBD/${INIT1}/g" pull_md_${i}.mdp

cat > launch_pulling_${i}.sh <<INPUT
#!/bin/bash
#SBATCH -J ${RESNAME}-${i}
#SBATCH -o pmf-${i}.out
#SBATCH -N 1
#SBATCH -n 8
#SBATCH -p regular-cpu

grompp -f pull_eq_${i}.mdp -c solution_em.gro -n solution.ndx -p solution.top -o pulling_${i}_eq -maxwarn 1 
mdrun -v -deffnm pulling_${i}_eq

grompp -f pull_md_${i}.mdp -c pulling_${i}_eq.gro -n solution.ndx -p solution.top -o pulling_${i}_md -maxwarn 1 
mdrun -v -pf pullf_${i}.xvg -px pullx_${i}.xvg -deffnm pulling_${i}_md

rm \#*
INPUT
done

# Clean up
rm step*pdb
rm \#*
