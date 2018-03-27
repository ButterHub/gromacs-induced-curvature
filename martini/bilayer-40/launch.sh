#!/bin/bash
#SBATCH -J "bilayer-40"
#SBATCH -o "eq.out"
#SBATCH -N 1
#SBATCH -n 64
#SBATCH -p extended-cpu

grompp -f unbiased_eq.mdp -c em.gro -p topol.top -n index.ndx -o eq.tpr
mdrun -v -deffnm eq
