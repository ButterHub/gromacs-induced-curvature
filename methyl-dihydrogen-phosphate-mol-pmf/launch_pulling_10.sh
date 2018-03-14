#!/bin/bash
#SBATCH -J 10-methyl-phosphate
#SBATCH -o pmf-10.out
#SBATCH -N 1
#SBATCH -n 8
#SBATCH -p regular-cpu

mdrun -v -pf pullf_10.xvg -px pullx_10.xvg -s pulling_10_md_2.tpr -deffnm pulling_10_md -cpi pulling_10_md.cpt

