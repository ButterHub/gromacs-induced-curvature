#!/bin/bash
#SBATCH -J 0-methyl-phosphate
#SBATCH -o pmf-0.out
#SBATCH -N 1
#SBATCH -n 8
#SBATCH -p regular-cpu

mdrun -v -pf pullf_0.xvg -px pullx_0.xvg -s pulling_0_md_2.tpr -deffnm pulling_0_md -cpi pulling_0_md.cpt

