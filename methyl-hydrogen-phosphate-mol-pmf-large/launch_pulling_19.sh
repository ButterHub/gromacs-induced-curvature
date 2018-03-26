#!/bin/bash
#SBATCH -J 19-VQJG
#SBATCH -o pmf-19.out
#SBATCH -N 1
#SBATCH -n 32
#SBATCH -p extended-mem

grompp -f pull_eq_19.mdp -c solution_em.gro -n solution.ndx -p solution.top -o pulling_19_eq -maxwarn 1
mdrun -v -deffnm pulling_19_eq

grompp -f pull_md_19.mdp -c pulling_19_eq.gro -n solution.ndx -p solution.top -o pulling_19_md -maxwarn 1
mdrun -v -pf pullf_19.xvg -px pullx_19.xvg -deffnm pulling_19_md -cpi pulling_19_md.cpt

