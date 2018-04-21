#!/bin/bash
#SBATCH -J "eq9.0"
#SBATCH -o "eq9.0.out"
#SBATCH -N 1
#SBATCH -n 8
#SBATCH -p extended-mem

gmx mdrun -v -deffnm eq9.0
