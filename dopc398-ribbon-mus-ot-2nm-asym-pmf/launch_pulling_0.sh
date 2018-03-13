#!/bin/bash
#SBATCH -J 0-dopc398-ribbon-mus-ot-2nm-asym
#SBATCH -o pmf-0.out
#SBATCH -N 1
#SBATCH -n 32
#SBATCH -p extended-mem

mdrun -v -pf pullf_0.xvg -px pullx_0.xvg -deffnm pulling_0_md -cpi pulling_0_md.cpt

