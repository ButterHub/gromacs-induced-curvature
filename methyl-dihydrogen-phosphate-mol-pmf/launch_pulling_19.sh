#!/bin/bash
#SBATCH -J mdp-19
#SBATCH -o pmf-19.out
#SBATCH -N 1
#SBATCH -n 8
#SBATCH -p extended-mem
mdrun -v -pf pullf_19.xvg -px pullx_19.xvg -deffnm pulling_19_md -cpi pulling_19_md.cpt
