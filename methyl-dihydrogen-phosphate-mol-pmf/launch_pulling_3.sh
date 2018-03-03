#!/bin/bash
#SBATCH -J mdp-3
#SBATCH -o pmf-3.out
#SBATCH -N 1
#SBATCH -n 8
#SBATCH -p extended-mem
mdrun -v -pf pullf_3.xvg -px pullx_3.xvg -deffnm pulling_3_md -cpi pulling_3_md.cpt
