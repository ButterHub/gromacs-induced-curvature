#!/bin/bash
#SBATCH -J 5-unreal-mudhp-2nm-sym
#SBATCH -o pmf-5.out
#SBATCH -N 1
#SBATCH -n 8
#SBATCH -p regular-cpu

grompp -f pull_eq_np_5.mdp -c solution_em.gro -p system.top -n system.ndx -o pulling_5_eq.tpr -maxwarn 1
mdrun -v -deffnm pulling_5_eq -cpi pulling_5_eq.cpt

grompp -f pull_md_np_5.mdp -c pulling_5_eq.gro -p system.top -n system.ndx -o pulling_5_md.tpr -maxwarn 1
mdrun -v -pf pullf_5.xvg -px pullx_5.xvg -deffnm pulling_5_md -cpi pulling_5_md.cpt
