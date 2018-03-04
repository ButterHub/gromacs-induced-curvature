#!/bin/bash
#SBATCH -J CA-20
#SBATCH -o pmf-20.out
#SBATCH -N 1
#SBATCH -n 8 
#SBATCH -p regular-cpu 

grompp -f pull_eq_20.mdp -c solution_em.gro -n solution.ndx -p solution.top -o pulling_20_eq -maxwarn 1 
mdrun -v -deffnm pulling_20_eq

grompp -f pull_md_20.mdp -c pulling_20_eq.gro -n solution.ndx -p solution.top -o pulling_20_md -maxwarn 1 
mdrun -v -pf pullf_20.xvg -px pullx_20.xvg -deffnm pulling_20_md -cpi pulling_20_md.cpt

