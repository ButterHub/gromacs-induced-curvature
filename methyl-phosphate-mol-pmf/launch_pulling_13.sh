#!/bin/bash
#SBATCH -J 13-methyl-phosphate
#SBATCH -o pmf-13.out
#SBATCH -N 1
#SBATCH -n 8
#SBATCH -p regular-cpu

mdrun -v -pf pullf_13.xvg -px pullx_13.xvg -deffnm pulling_13_md -cpi pulling_13_md.cpt

