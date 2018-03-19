#!/bin/bash
#SBATCH -J UEYB-11
#SBATCH -o pmf-11.out
#SBATCH -N 1
#SBATCH -n 16 
#SBATCH -p extended-mem 

grompp -f pull_eq_11.mdp -c solution_em.gro -n solution.ndx -p solution.top -o pulling_11_eq -maxwarn 1 
mdrun -v -deffnm pulling_11_eq

grompp -f pull_md_11.mdp -c pulling_11_eq.gro -n solution.ndx -p solution.top -o pulling_11_md -maxwarn 1 
mdrun -v -pf pullf_11.xvg -px pullx_11.xvg -deffnm pulling_11_md -cpi pulling_11_md.cpt

