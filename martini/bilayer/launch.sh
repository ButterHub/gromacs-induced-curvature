#!/bin/bash
#SBATCH -J "bilayer"
#SBATCH -o "eq.out"
#SBATCH -N 1
#SBATCH -n 64
#SBATCH -p extended-cpu

#dry_martini_bilayer_eq.mdp or template_sd.mdp
grompp -f template_sd.mdp -c em.gro -p topol.top -n index.ndx -o eq.tpr
mdrun -v -deffnm eq
# Centering molecules in box, but with no other groups there?
