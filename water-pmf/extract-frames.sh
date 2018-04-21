#WARNING: This doesn't work as well as the python version (extract-frames.py)
gmx trjconv -s pull/pull.tpr -f traj_comp.xtc -o conf.gro -sep

# use gmx distance to calc distance between pull groups
