#!/bin/bash
#SBATCH -J 20-unreal-mup-2nm-sym
#SBATCH -o pmf-20.out
#SBATCH -N 1
#SBATCH -n 8
#SBATCH -p regular-cpu

grompp -f pull_eq_np_20.mdp -c solution_em.gro -p system.top -n system.ndx -o pulling_20_eq.tpr -maxwarn 1
mdrun -v -deffnm pulling_20_eq -cpi pulling_20_eq.cpt

grompp -f pull_md_np_20.mdp -c pulling_20_eq.gro -p system.top -n system.ndx -o pulling_20_md.tpr -maxwarn 1
mdrun -v -pf pullf_20.xvg -px pullx_20.xvg -deffnm pulling_20_md -cpi pulling_20_md.cpt

