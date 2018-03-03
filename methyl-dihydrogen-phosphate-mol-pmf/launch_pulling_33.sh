#!/bin/bash
#SBATCH -J mdp-33
#SBATCH -o pmf-33.out
#SBATCH -N 1
#SBATCH -n 8
#SBATCH -p extended-mem
mdrun -v -pf pullf_33.xvg -px pullx_33.xvg -deffnm pulling_33_md -cpi pulling_33_md.cpt
