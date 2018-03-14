#!/bin/bash
#SBATCH -J 31-methyl-phosphate
#SBATCH -o pmf-31.out
#SBATCH -N 1
#SBATCH -n 8
#SBATCH -p regular-cpu

mdrun -v -pf pullf_31.xvg -px pullx_31.xvg -s pulling_31_md_2.tpr -deffnm pulling_31_md -cpi pulling_31_md.cpt

