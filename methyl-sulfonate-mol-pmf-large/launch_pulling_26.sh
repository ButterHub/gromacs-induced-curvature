#!/bin/bash
#SBATCH -J IXUV-26
#SBATCH -o pmf-26.out
#SBATCH -N 1
#SBATCH -n 8 
#SBATCH -p regular-cpu 

grompp -f pull_eq_26.mdp -c solution_em.gro -n solution.ndx -p solution.top -o pulling_26_eq -maxwarn 1 
mdrun -v -deffnm pulling_26_eq

grompp -f pull_md_26.mdp -c pulling_26_eq.gro -n solution.ndx -p solution.top -o pulling_26_md -maxwarn 1 
mdrun -v -pf pullf_26.xvg -px pullx_26.xvg -deffnm pulling_26_md -cpi pulling_26_md.cpt

