# PERFORMS EQUILIBRATION PRIOR TO UMBRELLA SAMPLING.
dir=eq-sampling
if [ ! -d $dir ]; then
	mkdir $dir
fi

# Loops over all frames in frames/ 
for f in frames/*.gro; do
	nodir=${f#*/}
	num=${nodir%.*}	
	gmx grompp -f eq-sampling.mdp -c $f -p topol.top -n index.ndx -o eq-sampling/eq${num}.tpr

# Make launch file
cd eq-sampling
cat > launch-eq.sh<<EOF
#!/bin/bash
#SBATCH -J "eq${num}h2o"
#SBATCH -o "eq${num}h2o.out"
#SBATCH -N 1
#SBATCH -n 8
#SBATCH -p extended-mem

gmx mdrun -v -deffnm eq${num}
EOF

# Run it
sbatch launch-eq.sh
cd ../

done
 
# Clean up
rm eq-sampling/'#'*
rm '#'*
