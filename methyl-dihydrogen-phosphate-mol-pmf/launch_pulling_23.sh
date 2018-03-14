#!/bin/bash
#SBATCH -J 23-methyl-phosphate
#SBATCH -o pmf-23.out
#SBATCH -N 1
#SBATCH -n 8
#SBATCH -p regular-cpu

mdrun -v -pf pullf_23.xvg -px pullx_23.xvg -s pulling_23_md_2.tpr -deffnm pulling_23_md -cpi pulling_23_md.cpt

