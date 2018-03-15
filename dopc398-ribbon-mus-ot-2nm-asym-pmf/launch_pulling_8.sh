#!/bin/bash
#SBATCH -J 8-dopc398-ribbon-mus-ot-2nm-asym
#SBATCH -o pmf-8.out
#SBATCH -N 1
#SBATCH -n 64
#SBATCH -p extended-cpu

mdrun -v -pf pullf_8.xvg -px pullx_8.xvg -deffnm pulling_8_md -cpi pulling_8_md.cpt

