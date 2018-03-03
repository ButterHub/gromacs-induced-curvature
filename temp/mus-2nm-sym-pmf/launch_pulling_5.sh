#!/bin/bash
#SBATCH -J 5-mus-2nm-sym
#SBATCH -o pmf-5.out
#SBATCH -N 1
#SBATCH -n 8
#SBATCH -p extended-mem

grompp -f pull_eq_np_5.mdp -c solution_em.gro -p system.top -n system.ndx -o pulling_5_eq -maxwarn 1
mdrun -v -deffnm pulling_5_eq -cpi pulling_5_eq.cpt

grompp -f pull_md_np_5.mdp -c pulling_5_eq.gro -p system.top -n system.ndx -o pulling_5_md -maxwarn 1
mdrun -v -pf pullf_5.xvg -px pullx_5.xvg -deffnm pulling_5_md -cpi pulling_5_md.cpt

