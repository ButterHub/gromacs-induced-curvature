#!/bin/bash
#SBATCH -J 14-dopc494-mus-ot-2nm-sym
#SBATCH -o pmf-14.out
#SBATCH -N 1
#SBATCH -n 64
#SBATCH -p extended-cpu

grompp -f pull_eq_np_14.mdp -c solution_em.gro -p system.top -n system.ndx -o pulling_14_eq.tpr -maxwarn 1
mdrun -v -deffnm pulling_14_eq -cpi pulling_14_eq.cpt

grompp -f pull_md_np_14.mdp -c pulling_14_eq.gro -p system.top -n system.ndx -o pulling_14_md.tpr -maxwarn 1
mdrun -v -pf pullf_14.xvg -px pullx_14.xvg -deffnm pulling_14_md -cpi pulling_14_md.cpt

