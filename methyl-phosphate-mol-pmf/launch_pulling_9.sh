#!/bin/bash
#SBATCH -J 9-methyl-phosphate
#SBATCH -o pmf-9.out
#SBATCH -N 1
#SBATCH -n 8
#SBATCH -p regular-cpu

mdrun -v -pf pullf_9.xvg -px pullx_9.xvg -deffnm pulling_9_md -cpi pulling_9_md.cpt

