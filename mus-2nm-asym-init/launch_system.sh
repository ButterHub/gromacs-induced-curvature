#!/bin/bash
#SBATCH -J mus-2nm-asym-init
#SBATCH -o mus-2nm-asym.out
#SBATCH -N 2 
#SBATCH -n 64 
#SBATCH -p extended-mem
gmx_mpi=/usr/local/gromacs4/bin/
# Pull lower ligands (29 times)(by the oxygen in end group) to upper bilayer.
for i in $(seq 1 50); do 
PREV=$(echo "$i - 1" | bc -l)
# Determining optimal ligand
grompp -f minim.mdp -c pulling_${PREV}_md.gro -p system.top -n system.ndx -o dummy.tpr
g_traj -com -f pulling_${PREV}_md.gro -s dummy.tpr -n system.ndx -ox gold.xvg <<INPUT
Gold
INPUT
NP_COM_z=$(cat gold.xvg | tail -n1 | awk '{print $4}')
NP_COM_z=$(echo "$NP_COM_z - 1" | bc -l)
g_select -f pulling_${PREV}_md.gro -select "atomname SAU and (same residue as (atomname OS3 and z < ${NP_COM_z}))" -s dummy.tpr -on thiol_sulfurs.ndx
trjconv -f pulling_${PREV}_md.gro -s dummy.tpr -n thiol_sulfurs.ndx -o thiol_sulfurs.gro
# SORT GRO FILE DESCENDING Z VALUE, pick the top
PULL_DETAILS=$(cat thiol_sulfurs.gro | tail -n+3 | head -n-1 | sort -k6 -rn | head -n1)
RESNR_PULL=$(echo ${PULL_DETAILS} | awk '{print $1}')
RESNR_PULL=${RESNR_PULL%MUS}

# Calculating normal to the surface of the NP sphere. (COM Vector Thiol - NP)
NP_COM=$(cat gold.xvg | tail -n1)
NP_COM_x=$(echo $NP_COM | awk '{print $2}'); NP_COM_y=$(echo $NP_COM | awk '{print $3}'); NP_COM_z=$(echo $NP_COM | awk '{print $4}')
# TODO COM of THIOL SULFOR 
PULL_COM_x=$(echo $PULL_DETAILS | awk '{print $4}'); PULL_COM_y=$(echo $PULL_DETAILS | awk '{print $5}'); PULL_COM_z=$(echo $PULL_DETAILS | awk '{print $6}')
# Difference between components
NORM_x=$(echo "$PULL_COM_x - $NP_COM_x" | bc -l)
NORM_y=$(echo "$PULL_COM_y - $NP_COM_y" | bc -l)
NORM_z=$(echo "$PULL_COM_z - $NP_COM_z" | bc -l)

sed -i "/pull_init1/c\pull_init1          = 2.5" pull_eq_np_taut.mdp
sed -i "/pull_vec1/c\pull_vec1           = $NORM_x $NORM_y $NORM_z" pull_eq_np_taut.mdp

# Pulling 3 oxygens from the end group of ligand
make_ndx -f pulling_${PREV}_md.gro -n system.ndx -o system-current.ndx<<INPUT
a OS3 & ri ${RESNR_PULL}
name 6 Pull
q
INPUT
echo "[ Upper_Heads ]" >> system-current.ndx
cat u-leaflet-heads.ndx | tail -n+2 >> system-current.ndx

grompp -f pull_eq_np_taut.mdp -c pulling_${PREV}_md -n system-current.ndx -p system.top -o pulling_${i}_taut.tpr
#mdrun -v -deffnm pulling_${i}_taut
mpirun $gmx_mpi/mdrun_mpi -v -deffnm pulling_${i}_taut

grompp -f pull_eq_np_init.mdp -c pulling_${i}_taut -n system-current.ndx -p system.top -o pulling_${i}_eq.tpr
#mdrun -v -deffnm pulling_${i}_eq
mpirun $gmx_mpi/mdrun_mpi -v -deffnm pulling_${i}_eq

grompp -f pull_md_np_init.mdp -c pulling_${i}_eq -n system-current.ndx -p system.top -o pulling_${i}_md.tpr
#mdrun -v -px pullx_${i} -pf pullf_${i}.xvg -deffnm pulling_${i}_md
mpirun $gmx_mpi/mdrun_mpi -v -deffnm pulling_${i}_md
rm '#'*
rm *.log; rm *.edr; rm *.xtc; rm *.trr
done
