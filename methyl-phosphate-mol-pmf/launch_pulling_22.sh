#!/bin/bash
#SBATCH -J 22-methyl-phosphate
#SBATCH -o pmf-22.out
#SBATCH -N 1
#SBATCH -n 8
#SBATCH -p regular-cpu

mdrun -v -pf pullf_22.xvg -px pullx_22.xvg -deffnm pulling_22_md -cpi pulling_22_md.cpt

