#!/bin/bash
#SBATCH -J mdp-1
#SBATCH -o pmf-1.out
#SBATCH -N 1
#SBATCH -n 8
#SBATCH -p extended-mem
mdrun -v -pf pullf_1.xvg -px pullx_1.xvg -deffnm pulling_1_md -cpi pulling_1_md.cpt
