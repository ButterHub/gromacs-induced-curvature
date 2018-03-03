#!/bin/bash
#SBATCH -J CA-23
#SBATCH -o pmf-23.out
#SBATCH -N 1
#SBATCH -n 8 
#SBATCH -p extended-mem 

grompp -f pull_eq_23.mdp -c solution_em.gro -n solution.ndx -p solution.top -o pulling_23_eq -maxwarn 1 
mdrun -v -deffnm pulling_23_eq

grompp -f pull_md_23.mdp -c pulling_23_eq.gro -n solution.ndx -p solution.top -o pulling_23_md -maxwarn 1 
mdrun -v -pf pullf_23.xvg -px pullx_23.xvg -deffnm pulling_23_md

