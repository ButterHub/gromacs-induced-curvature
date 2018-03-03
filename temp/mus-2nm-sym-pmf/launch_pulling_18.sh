#!/bin/bash
#SBATCH -J 18-mus-2nm-sym
#SBATCH -o pmf-18.out
#SBATCH -N 1
#SBATCH -n 8
#SBATCH -p extended-mem

grompp -f pull_eq_np_18.mdp -c solution_em.gro -p system.top -n system.ndx -o pulling_18_eq -maxwarn 1
mdrun -v -deffnm pulling_18_eq -cpi pulling_18_eq.cpt

grompp -f pull_md_np_18.mdp -c pulling_18_eq.gro -p system.top -n system.ndx -o pulling_18_md -maxwarn 1
mdrun -v -pf pullf_18.xvg -px pullx_18.xvg -deffnm pulling_18_md -cpi pulling_18_md.cpt

