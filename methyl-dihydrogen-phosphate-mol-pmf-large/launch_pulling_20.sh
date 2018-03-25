#!/bin/bash
#SBATCH -J 20-UEYB
#SBATCH -o pmf-20.out
#SBATCH -N 1
#SBATCH -n 64
#SBATCH -p extended-cpu

mdrun -v -deffnm pulling_20_eq -cpi pulling_{i}_eq.cpt

grompp -f pull_md_20.mdp -c pulling_20_eq.gro -n solution.ndx -p solution.top -o pulling_20_md -maxwarn 1
mdrun -v -pf pullf_20.xvg -px pullx_20.xvg -deffnm pulling_20_md -cpi pulling_20_md.cpt

