#!/bin/bash
# Embeds NP into CG bilayer
# Input parameters
NGRID=${1:-4} # DEFAULTS TO 4
NNP=$(echo "$NGRID*$NGRID" | bc -l)
NP="martini-mus-2nm-checkerboard"
CLIGAND=1 # #Charge per ligand
NLIGAND=58 # #Ligands
NIONS=$(echo "$CLIGAND * $NNP * $NLIGAND" | bc -l)
LIPID=DOPC
DTRANS=5 #(nm) Distance to translate NP array from bilayer

CASENAME=${LIPID,,}-${NP}-${NNP}
mkdir $CASENAME
cd $CASENAME

# Copying files
cp ../includes/dry_martini*.itp .
cp ../includes/minim.mdp .
cp ../includes/${NP}.* .
cp ../includes/dry_martini_bilayer_*.mdp .
cp ../includes/dry_martini_np*.mdp .
cp ../includes/${LIPID,,}-bilayer.gro bilayer.gro
cp ../includes/counterion.gro .

# Get box size on bilayer
BOX=$(cat bilayer.gro | tail -n1)
BOX_X=$(echo $BOX | awk '{print $1}')
BOX_Y=$(echo $BOX | awk '{print $2}')
# Unit cell of NP
editconf -box $BOX_X $BOX_Y 10 -f ${NP}.gro -o ${NP}.gro
# Grid of NP
genconf -nbox ${NGRID} ${NGRID} 1 -f ${NP}.gro -o ${NP}.gro

# Will translate bilayer after merge. (Before any simulations)
# But this should be okay.
echo "${NP} in ${LIPID,,} system" > merged.gro
tail -n+3 ${NP}.gro | head -n-1 >> merged.gro
tail -n+3 bilayer.gro >> merged.gro
sed -i "2i $(printf "%5d" "$(echo "$(cat merged.gro | wc -l) - 2" | bc)")" merged.gro

make_ndx -f merged.gro -o index.ndx <<EOF
keep 0
r DOPC
name 1 Lipids
r MUS AU
name 2 NP 
r AU
name 3 AU
q
EOF

# Prepare restraints to NP positions
#BOX_X=$(cat bilayer.gro | tail -n1 | awk '{print $1}')
#BOX_Y=$(cat bilayer.gro | tail -n1 | awk '{print $2}')
#NP_X=$(echo "$BOX_X / " | bc -l)
#NP_Y=$(echo "$BOX_Y / " | bc -l)
genrestr -fc 1000 1000 0 -f merged.gro -n index.ndx -o ${NP}-posres.itp<<EOF
AU
EOF

cat > topol.top <<EOF
#include "dry_martini_v2.1.itp"
#include "dry_martini_v2.1_ions.itp"
#include "dry_martini_v2.1_solvents.itp"
#include "dry_martini_v2.1_lipids.itp"
#include "${NP}.itp"
#include "${NP}-posres.itp"

[ system ]
$NNP ${NP} in ${LIPID,,} bilayer

[ molecules ] 
AUNP    $NNP
EOF
NLIPIDS=$(tail -n+2 merged.gro | grep "$LIPID" | awk '{print $1}' | uniq | wc -l)
echo "$LIPID    $NLIPIDS" >> topol.top

# Translate NP (prevent initial bilayer-np overlap)
grompp -f minim.mdp -c merged.gro -p topol.top -n index.ndx -o dummy.tpr
editconf -f merged.gro -n index.ndx -o merged-trans.gro -translate 0 0 ${DTRANS}<<EOF
NP
System
EOF

# Neutralise ligand charges by adding NA beads.
grompp -f minim.mdp -c merged.gro -p topol.top -o ions.tpr
genbox -p topol.top -cp merged.gro -ci counterion.gro -o merged-neutral.gro -nmol $NIONS

# Energy minimisation
grompp -f minim.mdp -c merged.gro -p topol.top -n index.ndx -o system_em.tpr
mdrun -v -deffnm system_em

# MD - see what happens
cat >launch.sh<<EOF
#!/bin/bash
#SBATCH -J "${NP}-${NNP}-bilayer"
#SBATCH -o ".out"
#SBATCH -N 1
#SBATCH -n 64
#SBATCH -p extended-cpu

#EQ
grompp -f dry_martini_np_md.mdp -p topol.top -n index.ndx -o md.tpr 
mdrun -v -deffnm eq
#MD

EOF
# TODO Fix this script. Segmentation fault
