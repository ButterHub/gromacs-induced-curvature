#!/bin/bash
#SBATCH -J VQJG-16
#SBATCH -o pmf-16.out
#SBATCH -N 1
#SBATCH -n 8
#SBATCH -p extended-mem

mdrun -v -pf pullf_16.xvg -px pullx_16.xvg -deffnm pulling_16_md -cpi pulling_16_md.cpt
