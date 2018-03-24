#!/bin/bash
#SBATCH -J 7-UEYB
#SBATCH -o pmf-7.out
#SBATCH -N 1
#SBATCH -n 64
#SBATCH -p extended-cpu
mdrun -v -pf pullf_7.xvg -px pullx_7.xvg -deffnm pulling_7_md -cpi pulling_7_md.cpt

