#!/bin/bash
#SBATCH -J 19-dopc398-ribbon-mus-ot-2nm-sym
#SBATCH -o pmf-19.out
#SBATCH -N 1
#SBATCH -n 8
#SBATCH -p extended-mem

grompp -f pull_eq_np_19.mdp -c solution_em.gro -p system.top -n system.ndx -o pulling_19_eq.tpr -maxwarn 1
mdrun -v -deffnm pulling_19_eq -cpi pulling_19_eq.cpt

grompp -f pull_md_np_19.mdp -c pulling_19_eq.gro -p system.top -n system.ndx -o pulling_19_md.tpr -maxwarn 1
mdrun -v -pf pullf_19.xvg -px pullx_19.xvg -deffnm pulling_19_md -cpi pulling_19_md.cpt

