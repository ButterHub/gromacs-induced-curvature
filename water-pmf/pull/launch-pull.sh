#!/bin/bash
#SBATCH -J "Pull H20"
#SBATCH -o "pull.out"
#SBATCH -N 2
#SBATCH -n 64
#SBATCH -p extended-mem

gmx mdrun -v -deffnm pull
