#!/bin/bash
#SBATCH -J _K04-25
#SBATCH -o pmf-25.out
#SBATCH -N 1
#SBATCH -n 8 
#SBATCH -p regular-cpu 

grompp -f pull_eq_25.mdp -c solution_em.gro -n solution.ndx -p solution.top -o pulling_25_eq -maxwarn 1 
mdrun -v -deffnm pulling_25_eq

grompp -f pull_md_25.mdp -c pulling_25_eq.gro -n solution.ndx -p solution.top -o pulling_25_md -maxwarn 1 
mdrun -v -pf pullf_25.xvg -px pullx_25.xvg -deffnm pulling_25_md -cpi pulling_25_md.cpt

