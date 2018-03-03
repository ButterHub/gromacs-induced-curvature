#!/bin/bash
#SBATCH -J 21-dopc494-mus-ot-2nm-sym
#SBATCH -o pmf-21.out
#SBATCH -N 1
#SBATCH -n 8
#SBATCH -p regular-cpu

grompp -f pull_eq_np_21.mdp -c solution_em.gro -p system.top -n system.ndx -o pulling_21_eq.tpr -maxwarn 1
mdrun -v -deffnm pulling_21_eq -cpi pulling_21_eq.cpt

grompp -f pull_md_np_21.mdp -c pulling_21_eq.gro -p system.top -n system.ndx -o pulling_21_md.tpr -maxwarn 1
mdrun -v -pf pullf_21.xvg -px pullx_21.xvg -deffnm pulling_21_md -cpi pulling_21_md.cpt

