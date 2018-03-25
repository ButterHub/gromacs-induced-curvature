#!/bin/bash
#SBATCH -J 8-VQJG
#SBATCH -o pmf-8.out
#SBATCH -N 1
#SBATCH -n 32
#SBATCH -p extended-mem

mdrun -v -deffnm pulling_8_eq

grompp -f pull_md_8.mdp -c pulling_8_eq.gro -n solution.ndx -p solution.top -o pulling_8_md -maxwarn 1
mdrun -v -pf pullf_8.xvg -px pullx_8.xvg -deffnm pulling_8_md -cpi pulling_8_md.cpt

