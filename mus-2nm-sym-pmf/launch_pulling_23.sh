#!/bin/bash
#SBATCH -J 23-
#SBATCH -o pmf-23.out
#SBATCH -N 1
#SBATCH -n 8
#SBATCH -p regular-cpu
mdrun -v -pf pullf_23.xvg -px pullx_23.xvg -deffnm pulling_23_md -cpi pulling_23_md.cpt
