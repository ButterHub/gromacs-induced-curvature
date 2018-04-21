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

rm '#'*
