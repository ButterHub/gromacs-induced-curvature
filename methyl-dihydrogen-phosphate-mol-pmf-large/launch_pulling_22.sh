#!/bin/bash
#SBATCH -J 22-UEYB
#SBATCH -o pmf-22.out
#SBATCH -N 1
#SBATCH -n 64
#SBATCH -p extended-cpu

mdrun -v -deffnm pulling_22_eq -cpi pulling_{i}_eq.cpt

grompp -f pull_md_22.mdp -c pulling_22_eq.gro -n solution.ndx -p solution.top -o pulling_22_md -maxwarn 1
mdrun -v -pf pullf_22.xvg -px pullx_22.xvg -deffnm pulling_22_md -cpi pulling_22_md.cpt

