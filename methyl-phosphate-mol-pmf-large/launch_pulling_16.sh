#!/bin/bash
#SBATCH -J _K04-16
#SBATCH -o pmf-16.out
#SBATCH -N 1
#SBATCH -n 8 
#SBATCH -p regular-cpu 

grompp -f pull_eq_16.mdp -c solution_em.gro -n solution.ndx -p solution.top -o pulling_16_eq -maxwarn 1 
mdrun -v -deffnm pulling_16_eq

grompp -f pull_md_16.mdp -c pulling_16_eq.gro -n solution.ndx -p solution.top -o pulling_16_md -maxwarn 1 
mdrun -v -pf pullf_16.xvg -px pullx_16.xvg -deffnm pulling_16_md -cpi pulling_16_md.cpt

