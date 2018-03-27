#!/bin/bash
#SBATCH -J 14-VQJG
#SBATCH -o pmf-14.out
#SBATCH -N 1
#SBATCH -n 32
#SBATCH -p extended-mem
mdrun -v -pf pullf_14.xvg -px pullx_14.xvg -deffnm pulling_14_md -cpi pulling_14_md.cpt

