#!/usr/bin/env python2.7
# LIPID CURVATURE CALCULATIONS USING LIPID HEADGROUP (HEAD)
import MDAnalysis as mda
import numpy as np
import matplotlib as mpl
import matplotlib.pyplot as plt
from scipy.optimize import curve_fit, minimize_scalar, least_squares

# VARIABLES
DIR = "/old/rvanlehn/planar_insertion/unbiased/musot/ribbon_extended/unb_7_2500ps_1"
HEAD = "O* P*"
GRO = "{}/ribbon_musot_7_2500ps_1_400ns.gro".format(DIR)
XTC = "{}/ribbon_musot_7_2500ps_1_400ns_center.xtc".format(DIR)
u = mda.Universe(GRO, XTC) # Universe created

# FUNCTIONS
def gauss(x, a, b, c):
    return a*np.exp((-(x - b)**2)/(2*c**2)) #+ d

def fit_circle(x, y):
    # == METHOD 1 ==
    method_1 = 'algebraic'
    
    # coordinates of the barycenter
    x_m = np.mean(x)
    y_m = np.mean(y)
    
    # calculation of the reduced coordinates
    u = x - x_m
    v = y - y_m
    
    # linear system defining the center (uc, vc) in reduced coordinates:
    #    Suu * uc +  Suv * vc = (Suuu + Suvv)/2
    #    Suv * uc +  Svv * vc = (Suuv + Svvv)/2
    Suv  = sum(u*v)
    Suu  = sum(u**2)
    Svv  = sum(v**2)
    Suuv = sum(u**2 * v)
    Suvv = sum(u * v**2)
    Suuu = sum(u**3)
    Svvv = sum(v**3)
    
    # Solving the linear system
    A = np.array([ [ Suu, Suv ], [Suv, Svv]])
    B = np.array([ Suuu + Suvv, Svvv + Suuv ])/2.0
    uc, vc = np.linalg.solve(A, B)
    
    xc_1 = x_m + uc
    yc_1 = y_m + vc
    
    # Calcul des distances au centre (xc_1, yc_1)
    Ri_1     = np.sqrt((x-xc_1)**2 + (y-yc_1)**2)
    R_1      = np.mean(Ri_1)
    residu_1 = np.sum((Ri_1-R_1)**2)

    return R_1

def fit_circle_2(x, y):
    
    def calc_R(xc, yc):
        """ calculate the distance of each 2D points from the center (xc, yc) """
        return np.sqrt((x-xc)**2 + (y-yc)**2)
    
    def f_2(c):
        """ calculate the algebraic distance between the data points and the mean circle centered at c=(xc, yc) """
        Ri = calc_R(*c)
        return Ri - Ri.mean()
    
    x_m = np.mean(x)
    y_m = np.mean(y)

    center_estimate = x_m, y_m
    res = least_squares(f_2, center_estimate)
    
    center_2 = res.x
    xc_2, yc_2 = center_2
    Ri_2       = calc_R(*center_2)
    R_2        = Ri_2.mean()
    residu_2   = np.sum((Ri_2 - R_2)**2)

    return R_2

# ARRAYS
xU = np.array([])
zxU = np.array([])
yU = np.array([])
zyU = np.array([])
curvatureXZ = np.array([])
#curvatureYZ = np.array([])
time = np.array([])

# Data
for ts in u.trajectory:
    if ts.frame > 400:
        break
    #lipids_com = u.select_atoms("resname DOPC").center_of_mass()
    #u_heads = u.select_atoms("resname DOPC and prop x>65 and prop x<165 and prop z>{}".format(lipids_com[2],HEAD))
    l_heads = u.select_atoms("resname DOPC")
    # u_heads_pos = u_heads.positions
    l_heads_pos = l_heads.positions 
    x = [sublist[0] for sublist in l_heads_pos]
    y = [sublist[1] for sublist in l_heads_pos]
    z = [sublist[2] for sublist in l_heads_pos]
    # Gaussian fit, (X,Z) and (Y,Z)  
    #p_initial = [1.0, 1.0, 1.0]
    # TODO Fix negative variances and failed calculations
    #popt_UXZ, pcov_UXZ = curve_fit(gauss, x, z, p0=p_initial, maxfev = 1000000)
    #popt_UYZ, pcov_UYZ = curve_fit(gauss, y, z, p0=p_initial, maxfev = 10000000)
    result_UXZ = 1./fit_circle_2(x,z) #2 is variance. Or can switch to 2nd derivative at peak.
    print ts.frame, result_UXZ
    #result_UYZ = popt_UYZ[2]
    # Save to curvature array.
    curvatureXZ = np.append(curvatureXZ, result_UXZ)
    #curvatureYZ = np.append(curvatureYZ, result_UYZ)
    time = np.append(time, ts.time) #time in ps

np.savetxt('Lower_Curvature.txt', np.c_[time, curvatureXZ])
# plt.plot(time, curvatureXZ, 'rx', label='data')
# plt.plot(x, z, 'rx')
# plt.plot(time, curvatureYZ)

# Plot fitted curve
# x_fit = np.linspace(65,165,1000)
# z_fit = gauss(x_fit, *popt_UXZ)
# plt.plot(x_fit, z_fit, 'b-', label='fit')
# plt.show()

