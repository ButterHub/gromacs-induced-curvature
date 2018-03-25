#!/bin/bash
#SBATCH -J 3-VQJG
#SBATCH -o pmf-3.out
#SBATCH -N 1
#SBATCH -n 64
#SBATCH -p extended-cpu

grompp -f pull_eq_3.mdp -c solution_em.gro -n solution.ndx -p solution.top -o pulling_3_eq -maxwarn 1
mdrun -v -deffnm pulling_3_eq

grompp -f pull_md_3.mdp -c pulling_3_eq.gro -n solution.ndx -p solution.top -o pulling_3_md -maxwarn 1
mdrun -v -pf pullf_3.xvg -px pullx_3.xvg -deffnm pulling_3_md -cpi pulling_3_md.cpt

