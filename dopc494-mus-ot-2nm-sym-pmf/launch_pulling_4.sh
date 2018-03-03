#!/bin/bash
#SBATCH -J 4-dopc494-mus-ot-2nm-sym
#SBATCH -o pmf-4.out
#SBATCH -N 1
#SBATCH -n 8
#SBATCH -p extended-mem

grompp -f pull_eq_np_4.mdp -c solution_em.gro -p system.top -n system.ndx -o pulling_4_eq.tpr -maxwarn 1
mdrun -v -deffnm pulling_4_eq -cpi pulling_4_eq.cpt

grompp -f pull_md_np_4.mdp -c pulling_4_eq.gro -p system.top -n system.ndx -o pulling_4_md.tpr -maxwarn 1
mdrun -v -pf pullf_4.xvg -px pullx_4.xvg -deffnm pulling_4_md -cpi pulling_4_md.cpt

