#!/bin/bash
#SBATCH -J "bilayer-40"
#SBATCH -o "eq.out"
#SBATCH -N 1
#SBATCH -n 64
#SBATCH -p extended-cpu

grompp -f dry_martini_bilayer_eq.mdp -c em.gro -p topol.top -n index.ndx -o eq
mdrun -v -deffnm eq

grompp -f dry_martini_bilayer_md.mdp -c eq.gro -p topol.top -n index.ndx -o md
mdrun -gcom 1000 -v -deffnm md
