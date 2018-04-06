"""Plots PMF for different files when file names passed in."""
# Can use a bash script to loop over system groups (NP, Ions, Small Molecules)
import matplotlib
matplotlib.use('Agg')
import math, os, time 
import numpy as np
import matplotlib.pyplot as plt

molsL = ['methyl-phosphate-mol-pmf-large.xvg', 'methyl-hydrogen-phosphate-mol-pmf-large.xvg', 'methyl-dihydrogen-phosphate-mol-pmf-large.xvg', 'methyl-sulfonate-mol-pmf-large.xvg']
ions = ['na-mol-pmf.xvg', 'ca-mol-pmf.xvg']
nps = ['mus-2nm-sym-pmf.xvg', 'dopc494-mus-ot-2nm-sym-pmf.xvg', 'dopc398-ribbon-mus-ot-2nm-asym-pmf.xvg']
water = ['water-pmf.xvg']
# EDIT 'FILES' ONLY
files = molsL

for i, molecule in enumerate(files):
    molecules = ["{}-20.xvg".format(os.path.splitext(molecule)[0]), "{}-40.xvg".format(os.path.splitext(molecule)[0]), "{}-60.xvg".format(os.path.splitext(molecule)[0])]
    fig, ax = plt.subplots(1)
    plt.title("Potential of Mean Force")
    plt.xlabel("z (nm)")
    plt.ylabel("PMF (kcal / mol)")

    # Loop over 20 40 60ns
    for i, mol in enumerate(molecules):
        x, y = np.genfromtxt(mol, unpack=True, dtype="float_")
        yShift=y-np.amin(y)
        plt.plot(x, yShift, label=mol, linewidth=2)
    legend = ax.legend(loc='upper center', shadow=True)

    date=time.strftime("%Y_%m_%d")
    plt.savefig("convergencePMF-{0}-{1}.pdf".format(molecule, date))