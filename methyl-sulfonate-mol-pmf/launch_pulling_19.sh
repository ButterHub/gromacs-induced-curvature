#!/bin/bash
#SBATCH -J 19-methyl-sulfonate
#SBATCH -o pmf-19.out
#SBATCH -N 1
#SBATCH -n 8
#SBATCH -p regular-cpu

mdrun -v -pf pullf_19.xvg -px pullx_19.xvg -s pulling_19_md_2.tpr -deffnm pulling_19_md -cpi pulling_19_md.cpt

