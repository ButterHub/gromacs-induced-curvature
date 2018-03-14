#!/bin/bash
#SBATCH -J VQJG-22
#SBATCH -o pmf-22.out
#SBATCH -N 1
#SBATCH -n 8 
#SBATCH -p extended-mem 

grompp -f pull_eq_22.mdp -c solution_em.gro -n solution.ndx -p solution.top -o pulling_22_eq -maxwarn 1 
mdrun -v -deffnm pulling_22_eq

grompp -f pull_md_22.mdp -c pulling_22_eq.gro -n solution.ndx -p solution.top -o pulling_22_md -maxwarn 1 
mdrun -v -pf pullf_22.xvg -px pullx_22.xvg -deffnm pulling_22_md -cpi pulling_22_md.cpt

