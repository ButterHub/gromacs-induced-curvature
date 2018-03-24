#!/bin/bash
#SBATCH -J 3-UEYB
#SBATCH -o pmf-3.out
#SBATCH -N 1
#SBATCH -n 64
#SBATCH -p extended-cpu
mdrun -v -pf pullf_3.xvg -px pullx_3.xvg -deffnm pulling_3_md -cpi pulling_3_md.cpt

