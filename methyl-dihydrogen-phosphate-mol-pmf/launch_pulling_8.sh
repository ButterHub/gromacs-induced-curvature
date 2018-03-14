#!/bin/bash
#SBATCH -J 8-methyl-phosphate
#SBATCH -o pmf-8.out
#SBATCH -N 1
#SBATCH -n 8
#SBATCH -p regular-cpu

mdrun -v -pf pullf_8.xvg -px pullx_8.xvg -s pulling_8_md_2.tpr -deffnm pulling_8_md -cpi pulling_8_md.cpt

