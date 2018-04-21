# Prepares and runs simulation for one case: pulling one water molecule through lipid bilayer.

# Duplicate to dopc-bilayer (ID30 from ATb). If PDB used, then use editconf
cp ../included/dopc-bilayer-id30.gro dopc-bilayer.gro
# need to replace DOP with DOPC. Original file uses DOP.
sed -i "2,$ s/DOP /DOPC/g" dopc-bilayer.gro

# Creating top file first, to use in PBC MOL.
# Count #molecules for each molecule in new system
solcount=$(cat dopc-bilayer.gro | tail -n +3 | grep SOL | awk '{print $1}' | uniq | wc -l)
dopccount=$(cat dopc-bilayer.gro | tail -n +3 | grep DOPC | awk '{print $1}' | uniq | wc -l)
echo SOL = ${solcount}, DOPC = ${dopccount}

# Fix molecule count in topology file
sed -i "s/SOL.*/SOL         ${solcount}/" topol.top
sed -i "s/DOPC.*/DOPC        ${dopccount}/" topol.top

# Tried PBC Box here. DOPC molecules escaping PBC through bottom side of pbc
# After adjusting pull.mdp parameters, not needed.

# Expansion of System (to allow further pulling without exploding simulation later on)
# Genconf to stack duplicates of the system. 3 in a stack.
gmx genconf -f dopc-bilayer.gro -o dopc-bilayer.gro -nbox 1 1 3

# After VMD inspection (choose region of initial bilayer and surrounding water). Remove newly added DOPC molecules.
gmx select -f dopc-bilayer.gro -s dopc-bilayer.gro -select 'same residue as (z>5 and z<15)' -on index.ndx

#Remove atoms not selected.
gmx trjconv -f dopc-bilayer.gro -s dopc-bilayer.gro -n index.ndx -o dopc-bilayer.gro 

# Resize boxes
gmx editconf -f dopc-bilayer.gro -o dopc-bilayer.gro -box 6.51040 6.51040 10
# gmx editconf -f dopc-bilayer.gro -o dopc-bilayer.gro -box 10 10 11

# Regroup compounds in gro file. (Sorted nicely)
sed -i -e '/SOL/{H;d}' -e '${x;s/^\n//p;x}' dopc-bilayer.gro

# Renumber gro file. DO NOT use genconf, it will mess up the grouping again.
gmx editconf -f dopc-bilayer.gro -o dopc-bilayer.gro -resnr 1

# Recreate index file. Need to select one molecule for pulling. Initially I use residue 8051. But when you renumber them, theyre different!
gmx make_ndx -f dopc-bilayer.gro -o index.ndx <<EOF
keep 0
ri 6398 
name 1 Pull
r DOPC
name 2 Lipids
r SOL
name 3 Solvent
q
EOF

#Count #molecules for each molecule in new system
solcount=$(cat dopc-bilayer.gro | tail -n +3 | grep SOL | awk '{print $1}' | uniq | wc -l)
dopccount=$(cat dopc-bilayer.gro | tail -n +3 | grep DOPC | awk '{print $1}' | uniq | wc -l)

#Fix molecule count in topology file
sed -i "s/SOL.*/SOL         ${solcount}/" topol.top
sed -i "s/DOPC.*/DOPC        ${dopccount}/" topol.top

# Fix molecule broken across pb. Creating a TPR file to do pbc mol
# gmx grompp -f ../included/em.mdp -c dopc-bilayer.gro -p topol.top -o fake.tpr
# gmx trjconv -f dopc-bilayer.gro -s fake.tpr -o dopc-bilayer.gro -pbc mol << EOF
# 0
# EOF

#STEPS BELOW REQUIRE MDP FILES
#Energy minimisation. Same files for EQ for all simulations. NEVER changed
gmx grompp -f ../included/em.mdp -c dopc-bilayer.gro -n index.ndx -p topol.top -o em.tpr
gmx mdrun -v -deffnm em

#Equilibration, similar to production file (MD) but generates random velocities. (EQ uses Berendsen Barostat)
# gmx grompp -f eq.mdp -c dopc-bilayer.gro -n index.ndx -p topol.top -o eq.tpr
# gmx mdrun -v -deffnm eq

#Pull water molecule. Custom MDP File created, pull.mdp in water-pmf
gmx grompp -f pull.mdp -c em.gro -n index.ndx -p topol.top -o pull.tpr
# gmx mdrun -v -deffnm pull #Give it some time to see if it works. It may fail the pull part. Then you can try sbatch

# Create bash script that makes the launch script.
# Atoms/500 = 32457/500 = 64.9 cores.
# But only partition available is extended mem
cat > launch-pull.sh <<EOF
#!/bin/bash
#SBATCH -J "Pull H2O <-> Bilayer"
#SBATCH -o "pull.out"
#SBATCH -N 2
#SBATCH -n 64
#SBATCH -p extended-mem

gmx mdrun -v -deffnm pull
EOF

sbatch launch-pull.sh

#Remove overwritten then backed up files
rm '#'*
rm step*
