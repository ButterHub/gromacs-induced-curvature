#!/bin/bash
#SBATCH -J 19-dopc398-ribbon-mus-ot-2nm-asym
#SBATCH -o pmf-19.out
#SBATCH -N 1
#SBATCH -n 32
#SBATCH -p extended-mem

mdrun -v -pf pullf_19.xvg -px pullx_19.xvg -deffnm pulling_19_md -cpi pulling_19_md.cpt

