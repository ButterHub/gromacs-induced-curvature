#!/bin/bash
#SBATCH -J 2-mus-2nm-sym
#SBATCH -o pmf-2.out
#SBATCH -N 1
#SBATCH -n 8
#SBATCH -p regular-cpu

grompp -f pull_eq_np_2.mdp -c solution_em.gro -p system.top -n system.ndx -o pulling_2_eq -maxwarn 1
mdrun -v -deffnm pulling_2_eq -cpi pulling_2_eq.cpt

grompp -f pull_md_np_2.mdp -c pulling_2_eq.gro -p system.top -n system.ndx -o pulling_2_md -maxwarn 1
mdrun -v -pf pullf_2.xvg -px pullx_2.xvg -deffnm pulling_2_md -cpi pulling_2_md.cpt

