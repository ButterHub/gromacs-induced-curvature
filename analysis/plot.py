"""Plots PMF for different files when file names passed in."""
# Can use a bash script to loop over system groups (NP, Ions, Small Molecules)
import matplotlib
matplotlib.use('Agg')
import math, os, time 
import numpy as np
import matplotlib.pyplot as plt

mols = ['methyl-phosphate-mol-pmf.xvg', 'methyl-hydrogen-phosphate-mol-pmf.xvg', 'methyl-dihydrogen-phosphate-mol-pmf.xvg', 'methyl-sulfonate-mol-pmf.xvg']
molsL = ['methyl-phosphate-mol-pmf-large.xvg', 'methyl-hydrogen-phosphate-mol-pmf-large.xvg', 'methyl-dihydrogen-phosphate-mol-pmf-large.xvg', 'methyl-sulfonate-mol-pmf-large.xvg']
ions = ['na-mol-pmf.xvg', 'ca-mol-pmf.xvg']
nps = ['mus-2nm-sym-pmf.xvg', 'dopc494-mus-ot-2nm-sym-pmf.xvg', 'dopc398-ribbon-mus-ot-2nm-asym-pmf.xvg']
water = ['water-pmf_bs.xvg']
# EDIT 'FILES' ONLY
files = water
name = "water-error"

# Create figure
fig, ax = plt.subplots(1)
#fig.show()
plt.title("Potential of Mean Force")
plt.xlabel("z (nm)")
plt.ylabel("PMF (kcal / mol)")

# Number of plots
n_plots = len(files)
MaxY = 0

# Loop over files
for i, file_name in enumerate(files):
	x, y, s = np.genfromtxt(file_name, unpack=True, dtype="float_")
	shiftedValue=y-y[-1] # np.amin(y) for minimum, y[-1]
	shiftedS=s-y[-1]
	if np.max(shiftedValue) > MaxY:
		MaxY = np.max(shiftedValue)
	#plt.plot(x, shiftedValue, label=file_name, linewidth=2)
	plt.errorbar(x, shiftedValue, yerr=shiftedS/10, label=file_name, linewidth=2)
legend = ax.legend(loc='upper center', shadow=True)

# Set Max and Min Y
#plt.ylim(ymax=np.around(MaxY, -1))
#plt.ylim(ymin=-5)
plt.xlim(xmax=3.5)

save_name=time.strftime("%Y_%m_%d")
plt.savefig("PMF-{0}{1}_{2}.pdf".format(n_plots, name, save_name))

