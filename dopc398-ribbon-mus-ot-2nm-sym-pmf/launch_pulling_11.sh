#!/bin/bash
#SBATCH -J 11-dopc398-ribbon-mus-ot-2nm-sym
#SBATCH -o pmf-11.out
#SBATCH -N 1
#SBATCH -n 8
#SBATCH -p extended-mem

grompp -f pull_eq_np_11.mdp -c solution_em.gro -p system.top -n system.ndx -o pulling_11_eq.tpr -maxwarn 1
mdrun -v -deffnm pulling_11_eq -cpi pulling_11_eq.cpt

grompp -f pull_md_np_11.mdp -c pulling_11_eq.gro -p system.top -n system.ndx -o pulling_11_md.tpr -maxwarn 1
mdrun -v -pf pullf_11.xvg -px pullx_11.xvg -deffnm pulling_11_md -cpi pulling_11_md.cpt

