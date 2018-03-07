#!/bin/bash
#SBATCH -J 25-dopc398-ribbon-mus-ot-2nm-asym
#SBATCH -o pmf-25.out
#SBATCH -N 1
#SBATCH -n 8
#SBATCH -p regular-cpu

grompp -f pull_eq_np_25.mdp -c solution_em.gro -p system.top -n system.ndx -o pulling_25_eq.tpr -maxwarn 1
mdrun -v -deffnm pulling_25_eq -cpi pulling_25_eq.cpt

grompp -f pull_md_np_25.mdp -c pulling_25_eq.gro -p system.top -n system.ndx -o pulling_25_md.tpr -maxwarn 1
mdrun -v -pf pullf_25.xvg -px pullx_25.xvg -deffnm pulling_25_md -cpi pulling_25_md.cpt

