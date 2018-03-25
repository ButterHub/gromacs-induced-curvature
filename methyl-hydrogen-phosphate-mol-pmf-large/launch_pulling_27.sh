#!/bin/bash
#SBATCH -J 27-VQJG
#SBATCH -o pmf-27.out
#SBATCH -N 1
#SBATCH -n 64
#SBATCH -p extended-cpu

mdrun -v -deffnm pulling_27_eq

grompp -f pull_md_27.mdp -c pulling_27_eq.gro -n solution.ndx -p solution.top -o pulling_27_md -maxwarn 1
mdrun -v -pf pullf_27.xvg -px pullx_27.xvg -deffnm pulling_27_md -cpi pulling_27_md.cpt

