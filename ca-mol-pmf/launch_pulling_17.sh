#!/bin/bash
#SBATCH -J CA-17
#SBATCH -o pmf-17.out
#SBATCH -N 1
#SBATCH -n 8 
#SBATCH -p regular-cpu 

grompp -f pull_eq_17.mdp -c solution_em.gro -n solution.ndx -p solution.top -o pulling_17_eq -maxwarn 1 
mdrun -v -deffnm pulling_17_eq

grompp -f pull_md_17.mdp -c pulling_17_eq.gro -n solution.ndx -p solution.top -o pulling_17_md -maxwarn 1 
mdrun -v -pf pullf_17.xvg -px pullx_17.xvg -deffnm pulling_17_md -cpi pulling_17_md.cpt

