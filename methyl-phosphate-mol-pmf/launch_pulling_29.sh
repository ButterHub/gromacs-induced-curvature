#!/bin/bash
#SBATCH -J _K04-29
#SBATCH -o pmf-29.out
#SBATCH -N 1
#SBATCH -n 8
#SBATCH -p regular-cpu

grompp -f pull_eq_29.mdp -c solution_em.gro -n solution.ndx -p solution.top -o pulling_29_eq -maxwarn 1 
mdrun -v -deffnm pulling_29_eq

grompp -f pull_md_29.mdp -c pulling_29_eq.gro -n solution.ndx -p solution.top -o pulling_29_md -maxwarn 1 
mdrun -v -pf pullf_29.xvg -px pullx_29.xvg -deffnm pulling_29_md

rm \#*
