import MDAnalysis
import numpy as np
import matplotlib.pyplot as plt
from scipy.optimize import curve_fit

DIR = "/old/rvanlehn/planar_insertion/unbiased/musot/ribbon_extended/unb_7_2500ps_1"
GRO = "{}/ribbon_musot_7_2500ps_1_400ns_center.gro".format(DIR)
XTC = "{}/ribbon_musot_7_2500ps_1_400ns_center.xtc".format(DIR)

def get_bottom_layer(coords, dx = 10, max_x = 300):
  bottom_coords = []
  average = 0
  for i in range(0, max_x, dx):
    phos_section = []
    #Select coordinates that fall within range
    for j in range(len(coords)):
      if coords[j][0] > i and coords[j][0] < i + dx:
        phos_section.append(coords[j])
    #Average all y coordinates
    if phos_section: #If the list isn't empty
      average = 1.0 * np.sum(phos_section, axis=0)[1] / len(phos_section)
    #Select coordinates below average
    for j in range(len(phos_section)):
      if phos_section[j][1] < average:
        bottom_coords.append(phos_section[j].tolist())
  bottom_coords = np.array(bottom_coords)
  return bottom_coords[bottom_coords[:,0].argsort()] #Sorted by first column

#Create universe
u = MDAnalysis.Universe(GRO, GRO)

#Get center of gold nanoparticle x coordinate
au = u.select_atoms("resname AU")
cog_x = au.center_of_geometry()[0]

#Select x-z coordinates of all phosphate groups in DOPC
phos = u.select_atoms("resname DOPC and name O* P*")
phos_array = np.array(phos.positions)
phos_array = np.delete(phos_array, 1, 1)

phos_lower = get_bottom_layer(phos_array)

#Fit quartic curve to bottom of bilayer
phos_x = [x[0] for x in phos_lower]
phos_z = [x[1] for x in phos_lower]

paras = np.polyfit(phos_x, phos_z, 6)
p = np.poly1d(paras)
phos_full_x = [x[0] for x in phos_array]
phos_full_z = [x[1] for x in phos_array]
xp = np.linspace(0, 200, 200)
_ = plt.plot(phos_full_x, phos_full_z, '.', xp, p(xp), 'r-', [cog_x], [p(cog_x)], 'yo')
plt.ylim(0, 200)

#Print curvature
curvature = p.deriv(2)
print curvature(cog_x)

#plt.scatter(phos_x, phos_z)
plt.show()

