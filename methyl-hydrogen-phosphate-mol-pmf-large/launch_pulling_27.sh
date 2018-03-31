#!/bin/bash
#SBATCH -J 27-VQJG
#SBATCH -o pmf-27.out
#SBATCH -N 1
#SBATCH -n 32
#SBATCH -p extended-mem

mdrun -v -pf pullf_27.xvg -px pullx_27.xvg -deffnm pulling_27_md -cpi pulling_27_md.cpt

