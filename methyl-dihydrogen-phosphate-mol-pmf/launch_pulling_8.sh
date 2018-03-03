#!/bin/bash
#SBATCH -J mdp-8
#SBATCH -o pmf-8.out
#SBATCH -N 1
#SBATCH -n 8
#SBATCH -p extended-mem
mdrun -v -pf pullf_8.xvg -px pullx_8.xvg -deffnm pulling_8_md -cpi pulling_8_md.cpt
