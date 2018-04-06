# Goes over trajectory files, and calculates PMF for each $STEPSIZE window.

LENGTH=60000 # ps
NSTEPS=20
STEPSIZE=$(echo "$LENGTH/$NSTEPS" | bc -l)
for STEP in $(seq 1 $NSTEPS); do
CURRSTEP=$(echo "$STEP*$STEPSIZE" | bc -l) # Final time to analyse (ps)
PREVSTEP=$(echo "$CURRSTEP-$STEPSIZE" | bc -l)
# 
g_wham -it tpr-files.dat -if pullf-files.dat -b $PREVSTEP -e $CURRSTEP -o profile-$STEP.xvg -unit kCal
sed -i "s/@/#/g" profile-$STEP.xvg

done

# Calculate PMF in Python
# Save data (time, PMF)
