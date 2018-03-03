#!/bin/bash
#SBATCH -J 12-
#SBATCH -o pmf-12.out
#SBATCH -N 1
#SBATCH -n 8
#SBATCH -p extended-mem
mdrun -v -pf pullf_12.xvg -px pullx_12.xvg -deffnm pulling_12_md -cpi pulling_12_md.cpt
