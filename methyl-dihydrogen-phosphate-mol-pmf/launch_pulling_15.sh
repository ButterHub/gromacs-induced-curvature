#!/bin/bash
#SBATCH -J 15-methyl-phosphate
#SBATCH -o pmf-15.out
#SBATCH -N 1
#SBATCH -n 8
#SBATCH -p regular-cpu

mdrun -v -pf pullf_15.xvg -px pullx_15.xvg -s pulling_15_md_2.tpr -deffnm pulling_15_md -cpi pulling_15_md.cpt

