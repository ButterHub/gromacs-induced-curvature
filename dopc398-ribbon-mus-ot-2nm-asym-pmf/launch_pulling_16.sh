#!/bin/bash
#SBATCH -J 16-dopc398-ribbon-mus-ot-2nm-asym
#SBATCH -o pmf-16.out
#SBATCH -N 1
#SBATCH -n 64
#SBATCH -p extended-cpu

grompp -f pull_eq_np_16.mdp -c solution_em.gro -p system.top -n system.ndx -o pulling_16_eq.tpr -maxwarn 1
mdrun -v -deffnm pulling_16_eq -cpi pulling_16_eq.cpt

grompp -f pull_md_np_16.mdp -c pulling_16_eq.gro -p system.top -n system.ndx -o pulling_16_md.tpr -maxwarn 1
mdrun -v -pf pullf_16.xvg -px pullx_16.xvg -deffnm pulling_16_md -cpi pulling_16_md.cpt

