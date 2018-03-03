#!/bin/bash
#SBATCH -J mdp-21
#SBATCH -o pmf-21.out
#SBATCH -N 1
#SBATCH -n 8
#SBATCH -p extended-mem
mdrun -v -pf pullf_21.xvg -px pullx_21.xvg -deffnm pulling_21_md -cpi pulling_21_md.cpt
