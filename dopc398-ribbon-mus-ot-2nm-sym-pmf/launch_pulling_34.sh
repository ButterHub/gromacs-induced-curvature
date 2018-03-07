#!/bin/bash
#SBATCH -J 34-dopc398-ribbon-mus-ot-2nm-sym
#SBATCH -o pmf-34.out
#SBATCH -N 1
#SBATCH -n 8
#SBATCH -p extended-mem

grompp -f pull_eq_np_34.mdp -c solution_em.gro -p system.top -n system.ndx -o pulling_34_eq.tpr -maxwarn 1
mdrun -v -deffnm pulling_34_eq -cpi pulling_34_eq.cpt

grompp -f pull_md_np_34.mdp -c pulling_34_eq.gro -p system.top -n system.ndx -o pulling_34_md.tpr -maxwarn 1
mdrun -v -pf pullf_34.xvg -px pullx_34.xvg -deffnm pulling_34_md -cpi pulling_34_md.cpt

