#!/bin/bash
#SBATCH -J 5-methyl-sulfonate
#SBATCH -o pmf-5.out
#SBATCH -N 1
#SBATCH -n 8
#SBATCH -p regular-cpu

mdrun -v -pf pullf_5.xvg -px pullx_5.xvg -s pulling_5_md_2.tpr -deffnm pulling_5_md -cpi pulling_5_md.cpt

