#!/bin/bash
#SBATCH -J "us-sampling9.0h2o"
#SBATCH -o "us-sampling9.0.out"
#SBATCH -N 1 
#SBATCH -n 8
#SBATCH -p regular-cpu

gmx mdrun -v -deffnm us-sampling9.0
