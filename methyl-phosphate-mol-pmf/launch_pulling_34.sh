#!/bin/bash
#SBATCH -J 34-methyl-phosphate
#SBATCH -o pmf-34.out
#SBATCH -N 1
#SBATCH -n 8
#SBATCH -p regular-cpu

mdrun -v -pf pullf_34.xvg -px pullx_34.xvg -deffnm pulling_34_md -cpi pulling_34_md.cpt

