for i in $(seq 1 6); do
cd mus-ot-2nm-np-dopc-ribbon-searching-$i
make_ndx -f solution_em.gro -o hyd.ndx <<INPUT
keep 0
r MUS OT & a CH2 CH3
name 1 NP_HYD
r DOPC & a C1* C2*
name 2 LIPID_HYD
q
INPUT
g_mindist -f solution_searching.trr -s solution_searching.tpr -n hyd.ndx -on numcont_hyd.xvg -od dist_hyd.xvg <<INPUT
NP_HYD
LIPID_HYD
INPUT
cd ..
done
