#!/bin/bash
#SBATCH -J 2-UEYB
#SBATCH -o pmf-2.out
#SBATCH -N 1
#SBATCH -n 64
#SBATCH -p extended-cpu

mdrun -v -pf pullf_2.xvg -px pullx_2.xvg -deffnm pulling_2_md -cpi pulling_2_md.cpt

