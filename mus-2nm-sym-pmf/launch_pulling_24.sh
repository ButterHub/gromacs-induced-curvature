#!/bin/bash
#SBATCH -J 24-
#SBATCH -o pmf-24.out
#SBATCH -N 1
#SBATCH -n 8
#SBATCH -p regular-cpu
mdrun -v -pf pullf_24.xvg -px pullx_24.xvg -deffnm pulling_24_md -cpi pulling_24_md.cpt
