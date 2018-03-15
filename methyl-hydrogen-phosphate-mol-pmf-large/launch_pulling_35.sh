#!/bin/bash
#SBATCH -J VQJG-35
#SBATCH -o pmf-35.out
#SBATCH -N 1
#SBATCH -n 8 
#SBATCH -p regular-cpu 

grompp -f pull_eq_35.mdp -c solution_em.gro -n solution.ndx -p solution.top -o pulling_35_eq -maxwarn 1 
mdrun -v -deffnm pulling_35_eq

grompp -f pull_md_35.mdp -c pulling_35_eq.gro -n solution.ndx -p solution.top -o pulling_35_md -maxwarn 1 
mdrun -v -pf pullf_35.xvg -px pullx_35.xvg -deffnm pulling_35_md -cpi pulling_35_md.cpt

