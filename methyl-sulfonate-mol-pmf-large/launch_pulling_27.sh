#!/bin/bash
#SBATCH -J IXUV-27
#SBATCH -o pmf-27.out
#SBATCH -N 1
#SBATCH -n 8 
#SBATCH -p regular-cpu 

grompp -f pull_eq_27.mdp -c solution_em.gro -n solution.ndx -p solution.top -o pulling_27_eq -maxwarn 1 
mdrun -v -deffnm pulling_27_eq

grompp -f pull_md_27.mdp -c pulling_27_eq.gro -n solution.ndx -p solution.top -o pulling_27_md -maxwarn 1 
mdrun -v -pf pullf_27.xvg -px pullx_27.xvg -deffnm pulling_27_md -cpi pulling_27_md.cpt

