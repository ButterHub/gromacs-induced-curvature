#!/bin/bash
#SBATCH -J 2-UEYB
#SBATCH -o pmf-2.out
#SBATCH -N 1
#SBATCH -n 64
#SBATCH -p extended-cpu

mdrun -v -deffnm pulling_2_eq -cpi pulling_{i}_eq.cpt

grompp -f pull_md_2.mdp -c pulling_2_eq.gro -n solution.ndx -p solution.top -o pulling_2_md -maxwarn 1
mdrun -v -pf pullf_2.xvg -px pullx_2.xvg -deffnm pulling_2_md -cpi pulling_2_md.cpt

