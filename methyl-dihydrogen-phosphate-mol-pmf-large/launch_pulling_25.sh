#!/bin/bash
#SBATCH -J 25-UEYB
#SBATCH -o pmf-25.out
#SBATCH -N 1
#SBATCH -n 64
#SBATCH -p extended-cpu

mdrun -v -pf pullf_25.xvg -px pullx_25.xvg -deffnm pulling_25_md -cpi pulling_25_md.cpt

