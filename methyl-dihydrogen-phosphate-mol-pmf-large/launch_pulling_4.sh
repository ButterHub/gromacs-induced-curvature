#!/bin/bash
#SBATCH -J 4-UEYB
#SBATCH -o pmf-4.out
#SBATCH -N 1
#SBATCH -n 64
#SBATCH -p extended-cpu
mdrun -v -pf pullf_4.xvg -px pullx_4.xvg -deffnm pulling_4_md -cpi pulling_4_md.cpt

