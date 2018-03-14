#!/bin/bash
#SBATCH -J 28-methyl-hydrogen-phosphate
#SBATCH -o pmf-28.out
#SBATCH -N 1
#SBATCH -n 8
#SBATCH -p regular-cpu

mdrun -v -pf pullf_28.xvg -px pullx_28.xvg -s pulling_28_md_2.tpr -deffnm pulling_28_md -cpi pulling_28_md.cpt

