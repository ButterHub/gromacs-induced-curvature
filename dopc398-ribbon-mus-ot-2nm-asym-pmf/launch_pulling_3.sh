#!/bin/bash
#SBATCH -J 3-dopc398-ribbon-mus-ot-2nm-asym
#SBATCH -o pmf-3.out
#SBATCH -N 1
#SBATCH -n 32
#SBATCH -p extended-mem

mdrun -v -pf pullf_3.xvg -px pullx_3.xvg -deffnm pulling_3_md -cpi pulling_3_md.cpt

