#!/bin/bash
#SBATCH -J 3-methyl-hydrogen-phosphate
#SBATCH -o pmf-3.out
#SBATCH -N 1
#SBATCH -n 8
#SBATCH -p regular-cpu

mdrun -v -pf pullf_3.xvg -px pullx_3.xvg -s pulling_3_md_2.tpr -deffnm pulling_3_md -cpi pulling_3_md.cpt

