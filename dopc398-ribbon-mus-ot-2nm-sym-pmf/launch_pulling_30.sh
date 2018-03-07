#!/bin/bash
#SBATCH -J 30-dopc398-ribbon-mus-ot-2nm-sym
#SBATCH -o pmf-30.out
#SBATCH -N 1
#SBATCH -n 8
#SBATCH -p extended-mem

grompp -f pull_eq_np_30.mdp -c solution_em.gro -p system.top -n system.ndx -o pulling_30_eq.tpr -maxwarn 1
mdrun -v -deffnm pulling_30_eq -cpi pulling_30_eq.cpt

grompp -f pull_md_np_30.mdp -c pulling_30_eq.gro -p system.top -n system.ndx -o pulling_30_md.tpr -maxwarn 1
mdrun -v -pf pullf_30.xvg -px pullx_30.xvg -deffnm pulling_30_md -cpi pulling_30_md.cpt

