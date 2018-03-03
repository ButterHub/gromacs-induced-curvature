#!/bin/bash
#SBATCH -J mdp-13
#SBATCH -o pmf-13.out
#SBATCH -N 1
#SBATCH -n 8
#SBATCH -p extended-mem
mdrun -v -pf pullf_13.xvg -px pullx_13.xvg -deffnm pulling_13_md -cpi pulling_13_md.cpt
