#!/bin/bash
#SBATCH -J 17-UEYB
#SBATCH -o pmf-17.out
#SBATCH -N 1
#SBATCH -n 64
#SBATCH -p extended-cpu
mdrun -v -pf pullf_17.xvg -px pullx_17.xvg -deffnm pulling_17_md -cpi pulling_17_md.cpt

