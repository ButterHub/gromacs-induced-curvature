#!/bin/bash
#SBATCH -J mdp-32
#SBATCH -o pmf-32.out
#SBATCH -N 1
#SBATCH -n 8
#SBATCH -p extended-mem
mdrun -v -pf pullf_32.xvg -px pullx_32.xvg -deffnm pulling_32_md -cpi pulling_32_md.cpt
