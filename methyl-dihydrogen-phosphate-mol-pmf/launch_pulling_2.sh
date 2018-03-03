#!/bin/bash
#SBATCH -J mdp-2
#SBATCH -o pmf-2.out
#SBATCH -N 1
#SBATCH -n 8
#SBATCH -p extended-mem
mdrun -v -pf pullf_2.xvg -px pullx_2.xvg -deffnm pulling_2_md -cpi pulling_2_md.cpt
