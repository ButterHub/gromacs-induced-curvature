#!/bin/bash
#SBATCH -J 11-methyl-phosphate
#SBATCH -o pmf-11.out
#SBATCH -N 1
#SBATCH -n 8
#SBATCH -p regular-cpu

mdrun -v -pf pullf_11.xvg -px pullx_11.xvg -deffnm pulling_11_md -cpi pulling_11_md.cpt

