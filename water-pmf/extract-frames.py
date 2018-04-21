"""Extract Frames
Frames corresponding different positions of the water molecule relative to the centroid of the DOPC bilayer.
details required: xtc trajectory and top topology, interested groups, spacing between largest and smallest z-values.(nm)
output: individual frames, named according to distance in extracted folder.
"""
#Used on python3.5.2
t = 0 #decimal place rounding. 0 means integer
tolerance = 1/(10**(t+1))

import os
import numpy as np
import MDAnalysis as mda #some submodules need to explicitly imported.
#Load topology and trajectory into universe (central data structure object)
# topology = 'topol.top' # actually Gromacs TOP files cannot be read by MDa.
topology = 'pull/pull.tpr'
trajectory = 'pull/pull.xtc'
u = mda.Universe(topology, trajectory)
all = u.select_atoms("all")
pull = u.select_atoms("resid 1355")
# Resid in MDAnalysis is one lower than in VMD & Gromacs
dopc = u.select_atoms("resname DOPC")

#Ensure folder created
dir = 'frames'
if os.path.isdir(dir) == False:
    os.mkdir(dir)

frameTime={}
for ts in u.trajectory:
    print("Frame: {0:5d}, Time: {1:8.3f} ps".format(ts.frame, u.trajectory.time))

#Distance Calculation. Units is Angstroms.
    d = dopc.centroid()[2] - pull.center_of_mass()[2]
#Use COM of DOPC and COM of PULL. #ISSUE: com of dopc will give a bunch of COMS. Thats why centroid is used.
#    r = dopc.centroid() - pull.center_of_mass() 
#    d = np.linalg.norm(r)
    #print(ts)
    print("DOPC centroid <-> Pull com = {} Anstroms.".format(d))
	
    rounded = round(d,t)
#Saving into Dictionary if close enough to optimal frame and within range close to bilayer.
    upperBound = 30;lowerBound = -30
    if  d>=lowerBound and d<=upperBound and (rounded in frameTime and abs(rounded - d) < abs(rounded - frameTime[rounded][1]) or
        rounded not in frameTime and abs(d-rounded) <= tolerance): #Must be smaller difference than tolerance
        frameTime[rounded] = [ts.frame, d] # {optimal distance:[frame number, real distance]}
        print("BOOOM! Savin frame...{} Angstroms".format(rounded))
        #Name the frame. If better frame found, it gets replaced
        filename = "frames/{}.gro".format(rounded)
        all.write(filename)

# Save frameTime
f = open('distance-frame-realdistance.txt', 'w')
f.write(str(frameTime))
f.close()
