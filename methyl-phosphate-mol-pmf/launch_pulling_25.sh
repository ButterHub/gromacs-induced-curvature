#!/bin/bash
#SBATCH -J 25-methyl-phosphate
#SBATCH -o pmf-25.out
#SBATCH -N 1
#SBATCH -n 8
#SBATCH -p regular-cpu

mdrun -v -pf pullf_25.xvg -px pullx_25.xvg -deffnm pulling_25_md -cpi pulling_25_md.cpt

