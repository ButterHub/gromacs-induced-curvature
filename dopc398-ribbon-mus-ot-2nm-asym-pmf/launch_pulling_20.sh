#!/bin/bash
#SBATCH -J 20-dopc398-ribbon-mus-ot-2nm-asym
#SBATCH -o pmf-20.out
#SBATCH -N 1
#SBATCH -n 32
#SBATCH -p extended-mem

mdrun -v -pf pullf_20.xvg -px pullx_20.xvg -deffnm pulling_20_md -cpi pulling_20_md.cpt

