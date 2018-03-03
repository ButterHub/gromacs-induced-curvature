#!/bin/bash
#SBATCH -J VQJG-35
#SBATCH -o pmf-35.out
#SBATCH -N 1
#SBATCH -n 8
#SBATCH -p extended-mem

mdrun -v -pf pullf_35.xvg -px pullx_35.xvg -deffnm pulling_35_md -cpi pulling_35_md.cpt
