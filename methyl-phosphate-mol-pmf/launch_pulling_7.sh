#!/bin/bash
#SBATCH -J 7-methyl-phosphate
#SBATCH -o pmf-7.out
#SBATCH -N 1
#SBATCH -n 8
#SBATCH -p regular-cpu

mdrun -v -pf pullf_7.xvg -px pullx_7.xvg -deffnm pulling_7_md -cpi pulling_7_md.cpt

