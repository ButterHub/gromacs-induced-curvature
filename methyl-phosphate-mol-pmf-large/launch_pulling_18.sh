#!/bin/bash
#SBATCH -J _K04-18
#SBATCH -o pmf-18.out
#SBATCH -N 1
#SBATCH -n 8 
#SBATCH -p regular-cpu 

grompp -f pull_eq_18.mdp -c solution_em.gro -n solution.ndx -p solution.top -o pulling_18_eq -maxwarn 1 
mdrun -v -deffnm pulling_18_eq

grompp -f pull_md_18.mdp -c pulling_18_eq.gro -n solution.ndx -p solution.top -o pulling_18_md -maxwarn 1 
mdrun -v -pf pullf_18.xvg -px pullx_18.xvg -deffnm pulling_18_md -cpi pulling_18_md.cpt

