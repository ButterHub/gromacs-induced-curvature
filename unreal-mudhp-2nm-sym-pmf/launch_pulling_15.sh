#!/bin/bash
#SBATCH -J 15-unreal-mudhp-2nm-sym
#SBATCH -o pmf-15.out
#SBATCH -N 1
#SBATCH -n 8
#SBATCH -p regular-cpu

grompp -f pull_eq_np_15.mdp -c solution_em.gro -p system.top -n system.ndx -o pulling_15_eq.tpr -maxwarn 1
mdrun -v -deffnm pulling_15_eq -cpi pulling_15_eq.cpt

grompp -f pull_md_np_15.mdp -c pulling_15_eq.gro -p system.top -n system.ndx -o pulling_15_md.tpr -maxwarn 1
mdrun -v -pf pullf_15.xvg -px pullx_15.xvg -deffnm pulling_15_md -cpi pulling_15_md.cpt

