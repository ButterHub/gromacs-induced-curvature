#!/usr/bin/env python2.7
# LIPID CURVATURE CALCULATIONS USING LIPID HEADGROUP (HEAD)
import MDAnalysis as mda
import numpy as np
import matplotlib as mpl
import matplotlib.pyplot as plt
from scipy.optimize import curve_fit

# VARIABLES
DIR = "/old/rvanlehn/planar_insertion/unbiased/musot/ribbon_extended/unb_7_2500ps_1"
HEAD = "NTM" #(Nitrogen trimethyl)
GRO = "{}/ribbon_musot_7_2500ps_1_400ns_center.gro".format(DIR)
XTC = "{}/ribbon_musot_7_2500ps_1_400ns_center.xtc".format(DIR)
u = mda.Universe(GRO, XTC) # Universe created

# FUNCTIONS
def gauss(x, a, b, c):
    return a*np.exp((-(x - b)**2)/(2*c**2)) #+ d

# ARRAYS
xU = np.array([])
zxU = np.array([])
yU = np.array([])
zyU = np.array([])
curvatureXZ = np.array([])
curvatureYZ = np.array([])
time = np.array([])

# Data
for ts in u.trajectory:
    print ts.frame
    lipids_com = u.select_atoms("resname DOPC").center_of_mass()
    u_heads = u.select_atoms("prop x>65 and prop x<165 and prop z>{} and name {}".format(lipids_com[2],HEAD))
    l_heads = u.select_atoms("prop x>65 and prop x<165 and prop z<{} and name {}".format(lipids_com[2],HEAD))
    # u_heads_pos = u_heads.positions
    l_heads_pos = l_heads.positions 
    x = [sublist[0] for sublist in l_heads_pos]
    y = [sublist[1] for sublist in l_heads_pos]
    z = [sublist[2] for sublist in l_heads_pos]
    # Gaussian fit, (X,Z) and (Y,Z)  
    p_initial = [1.0, 115.0, 0.1]
    # TODO Fix negative variances and failed calculations
    popt_UXZ, pcov_UXZ = curve_fit(gauss, x, z, p0=p_initial, maxfev = 10000000)
    # popt_UYZ, pcov_UYZ = curve_fit(gauss, y, z, p0=p_initial)
    result_UXZ = popt_UXZ[2] #2 is variance. Or can switch to 2nd derivative at peak.
    result_UYZ = popt_UYZ[2]
    # Save to curvature array.
    curvatureXZ = np.append(curvatureXZ, result_UXZ)
    curvatureYZ = np.append(curvatureYZ, result_UYZ)
    time = np.append(time, ts.time) #time in ps

np.savetxt('Upper_Curvature.txt', np.c[time, curvatureXZ, curvatureYZ])
plt.plot(time, curvatureXZ)
plt.plot(time, curvatureYZ)

