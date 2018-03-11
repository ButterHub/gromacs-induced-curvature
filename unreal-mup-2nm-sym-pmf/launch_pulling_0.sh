#!/bin/bash
#SBATCH -J 0-unreal-mup-2nm-sym
#SBATCH -o pmf-0.out
#SBATCH -N 1
#SBATCH -n 8
#SBATCH -p regular-cpu

grompp -f pull_eq_np_0.mdp -c solution_em.gro -p system.top -n system.ndx -o pulling_0_eq.tpr -maxwarn 1
mdrun -v -deffnm pulling_0_eq -cpi pulling_0_eq.cpt

grompp -f pull_md_np_0.mdp -c pulling_0_eq.gro -p system.top -n system.ndx -o pulling_0_md.tpr -maxwarn 1
mdrun -v -pf pullf_0.xvg -px pullx_0.xvg -deffnm pulling_0_md -cpi pulling_0_md.cpt

