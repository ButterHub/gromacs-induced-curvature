#!/bin/bash
#SBATCH -J UEYB-34
#SBATCH -o pmf-34.out
#SBATCH -N 1
#SBATCH -n 8 
#SBATCH -p extended-mem 

grompp -f pull_eq_34.mdp -c solution_em.gro -n solution.ndx -p solution.top -o pulling_34_eq -maxwarn 1 
mdrun -v -deffnm pulling_34_eq

grompp -f pull_md_34.mdp -c pulling_34_eq.gro -n solution.ndx -p solution.top -o pulling_34_md -maxwarn 1 
mdrun -v -pf pullf_34.xvg -px pullx_34.xvg -deffnm pulling_34_md -cpi pulling_34_md.cpt

