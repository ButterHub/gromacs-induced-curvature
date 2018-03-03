#!/bin/bash
#SBATCH -J 6-
#SBATCH -o pmf-6.out
#SBATCH -N 1
#SBATCH -n 8
#SBATCH -p extended-mem
mdrun -v -pf pullf_6.xvg -px pullx_6.xvg -deffnm pulling_6_md -cpi pulling_6_md.cpt
