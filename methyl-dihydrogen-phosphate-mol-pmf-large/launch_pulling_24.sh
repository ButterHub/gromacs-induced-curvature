#!/bin/bash
#SBATCH -J 24-UEYB
#SBATCH -o pmf-24.out
#SBATCH -N 1
#SBATCH -n 64
#SBATCH -p extended-cpu

mdrun -v -deffnm pulling_24_eq -cpi pulling_{i}_eq.cpt

grompp -f pull_md_24.mdp -c pulling_24_eq.gro -n solution.ndx -p solution.top -o pulling_24_md -maxwarn 1
mdrun -v -pf pullf_24.xvg -px pullx_24.xvg -deffnm pulling_24_md -cpi pulling_24_md.cpt

