#!/bin/bash
#SBATCH -J 35-methyl-hydrogen-phosphate
#SBATCH -o pmf-35.out
#SBATCH -N 1
#SBATCH -n 32
#SBATCH -p extended-mem

mdrun -v -pf pullf_35.xvg -px pullx_35.xvg -s pulling_35_md_2.tpr -deffnm pulling_35_md -cpi pulling_35_md.cpt

