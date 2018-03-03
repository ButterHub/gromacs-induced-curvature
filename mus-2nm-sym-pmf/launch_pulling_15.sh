#!/bin/bash
#SBATCH -J 15-
#SBATCH -o pmf-15.out
#SBATCH -N 1
#SBATCH -n 8
#SBATCH -p extended-mem
mdrun -v -pf pullf_15.xvg -px pullx_15.xvg -deffnm pulling_15_md -cpi pulling_15_md.cpt
