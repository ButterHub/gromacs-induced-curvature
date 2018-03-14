#!/bin/bash
#SBATCH -J IXUV-6
#SBATCH -o pmf-6.out
#SBATCH -N 1
#SBATCH -n 8 
#SBATCH -p extended-mem 

grompp -f pull_eq_6.mdp -c solution_em.gro -n solution.ndx -p solution.top -o pulling_6_eq -maxwarn 1 
mdrun -v -deffnm pulling_6_eq

grompp -f pull_md_6.mdp -c pulling_6_eq.gro -n solution.ndx -p solution.top -o pulling_6_md -maxwarn 1 
mdrun -v -pf pullf_6.xvg -px pullx_6.xvg -deffnm pulling_6_md -cpi pulling_6_md.cpt

