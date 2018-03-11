#!/bin/bash
#SBATCH -J 1-unreal-mudhp-2nm-sym
#SBATCH -o pmf-1.out
#SBATCH -N 1
#SBATCH -n 8
#SBATCH -p regular-cpu

grompp -f pull_eq_np_1.mdp -c solution_em.gro -p system.top -n system.ndx -o pulling_1_eq.tpr -maxwarn 1
mdrun -v -deffnm pulling_1_eq -cpi pulling_1_eq.cpt

grompp -f pull_md_np_1.mdp -c pulling_1_eq.gro -p system.top -n system.ndx -o pulling_1_md.tpr -maxwarn 1
mdrun -v -pf pullf_1.xvg -px pullx_1.xvg -deffnm pulling_1_md -cpi pulling_1_md.cpt

