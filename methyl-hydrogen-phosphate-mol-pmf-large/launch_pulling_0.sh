#!/bin/bash
#SBATCH -J VQJG-0
#SBATCH -o pmf-0.out
#SBATCH -N 1
#SBATCH -n 8 
#SBATCH -p regular-cpu 

grompp -f pull_eq_0.mdp -c solution_em.gro -n solution.ndx -p solution.top -o pulling_0_eq -maxwarn 1 
mdrun -v -deffnm pulling_0_eq

grompp -f pull_md_0.mdp -c pulling_0_eq.gro -n solution.ndx -p solution.top -o pulling_0_md -maxwarn 1 
mdrun -v -pf pullf_0.xvg -px pullx_0.xvg -deffnm pulling_0_md -cpi pulling_0_md.cpt

