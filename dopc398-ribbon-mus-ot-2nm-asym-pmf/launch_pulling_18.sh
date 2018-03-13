#!/bin/bash
#SBATCH -J 18-dopc398-ribbon-mus-ot-2nm-asym
#SBATCH -o pmf-18.out
#SBATCH -N 1
#SBATCH -n 32
#SBATCH -p extended-mem

mdrun -v -pf pullf_18.xvg -px pullx_18.xvg -deffnm pulling_18_md -cpi pulling_18_md.cpt

