#!/bin/bash
#SBATCH -J 6-dopc398-ribbon-mus-ot-2nm-sym
#SBATCH -o pmf-6.out
#SBATCH -N 1
#SBATCH -n 8
#SBATCH -p extended-mem

grompp -f pull_eq_np_6.mdp -c solution_em.gro -p system.top -n system.ndx -o pulling_6_eq.tpr -maxwarn 1
mdrun -v -deffnm pulling_6_eq -cpi pulling_6_eq.cpt

grompp -f pull_md_np_6.mdp -c pulling_6_eq.gro -p system.top -n system.ndx -o pulling_6_md.tpr -maxwarn 1
mdrun -v -pf pullf_6.xvg -px pullx_6.xvg -deffnm pulling_6_md -cpi pulling_6_md.cpt

