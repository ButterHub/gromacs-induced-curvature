#!/bin/bash
#SBATCH -J UEYB-28
#SBATCH -o pmf-28.out
#SBATCH -N 1
#SBATCH -n 8 
#SBATCH -p extended-mem 

grompp -f pull_eq_28.mdp -c solution_em.gro -n solution.ndx -p solution.top -o pulling_28_eq -maxwarn 1 
mdrun -v -deffnm pulling_28_eq

grompp -f pull_md_28.mdp -c pulling_28_eq.gro -n solution.ndx -p solution.top -o pulling_28_md -maxwarn 1 
mdrun -v -pf pullf_28.xvg -px pullx_28.xvg -deffnm pulling_28_md -cpi pulling_28_md.cpt

