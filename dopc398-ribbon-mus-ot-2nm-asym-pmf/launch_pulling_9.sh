#!/bin/bash
#SBATCH -J 9-dopc398-ribbon-mus-ot-2nm-asym
#SBATCH -o pmf-9.out
#SBATCH -N 1
#SBATCH -n 32
#SBATCH -p extended-mem

mdrun -v -pf pullf_9.xvg -px pullx_9.xvg -deffnm pulling_9_md -cpi pulling_9_md.cpt

