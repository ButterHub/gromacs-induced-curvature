#!/bin/bash
#SBATCH -J UEYB-32
#SBATCH -o pmf-32.out
#SBATCH -N 1
#SBATCH -n 8 
#SBATCH -p regular-cpu 

grompp -f pull_eq_32.mdp -c solution_em.gro -n solution.ndx -p solution.top -o pulling_32_eq -maxwarn 1 
mdrun -v -deffnm pulling_32_eq

grompp -f pull_md_32.mdp -c pulling_32_eq.gro -n solution.ndx -p solution.top -o pulling_32_md -maxwarn 1 
mdrun -v -pf pullf_32.xvg -px pullx_32.xvg -deffnm pulling_32_md -cpi pulling_32_md.cpt

