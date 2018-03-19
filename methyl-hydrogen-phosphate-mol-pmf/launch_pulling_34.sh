#!/bin/bash
#SBATCH -J 34-methyl-hydrogen-phosphate
#SBATCH -o pmf-34.out
#SBATCH -N 1
#SBATCH -n 32
#SBATCH -p extended-mem

mdrun -v -pf pullf_34.xvg -px pullx_34.xvg -s pulling_34_md_2.tpr -deffnm pulling_34_md -cpi pulling_34_md.cpt

