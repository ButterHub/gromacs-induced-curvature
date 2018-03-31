#!/bin/bash
#SBATCH -J 30-VQJG
#SBATCH -o pmf-30.out
#SBATCH -N 1
#SBATCH -n 32
#SBATCH -p extended-mem

mdrun -v -pf pullf_30.xvg -px pullx_30.xvg -deffnm pulling_30_md -cpi pulling_30_md.cpt

