#!/bin/bash
#SBATCH -J 17-methyl-phosphate
#SBATCH -o pmf-17.out
#SBATCH -N 1
#SBATCH -n 8
#SBATCH -p regular-cpu

mdrun -v -pf pullf_17.xvg -px pullx_17.xvg -s pulling_17_md_2.tpr -deffnm pulling_17_md -cpi pulling_17_md.cpt

