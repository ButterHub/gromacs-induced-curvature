#!/bin/bash
#SBATCH -J 2-methyl-phosphate
#SBATCH -o pmf-2.out
#SBATCH -N 1
#SBATCH -n 8
#SBATCH -p regular-cpu

mdrun -v -pf pullf_2.xvg -px pullx_2.xvg -s pulling_2_md_2.tpr -deffnm pulling_2_md -cpi pulling_2_md.cpt

