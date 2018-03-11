#!/bin/bash
#SBATCH -J 33-dopc494-mus-ot-2nm-sym
#SBATCH -o pmf-33.out
#SBATCH -N 1
#SBATCH -n 32
#SBATCH -p extended-mem

grompp -f pull_eq_np_33.mdp -c solution_em.gro -p system.top -n system.ndx -o pulling_33_eq.tpr -maxwarn 1
mdrun -v -deffnm pulling_33_eq -cpi pulling_33_eq.cpt

grompp -f pull_md_np_33.mdp -c pulling_33_eq.gro -p system.top -n system.ndx -o pulling_33_md.tpr -maxwarn 1
mdrun -v -pf pullf_33.xvg -px pullx_33.xvg -deffnm pulling_33_md -cpi pulling_33_md.cpt

