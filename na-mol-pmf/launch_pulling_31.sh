#!/bin/bash
#SBATCH -J NA-31
#SBATCH -o pmf-31.out
#SBATCH -N 1
#SBATCH -n 8 
#SBATCH -p extended-mem 

grompp -f pull_eq_31.mdp -c solution_em.gro -n solution.ndx -p solution.top -o pulling_31_eq -maxwarn 1 
mdrun -v -deffnm pulling_31_eq

grompp -f pull_md_31.mdp -c pulling_31_eq.gro -n solution.ndx -p solution.top -o pulling_31_md -maxwarn 1 
mdrun -v -pf pullf_31.xvg -px pullx_31.xvg -deffnm pulling_31_md

