#!/bin/bash
#SBATCH -J VQJG-4
#SBATCH -o pmf-4.out
#SBATCH -N 1
#SBATCH -n 8
#SBATCH -p extended-mem

mdrun -v -pf pullf_4.xvg -px pullx_4.xvg -deffnm pulling_4_md -cpi pulling_4_md.cpt
