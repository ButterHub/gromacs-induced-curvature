#!/bin/bash
#SBATCH -J 31-UEYB
#SBATCH -o pmf-31.out
#SBATCH -N 1
#SBATCH -n 64
#SBATCH -p extended-cpu
mdrun -v -pf pullf_31.xvg -px pullx_31.xvg -deffnm pulling_31_md -cpi pulling_31_md.cpt

