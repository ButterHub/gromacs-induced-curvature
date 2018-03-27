#!/bin/bash
#SBATCH -J 21-UEYB
#SBATCH -o pmf-21.out
#SBATCH -N 1
#SBATCH -n 64
#SBATCH -p extended-cpu

mdrun -v -pf pullf_21.xvg -px pullx_21.xvg -deffnm pulling_21_md -cpi pulling_21_md.cpt

