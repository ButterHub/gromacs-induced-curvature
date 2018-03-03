#!/bin/bash
#SBATCH -J mdp-17
#SBATCH -o pmf-17.out
#SBATCH -N 1
#SBATCH -n 8
#SBATCH -p extended-mem
mdrun -v -pf pullf_17.xvg -px pullx_17.xvg -deffnm pulling_17_md -cpi pulling_17_md.cpt
