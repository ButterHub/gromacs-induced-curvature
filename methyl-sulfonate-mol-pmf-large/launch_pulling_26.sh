#!/bin/bash
#SBATCH -J IXUV-26
#SBATCH -o pmf-26.out
#SBATCH -N 1
#SBATCH -n 32
#SBATCH -p extended-mem
mdrun -v -pf pullf_26.xvg -px pullx_26.xvg -deffnm pulling_26_md -cpi pulling_26_md.cpt

