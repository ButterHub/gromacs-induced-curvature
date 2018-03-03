#!/bin/bash
#SBATCH -J VQJG-31
#SBATCH -o pmf-31.out
#SBATCH -N 1
#SBATCH -n 8
#SBATCH -p extended-mem

mdrun -v -pf pullf_31.xvg -px pullx_31.xvg -deffnm pulling_31_md -cpi pulling_31_md.cpt
