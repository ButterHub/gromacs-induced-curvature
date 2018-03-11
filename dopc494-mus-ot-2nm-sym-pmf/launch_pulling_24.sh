#!/bin/bash
#SBATCH -J 24-dopc494-mus-ot-2nm-sym
#SBATCH -o pmf-24.out
#SBATCH -N 1
#SBATCH -n 64
#SBATCH -p extended-cpu

grompp -f pull_eq_np_24.mdp -c solution_em.gro -p system.top -n system.ndx -o pulling_24_eq.tpr -maxwarn 1
mdrun -v -deffnm pulling_24_eq -cpi pulling_24_eq.cpt

grompp -f pull_md_np_24.mdp -c pulling_24_eq.gro -p system.top -n system.ndx -o pulling_24_md.tpr -maxwarn 1
mdrun -v -pf pullf_24.xvg -px pullx_24.xvg -deffnm pulling_24_md -cpi pulling_24_md.cpt

