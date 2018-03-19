#!/bin/bash
#SBATCH -J UEYB-9
#SBATCH -o pmf-9.out
#SBATCH -N 1
#SBATCH -n 16 
#SBATCH -p extended-mem 

grompp -f pull_eq_9.mdp -c solution_em.gro -n solution.ndx -p solution.top -o pulling_9_eq -maxwarn 1 
mdrun -v -deffnm pulling_9_eq

grompp -f pull_md_9.mdp -c pulling_9_eq.gro -n solution.ndx -p solution.top -o pulling_9_md -maxwarn 1 
mdrun -v -pf pullf_9.xvg -px pullx_9.xvg -deffnm pulling_9_md -cpi pulling_9_md.cpt

