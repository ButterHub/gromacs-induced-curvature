#!/bin/bash
#SBATCH -J 28-UEYB
#SBATCH -o pmf-28.out
#SBATCH -N 1
#SBATCH -n 64
#SBATCH -p extended-cpu
mdrun -v -pf pullf_28.xvg -px pullx_28.xvg -deffnm pulling_28_md -cpi pulling_28_md.cpt

