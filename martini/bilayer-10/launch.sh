#!/bin/bash
#SBATCH -J "bilayer-10"
#SBATCH -o "eq.out"
#SBATCH -N 1
#SBATCH -n 64
#SBATCH -p extended-cpu

grompp -f dry_martini_bilayer_preq.mdp -c em.gro -p topol.top -n index.ndx -o eq.tpr
mdrun -v -deffnm eq
