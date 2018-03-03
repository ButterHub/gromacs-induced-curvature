#!/bin/bash
#SBATCH -J VQJG-20
#SBATCH -o pmf-20.out
#SBATCH -N 1
#SBATCH -n 8
#SBATCH -p extended-mem

mdrun -v -pf pullf_20.xvg -px pullx_20.xvg -deffnm pulling_20_md -cpi pulling_20_md.cpt
