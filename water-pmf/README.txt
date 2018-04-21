em -> pull -> extract -> eq-sampling -> us-sampling -> wham
NOTE: Right now, the final WHAM results were created from a PULL.xtc that was deleted. A new pull.xtc is available, but it will be incompatible. Need to re-EM and EQ, and US the new pull.xtc

<---------------------EM-------------------->
prepare-water-system.sh File with scripts to prepare dopc-bilayer.gro file for simulation. This includes genconf to increase system size to allow for greater pulling distance. Creates launch-pull.sh. It also equilibrates the system. See file for more details..
prepare-water-system-one.sh Everything before creating index.
Go To VMD, identify optimal water molecule.
prepare-water-system.two.sh 

<---------------------PULL------------------>
launch-pull.sh Runs pulling mdrun. Automatically ran by prepare-water-system.

<---------------------EXTRACT--------------->
extract-frames.py File extracts optimal frames from trajectory.
extract-frames.sh An alternative for optimal frame extraction as above [incomplete and not necessary]

<---------------------EQ-SAMPLING----------->
eq.sh Runs equilibration for all individual frames before US.
2ns with random velocities (gen_vel = yes) and berendsen barostat.

<---------------------US-SAMPLING-------------->
us-sampling.sh runs umbrella sampling over optimal frames
10ns Parinello Rahman

<---------------------WHAM------------------>
wham.sh - runs wham on results.
plot.py - plots xvg files [incomplete and unnecessary]

<---------------------DATA ANALYSIS--------->



<---------------------ADDITIONAL FILES------>
clean.sh Deletes backed-up overwritten files
fake.tpr Fake tpr file used for pbc mol using trjconv. This would fix broken molecules along PBC

*us means umbrella sampling
