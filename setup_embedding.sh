#!/bin/bash
# Setup bilayer or ribbon from building block bilayer and embed nanoparticle using g_membed

# Input parameters
NP="mus-2nm-checkerboard" # or mus-2nm-checkerboard or unreal-mup-2nm-sym
NNA=58 # 58 for normal, but MUP has -2 charge 116
LIPID="DOPC"
CROP=10
SLIPID="bilayer" # bilayer or ribbon

# Define basename
BASENAME=${LIPID,,}-${SLIPID}-${NP,,}-np-${CROP}-nm
NP="gromos-${NP}" # Prepending as thats the file name
mkdir $BASENAME
cd $BASENAME

# Copy over include files
cp ../includes/${NP}.* .
cp ../includes/${LIPID,,}-${SLIPID}.gro .
cp ../includes/minim.mdp .
cp ../includes/membed.mdp .
cp ../includes/gromos*itp .
cp ../includes/gromos_membed_*.mdp .

# Generate bilayer .gro file. # Not running for Ribbon system
cp ${LIPID,,}-${SLIPID}.gro system.gro
#genconf -f ${LIPID,,}-${SLIPID}.gro -o system.gro -nbox 5 5 1
sed -i -e '/SOL/{H;d}' -e '${x;s/^\n//p;x}' system.gro 
sed -i -e '/NA/{H;d}' -e '${x;s/^\n//p;x}' system.gro 
sed -i -e '/CL/{H;d}' -e '${x;s/^\n//p;x}' system.gro 
#added for ribbon init to work. Resnr
editconf -f system.gro -o system.gro -resnr 1

# Crop to a smaller box size
#g_select -s system.gro -selrpos whole_res_com -select "same residue as (x < $CROP and y < $CROP)" -on cropped.ndx
#trjconv -f system.gro -s system.gro -o system.gro -n cropped.ndx
#editconf -f system.gro -o system.gro -box $(echo "$CROP + 1.0" | bc -l) $(echo "$CROP + 1.0" | bc -l) $(tail -n 1 system.gro | awk '{print $3}')

# Generate .top file
cat > system.top <<EOF
#include "gromos_54a7.itp"
#include "gromos_54a7_ions.itp"
#include "gromos_54a7_spc.itp"
#include "gromos_54a7_${LIPID,,}.itp"

[ system ]
${LIPID,,} $SLIPID 

[ molecules ]
EOF
NLIPIDS=$(tail -n+2 system.gro | grep "$LIPID" | awk '{print $1}' | uniq | wc -l)
NSOL=$(tail -n+2 system.gro | grep "SOL" | awk '{print $1}' | uniq | wc -l)
NNA=$(tail -n+2 system.gro | grep "NA" | awk '{print $1}' | uniq | wc -l)
NCL=$(tail -n+2 system.gro | grep "CL" | awk '{print $1}' | uniq | wc -l)
echo "$LIPID	$NLIPIDS" >> system.top
echo "SOL	$NSOL" >> system.top
echo "NA      $NNA" >> system.top
echo "CL      $NCL" >> system.top

# Energy minimization
grompp -f minim.mdp -c system.gro -p system.top -o system_em
mdrun -v -deffnm system_em

# Generate .ndx file
make_ndx -f system_em.gro -o system.ndx <<INPUT
keep 0
r ${LIPID}
name 1 Lipids
r SOL NA CL
name 2 Solvent
!r ${LIPID} SOL NA CL
name 3 NP
q
INPUT

# Center bilayer in z-direction - centering system to solvent
trjconv -f system_em.gro -s system_em.tpr -n system.ndx -o system_em.gro -center -pbc mol <<INPUT
Solvent
System
INPUT

g_traj -ox -com -s system_em.tpr -f system_em.gro -n system.ndx <<INPUT
Lipids
INPUT

BOX_Z=$(tail -n 1 system_em.gro | awk '{print $3}')
BILAYER_COM_Z=$(tail -n 1 coord.xvg | awk '{print $4}')
DZ=$(echo "($BOX_Z / 2) - $BILAYER_COM_Z" | bc -l) # Precision may cause issues for trjconv below.

trjconv -f system_em.gro -s system_em.tpr -n system.ndx -o system_em.gro -trans 0 0 $DZ -pbc mol <<INPUT
System
INPUT

# Center nanoparticle in correctly sized box
editconf -f ${NP}.gro -o ${NP}.gro -box $(tail -n 1 system_em.gro)

# Merge nanoparticle and bilayer boxes
echo "np ${SLIPID} system" > merged.gro
tail -n+3 ${NP}.gro | head -n-1 >> merged.gro
tail -n+3 system_em.gro >> merged.gro
sed -i "2i $(printf "%5d" "$(echo "$(cat merged.gro | wc -l) - 2" | bc)")" merged.gro

# Remove waters that overlap with nanoparticle
g_select -s merged.gro -selrpos whole_res_com -select "not (resname SOL DOPC and within 0.75 of resname AU MUS OT)" -on noconflicts.ndx
trjconv -f merged.gro -s merged.gro -o merged.gro -n noconflicts.ndx

# Generate updated .ndx file
make_ndx -f merged.gro -o system.ndx <<INPUT
keep 0
r ${LIPID}
name 1 Lipids
r SOL NA CL
name 2 Solvent
!r ${LIPID} SOL NA CL
name 3 NP
q
INPUT

# Generate updated .top file
cat > system.top <<EOF
#include "gromos_54a7.itp"
#include "gromos_54a7_ions.itp"
#include "gromos_54a7_spc.itp"
#include "gromos_54a7_${LIPID,,}.itp"
#include "${NP}.itp"

[ system ]
${LIPID,,} ${SLIPID} 

[ molecules ]
AUNP	    1
EOF
NLIPIDS=$(tail -n+2 merged.gro | grep "$LIPID" | awk '{print $1}' | uniq | wc -l)
NSOL=$(tail -n+2 merged.gro | grep "SOL" | awk '{print $1}' | uniq | wc -l)
NNA=$(tail -n+2 merged.gro | grep "NA" | awk '{print $1}' | uniq | wc -l)
NCL=$(tail -n+2 merged.gro | grep "CL" | awk '{print $1}' | uniq | wc -l)
echo "$LIPID    $NLIPIDS" >> system.top
echo "SOL       $NSOL" >> system.top
echo "NA      $NNA" >> system.top
echo "CL      $NCL" >> system.top

# Energy minimization
grompp -f minim.mdp -c merged.gro -p system.top -o system_em_2
mdrun -v -deffnm system_em_2

# Run g_membed
grompp -f membed.mdp -c system_em_2.gro -p system.top -n system.ndx -o membedded.tpr
g_membed -f membedded.tpr -p system.top -n system.ndx -xyinit 0.1 -xyend 1.0 -nxy 10000 -maxwarn 1
mdrun -v -s membedded.tpr -membed membed.dat -o traj.trr -c membedded.gro -e ener.edr -nt 1 -cpt -1 -mn system.ndx -mp system.top <<INPUT
NP
Lipids
INPUT

# Add counterions to neutralize system
grompp -f minim.mdp -c membedded.gro -p system.top -o ions.tpr
genion -s ions.tpr -o membedded_neutral.gro -np $NNA -p system.top <<INPUT
SOL
INPUT

# Energy minimization once more
grompp -f minim.mdp -c membedded_neutral.gro -p system.top -o system_em
mdrun -v -deffnm system_em

# Generate .ndx file
make_ndx -f system_em.gro -o system.ndx <<INPUT
keep 0
r ${LIPID}
name 1 Lipids
r SOL NA CL
name 2 Solvent
!r ${LIPID} SOL NA CL
name 3 NP
q
INPUT

# Generate SLURM launch script
cat > launch_system.sh <<EOL
#!/bin/bash
#SBATCH -J system
#SBATCH -o system.out
#SBATCH -N 1
#SBATCH -n 64
#SBATCH -p extended-cpu

grompp -f gromos_membed_eq.mdp -c system_em.gro -n system.ndx -p system.top -o system_eq
mdrun -v -deffnm system_eq

grompp -f gromos_membed_md.mdp -c system_eq.gro -n system.ndx -p system.top -o system_md
mdrun -v -deffnm system_md

rm \#*
EOL

# Clean up
rm ${LIPID,,}-${SLIPID}.gro
rm cropped.*
rm noconflicts.*
rm coord.xvg
rm system.gro
rm mdout.mdp
rm \#*
