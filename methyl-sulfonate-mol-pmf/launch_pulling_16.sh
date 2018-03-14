#!/bin/bash
#SBATCH -J 16-methyl-sulfonate
#SBATCH -o pmf-16.out
#SBATCH -N 1
#SBATCH -n 8
#SBATCH -p regular-cpu

mdrun -v -pf pullf_16.xvg -px pullx_16.xvg -s pulling_16_md_2.tpr -deffnm pulling_16_md -cpi pulling_16_md.cpt

