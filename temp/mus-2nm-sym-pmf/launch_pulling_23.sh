#!/bin/bash
#SBATCH -J 23-mus-2nm-sym
#SBATCH -o pmf-23.out
#SBATCH -N 1
#SBATCH -n 8
#SBATCH -p regular-cpu

grompp -f pull_eq_np_23.mdp -c solution_em.gro -p system.top -n system.ndx -o pulling_23_eq -maxwarn 1
mdrun -v -deffnm pulling_23_eq -cpi pulling_23_eq.cpt

grompp -f pull_md_np_23.mdp -c pulling_23_eq.gro -p system.top -n system.ndx -o pulling_23_md -maxwarn 1
mdrun -v -pf pullf_23.xvg -px pullx_23.xvg -deffnm pulling_23_md -cpi pulling_23_md.cpt

