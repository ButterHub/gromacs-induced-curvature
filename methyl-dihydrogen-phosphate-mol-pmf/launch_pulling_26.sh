#!/bin/bash
#SBATCH -J 26-methyl-phosphate
#SBATCH -o pmf-26.out
#SBATCH -N 1
#SBATCH -n 8
#SBATCH -p regular-cpu

mdrun -v -pf pullf_26.xvg -px pullx_26.xvg -s pulling_26_md_2.tpr -deffnm pulling_26_md -cpi pulling_26_md.cpt

