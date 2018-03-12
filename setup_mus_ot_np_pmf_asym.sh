# PMF for symmetrically embedded NP

# Input parameters
ATOM_SEL="SAU"
ATOM_PULL="OS3"

NP="mus-ot-2nm-asym"
LIGAND=${NP%%-*}
LIPID="DOPC"
NLIPID=398
SYS=${LIPID,,}${NLIPID}-ribbon-${NP}

# Setup case directory
CASENAME="${SYS}-pmf"
mkdir $CASENAME
cd $CASENAME

# Copy necessary files
cp ../includes/minim.mdp .
cp ../includes/gromos*itp .
cp ../includes/pull_md_np.mdp .
cp ../includes/pull_eq_np.mdp .
cp ../includes/$SYS.gro .
cp ../includes/$SYS.itp .

# Create index 
make_ndx -f $SYS -o system.ndx<<EOF
keep 0
r AU
name 1 Gold
a SAU
name 2 Thiols
r ${LIPID} 
name 3 Lipids
r AU MUS OT DOPR
name 4 NP
r SOL NA CL
name 5 Solvent
q
EOF

# Topology file
cat > system.top<<EOF
#include "gromos_54a7.itp"
#include "gromos_54a7_ions.itp"
#include "gromos_54a7_spc.itp"
#include "gromos_54a7_${LIPID,,}.itp"
#include "${SYS}.itp"

[ system ]
${NP} through ${LIPID,,} bilayer

[ molecules ]
AUNP    1
EOF
NLIPIDS=$(tail -n+2 $SYS.gro | grep "$LIPID" | awk '{print $1}' | uniq | wc -l)
NSOL=$(tail -n+2 $SYS.gro | grep "SOL" | awk '{print $1}' | uniq | wc -l)
NNA=$(tail -n+2 $SYS.gro | grep "NA" | awk '{print $1}' | uniq | wc -l)
NCL=$(tail -n+2 $SYS.gro | grep "CL" | awk '{print $1}' | uniq | wc -l)
echo "$LIPID    $NLIPIDS " >> system.top
echo "SOL     $NSOL" >> system.top
echo "NA      $NNA" >> system.top
echo "CL      $NCL" >> system.top

# Lipid COM_z
grompp -f minim.mdp -c $SYS.gro -p system.top -n system.ndx -o dummy.tpr
g_traj -com -f $SYS.gro -s dummy.tpr -n system.ndx -ox lipids.xvg<<EOF
Lipids
EOF
LIPID_COM_z=$(cat lipids.xvg | tail -n1 | awk '{print $4}')

# Upper leaflet head COM_z (upper limit of pull. Lower limit is the initial position of Oxygen)
g_select -f $SYS.gro -select "name P and z > ${LIPID_COM_z}" -s dummy.tpr -on u-leaflet-heads.ndx
trjconv -f $SYS.gro -s dummy.tpr -n u-leaflet-heads.ndx -o u-leaflet-heads.gro
echo "[ Upper_Heads ]" >> system.ndx
cat u-leaflet-heads.ndx | tail -n+2 >> system.ndx

# Determining optimal ligand
grompp -f minim.mdp -c $SYS.gro -p system.top -n system.ndx -o dummy.tpr
g_traj -com -f $SYS.gro -s dummy.tpr -n system.ndx -ox gold.xvg<<EOF
Gold
EOF
NP_COM_z=$(cat gold.xvg | tail -n1 | awk '{print $4}')
g_select -f $SYS.gro -select "z < ${NP_COM_z} and atomname ${ATOM_SEL}" -s dummy.tpr -on thiol_sulfurs.ndx
#g_select -f $SYS.gro -select "atomname ${ATOM_SEL} and (same residue as (z < ${NP_COM_z} and atomname ${ATOM_PULL}))" -s dummy.tpr -on thiol_sulfurs.ndx
trjconv -f $SYS.gro -s dummy.tpr -n thiol_sulfurs.ndx -o thiol_sulfurs.gro
# SORT GRO FILE DESCENDING Z VALUE, pick the BOTTOM to pull back down
PULL_DETAILS=$(cat thiol_sulfurs.gro | tail -n+3 | head -n-1 | sort -k6 -rn | sed "/OT/d" | tail -n1)
RESNR_PULL=$(echo ${PULL_DETAILS} | awk '{print $1}')
RESNR_PULL=${RESNR_PULL%${LIGAND^^}}
# Pulling 3 oxygens from the end group of ligand 
make_ndx -f $SYS.gro -n system.ndx -o system.ndx<<EOF
a ${ATOM_PULL} & ri ${RESNR_PULL}
name 7 Pull
q
EOF

# Energy minimisation
grompp -f minim.mdp -c $SYS.gro -p system.top -n system.ndx -o solution_em
mdrun -v -deffnm solution_em

# Setup umbrella sampling simulations 
for i in $(seq 0 20); do
INIT1=$(echo "${i} * 0.1" | bc -l)

cp pull_eq_np.mdp pull_eq_np_${i}.mdp
cp pull_md_np.mdp pull_md_np_${i}.mdp
sed -i -e "s/TBD/$INIT1/g" pull_eq_np_${i}.mdp
sed -i -e "s/TBD/$INIT1/g" pull_md_np_${i}.mdp

cat > launch_pulling_${i}.sh <<EOF
#!/bin/bash
#SBATCH -J ${i}-${SYS}
#SBATCH -o pmf-${i}.out
#SBATCH -N 1
#SBATCH -n 8
#SBATCH -p extended-mem

grompp -f pull_eq_np_${i}.mdp -c solution_em.gro -p system.top -n system.ndx -o pulling_${i}_eq.tpr -maxwarn 1
mdrun -v -deffnm pulling_${i}_eq -cpi pulling_${i}_eq.cpt

grompp -f pull_md_np_${i}.mdp -c pulling_${i}_eq.gro -p system.top -n system.ndx -o pulling_${i}_md.tpr -maxwarn 1
mdrun -v -pf pullf_${i}.xvg -px pullx_${i}.xvg -deffnm pulling_${i}_md -cpi pulling_${i}_md.cpt

EOF
done
