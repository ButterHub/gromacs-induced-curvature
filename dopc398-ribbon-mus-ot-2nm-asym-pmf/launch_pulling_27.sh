#!/bin/bash
#SBATCH -J 27-dopc398-ribbon-mus-ot-2nm-asym
#SBATCH -o pmf-27.out
#SBATCH -N 1
#SBATCH -n 8
#SBATCH -p regular-cpu

grompp -f pull_eq_np_27.mdp -c solution_em.gro -p system.top -n system.ndx -o pulling_27_eq.tpr -maxwarn 1
mdrun -v -deffnm pulling_27_eq -cpi pulling_27_eq.cpt

grompp -f pull_md_np_27.mdp -c pulling_27_eq.gro -p system.top -n system.ndx -o pulling_27_md.tpr -maxwarn 1
mdrun -v -pf pullf_27.xvg -px pullx_27.xvg -deffnm pulling_27_md -cpi pulling_27_md.cpt

