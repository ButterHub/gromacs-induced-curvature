#!/bin/bash
#SBATCH -J 23-UEYB
#SBATCH -o pmf-23.out
#SBATCH -N 1
#SBATCH -n 64
#SBATCH -p extended-cpu

mdrun -v -pf pullf_23.xvg -px pullx_23.xvg -deffnm pulling_23_md -cpi pulling_23_md.cpt

