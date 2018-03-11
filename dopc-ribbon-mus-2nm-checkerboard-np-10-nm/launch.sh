#!/bin/bash
#SBATCH -J "dopc-ribbon-mus-sym-embed"
#SBATCH -o membed.out
#SBATCH -N 1
#SBATCH -n 64
#SBATCH -p extended-cpu

mdrun -v -s membedded.tpr -membed membed.dat -o traj.trr -c membedded.gro -e ener.edr -nt 1 -cpt -1 -mn system.ndx -mp system.top <<INPUT
NP
Lipids
INPUT

