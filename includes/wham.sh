#!/bin/bash
echo "Checking for required files."
# Check for TPR Files, at least one.
for i in *.tpr
do
	if [ ! -f $i ]
	then
	echo "No TPR files exist."
	exit 1
	fi
done

echo "Preparing WHAM input files."
# Create file lists
ls pulling*md.tpr > tpr-files.dat
ls pullf*.xvg > pullf-files.dat
ls pullx*.xvg > pullx-files.dat

echo "Running g_wham."
g_wham -it tpr-files.dat -if pullf-files.dat -b 2000 -o -hist -unit kCal
sed -i "s/@/#/g" profile.xvg
