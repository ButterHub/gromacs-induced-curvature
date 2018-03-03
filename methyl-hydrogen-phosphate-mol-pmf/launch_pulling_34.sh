#!/bin/bash
#SBATCH -J VQJG-34
#SBATCH -o pmf-34.out
#SBATCH -N 1
#SBATCH -n 8
#SBATCH -p extended-mem

mdrun -v -pf pullf_34.xvg -px pullx_34.xvg -deffnm pulling_34_md -cpi pulling_34_md.cpt
