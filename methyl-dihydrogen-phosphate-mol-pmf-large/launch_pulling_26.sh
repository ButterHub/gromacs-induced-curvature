#!/bin/bash
#SBATCH -J 26-UEYB
#SBATCH -o pmf-26.out
#SBATCH -N 1
#SBATCH -n 64
#SBATCH -p extended-cpu

mdrun -v -deffnm pulling_26_eq -cpi pulling_{i}_eq.cpt

grompp -f pull_md_26.mdp -c pulling_26_eq.gro -n solution.ndx -p solution.top -o pulling_26_md -maxwarn 1
mdrun -v -pf pullf_26.xvg -px pullx_26.xvg -deffnm pulling_26_md -cpi pulling_26_md.cpt

