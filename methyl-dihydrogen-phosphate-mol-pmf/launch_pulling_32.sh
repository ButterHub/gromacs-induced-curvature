#!/bin/bash
#SBATCH -J 32-methyl-phosphate
#SBATCH -o pmf-32.out
#SBATCH -N 1
#SBATCH -n 8
#SBATCH -p regular-cpu

mdrun -v -pf pullf_32.xvg -px pullx_32.xvg -s pulling_32_md_2.tpr -deffnm pulling_32_md -cpi pulling_32_md.cpt

