# preparation of asymmetrically inserted NP initial configuration

# Input parameters
ATOM_SEL="SAU"
ATOM_PULL="OS3"
NP="mus-2nm-checkerboard"
LIGAND=${NP%%-*}
LIPID="DOPC"
INIT="${LIGAND}-2nm-sym"
SYS="${LIGAND}-2nm-asym"
NORM_LENGTH=2.5

# Setup case directory
CASENAME="${SYS}-init"
mkdir $CASENAME
cd $CASENAME

# Copy necessary files
cp ../includes/minim.mdp .
cp ../includes/gromos*itp .
cp ../includes/$INIT.gro $SYS.gro 
cp ../includes/gromos-mus-2nm-checkerboard.itp .
cp ../includes/pull_eq_np_taut.mdp .

# Create index
make_ndx -f $SYS -o system.ndx<<EOF
keep 0
r AU
name 1 Gold
a SAU
name 2 Thiols
r DOPC
name 3 Lipids
r AU MUS
name 4 NP
r SOL NA
name 5 Solvent
q
EOF

# Topology file
cat > system.top<<EOF
#include "gromos_54a7.itp"
#include "gromos_54a7_ions.itp"
#include "gromos_54a7_spc.itp"
#include "gromos_54a7_${LIPID,,}.itp"
#include "gromos-mus-2nm-checkerboard.itp"

[ system ]
${NP} through ${LIPID,,} bilayer

[ molecules ]
AUNP    1
EOF
NLIPIDS=$(tail -n+2 $SYS.gro | grep "$LIPID" | awk '{print $1}' | uniq | wc -l)
NSOL=$(tail -n+2 $SYS.gro | grep "SOL" | awk '{print $1}' | uniq | wc -l)
NNA=$(tail -n+2 $SYS.gro | grep "NA" | awk '{print $1}' | uniq | wc -l)
echo "$LIPID   $NLIPIDS " >> system.top
echo "SOL    $NSOL" >> system.top
echo "NA    $NNA" >> system.top

# Lipid COM_z
grompp -f minim.mdp -c $SYS.gro -p system.top -n system.ndx -o dummy.tpr
g_traj -com -f $SYS.gro -s dummy.tpr -n system.ndx -ox lipids.xvg<<EOF
Lipids
EOF
LIPID_COM_z=$(cat lipids.xvg | tail -n1 | awk '{print $4}')

# Upper leaflet head COM_z (upper limit of pull. Lower limit is the initial position of Oxygen)
g_select -f $SYS.gro -select "name P and z > ${LIPID_COM_z}" -s dummy.tpr -on u-leaflet-heads.ndx
trjconv -f $SYS.gro -s dummy.tpr -n u-leaflet-heads.ndx -o u-leaflet-heads.gro
# Calculate highest Z point to pull to.(highest initial configuration)
n_z=$(cat u-leaflet-heads.gro | tail -n+3 | head -n-1 | wc -l)
sum=$(cat u-leaflet-heads.gro | tail -n+3 | head -n-1 | awk '{ sum += $6 } END {print sum}')
MAX_z=$(echo "$sum * 10 / $n_z" | bc -l)
#subtract z value for DOPC bilayer
MAX_z=$(echo "$MAX_z - (10*$LIPID_COM_z)" | bc -l)
MAX_z=${MAX_z%.*}
MAX_z=$(echo "$MAX_z / 10" | bc -l)

# Minim system
grompp -f minim.mdp -c $SYS.gro -p system.top -n system.ndx -o solution_em.tpr
mdrun -v -deffnm solution_em
cp solution_em.gro pulling_0_md.gro

cp ../includes/pull_eq_np_init.mdp .
cp ../includes/pull_md_np_init.mdp .
# TODO To select below 2 or above 2 naming conventions
#cp ../includes/eq_init_np.mdp . 
#cp ../includes/md_init_np.mdp .

cat > launch_system.sh <<EOF
#!/bin/bash
#SBATCH -J ${SYS}-init
#SBATCH -o ${SYS}.out
#SBATCH -N 1 
#SBATCH -n 32
#SBATCH -p extended-mem
EOF
cat >> launch_system.sh <<'EOF'
# Pull lower ligands (29 times)(by the oxygen in end group) to upper bilayer.
for i in $(seq 1 50); do 
PREV=$(echo "$i - 1" | bc -l)
# Determining optimal ligand
grompp -f minim.mdp -c pulling_${PREV}_md.gro -p system.top -n system.ndx -o dummy.tpr
g_traj -com -f pulling_${PREV}_md.gro -s dummy.tpr -n system.ndx -ox gold.xvg <<INPUT
Gold
INPUT
NP_COM_z=$(cat gold.xvg | tail -n1 | awk '{print $4}')
g_select -f pulling_${PREV}_md.gro -select "atomname ATOM_SEL and (same residue as (atomname ATOM_PULL and z < ${NP_COM_z}))" -s dummy.tpr -on thiol_sulfurs.ndx
trjconv -f pulling_${PREV}_md.gro -s dummy.tpr -n thiol_sulfurs.ndx -o thiol_sulfurs.gro
# SORT GRO FILE DESCENDING Z VALUE, pick the top
PULL_DETAILS=$(cat thiol_sulfurs.gro | tail -n+3 | head -n-1 | sort -k6 -rn | head -n1)
RESNR_PULL=$(echo ${PULL_DETAILS} | awk '{print $1}')
RESNR_PULL=${RESNR_PULL%LIGAND}

# Calculating normal to the surface of the NP sphere. (COM Vector Thiol - NP)
NP_COM=$(cat gold.xvg | tail -n1)
NP_COM_x=$(echo $NP_COM | awk '{print $2}'); NP_COM_y=$(echo $NP_COM | awk '{print $3}'); NP_COM_z=$(echo $NP_COM | awk '{print $4}')
# TODO COM of THIOL SULFOR 
PULL_COM_x=$(echo $PULL_DETAILS | awk '{print $4}'); PULL_COM_y=$(echo $PULL_DETAILS | awk '{print $5}'); PULL_COM_z=$(echo $PULL_DETAILS | awk '{print $6}')
# Difference between components
NORM_x=$(echo "$PULL_COM_x - $NP_COM_x" | bc -l)
NORM_y=$(echo "$PULL_COM_y - $NP_COM_y" | bc -l)
NORM_z=$(echo "$PULL_COM_z - $NP_COM_z" | bc -l)

sed -i "/pull_init1/c\pull_init1          = NORM_LENGTH" pull_eq_np_taut.mdp
sed -i "/pull_vec1/c\pull_vec1           = $NORM_x $NORM_y $NORM_z" pull_eq_np_taut.mdp

# Pulling 3 oxygens from the end group of ligand
make_ndx -f pulling_${PREV}_md.gro -n system.ndx -o system-current.ndx<<INPUT
a ATOM_PULL & ri ${RESNR_PULL}
name 6 Pull
q
INPUT
echo "[ Upper_Heads ]" >> system-current.ndx
cat u-leaflet-heads.ndx | tail -n+2 >> system-current.ndx

grompp -f pull_eq_np_taut.mdp -c pulling_${PREV}_md -n system-current.ndx -p system.top -o pulling_${i}_taut.tpr
mdrun -v -deffnm pulling_${i}_taut

grompp -f pull_eq_np_init.mdp -c pulling_${i}_taut -n system-current.ndx -p system.top -o pulling_${i}_eq.tpr
mdrun -v -deffnm pulling_${i}_eq

grompp -f pull_md_np_init.mdp -c pulling_${i}_eq -n system-current.ndx -p system.top -o pulling_${i}_md.tpr
mdrun -v -px pullx_${i} -pf pullf_${i}.xvg -deffnm pulling_${i}_md
rm '#'*
rm *.log; rm *.edr; rm *.xtc; rm *.trr
done
EOF

sed -i "s/NORM_LENGTH/${NORM_LENGTH}/g" pull_eq_np_taut.mdp 
sed -i "s/NORM_LENGTH/${NORM_LENGTH}/g" launch_system.sh
sed -i "s/ATOM_SEL/${ATOM_SEL}/g" launch_system.sh
sed -i "s/ATOM_PULL/${ATOM_PULL}/g" launch_system.sh
sed -i "s/LIGAND/${LIGAND^^}/g" launch_system.sh

rm '#'*
