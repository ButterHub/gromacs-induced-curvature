#!/bin/bash
#SBATCH -J 35-UEYB
#SBATCH -o pmf-35.out
#SBATCH -N 1
#SBATCH -n 64
#SBATCH -p extended-cpu
mdrun -v -pf pullf_35.xvg -px pullx_35.xvg -deffnm pulling_35_md -cpi pulling_35_md.cpt

