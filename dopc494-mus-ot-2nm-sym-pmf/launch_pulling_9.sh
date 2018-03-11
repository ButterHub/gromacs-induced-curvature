#!/bin/bash
#SBATCH -J 9-dopc494-mus-ot-2nm-sym
#SBATCH -o pmf-9.out
#SBATCH -N 1
#SBATCH -n 8
#SBATCH -p regular-cpu
grompp -f pull_eq_np_9.mdp -c solution_em.gro -p system.top -n system.ndx -o pulling_9_eq.tpr -maxwarn 1
mdrun -v -deffnm pulling_9_eq -cpi pulling_9_eq.cpt

grompp -f pull_md_np_9.mdp -c pulling_9_eq.gro -p system.top -n system.ndx -o pulling_9_md.tpr -maxwarn 1
mdrun -v -pf pullf_9.xvg -px pullx_9.xvg -deffnm pulling_9_md -cpi pulling_9_md.cpt

