#!/bin/bash
#SBATCH -J IXUV-24
#SBATCH -o pmf-24.out
#SBATCH -N 1
#SBATCH -n 8 
#SBATCH -p extended-mem 

grompp -f pull_eq_24.mdp -c solution_em.gro -n solution.ndx -p solution.top -o pulling_24_eq -maxwarn 1 
mdrun -v -deffnm pulling_24_eq

grompp -f pull_md_24.mdp -c pulling_24_eq.gro -n solution.ndx -p solution.top -o pulling_24_md -maxwarn 1 
mdrun -v -pf pullf_24.xvg -px pullx_24.xvg -deffnm pulling_24_md -cpi pulling_24_md.cpt

