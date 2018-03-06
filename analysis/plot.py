"""Plots PMF for different files when file names passed in."""
import matplotlib
matplotlib.use('Agg')
import math, os, time 
import numpy as np
import matplotlib.pyplot as plt

small_molecule_files = ['methyl-phosphate-mol-pmf.xvg', 'methyl-hydrogen-phosphate-mol-pmf.xvg', 'methyl-dihydrogen-phosphate-mol-pmf.xvg', 'methyl-sulfonate-mol-pmf.xvg']
ion_files = ['na-mol-pmf.xvg', 'ca-mol-pmf.xvg']
np_files = ['mus-2nm-sym-pmf.xvg']
# EDIT 'FILES' ONLY
files = ion_files 
name = "na-ca"

# Create figure
fig, ax = plt.subplots(1)
#fig.show()
plt.title("Potential of Mean Force")
plt.xlabel("z (nm)")
plt.ylabel("PMF (kcal / mol)")

# Number of plots
n_plots = len(files)

# Loop over files
for i, file_name in enumerate(files):
	x, y = np.genfromtxt(file_name, unpack=True, dtype="float_")
	plt.plot(x, y-y[-5], label=file_name, linewidth=2)
legend = ax.legend(loc='upper center', shadow=True)

save_name=time.strftime("%Y_%m_%d")
plt.savefig("PMF-{0}{1}_{2}.pdf".format(n_plots, name, save_name))

