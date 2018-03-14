#!/bin/bash
#SBATCH -J VQJG-33
#SBATCH -o pmf-33.out
#SBATCH -N 1
#SBATCH -n 8 
#SBATCH -p extended-mem 

grompp -f pull_eq_33.mdp -c solution_em.gro -n solution.ndx -p solution.top -o pulling_33_eq -maxwarn 1 
mdrun -v -deffnm pulling_33_eq

grompp -f pull_md_33.mdp -c pulling_33_eq.gro -n solution.ndx -p solution.top -o pulling_33_md -maxwarn 1 
mdrun -v -pf pullf_33.xvg -px pullx_33.xvg -deffnm pulling_33_md -cpi pulling_33_md.cpt

