#!/bin/bash
#SBATCH -J 13-dopc398-ribbon-mus-ot-2nm-asym
#SBATCH -o pmf-13.out
#SBATCH -N 1
#SBATCH -n 32
#SBATCH -p extended-mem

mdrun -v -pf pullf_13.xvg -px pullx_13.xvg -deffnm pulling_13_md -cpi pulling_13_md.cpt

