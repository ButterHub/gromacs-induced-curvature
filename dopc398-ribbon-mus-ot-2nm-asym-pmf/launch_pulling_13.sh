#!/bin/bash
#SBATCH -J 13-dopc398-ribbon-mus-ot-2nm-asym
#SBATCH -o pmf-13.out
#SBATCH -N 1
#SBATCH -n 64
#SBATCH -p extended-cpu

grompp -f pull_eq_np_13.mdp -c solution_em.gro -p system.top -n system.ndx -o pulling_13_eq.tpr -maxwarn 1
mdrun -v -deffnm pulling_13_eq -cpi pulling_13_eq.cpt

grompp -f pull_md_np_13.mdp -c pulling_13_eq.gro -p system.top -n system.ndx -o pulling_13_md.tpr -maxwarn 1
mdrun -v -pf pullf_13.xvg -px pullx_13.xvg -deffnm pulling_13_md -cpi pulling_13_md.cpt

