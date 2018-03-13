#!/bin/bash
#SBATCH -J 4-dopc398-ribbon-mus-ot-2nm-asym
#SBATCH -o pmf-4.out
#SBATCH -N 1
#SBATCH -n 32
#SBATCH -p extended-mem

mdrun -v -pf pullf_4.xvg -px pullx_4.xvg -deffnm pulling_4_md -cpi pulling_4_md.cpt

