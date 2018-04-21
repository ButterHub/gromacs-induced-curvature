# Loops over all frames in frames/ 
dir=sampling-faster-results
if [ ! -d $dir ]; then
	mkdir $dir
fi

for f in frames-faster/*.gro; do
	nodir=${f#*/}
	num=${nodir%.*}	
	gmx grompp -f sampling.mdp -c frames-faster/${nodir} -p topol-faster.top -n index.ndx -o sampling-faster-results/sampling${num}.tpr
#	gmx mdrun -v -deffnm sampling-results/sampling${num}
# Make launch file
cd sampling-faster-results
cat > launch-sampling.sh<<EOF
#!/bin/bash
#SBATCH -J "Umbrella F${num}"
#SBATCH -o "umbrellaF${num}.out"
#SBATCH -N 1
#SBATCH -n 8 
#SBATCH -p regular-cpu

gmx mdrun -v -deffnm sampling${num}
EOF
# Run it
sbatch launch-sampling.sh
cd ../

done
 
# Clean up
rm sampling-faster-results/'#'*
rm '#'*
