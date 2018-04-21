# After simulation/ data analysis (Umbrella sampling is performed)

cd us-sampling
# THESE NEED TO BE IN ORDER.
# Preparing list of tpr files for Weighted Histogram Analysis Method
ls *.tpr > tpr-files.dat
# Preparing list of XVG (force and position) files for WHAM
ls *pullx.xvg > pullx-files.dat
ls *pullf.xvg > pullf-files.dat

# REORDERING THEM FROM 
sort -t g -k 2 -g tpr-files.dat -o tpr-files.dat
sort -t g -k 2 -g pullx-files.dat -o pullx-files.dat
sort -t g -k 2 -g pullf-files.dat -o pullf-files.dat
# The line below doesn't work
#gmx wham -it sampling-results/tpr-files.dat -if sampling-results/pullf-files.dat -o -hist -unit kCal
gmx wham -v -it tpr-files.dat -if pullf-files.dat -o -hist -unit kCal
#gmx wham -it tpr-files.dat -ix pullx-files.dat -o -hist -unit kCal

#Alternative distance calc.
# gmx distance -f pull/pull.xtc -s dopc-bilayer.gro -n index.ndx -select 'com of group 'Lipids' plus com of group 'Pull'' -oxyz com-separation.xvg

#Plotting
# Bad data error on line 13
# Works on 
# gnuplot <<EOF
# plot 'profile.xvg'
# EOF


#cd ../
#gnuplot <<EOF
#plot 'com-separation.xvg' using 1:4 with lines


#EOF
