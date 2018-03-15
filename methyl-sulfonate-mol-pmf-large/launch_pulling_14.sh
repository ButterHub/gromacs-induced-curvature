#!/bin/bash
#SBATCH -J IXUV-14
#SBATCH -o pmf-14.out
#SBATCH -N 1
#SBATCH -n 8 
#SBATCH -p regular-cpu 

grompp -f pull_eq_14.mdp -c solution_em.gro -n solution.ndx -p solution.top -o pulling_14_eq -maxwarn 1 
mdrun -v -deffnm pulling_14_eq

grompp -f pull_md_14.mdp -c pulling_14_eq.gro -n solution.ndx -p solution.top -o pulling_14_md -maxwarn 1 
mdrun -v -pf pullf_14.xvg -px pullx_14.xvg -deffnm pulling_14_md -cpi pulling_14_md.cpt

