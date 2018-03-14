# PMF for small molecule permeation through lipid bilayer

# Input parameters
MOL=$1
MOL_Z=8
LIPID="DOPC"
SIZE=large #LARGE OR SMALL

# Setup case directory 
CASENAME="${MOL}-mol-pmf-${SIZE,,}"
mkdir $CASENAME
cd $CASENAME

# Copy over required files
cp ../includes/gromos*itp .
# Can switch from -s and -l. 128 to 254 lipids.
cp ../includes/dopc-bilayer-${SIZE:0:1}.gro ./bilayer.gro
cp ../includes/${MOL}.gro .
cp ../includes/${MOL}.itp .
cp ../includes/minim.mdp .
cp ../includes/pull_eq.mdp .
cp ../includes/pull_md.mdp .

# Figure out resname of molecule
RESNAME=$(grep "moleculetype" ${MOL}.itp -A 2 | tail -n 1 | awk '{print $1}')

# Setup system (small molecule over membrane)
BOX_X=$(tail -n 1 bilayer.gro | awk '{print $1}') 
BOX_Y=$(tail -n 1 bilayer.gro | awk '{print $2}') 
BOX_Z=$(tail -n 1 bilayer.gro | awk '{print $3}') 
MOL_X=$(echo "$BOX_X / 2" | bc -l)
MOL_Y=$(echo "$BOX_Y / 2" | bc -l)
echo "mol over bilayer" > merged.gro
editconf -f ${MOL}.gro -o mol.gro -box $BOX_X $BOX_Y $BOX_Z -center $MOL_X $MOL_Y $MOL_Z
cat mol.gro | tail -n+3 | head -n-1 >> merged.gro
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

# If CA or NA, need to delete include itp file. Avoiding redefining moleculetype
if [ $RESNAME = "CA" ] || [ $RESNAME = "NA" ]; then
sed -i "/${RESNAME,,}.itp/d" solution.top
fi 

# Add counterions
grompp -f minim.mdp -c merged.gro -p solution.top -o dummy
genion -s dummy.tpr -o merged.gro -p solution.top -pname NA -nname CL -neutral <<INPUT
SOL
INPUT

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
#SBATCH -J ${i}-${SIZE:0:1}-${RESNAME}
#SBATCH -o pmf-${i}.out
#SBATCH -N 1
#SBATCH -n 8 
#SBATCH -p extended-mem 

grompp -f pull_eq_${i}.mdp -c solution_em.gro -n solution.ndx -p solution.top -o pulling_${i}_eq -maxwarn 1 
mdrun -v -deffnm pulling_${i}_eq

grompp -f pull_md_${i}.mdp -c pulling_${i}_eq.gro -n solution.ndx -p solution.top -o pulling_${i}_md -maxwarn 1 
mdrun -v -pf pullf_${i}.xvg -px pullx_${i}.xvg -deffnm pulling_${i}_md -cpi pulling_${i}_md.cpt

INPUT
done

# Clean up
rm step*pdb
rm \#*
