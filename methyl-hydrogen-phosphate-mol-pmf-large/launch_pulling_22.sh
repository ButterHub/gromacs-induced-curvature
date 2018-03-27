#!/bin/bash
#SBATCH -J 22-VQJG
#SBATCH -o pmf-22.out
#SBATCH -N 1
#SBATCH -n 32
#SBATCH -p extended-mem
mdrun -v -pf pullf_22.xvg -px pullx_22.xvg -deffnm pulling_22_md -cpi pulling_22_md.cpt

