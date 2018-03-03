#!/bin/bash
#SBATCH -J system
#SBATCH -o system.out
#SBATCH -N 1
#SBATCH -n 64
#SBATCH -p extended-cpu

grompp -f gromos_membed_eq.mdp -c system_em.gro -n system.ndx -p system.top -o system_eq
mdrun -v -deffnm system_eq

grompp -f gromos_membed_md.mdp -c system_eq.gro -n system.ndx -p system.top -o system_md
mdrun -v -deffnm system_md

rm \#*
