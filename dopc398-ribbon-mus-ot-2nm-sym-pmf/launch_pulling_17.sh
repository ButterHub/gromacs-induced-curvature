#!/bin/bash
#SBATCH -J 17-dopc398-ribbon-mus-ot-2nm-sym
#SBATCH -o pmf-17.out
#SBATCH -N 1
#SBATCH -n 8
#SBATCH -p extended-mem

grompp -f pull_eq_np_17.mdp -c solution_em.gro -p system.top -n system.ndx -o pulling_17_eq.tpr -maxwarn 1
mdrun -v -deffnm pulling_17_eq -cpi pulling_17_eq.cpt

grompp -f pull_md_np_17.mdp -c pulling_17_eq.gro -p system.top -n system.ndx -o pulling_17_md.tpr -maxwarn 1
mdrun -v -pf pullf_17.xvg -px pullx_17.xvg -deffnm pulling_17_md -cpi pulling_17_md.cpt

