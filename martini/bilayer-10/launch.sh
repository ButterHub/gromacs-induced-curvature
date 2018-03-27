#!/bin/bash
#SBATCH -J "bilayer-10"
#SBATCH -o "eq.out"
#SBATCH -N 1
#SBATCH -n 32
#SBATCH -p extended-mem

grompp -f unbiased_eq.mdp -c em.gro -p topol.top -n index.ndx -o eq_v2.tpr
mdrun -v -deffnm "eq_v2" 

# -dlb yes made it slower
