# Input parameters
NP="mus-ot-2nm"
NNA=29

DIAMETER=2.0
LIPID="DOPC"
LIPID_PROTRUSION="DOPP"
LIPID_RESTRAINED="DOPR"
PULL_ATOM="C1R"
PULL_LIPID_1="284"

NP_DZ=3.5

BASENAME=${NP}-np-${LIPID,,}-ribbon-searching-test

# Create case directory
mkdir ${BASENAME}
cd ${BASENAME}

# Copy over include files
cp ../includes/${LIPID,,}-400-ribbon.gro .
cp ../includes/minim.mdp .
cp ../includes/gromos_np_ribbon_protrude.mdp .
cp ../includes/gromos_np_ribbon_searching.mdp .
cp ../includes/gromos_54a7*.itp .
cp ../includes/${NP}.itp .
cp ../includes/${NP}.gro np.gro

NP_X=$(cat ${LIPID,,}-400-ribbon.gro | grep "${PULL_LIPID_1}${LIPID}" | grep "${PULL_ATOM}" | awk '{print substr($0,21,8)}')
NP_Y=$(cat ${LIPID,,}-400-ribbon.gro | grep "${PULL_LIPID_1}${LIPID}" | grep "${PULL_ATOM}" | awk '{print substr($0,29,8)}')

# Mark lipids for induced protrusion
sed -i -e "s/\b${PULL_LIPID_1}${LIPID}\b/${PULL_LIPID_1}${LIPID_PROTRUSION}/g" ${LIPID,,}-400-ribbon.gro

# Add position restraints to lower leaflet lipids
g_traj -ox -com -s ${LIPID,,}-400-ribbon.gro -f ${LIPID,,}-400-ribbon.gro <<INPUT
$LIPID
INPUT
Z_COM=$(tail -n 1 coord.xvg | awk '{print $4}')

g_select -s ${LIPID,,}-400-ribbon.gro -selrpos whole_res_com -select "resname $LIPID and z < $Z_COM" -on restrained.ndx
g_select -s ${LIPID,,}-400-ribbon.gro -selrpos whole_res_com -select "not (resname $LIPID and z < $Z_COM)" -on non_restrained.ndx
trjconv -f ${LIPID,,}-400-ribbon.gro -s ${LIPID,,}-400-ribbon.gro -o restrained.gro -n restrained.ndx
trjconv -f ${LIPID,,}-400-ribbon.gro -s ${LIPID,,}-400-ribbon.gro -o non_restrained.gro -n non_restrained.ndx
sed -i -e "s/${LIPID}/${LIPID_RESTRAINED}/g" restrained.gro
head -n 2 ${LIPID,,}-400-ribbon.gro > ribbon-restrained.gro
grep "${LIPID}" non_restrained.gro >> ribbon-restrained.gro
grep "${LIPID_PROTRUSION}" non_restrained.gro >> ribbon-restrained.gro
grep "${LIPID_RESTRAINED}" restrained.gro >> ribbon-restrained.gro
grep "SOL" non_restrained.gro >> ribbon-restrained.gro
tail -n 1 ${LIPID,,}-400-ribbon.gro >> ribbon-restrained.gro
genconf -f ribbon-restrained.gro -o ribbon-restrained.gro -renumber

# Define position restraints for nanoparticle core
genrestr -f np.gro -o ${NP}_posres.itp -fc 1000 1000 1000 <<INPUT
AU
INPUT

# Place nanoparticle in appropriately sized box
BOX_X=$(tail -n 1 ribbon-restrained.gro | awk '{print $1}')
BOX_Y=$(tail -n 1 ribbon-restrained.gro | awk '{print $2}')
BOX_Z=$(tail -n 1 ribbon-restrained.gro | awk '{print $3}')
editconf -f np.gro -o np.gro -box $BOX_X $BOX_Y $BOX_Z -center $NP_X $NP_Y $(echo "$BOX_Z / 2" | bc -l)
editconf -f np.gro -o np_translated.gro -translate 0 0 $NP_DZ

# Merge bilayer and nanoparticle boxes
echo "np on bilayer" > merged.gro
tail -n+3 np_translated.gro | head -n-1 >> merged.gro
tail -n+3 ribbon-restrained.gro >> merged.gro
sed -i "2i $(printf "%5d" "$(echo "$(cat merged.gro | wc -l) - 2" | bc)")" merged.gro

# Renumber the system .gro file
genconf -f merged.gro -o merged.gro -renumber

# Remove water conflicts with bilayer and nanoparticle
make_ndx -f merged.gro -o merged.ndx <<INPUT
keep 0
r AU
name 1 AU
q
INPUT
EXCLUSION_RADIUS=$(echo "($DIAMETER / 2) + 0.155" | bc -l)
g_select -s merged.gro -n merged.ndx -selrpos whole_res_com -select "rdist = res_com distance from com of group AU; rdist > $EXCLUSION_RADIUS or name AU" -on merged_core.ndx
trjconv -f merged.gro -s merged.gro -o merged_core.gro -n merged_core.ndx
g_select -s merged_core.gro -selrpos atom -select "not (same residue as (resname SOL and within 0.5 of (not resname $LIPID $LIPID_RESTRAINED SOL)))" -on merged_nonoverlap.ndx
trjconv -f merged_core.gro -s merged_core.gro -n merged_nonoverlap.ndx -o merged_nonoverlap.gro

# Generate .top file
NLIPID=$(grep -e ${LIPID} -e ${LIPID_PROTRUSION} merged_nonoverlap.gro | awk '{print $1}' | uniq | wc -l)
NLIPID_RESTRAINED=$(grep ${LIPID_RESTRAINED} merged_nonoverlap.gro | awk '{print $1}' | uniq | wc -l)
NSOL=$(grep 'SOL' merged_nonoverlap.gro | awk '{print $1}' | uniq | wc -l)
cat > solution.top <<INPUT
#include "gromos_54a7.itp"
#include "gromos_54a7_spc.itp"
#include "gromos_54a7_ions.itp"
#include "gromos_54a7_${LIPID,,}.itp"

#ifdef POSRES
#include "gromos_54a7_${LIPID,,}_posres.itp"
#endif

#include "gromos_54a7_${LIPID,,}_restrained.itp"

#include "${NP}.itp"
#ifdef POSNP
#include "${NP}_posres.itp"
#endif

[ system ]
np on bilayer

[ molecules ]
AUNP        1
$LIPID	    $NLIPID
$LIPID_RESTRAINED	    $NLIPID_RESTRAINED
SOL     $NSOL
INPUT

# Make a note of indices of phosphates and pull atoms before further modifications
BOX_X=$(tail -n 1 merged_nonoverlap.gro | awk '{print $1}')
X_MIN=$(echo "0.30 * $BOX_X" | bc -l)
X_MAX=$(echo "0.70 * $BOX_X" | bc -l)
g_select -s merged_nonoverlap.gro -selrpos whole_res_com -select "name P and (x > $X_MIN) and (x < $X_MAX) and (z > $Z_COM)" -on phosphates.ndx
g_select -s merged_nonoverlap.gro -selrpos whole_res_com -select "resname ${LIPID_PROTRUSION} and name ${PULL_ATOM}" -on pull_atoms.ndx

# Add counterions
sed -i -e "s/${LIPID_PROTRUSION}/${LIPID}/g" merged_nonoverlap.gro
grompp -f minim.mdp -c merged_nonoverlap.gro -p solution.top -o ion_solution.tpr
genion -s ion_solution.tpr -o ion_solution.gro -p solution.top -pname NA -np $NNA <<INPUT
SOL
INPUT

# Energy minimization
grompp -f minim.mdp -c ion_solution.gro -p solution.top -o solution_em
mdrun -v -deffnm solution_em

# Generate index file
make_ndx -f solution_em.gro -o solution.ndx <<INPUT
keep 0
! r $LIPID SOL NA CL
name 1 NP
r $LIPID
name 2 Lipids
r SOL NA CL
name 3 Solvent
a AU
name 4 AU
q
INPUT

PULL_ATOM_1=$(tail -n 1 pull_atoms.ndx | awk '{print $1}')

echo "[ PHOS ]" >> solution.ndx
tail -n+2 phosphates.ndx >> solution.ndx
echo "[ PULL_TAIL_1 ]" >> solution.ndx
echo "$PULL_ATOM_1" >> solution.ndx

# Generate SLURM launch script
cat > launch_searching.sh <<EOL
#!/bin/bash
#SBATCH -J searching
#SBATCH -o searching.out
#SBATCH -N 1
#SBATCH -n 64
#SBATCH -p extended-cpu

grompp -f gromos_np_ribbon_protrude.mdp -c solution_em.gro -n solution.ndx -p solution.top -o solution_protrude
mdrun -v -deffnm solution_protrude

grompp -f gromos_np_ribbon_contact.mdp -c solution_protrude.gro -n solution.ndx -p solution.top -o solution_contact
mdrun -v -deffnm solution_contact

grompp -f gromos_np_ribbon_unbiased.mdp -c solution_contact.gro -n solution.ndx -p solution.top -o solution_unbiased
mdrun -v -deffnm solution_unbiased

rm \#*
EOL

# Clean up
rm coord.xvg
rm ion*
rm mdout*
rm merged*
rm non_restrained*
rm restrained*
rm np*
rm phosphates*
rm pull_atoms*
rm ribbon-restrained*
rm \#*
