# Recreate index file. Need to select one molecule for pulling. Initially I use residue 8051. But when you renumber them, theyre different!
gmx make_ndx -f dopc-bilayer.gro -o index.ndx <<EOF
keep 0
ri 1356
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

#Pull water molecule. Custom MDP File created, pull.mdp in water-pmf
gmx grompp -f pull.mdp -c em.gro -n index.ndx -p topol.top -o pull/pull.tpr
# gmx mdrun -v -deffnm pull #Give it some time to see if it works. It may fail the pull part. Then you can try sbatch

# Ensure folder created
pulldir=pull
if [ ! -d $pulldir ]; then
	mkdir $pulldir
fi
cd $pulldir

# Create bash script that makes the launch script.
# Atoms/500 = 32457/500 = 64.9 cores.
# But only partition available is extended mem
cat > launch-pull.sh <<EOF
#!/bin/bash
#SBATCH -J "Pull H20"
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
