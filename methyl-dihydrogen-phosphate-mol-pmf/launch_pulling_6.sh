#!/bin/bash
#SBATCH -J 6-methyl-phosphate
#SBATCH -o pmf-6.out
#SBATCH -N 1
#SBATCH -n 64
#SBATCH -p extended-cpu

mdrun -v -pf pullf_6.xvg -px pullx_6.xvg -s pulling_6_md_2.tpr -deffnm pulling_6_md -cpi pulling_6_md.cpt

