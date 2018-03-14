#!/bin/bash
#SBATCH -J 27-methyl-sulfonate
#SBATCH -o pmf-27.out
#SBATCH -N 1
#SBATCH -n 8
#SBATCH -p regular-cpu

mdrun -v -pf pullf_27.xvg -px pullx_27.xvg -s pulling_27_md_2.tpr -deffnm pulling_27_md -cpi pulling_27_md.cpt

