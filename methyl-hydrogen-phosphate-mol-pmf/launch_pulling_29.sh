#!/bin/bash
#SBATCH -J 29-methyl-hydrogen-phosphate
#SBATCH -o pmf-29.out
#SBATCH -N 1
#SBATCH -n 8
#SBATCH -p regular-cpu

mdrun -v -pf pullf_29.xvg -px pullx_29.xvg -s pulling_29_md_2.tpr -deffnm pulling_29_md -cpi pulling_29_md.cpt

