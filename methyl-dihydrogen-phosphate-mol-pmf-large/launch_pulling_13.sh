#!/bin/bash
#SBATCH -J UEYB-13
#SBATCH -o pmf-13.out
#SBATCH -N 1
#SBATCH -n 8 
#SBATCH -p regular-cpu 

grompp -f pull_eq_13.mdp -c solution_em.gro -n solution.ndx -p solution.top -o pulling_13_eq -maxwarn 1 
mdrun -v -deffnm pulling_13_eq

grompp -f pull_md_13.mdp -c pulling_13_eq.gro -n solution.ndx -p solution.top -o pulling_13_md -maxwarn 1 
mdrun -v -pf pullf_13.xvg -px pullx_13.xvg -deffnm pulling_13_md -cpi pulling_13_md.cpt

