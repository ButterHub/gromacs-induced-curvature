# PERFORMS UMBRELLA SAMPLING. (Need to have equilbrated first...use eq.sh) 
# Ensure directory exists.
dir=us-sampling
if [ ! -d $dir ]; then
	mkdir $dir
fi

# Loops over results of equilibration. 
for f in eq-sampling/*.gro; do
	nodir=${f#*/}
	eqnum=${nodir%.*}	
	num=${eqnum#eq}
	gmx grompp -f us-sampling.mdp -c $f -p topol.top -n index.ndx -o $dir/us-sampling${num}.tpr

# Make launch file
cd $dir
cat > launch-us-sampling.sh<<EOF
#!/bin/bash
#SBATCH -J "us-sampling${num}h2o"
#SBATCH -o "us-sampling${num}.out"
#SBATCH -N 1 
#SBATCH -n 8
#SBATCH -p regular-cpu

gmx mdrun -v -deffnm us-sampling${num}
EOF

# Run it
sbatch launch-us-sampling.sh
cd ../

done
 
# Clean up
rm $dir/'#'*
rm '#'*
