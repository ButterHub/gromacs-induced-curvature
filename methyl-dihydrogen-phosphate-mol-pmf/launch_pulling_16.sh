#!/bin/bash
#SBATCH -J 16-methyl-phosphate
#SBATCH -o pmf-16.out
#SBATCH -N 1
#SBATCH -n 64
#SBATCH -p extended-cpu

mdrun -v -pf pullf_16.xvg -px pullx_16.xvg -s pulling_16_md_2.tpr -deffnm pulling_16_md -cpi pulling_16_md.cpt

