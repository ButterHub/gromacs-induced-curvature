#!/bin/bash
#SBATCH -J UEYB-7
#SBATCH -o pmf-7.out
#SBATCH -N 1
#SBATCH -n 8 
#SBATCH -p regular-cpu 

grompp -f pull_eq_7.mdp -c solution_em.gro -n solution.ndx -p solution.top -o pulling_7_eq -maxwarn 1 
mdrun -v -deffnm pulling_7_eq

grompp -f pull_md_7.mdp -c pulling_7_eq.gro -n solution.ndx -p solution.top -o pulling_7_md -maxwarn 1 
mdrun -v -pf pullf_7.xvg -px pullx_7.xvg -deffnm pulling_7_md -cpi pulling_7_md.cpt

