#!/bin/bash
#SBATCH -J 0-UEYB
#SBATCH -o pmf-0.out
#SBATCH -N 1
#SBATCH -n 64
#SBATCH -p extended-cpu
mdrun -v -pf pullf_0.xvg -px pullx_0.xvg -deffnm pulling_0_md -cpi pulling_0_md.cpt

