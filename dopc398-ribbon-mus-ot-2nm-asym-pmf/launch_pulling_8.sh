#!/bin/bash
#SBATCH -J 8-dopc398-ribbon-mus-ot-2nm-asym
#SBATCH -o pmf-8.out
#SBATCH -N 1
#SBATCH -n 8
#SBATCH -p regular-cpu

grompp -f pull_eq_np_8.mdp -c solution_em.gro -p system.top -n system.ndx -o pulling_8_eq.tpr -maxwarn 1
mdrun -v -deffnm pulling_8_eq -cpi pulling_8_eq.cpt

grompp -f pull_md_np_8.mdp -c pulling_8_eq.gro -p system.top -n system.ndx -o pulling_8_md.tpr -maxwarn 1
mdrun -v -pf pullf_8.xvg -px pullx_8.xvg -deffnm pulling_8_md -cpi pulling_8_md.cpt

