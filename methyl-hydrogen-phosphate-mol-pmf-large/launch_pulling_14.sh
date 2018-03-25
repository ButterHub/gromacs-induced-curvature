#!/bin/bash
#SBATCH -J 14-VQJG
#SBATCH -o pmf-14.out
#SBATCH -N 1
#SBATCH -n 32
#SBATCH -p extended-mem

mdrun -v -deffnm pulling_14_eq

grompp -f pull_md_14.mdp -c pulling_14_eq.gro -n solution.ndx -p solution.top -o pulling_14_md -maxwarn 1
mdrun -v -pf pullf_14.xvg -px pullx_14.xvg -deffnm pulling_14_md -cpi pulling_14_md.cpt

