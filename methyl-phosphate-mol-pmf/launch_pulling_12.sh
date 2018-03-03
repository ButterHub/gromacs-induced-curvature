#!/bin/bash
#SBATCH -J _K04-12
#SBATCH -o pmf-12.out
#SBATCH -N 1
#SBATCH -n 8
#SBATCH -p regular-cpu

grompp -f pull_eq_12.mdp -c solution_em.gro -n solution.ndx -p solution.top -o pulling_12_eq -maxwarn 1 
mdrun -v -deffnm pulling_12_eq

grompp -f pull_md_12.mdp -c pulling_12_eq.gro -n solution.ndx -p solution.top -o pulling_12_md -maxwarn 1 
mdrun -v -pf pullf_12.xvg -px pullx_12.xvg -deffnm pulling_12_md

rm \#*
