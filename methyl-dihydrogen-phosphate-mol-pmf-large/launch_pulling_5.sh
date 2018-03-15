#!/bin/bash
#SBATCH -J UEYB-5
#SBATCH -o pmf-5.out
#SBATCH -N 1
#SBATCH -n 8 
#SBATCH -p regular-cpu 

grompp -f pull_eq_5.mdp -c solution_em.gro -n solution.ndx -p solution.top -o pulling_5_eq -maxwarn 1 
mdrun -v -deffnm pulling_5_eq

grompp -f pull_md_5.mdp -c pulling_5_eq.gro -n solution.ndx -p solution.top -o pulling_5_md -maxwarn 1 
mdrun -v -pf pullf_5.xvg -px pullx_5.xvg -deffnm pulling_5_md -cpi pulling_5_md.cpt

