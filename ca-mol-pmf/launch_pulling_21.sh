#!/bin/bash
#SBATCH -J CA-21
#SBATCH -o pmf-21.out
#SBATCH -N 1
#SBATCH -n 8 
#SBATCH -p extended-mem 

grompp -f pull_eq_21.mdp -c solution_em.gro -n solution.ndx -p solution.top -o pulling_21_eq -maxwarn 1 
mdrun -v -deffnm pulling_21_eq

grompp -f pull_md_21.mdp -c pulling_21_eq.gro -n solution.ndx -p solution.top -o pulling_21_md -maxwarn 1 
mdrun -v -pf pullf_21.xvg -px pullx_21.xvg -deffnm pulling_21_md

