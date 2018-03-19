#!/bin/bash
#SBATCH -J VQJG-4
#SBATCH -o pmf-4.out
#SBATCH -N 1
#SBATCH -n 64 
#SBATCH -p extended-cpu 

grompp -f pull_eq_4.mdp -c solution_em.gro -n solution.ndx -p solution.top -o pulling_4_eq -maxwarn 1 
mdrun -v -deffnm pulling_4_eq

grompp -f pull_md_4.mdp -c pulling_4_eq.gro -n solution.ndx -p solution.top -o pulling_4_md -maxwarn 1 
mdrun -v -pf pullf_4.xvg -px pullx_4.xvg -deffnm pulling_4_md -cpi pulling_4_md.cpt

