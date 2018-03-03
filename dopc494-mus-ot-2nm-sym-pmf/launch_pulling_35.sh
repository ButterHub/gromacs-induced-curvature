#!/bin/bash
#SBATCH -J 35-dopc494-mus-ot-2nm-sym
#SBATCH -o pmf-35.out
#SBATCH -N 1
#SBATCH -n 8
#SBATCH -p extended-mem

grompp -f pull_eq_np_35.mdp -c solution_em.gro -p system.top -n system.ndx -o pulling_35_eq.tpr -maxwarn 1
mdrun -v -deffnm pulling_35_eq -cpi pulling_35_eq.cpt

grompp -f pull_md_np_35.mdp -c pulling_35_eq.gro -p system.top -n system.ndx -o pulling_35_md.tpr -maxwarn 1
mdrun -v -pf pullf_35.xvg -px pullx_35.xvg -deffnm pulling_35_md -cpi pulling_35_md.cpt

