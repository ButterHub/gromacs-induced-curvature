#!/bin/bash
#SBATCH -J 32-mus-2nm-sym
#SBATCH -o pmf-32.out
#SBATCH -N 1
#SBATCH -n 8
#SBATCH -p extended-mem

grompp -f pull_eq_np_32.mdp -c solution_em.gro -p system.top -n system.ndx -o pulling_32_eq -maxwarn 1
mdrun -v -deffnm pulling_32_eq -cpi pulling_32_eq.cpt

grompp -f pull_md_np_32.mdp -c pulling_32_eq.gro -p system.top -n system.ndx -o pulling_32_md -maxwarn 1
mdrun -v -pf pullf_32.xvg -px pullx_32.xvg -deffnm pulling_32_md -cpi pulling_32_md.cpt

