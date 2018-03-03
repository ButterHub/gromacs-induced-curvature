#!/bin/bash
#SBATCH -J CA-30
#SBATCH -o pmf-30.out
#SBATCH -N 1
#SBATCH -n 8 
#SBATCH -p extended-mem 

grompp -f pull_eq_30.mdp -c solution_em.gro -n solution.ndx -p solution.top -o pulling_30_eq -maxwarn 1 
mdrun -v -deffnm pulling_30_eq

grompp -f pull_md_30.mdp -c pulling_30_eq.gro -n solution.ndx -p solution.top -o pulling_30_md -maxwarn 1 
mdrun -v -pf pullf_30.xvg -px pullx_30.xvg -deffnm pulling_30_md

