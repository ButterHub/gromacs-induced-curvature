#!/bin/bash
#SBATCH -J VQJG-11
#SBATCH -o pmf-11.out
#SBATCH -N 1
#SBATCH -n 8
#SBATCH -p extended-mem

mdrun -v -pf pullf_11.xvg -px pullx_11.xvg -deffnm pulling_11_md -cpi pulling_11_md.cpt
