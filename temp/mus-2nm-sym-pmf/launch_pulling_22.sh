#!/bin/bash
#SBATCH -J 22-mus-2nm-sym
#SBATCH -o pmf-22.out
#SBATCH -N 1
#SBATCH -n 8
#SBATCH -p regular-cpu

grompp -f pull_eq_np_22.mdp -c solution_em.gro -p system.top -n system.ndx -o pulling_22_eq -maxwarn 1
mdrun -v -deffnm pulling_22_eq -cpi pulling_22_eq.cpt

grompp -f pull_md_np_22.mdp -c pulling_22_eq.gro -p system.top -n system.ndx -o pulling_22_md -maxwarn 1
mdrun -v -pf pullf_22.xvg -px pullx_22.xvg -deffnm pulling_22_md -cpi pulling_22_md.cpt

