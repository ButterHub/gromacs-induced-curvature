#!/bin/bash
#SBATCH -J 28-mus-2nm-sym
#SBATCH -o pmf-28.out
#SBATCH -N 1
#SBATCH -n 8
#SBATCH -p regular-cpu

grompp -f pull_eq_np_28.mdp -c solution_em.gro -p system.top -n system.ndx -o pulling_28_eq -maxwarn 1
mdrun -v -deffnm pulling_28_eq -cpi pulling_28_eq.cpt

grompp -f pull_md_np_28.mdp -c pulling_28_eq.gro -p system.top -n system.ndx -o pulling_28_md -maxwarn 1
mdrun -v -pf pullf_28.xvg -px pullx_28.xvg -deffnm pulling_28_md -cpi pulling_28_md.cpt

