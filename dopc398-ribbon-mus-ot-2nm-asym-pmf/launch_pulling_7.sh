#!/bin/bash
#SBATCH -J 7-dopc398-ribbon-mus-ot-2nm-asym
#SBATCH -o pmf-7.out
#SBATCH -N 1
#SBATCH -n 32
#SBATCH -p extended-mem

mdrun -v -pf pullf_7.xvg -px pullx_7.xvg -deffnm pulling_7_md -cpi pulling_7_md.cpt

