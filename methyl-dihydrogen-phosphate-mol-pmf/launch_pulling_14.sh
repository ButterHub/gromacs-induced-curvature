#!/bin/bash
#SBATCH -J 14-methyl-phosphate
#SBATCH -o pmf-14.out
#SBATCH -N 1
#SBATCH -n 64
#SBATCH -p extended-cpu

mdrun -v -pf pullf_14.xvg -px pullx_14.xvg -s pulling_14_md_2.tpr -deffnm pulling_14_md -cpi pulling_14_md.cpt

