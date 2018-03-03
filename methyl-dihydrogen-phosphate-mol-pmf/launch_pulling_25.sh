#!/bin/bash
#SBATCH -J mdp-25
#SBATCH -o pmf-25.out
#SBATCH -N 1
#SBATCH -n 8
#SBATCH -p extended-mem
mdrun -v -pf pullf_25.xvg -px pullx_25.xvg -deffnm pulling_25_md -cpi pulling_25_md.cpt
