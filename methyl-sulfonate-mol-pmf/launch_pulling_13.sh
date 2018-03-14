#!/bin/bash
#SBATCH -J 13-methyl-sulfonate
#SBATCH -o pmf-13.out
#SBATCH -N 1
#SBATCH -n 8
#SBATCH -p regular-cpu

mdrun -v -pf pullf_13.xvg -px pullx_13.xvg -s pulling_13_md_2.tpr -deffnm pulling_13_md -cpi pulling_13_md.cpt

