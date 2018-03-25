#!/bin/bash
#SBATCH -J 19-UEYB
#SBATCH -o pmf-19.out
#SBATCH -N 1
#SBATCH -n 64
#SBATCH -p extended-cpu

mdrun -v -pf pullf_19.xvg -px pullx_19.xvg -deffnm pulling_19_md -cpi pulling_19_md.cpt

