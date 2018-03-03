#!/bin/bash
#SBATCH -J 5-
#SBATCH -o pmf-5.out
#SBATCH -N 1
#SBATCH -n 8
#SBATCH -p extended-mem
mdrun -v -pf pullf_5.xvg -px pullx_5.xvg -deffnm pulling_5_md -cpi pulling_5_md.cpt
