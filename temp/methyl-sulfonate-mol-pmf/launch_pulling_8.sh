#!/bin/bash
#SBATCH -J IXUV-8
#SBATCH -o pmf-8.out
#SBATCH -N 1
#SBATCH -n 8
#SBATCH -p regular-cpu

grompp -f pull_eq_8.mdp -c solution_em.gro -n solution.ndx -p solution.top -o pulling_8_eq -maxwarn 1 
mdrun -v -deffnm pulling_8_eq

grompp -f pull_md_8.mdp -c pulling_8_eq.gro -n solution.ndx -p solution.top -o pulling_8_md -maxwarn 1 
mdrun -v -pf pullf_8.xvg -px pullx_8.xvg -deffnm pulling_8_md

rm \#*
