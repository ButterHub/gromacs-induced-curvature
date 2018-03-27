#!/bin/bash
#SBATCH -J 8-VQJG
#SBATCH -o pmf-8.out
#SBATCH -N 1
#SBATCH -n 32
#SBATCH -p extended-mem
mdrun -v -pf pullf_8.xvg -px pullx_8.xvg -deffnm pulling_8_md -cpi pulling_8_md.cpt

