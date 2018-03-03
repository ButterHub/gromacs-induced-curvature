#!/bin/bash
#SBATCH -J NA-1
#SBATCH -o pmf-1.out
#SBATCH -N 1
#SBATCH -n 8 
#SBATCH -p extended-mem 

grompp -f pull_eq_1.mdp -c solution_em.gro -n solution.ndx -p solution.top -o pulling_1_eq -maxwarn 1 
mdrun -v -deffnm pulling_1_eq

grompp -f pull_md_1.mdp -c pulling_1_eq.gro -n solution.ndx -p solution.top -o pulling_1_md -maxwarn 1 
mdrun -v -pf pullf_1.xvg -px pullx_1.xvg -deffnm pulling_1_md

