#!/bin/bash
#SBATCH -J 21-methyl-hydrogen-phosphate
#SBATCH -o pmf-21.out
#SBATCH -N 1
#SBATCH -n 8
#SBATCH -p regular-cpu

mdrun -v -pf pullf_21.xvg -px pullx_21.xvg -s pulling_21_md_2.tpr -deffnm pulling_21_md -cpi pulling_21_md.cpt

