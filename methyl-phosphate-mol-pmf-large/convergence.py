"""Calculates PMF for all files, and then plots PMF against Sampling time."""
import matplotlib
matplotlib.use('Agg')
import math, os, time
import numpy as np
import matplotlib.pyplot as plt

# Filename, Time, PMF
files = np.array([])
PMFs = np.array([])
times = np.array([])

cwd = os.getcwd()
for file in os.listdir(cwd):
	if file.endswith(".xvg") and file.startswith("profile-"):
		x,  y = np.genfromtxt(file, unpack=True, dtype="float_")
		PMF = np.amax(y)-np.amin(y)
		time = file.replace("profile-", "")
		time = time.replace(".xvg", "")
		files = np.append(files, file)
		times = np.append(times, time) 
		PMFs = np.append(PMFs, PMF)

# Save files
plt.plot(times,PMFs, "rx")
plt.savefig("convergence.pdf")
