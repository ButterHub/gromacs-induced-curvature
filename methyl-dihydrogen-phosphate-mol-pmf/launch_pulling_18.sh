#!/bin/bash
#SBATCH -J 18-methyl-phosphate
#SBATCH -o pmf-18.out
#SBATCH -N 1
#SBATCH -n 64
#SBATCH -p extended-cpu

mdrun -v -pf pullf_18.xvg -px pullx_18.xvg -s pulling_18_md_2.tpr -deffnm pulling_18_md -cpi pulling_18_md.cpt

