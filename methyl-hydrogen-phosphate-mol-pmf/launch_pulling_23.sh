#!/bin/bash
#SBATCH -J VQJG-23
#SBATCH -o pmf-23.out
#SBATCH -N 1
#SBATCH -n 8
#SBATCH -p extended-mem

mdrun -v -pf pullf_23.xvg -px pullx_23.xvg -deffnm pulling_23_md -cpi pulling_23_md.cpt
