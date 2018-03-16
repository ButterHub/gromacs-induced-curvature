#!/bin/bash
#SBATCH -J 12-unreal-mup-2nm-sym
#SBATCH -o pmf-12.out
#SBATCH -N 1
#SBATCH -n 8
#SBATCH -p regular-cpu

grompp -f pull_eq_np_12.mdp -c solution_em.gro -p system.top -n system.ndx -o pulling_12_eq.tpr -maxwarn 1
mdrun -v -deffnm pulling_12_eq -cpi pulling_12_eq.cpt

grompp -f pull_md_np_12.mdp -c pulling_12_eq.gro -p system.top -n system.ndx -o pulling_12_md.tpr -maxwarn 1
mdrun -v -pf pullf_12.xvg -px pullx_12.xvg -deffnm pulling_12_md -cpi pulling_12_md.cpt

