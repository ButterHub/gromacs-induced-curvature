#!/bin/bash
#SBATCH -J VQJG-28
#SBATCH -o pmf-28.out
#SBATCH -N 1
#SBATCH -n 32
#SBATCH -p extended-mem 

mdrun -v -pf pullf_28.xvg -px pullx_28.xvg -deffnm pulling_28_md -cpi pulling_28_md.cpt

