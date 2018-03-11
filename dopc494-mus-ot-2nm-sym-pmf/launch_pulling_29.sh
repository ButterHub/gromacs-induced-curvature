#!/bin/bash
#SBATCH -J 29-dopc494-mus-ot-2nm-sym
#SBATCH -o pmf-29.out
#SBATCH -N 1
#SBATCH -n 8
#SBATCH -p regular-cpu
grompp -f pull_eq_np_29.mdp -c solution_em.gro -p system.top -n system.ndx -o pulling_29_eq.tpr -maxwarn 1
mdrun -v -deffnm pulling_29_eq -cpi pulling_29_eq.cpt

grompp -f pull_md_np_29.mdp -c pulling_29_eq.gro -p system.top -n system.ndx -o pulling_29_md.tpr -maxwarn 1
mdrun -v -pf pullf_29.xvg -px pullx_29.xvg -deffnm pulling_29_md -cpi pulling_29_md.cpt

