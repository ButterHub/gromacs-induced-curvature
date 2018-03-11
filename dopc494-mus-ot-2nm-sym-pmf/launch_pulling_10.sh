#!/bin/bash
#SBATCH -J 10-dopc494-mus-ot-2nm-sym
#SBATCH -o pmf-10.out
#SBATCH -N 1
#SBATCH -n 64
#SBATCH -p extended-cpu

grompp -f pull_eq_np_10.mdp -c solution_em.gro -p system.top -n system.ndx -o pulling_10_eq.tpr -maxwarn 1
mdrun -v -deffnm pulling_10_eq -cpi pulling_10_eq.cpt

grompp -f pull_md_np_10.mdp -c pulling_10_eq.gro -p system.top -n system.ndx -o pulling_10_md.tpr -maxwarn 1
mdrun -v -pf pullf_10.xvg -px pullx_10.xvg -deffnm pulling_10_md -cpi pulling_10_md.cpt

