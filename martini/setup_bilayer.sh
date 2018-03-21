# Prepares Dry Martini Bilayer of DOPC
CASENAME=bilayer
SIZE=10
CASENAME=$CASENAME-$SIZE
mkdir $CASENAME
cd $CASENAME
cp ../includes/dry_martini*.itp .
cp ../includes/minim.mdp .
cp ../includes/dry_martini_bilayer_*eq.mdp .
cp ../includes/template_sd.mdp .

python ../includes/insane.py -l DOPC -x $SIZE -y $SIZE -z $SIZE -d 0 -pbc cubic -sol W -o lipids.gro
sed -i "/W/d" lipids.gro  # Delete waters
NLIPIDS=$(cat lipids.gro | head -n-2 | tail -n+3 | awk '{print $1}' | uniq | wc -l)
NATOMS=$(cat lipids.gro | head -n-2 | tail -n+3 | wc -l)
cat > system.gro<<EOF
$CASENAME
$NATOMS
EOF
cat lipids.gro | tail -n+3 >> system.gro
cat > topol.top<<EOF
#include "dry_martini_v2.1.itp"
#include "dry_martini_v2.1_ions.itp"
#include "dry_martini_v2.1_solvents.itp"
#include "dry_martini_v2.1_lipids.itp"

[ system ]
$CASENAME

[ molecules ]
DOPC    $NLIPIDS
EOF

make_ndx -f system.gro -o index.ndx<<EOF
keep 0
r DOPC
name 1 Lipids
q
EOF
grompp -f minim.mdp -c system.gro -p topol.top -n index.ndx -o em.tpr
mdrun -v -deffnm em 

cat >launch.sh<<EOF
#!/bin/bash
#SBATCH -J "$CASENAME"
#SBATCH -o "eq.out"
#SBATCH -N 1
#SBATCH -n 64
#SBATCH -p extended-cpu

grompp -f dry_martini_bilayer_preq.mdp -c em.gro -p topol.top -n index.ndx -o eq.tpr
mdrun -v -deffnm eq
EOF
# TODO Fix mdp file
