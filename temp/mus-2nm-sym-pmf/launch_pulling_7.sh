#!/bin/bash
#SBATCH -J 7-mus-2nm-sym
#SBATCH -o pmf-7.out
#SBATCH -N 1
#SBATCH -n 8
#SBATCH -p extended-mem

grompp -f pull_eq_np_7.mdp -c solution_em.gro -p system.top -n system.ndx -o pulling_7_eq -maxwarn 1
mdrun -v -deffnm pulling_7_eq -cpi pulling_7_eq.cpt

grompp -f pull_md_np_7.mdp -c pulling_7_eq.gro -p system.top -n system.ndx -o pulling_7_md -maxwarn 1
mdrun -v -pf pullf_7.xvg -px pullx_7.xvg -deffnm pulling_7_md -cpi pulling_7_md.cpt

