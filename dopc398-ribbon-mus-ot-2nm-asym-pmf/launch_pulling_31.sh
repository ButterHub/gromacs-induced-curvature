#!/bin/bash
#SBATCH -J 31-dopc398-ribbon-mus-ot-2nm-asym
#SBATCH -o pmf-31.out
#SBATCH -N 1
#SBATCH -n 8
#SBATCH -p regular-cpu

grompp -f pull_eq_np_31.mdp -c solution_em.gro -p system.top -n system.ndx -o pulling_31_eq.tpr -maxwarn 1
mdrun -v -deffnm pulling_31_eq -cpi pulling_31_eq.cpt

grompp -f pull_md_np_31.mdp -c pulling_31_eq.gro -p system.top -n system.ndx -o pulling_31_md.tpr -maxwarn 1
mdrun -v -pf pullf_31.xvg -px pullx_31.xvg -deffnm pulling_31_md -cpi pulling_31_md.cpt
