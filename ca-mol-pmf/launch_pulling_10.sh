#!/bin/bash
#SBATCH -J CA-10
#SBATCH -o pmf-10.out
#SBATCH -N 1
#SBATCH -n 8 
#SBATCH -p extended-mem 

grompp -f pull_eq_10.mdp -c solution_em.gro -n solution.ndx -p solution.top -o pulling_10_eq -maxwarn 1 
mdrun -v -deffnm pulling_10_eq

grompp -f pull_md_10.mdp -c pulling_10_eq.gro -n solution.ndx -p solution.top -o pulling_10_md -maxwarn 1 
mdrun -v -pf pullf_10.xvg -px pullx_10.xvg -deffnm pulling_10_md

