#!/bin/bash
#SBATCH -J 26-dopc398-ribbon-mus-ot-2nm-asym
#SBATCH -o pmf-26.out
#SBATCH -N 1
#SBATCH -n 8
#SBATCH -p regular-cpu

grompp -f pull_eq_np_26.mdp -c solution_em.gro -p system.top -n system.ndx -o pulling_26_eq.tpr -maxwarn 1
mdrun -v -deffnm pulling_26_eq -cpi pulling_26_eq.cpt

grompp -f pull_md_np_26.mdp -c pulling_26_eq.gro -p system.top -n system.ndx -o pulling_26_md.tpr -maxwarn 1
mdrun -v -pf pullf_26.xvg -px pullx_26.xvg -deffnm pulling_26_md -cpi pulling_26_md.cpt

