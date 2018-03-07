#!/bin/bash
#SBATCH -J 3-dopc398-ribbon-mus-ot-2nm-sym
#SBATCH -o pmf-3.out
#SBATCH -N 1
#SBATCH -n 8
#SBATCH -p extended-mem

grompp -f pull_eq_np_3.mdp -c solution_em.gro -p system.top -n system.ndx -o pulling_3_eq.tpr -maxwarn 1
mdrun -v -deffnm pulling_3_eq -cpi pulling_3_eq.cpt

grompp -f pull_md_np_3.mdp -c pulling_3_eq.gro -p system.top -n system.ndx -o pulling_3_md.tpr -maxwarn 1
mdrun -v -pf pullf_3.xvg -px pullx_3.xvg -deffnm pulling_3_md -cpi pulling_3_md.cpt

