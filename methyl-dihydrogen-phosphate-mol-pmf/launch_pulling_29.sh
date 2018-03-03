#!/bin/bash
#SBATCH -J mdp-29
#SBATCH -o pmf-29.out
#SBATCH -N 1
#SBATCH -n 8
#SBATCH -p extended-mem
mdrun -v -pf pullf_29.xvg -px pullx_29.xvg -deffnm pulling_29_md -cpi pulling_29_md.cpt
