#!/bin/bash
#SBATCH -J mdp-18
#SBATCH -o pmf-18.out
#SBATCH -N 1
#SBATCH -n 8
#SBATCH -p extended-mem
mdrun -v -pf pullf_18.xvg -px pullx_18.xvg -deffnm pulling_18_md -cpi pulling_18_md.cpt
