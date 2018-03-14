#!/bin/bash
#SBATCH -J 1-methyl-hydrogen-phosphate
#SBATCH -o pmf-1.out
#SBATCH -N 1
#SBATCH -n 8
#SBATCH -p regular-cpu

mdrun -v -pf pullf_1.xvg -px pullx_1.xvg -s pulling_1_md_2.tpr -deffnm pulling_1_md -cpi pulling_1_md.cpt

