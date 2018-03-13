#!/bin/bash
#SBATCH -J 1-dopc398-ribbon-mus-ot-2nm-asym
#SBATCH -o pmf-1.out
#SBATCH -N 1
#SBATCH -n 32
#SBATCH -p extended-mem

mdrun -v -pf pullf_1.xvg -px pullx_1.xvg -deffnm pulling_1_md -cpi pulling_1_md.cpt

