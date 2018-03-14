#!/bin/bash
#SBATCH -J 33-methyl-phosphate
#SBATCH -o pmf-33.out
#SBATCH -N 1
#SBATCH -n 8
#SBATCH -p regular-cpu

mdrun -v -pf pullf_33.xvg -px pullx_33.xvg -deffnm pulling_33_md -cpi pulling_33_md.cpt

