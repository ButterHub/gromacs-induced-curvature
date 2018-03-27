#!/bin/bash
#SBATCH -J 29-UEYB
#SBATCH -o pmf-29.out
#SBATCH -N 1
#SBATCH -n 64
#SBATCH -p extended-cpu

mdrun -v -pf pullf_29.xvg -px pullx_29.xvg -deffnm pulling_29_md -cpi pulling_29_md.cpt

