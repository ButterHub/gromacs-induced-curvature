#!/bin/bash
#SBATCH -J 10-dopc398-ribbon-mus-ot-2nm-asym
#SBATCH -o pmf-10.out
#SBATCH -N 1
#SBATCH -n 32
#SBATCH -p extended-mem

mdrun -v -pf pullf_10.xvg -px pullx_10.xvg -deffnm pulling_10_md -cpi pulling_10_md.cpt

