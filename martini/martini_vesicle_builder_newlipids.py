# -*- coding: utf-8 -*-

from math import acos, asin, atan, cos, sin, tan, sqrt, pi
from random import randrange
from sys import argv, stderr

# area of a freaking square
def area2distance(area_per_lipid): return sqrt(area_per_lipid)
def distance2area(distance): return distance*distance

# write gro
def data2gro(title, coordinates, box_size):
  print title
  print len(coordinates)
  counter = 1
  for bead in coordinates:
    print '%5i%5s%5s%5i%8.3f%8.3f%8.3f' % (bead[0], bead[1], bead[2], counter, bead[4], bead[5], bead[6])
    if counter == 99999: counter = 1 # reset counter
    else: counter += 1
  print '%12.5f%12.5f%12.5f' % (box_size, box_size, box_size)

# convert cartesian to spherical coordinates
def cartesian2spherical(x, y, z):
  r = sqrt(x**2 + y**2 + z**2)
  theta = acos(z/r)
  phi = atan(y/x)
  return [r, theta, phi]

# convert spherical to cartesian coordinates
def spherical2cartesian(r, theta, phi):
  x = r*sin(theta)*cos(phi)
  y = r*sin(theta)*sin(phi)
  z = r*cos(theta)
  return [x, y, z]

# compute barycenter of a set of coordinates
def barycenter(coordinates):
  coordinates_barycenter = [0.0, 0.0, 0.0]
  for coordinate in coordinates:
    for component in range(3):
      coordinates_barycenter[component] += coordinate[component + 4]
  for component in range(3): coordinates_barycenter[component] /= len(coordinates)
  return coordinates_barycenter

# translate a set of cartesian coordinates
def translateXYZ(coordinates, vector):
  x, y, z = vector
  new_coordinates = []
  for coordinate in coordinates:
    new_coordinates.append([coordinate[0], coordinate[1], coordinate[2], coordinate[3], coordinate[4] + x, coordinate[5] + y, coordinate[6] + z])
  return new_coordinates

# rotation around the x axis of a set of geometrically centered cartesian coordinates
# |  1      0           0      |
# |  0  cos(angle) -sin(angle) |
# |  0  sin(angle)  cos(angle) |
def aroundX(coordinates, angle):
  coordinates_barycenter = barycenter(coordinates)
  new_coordinates = translateXYZ(coordinates, [-coordinates_barycenter[0], -coordinates_barycenter[1], -coordinates_barycenter[2]])
  for coordinate in new_coordinates:
    x = coordinate[4]
    y = coordinate[5]*cos(angle) - coordinate[6]*sin(angle)
    z = coordinate[5]*sin(angle) + coordinate[6]*cos(angle)
    coordinate[4] = x
    coordinate[5] = y
    coordinate[6] = z
  return new_coordinates

# rotation around y axis of a set of geometrically centered cartesian coordinates
# |  cos(angle)  0  sin(angle) |
# |      0       1      0      |
# | -sin(angle)  0  cos(angle) |
def aroundY(coordinates, angle):
  coordinates_barycenter = barycenter(coordinates)
  new_coordinates = translateXYZ(coordinates, [-coordinates_barycenter[0], -coordinates_barycenter[1], -coordinates_barycenter[2]])
  for coordinate in new_coordinates:
    x =  coordinate[4]*cos(angle) + coordinate[6]*sin(angle)
    y =  coordinate[5]
    z = -coordinate[4]*sin(angle) + coordinate[6]*cos(angle)
    coordinate[4] = x
    coordinate[5] = y
    coordinate[6] = z
  return new_coordinates

# rotation around z axis of a set of geometrically centered cartesian coordinates
# | cos(angle) -sin(angle)  0 |
# | sin(angle)  cos(angle)  0 |
# |     0           0       1 |
def aroundZ(coordinates, angle):
  coordinates_barycenter = barycenter(coordinates)
  new_coordinates = translateXYZ(coordinates, [-coordinates_barycenter[0], -coordinates_barycenter[1], -coordinates_barycenter[2]])
  for coordinate in new_coordinates:
    x = coordinate[4]*cos(angle) - coordinate[5]*sin(angle)
    y = coordinate[4]*sin(angle) + coordinate[5]*cos(angle)
    z = coordinate[6]
    coordinate[4] = x
    coordinate[5] = y
    coordinate[6] = z
  return new_coordinates

# tile a sphere with equilateral triangles; requires the radius of the sphere and the length of the edge of the equilateral triangle
def sphere2geodesics(radius, edge_length, beads, bilayer_thickness_marker):

  circonference_sphere = 2.0*pi*radius # circonference of the sphere
  number_vertices = int(round(circonference_sphere/edge_length, 0)) # maximum number of vertices
  reduced_edge_length = circonference_sphere/number_vertices # real edge length, used for the rest of the loop
  angle_between_vertices = pi/(number_vertices/2.0) # angle between two vertices
  vertex_height = reduced_edge_length*sqrt(3.0)/2.0 # height of each vertex
  number_heights = int(round(circonference_sphere/vertex_height, 0)) # maximum number of heights
  angle_edge_vertex = pi/(number_heights/2.0) # angle between an edge and a vertex

  coordinates = [] # lipid coordinates
  # theta
  theta = 0.0
  while theta < pi:
    current_circle_radius = radius*abs(sin(theta)) # radius of the circle a the current altitude (defined by the polar angle theta)
    circonference_current_circle = 2.0*pi*current_circle_radius # circonference of the current circle
    current_number_vertices = int(round(circonference_current_circle/edge_length, 0)) # number of vertices for the current circle
    try:
      current_angle_between_vertices = pi/(current_number_vertices/2.0) # angle between two vertices for the current circle

      # phi
      phi = current_angle_between_vertices/2.0
      while phi < 2.0*pi:
        x, y, z = spherical2cartesian(radius, theta, phi) # translation to cartesian coordinates
        new_beads = aroundY(beads, theta) # rotation around y
        new_beads = aroundZ(new_beads, phi) # rotation around z
        for bead in new_beads:
          if bilayer_thickness_marker in bead: vector = [x - bead[4], y - bead[5], z - bead[6]] # vector btween PO4 and the point on the sphere
        new_beads = translateXYZ(new_beads, vector) # translate the lipid according to its PO4
        for bead in new_beads: coordinates.append([bead[0], bead[1], bead[2], bead[3], bead[4], bead[5], bead[6]]) # add the new coordinates to the system
        phi += current_angle_between_vertices # update position (defined by the azimuthal angle phi)
        # stderr.write('%i %f %f\n' % (len(coordinates)/len(new_beads), theta*180.0/pi, phi*180.0/pi))

    except ZeroDivisionError:
      x, y, z = spherical2cartesian(radius, theta, 0.0) # translation to cartesian coordinates
      new_beads = aroundY(beads, theta) # rotation around y
      new_beads = aroundZ(new_beads, 0.0) # rotation around z
      for bead in new_beads:
        if bilayer_thickness_marker in bead: vector = [x - bead[4], y - bead[5], z - bead[6]] # vector btween PO4 and the point on the sphere
      new_beads = translateXYZ(new_beads, vector) # translate the lipid according to its PO4
      for bead in new_beads: coordinates.append([bead[0], bead[1], bead[2], bead[3], bead[4], bead[5], bead[6]]) # add the new coordinates to the system
      # stderr.write('%i %f %f\n' % (len(coordinates)/len(new_beads), theta*180.0/pi, 0.0))

    theta += angle_edge_vertex # change altitude

  return coordinates

# generate other lipids from the dopc backbone
# PC
def dopc2dhpc(lipid_coordinates):
  converted_lipid_coordinates = []
  for bead in lipid_coordinates:
    if bead[2] in ['NC3', 'PO4', 'GL1', 'GL2', 'C1A', 'C2A',                      'C1B', 'C2B'                     ]: converted_lipid_coordinates.append([bead[0], 'DHPC', bead[2]                                                                , bead[3], bead[4], bead[5], bead[6]])
  return converted_lipid_coordinates
def dopc2dlpc(lipid_coordinates):
  converted_lipid_coordinates = []
  for bead in lipid_coordinates:
    if bead[2] in ['NC3', 'PO4', 'GL1', 'GL2', 'C1A', 'C2A', 'D3A',               'C1B', 'C2B', 'D3B'              ]: converted_lipid_coordinates.append([bead[0], 'DLPC', bead[2].replace('D3' , 'C3' )                                          , bead[3], bead[4], bead[5], bead[6]])
  return converted_lipid_coordinates
def dopc2dppc(lipid_coordinates):
  converted_lipid_coordinates = []
  for bead in lipid_coordinates:
    if bead[2] in ['NC3', 'PO4', 'GL1', 'GL2', 'C1A', 'C2A', 'D3A', 'C4A',        'C1B', 'C2B', 'D3B', 'C4B'       ]: converted_lipid_coordinates.append([bead[0], 'DPPC', bead[2].replace('D3' , 'C3' )                                          , bead[3], bead[4], bead[5], bead[6]])
  return converted_lipid_coordinates
def dopc2dspc(lipid_coordinates):
  converted_lipid_coordinates = []
  for bead in lipid_coordinates:
    if bead[2] in ['NC3', 'PO4', 'GL1', 'GL2', 'C1A', 'C2A', 'D3A', 'C4A', 'C5A', 'C1B', 'C2B', 'D3B', 'C4B', 'C5B']: converted_lipid_coordinates.append([bead[0], 'DSPC', bead[2].replace('D3' , 'C3' )                                          , bead[3], bead[4], bead[5], bead[6]])
  return converted_lipid_coordinates
# *****************************************************************************************************
#   Edited by Mukarram Tahir on April 7, 2016 to reflect new MARTINI lipid parameterization for POPC
# *****************************************************************************************************
def dopc2popc(lipid_coordinates):
  converted_lipid_coordinates = []
  for bead in lipid_coordinates:
    if bead[2] in ['NC3', 'PO4', 'GL1', 'GL2', 'C1A', 'C2A', 'D3A', 'C4A',        'C1B', 'C2B', 'D3B', 'C4B'       ]: converted_lipid_coordinates.append([bead[0], 'POPC', bead[2].replace('D3A', 'C3A').replace('C2A', 'D2A').replace('D3B', 'C3B')                                          , bead[3], bead[4], bead[5], bead[6]])
  return converted_lipid_coordinates
# *****************************************************************************************************
# *****************************************************************************************************
#   Edited by Mukarram Tahir on June 30, 2016 to reflect new MARTINI lipid parameterization for DOPC
# *****************************************************************************************************
def dopc2dopc(lipid_coordinates):
  converted_lipid_coordinates = []
  for bead in lipid_coordinates:
    if bead[2] in ['NC3', 'PO4', 'GL1', 'GL2', 'C1A', 'C2A', 'D3A', 'C4A',        'C1B', 'C2B', 'D3B', 'C4B'       ]: converted_lipid_coordinates.append([bead[0], 'DOPC', bead[2].replace('C2A', 'D2A').replace('C2B', 'D2B').replace('D3A', 'C3A').replace('D3B', 'C3B')                                                                , bead[3], bead[4], bead[5], bead[6]])
  return converted_lipid_coordinates
# *****************************************************************************************************
def dopc2dupc(lipid_coordinates):
  converted_lipid_coordinates = []
  for bead in lipid_coordinates:
    if bead[2] in ['NC3', 'PO4', 'GL1', 'GL2', 'C1A', 'C2A', 'D3A', 'C4A',        'C1B', 'C2B', 'D3B', 'C4B'       ]: converted_lipid_coordinates.append([bead[0], 'DUPC', bead[2].replace('C2' , 'D2' )                                          , bead[3], bead[4], bead[5], bead[6]])
  return converted_lipid_coordinates
def dopc2dapc(lipid_coordinates):
  converted_lipid_coordinates = []
  for bead in lipid_coordinates:
    if bead[2] in ['NC3', 'PO4', 'GL1', 'GL2', 'C1A', 'C2A', 'D3A', 'C4A', 'C5A', 'C1B', 'C2B', 'D3B', 'C4B', 'C5B']: converted_lipid_coordinates.append([bead[0], 'DAPC', bead[2].replace('C'  , 'D'  ).replace('ND', 'NC').replace('D5' , 'C5' ), bead[3], bead[4], bead[5], bead[6]])
  return converted_lipid_coordinates
# PE
def dopc2dhpe(lipid_coordinates):
  converted_lipid_coordinates = []
  for bead in lipid_coordinates:
    if bead[2] in ['NC3', 'PO4', 'GL1', 'GL2', 'C1A', 'C2A',                      'C1B', 'C2B'                     ]: converted_lipid_coordinates.append([bead[0], 'DHPE', bead[2].replace('NC' , 'NH' )                                          , bead[3], bead[4], bead[5], bead[6]])
  return converted_lipid_coordinates
def dopc2dlpe(lipid_coordinates):
  converted_lipid_coordinates = []
  for bead in lipid_coordinates:
    if bead[2] in ['NC3', 'PO4', 'GL1', 'GL2', 'C1A', 'C2A', 'D3A',               'C1B', 'C2B', 'D3B'              ]: converted_lipid_coordinates.append([bead[0], 'DLPE', bead[2].replace('NC' , 'NH' ).replace('D'  , 'C'  )                    , bead[3], bead[4], bead[5], bead[6]])
  return converted_lipid_coordinates
def dopc2dppe(lipid_coordinates):
  converted_lipid_coordinates = []
  for bead in lipid_coordinates:
    if bead[2] in ['NC3', 'PO4', 'GL1', 'GL2', 'C1A', 'C2A', 'D3A', 'C4A',        'C1B', 'C2B', 'D3B', 'C4B'       ]: converted_lipid_coordinates.append([bead[0], 'DPPE', bead[2].replace('NC' , 'NH' ).replace('D'  , 'C'  )                    , bead[3], bead[4], bead[5], bead[6]])
  return converted_lipid_coordinates
def dopc2dspe(lipid_coordinates):
  converted_lipid_coordinates = []
  for bead in lipid_coordinates:
    if bead[2] in ['NC3', 'PO4', 'GL1', 'GL2', 'C1A', 'C2A', 'D3A', 'C4A', 'C5A', 'C1B', 'C2B', 'D3B', 'C4B', 'C5B']: converted_lipid_coordinates.append([bead[0], 'DSPE', bead[2].replace('NC' , 'NH' ).replace('D'  , 'C'  )                    , bead[3], bead[4], bead[5], bead[6]])
  return converted_lipid_coordinates
def dopc2pope(lipid_coordinates):
  converted_lipid_coordinates = []
  for bead in lipid_coordinates:
    if bead[2] in ['NC3', 'PO4', 'GL1', 'GL2', 'C1A', 'C2A', 'D3A', 'C4A',        'C1B', 'C2B', 'D3B', 'C4B', 'C5B']: converted_lipid_coordinates.append([bead[0], 'POPE', bead[2].replace('NC' , 'NH' ).replace('D3A', 'C3A')                    , bead[3], bead[4], bead[5], bead[6]])
  return converted_lipid_coordinates
def dopc2dope(lipid_coordinates):
  converted_lipid_coordinates = []
  for bead in lipid_coordinates:
    if bead[2] in ['NC3', 'PO4', 'GL1', 'GL2', 'C1A', 'C2A', 'D3A', 'C4A', 'C5A', 'C1B', 'C2B', 'D3B', 'C4B', 'C5B']: converted_lipid_coordinates.append([bead[0], 'DOPE', bead[2].replace('NC' , 'NH' )                                          , bead[3], bead[4], bead[5], bead[6]])
  return converted_lipid_coordinates
# PG
def dopc2popg(lipid_coordinates):
  converted_lipid_coordinates = []
  for bead in lipid_coordinates:
    if bead[2] in ['NC3', 'PO4', 'GL1', 'GL2', 'C1A', 'C2A', 'D3A', 'C4A',        'C1B', 'C2B', 'D3B', 'C4B', 'C5B']: converted_lipid_coordinates.append([bead[0], 'POPG', bead[2].replace('NC3', 'GL0').replace('D3A', 'C3A'), bead[3], bead[4], bead[5], bead[6]])
  return converted_lipid_coordinates
def dopc2dopg(lipid_coordinates):
  converted_lipid_coordinates = []
  for bead in lipid_coordinates:
    if bead[2] in ['NC3', 'PO4', 'GL1', 'GL2', 'C1A', 'C2A', 'D3A', 'C4A', 'C5A', 'C1B', 'C2B', 'D3B', 'C4B', 'C5B']: converted_lipid_coordinates.append([bead[0], 'DOPG', bead[2].replace('NC3', 'GL0')                      , bead[3], bead[4], bead[5], bead[6]])
  return converted_lipid_coordinates
# PS
def dopc2pops(lipid_coordinates):
  converted_lipid_coordinates = []
  for bead in lipid_coordinates:
    if bead[2] in ['NC3', 'PO4', 'GL1', 'GL2', 'C1A', 'C2A', 'D3A', 'C4A',        'C1B', 'C2B', 'D3B', 'C4B', 'C5B']: converted_lipid_coordinates.append([bead[0], 'POPS', bead[2].replace('NC3', 'CNO').replace('D3A', 'C3A'), bead[3], bead[4], bead[5], bead[6]])
  return converted_lipid_coordinates
def dopc2dops(lipid_coordinates):
  converted_lipid_coordinates = []
  for bead in lipid_coordinates:
    if bead[2] in ['NC3', 'PO4', 'GL1', 'GL2', 'C1A', 'C2A', 'D3A', 'C4A', 'C5A', 'C1B', 'C2B', 'D3B', 'C4B', 'C5B']: converted_lipid_coordinates.append([bead[0], 'DOPS', bead[2].replace('NC3', 'CNO')                      , bead[3], bead[4], bead[5], bead[6]])
  return converted_lipid_coordinates

# call corresponding function above
def dopc2lipid(lipid_coordinates, lipid):
  # PC
  if lipid == 'DHPC': return dopc2dhpc(lipid_coordinates)
  if lipid == 'DLPC': return dopc2dlpc(lipid_coordinates)
  if lipid == 'DPPC': return dopc2dppc(lipid_coordinates)
  if lipid == 'DSPC': return dopc2dspc(lipid_coordinates)
  if lipid == 'POPC': return dopc2popc(lipid_coordinates)
  if lipid == 'DOPC': return dopc2dopc(lipid_coordinates)
  if lipid == 'DUPC': return dopc2dupc(lipid_coordinates)
  if lipid == 'DAPC': return dopc2dapc(lipid_coordinates)
  # PE
  if lipid == 'DHPE': return dopc2dhpe(lipid_coordinates)
  if lipid == 'DLPE': return dopc2dlpe(lipid_coordinates)
  if lipid == 'DPPE': return dopc2dppe(lipid_coordinates)
  if lipid == 'DSPE': return dopc2dspe(lipid_coordinates)
  if lipid == 'POPE': return dopc2pope(lipid_coordinates)
  if lipid == 'DOPE': return dopc2dope(lipid_coordinates)
  # PG
  if lipid == 'POPG': return dopc2popg(lipid_coordinates)
  if lipid == 'DOPG': return dopc2dopg(lipid_coordinates)
  # PS
  if lipid == 'POPS': return dopc2pops(lipid_coordinates)
  if lipid == 'DOPS': return dopc2dops(lipid_coordinates)

# print usage
def help():
  string = '''
Script usage:
  python %s
    <VESICLE RADIUS (nm)>                                    *
    <LIPID(s) and RATIOS(s) used to build the vesicle (%%)>   *
    <CHOLESTEROL CONTENT (fake %%)>
    <THICKNESS(es) of the membrane/leaflets (nm)>
    <BEAD TYPE(s) used to compute thickness(es)>
    <AREA(s) PER LIPID for each leaflet (nm^2)>
    <DISTANCE(s) between headgroups for each leaflet (nm)>

The arguments are read in this very order, respect it!

Examples:
  python %s 10 DPPC 1> dppc_vesicle_20nm.gro 2> system.top
  python %s 15 DOPC 0 4.406 PO4 0.686 > dopc_vesicle_30nm.gro
  python %s 12.5 DPPC:DUPC,60:40 43 > dppc-dupc-chol_42-28-30_vesicle.gro
  python %s 12.5 DPPC:DUPC,69:31 25 > dppc-dupc-chol_55-25-20_vesicle.gro

The first two arguments [vesicle radius and lipid type(s)/ratio(s)] are *mandatory; the others are just in case you want to modify the default properties. Remember the properties used by default were computed/compared to experimental values for the flat bilayer case; it might very likely happen they are not valid for the vesicle case (compressed area per lipid in the inner leaflet, streched in the outer leaflet). The smaller the vesicle is, the more tension is applied on lipids, and the uglier the vesicle looks. If sufficiently bigger vesicles are built, random patches of lipids can be locally approximate to small flat bilayer; lipid properties will then get closer to the default values used here. It might happen the minimization run leaves pores in the vesicle; this will help equilibrating the vesicle (lipid flip-flop) and close quickly. Once equilibrated, the vesicle radius will always be smaller (~10 to ~40%% depending on the lipid tail lengths) than initially requested.

If multiple lipids are requested (see syntax in the last example above), a ratio (in %%) will be requested for each leaflet; the area per lipid and thickness will be updated (weighted by the ratio) for each leaflet to reflect the different lipids present in the mixture. Different ratios can be provided for each leaflet, inner first; if only one set or ratio is provided, it will assumed common for both leaflets. If only one type of lipid is provided, the vesicle will be assumed to contain 100%% of this unique lipid, and not ratio is needed.
Remember the ratios are given in %%; which means the sum of the ratios equals 100 in each leaflet. The number of cholesterols is computed according to the total number of lipids present in both leaflets; this content can thus be >100%%, if you want more cholesteral than phospholipids... A value of 100%% will give you exactly 50%% of cholesterol in your system (as much cholesterol as lipids), 200%% will correspond to 66.7%% of cholesterol, etc. This explains why a DPPC:DUPC:cholesterol mixture with a 42:28:30 ratio in each leaflet needs 42.86%% of cholesterol in your system.
Potential solutions to fix that:
  - The number of lipids defines the vesicle shape; why don't we build it, and then convert some of the lipids to cholesterols to respect the ratio? Then our vesicles will shrink like crazy. And do we know the area per lipid/thickness for each concentration of cholesterol in each type of lipid mixture?
  - Why not putting more cholesterol in there, let's say in the two leaflets separately? Good luck in minimizing a system this crowded...
  - Mmmh... No idea. Any other input?

If provided, the area per lipid will be used to compute the distance between headgroups. If the distance between headgroups is provided, the area per lipid will not be used at all.

The regular lipids defined in the Martini force field are available:
  PC: DPPC, DHPC, DLPC, DSPC, POPC, DOPC, DAPC, DUPC
  PE: DPPE, DHPE, DLPE, DSPE, POPE, DOPE
  PG: DOPG, POPG
  PS: DOPS, POPS
All these lipids are dynamically derived from a DOPC backbone (longest tails available in the standard Martini); beads are removed to match the bead definition. Some bond lengths/angles are thus not optimal in the generated conformation; a minimization run will fix that (again, the presence of pores does not mean the vesicle is unstable). So far, only cholesterol (namely "CHOL" in the topology) is included in this script (topology with virtual sites recommended!). But feel free to enlarge the pool of compounds!

Thingy written by Clement <C.Arnarez@rug.nl>, 2013/08/18. Thanks to Jaakko & Marcelo for the brainstorming and heavy testing.
  ''' % (argv[0], argv[0], argv[0], argv[0], argv[0])
  stderr.write(string)
  exit()

# lipid/cholesterol coordinates
lipid_coordinates = {
  # backbone
  'backbone': [
    [1, '', 'NC3', 0, -0.018,  0.180,  1.518],
    [1, '', 'PO4', 0, -0.022, -0.024,  1.099],
    [1, '', 'GL1', 0, -0.020, -0.021,  0.701],
    [1, '', 'GL2', 0,  0.034, -0.291,  0.626],
    [1, '', 'C1A', 0,  0.116,  0.291,  0.499],
    [1, '', 'C2A', 0,  0.187,  0.279,  0.075],
    [1, '', 'D3A', 0,  0.253,  0.092, -0.390],
    [1, '', 'C4A', 0,  0.115, -0.332, -0.596],
    [1, '', 'C5A', 0,  0.042, -0.571, -1.000],
    [1, '', 'C1B', 0, -0.080, -0.271,  0.244],
    [1, '', 'C2B', 0, -0.164,  0.001, -0.196],
    [1, '', 'D3B', 0, -0.290, -0.018, -0.557],
    [1, '', 'C4B', 0, -0.008,  0.253, -0.785],
    [1, '', 'C5B', 0, -0.146,  0.432, -1.239]
  ],
  # PC
  'DHPC': [],
  'DLPC': [],
  'DPPC': [],
  'DSPC': [],
  'POPC': [],
  'DOPC': [],
  'DUPC': [],
  'DAPC': [],
  # PE
  'DHPE': [],
  'DLPE': [],
  'DPPE': [],
  'DSPE': [],
  'POPE': [],
  'DOPE': [],
  # PG
  'POPG': [],
  'DOPG': [],
  # PS
  'POPS': [],
  'DOPS': [],
  # cholesterol
  'CHOL': [
   [1, 'CHOL', 'ROH', 0, -0.048,  0.289, 0.073],
   [1, 'CHOL', 'R1' , 0, -0.159,  0.197, 0.326],
   [1, 'CHOL', 'R2' , 0, -0.005,  0.040, 0.492],
   [1, 'CHOL', 'R3' , 0, -0.103,  0.224, 0.669],
   [1, 'CHOL', 'R4' , 0, -0.030, -0.010, 0.837],
   [1, 'CHOL', 'R5' , 0, -0.183,  0.096, 0.835],
   [1, 'CHOL', 'C1' , 0, -0.157,  0.114, 1.200],
   [1, 'CHOL', 'C2' , 0, -0.026,  0.303, 1.574]
  ]
}
# PC
lipid_coordinates['DHPC'] = dopc2lipid(lipid_coordinates['backbone'], 'DHPC')
lipid_coordinates['DLPC'] = dopc2lipid(lipid_coordinates['backbone'], 'DLPC')
lipid_coordinates['DPPC'] = dopc2lipid(lipid_coordinates['backbone'], 'DPPC')
lipid_coordinates['DSPC'] = dopc2lipid(lipid_coordinates['backbone'], 'DSPC')
lipid_coordinates['POPC'] = dopc2lipid(lipid_coordinates['backbone'], 'POPC')
lipid_coordinates['DOPC'] = dopc2lipid(lipid_coordinates['backbone'], 'DOPC')
lipid_coordinates['DUPC'] = dopc2lipid(lipid_coordinates['backbone'], 'DUPC')
lipid_coordinates['DAPC'] = dopc2lipid(lipid_coordinates['backbone'], 'DAPC')
# PE
lipid_coordinates['DHPE'] = dopc2lipid(lipid_coordinates['backbone'], 'DHPE')
lipid_coordinates['DLPE'] = dopc2lipid(lipid_coordinates['backbone'], 'DLPE')
lipid_coordinates['DPPE'] = dopc2lipid(lipid_coordinates['backbone'], 'DPPE')
lipid_coordinates['DSPE'] = dopc2lipid(lipid_coordinates['backbone'], 'DSPE')
lipid_coordinates['POPE'] = dopc2lipid(lipid_coordinates['backbone'], 'POPE')
lipid_coordinates['DOPE'] = dopc2lipid(lipid_coordinates['backbone'], 'DOPE')
# PG
lipid_coordinates['POPG'] = dopc2lipid(lipid_coordinates['backbone'], 'POPG')
lipid_coordinates['DOPG'] = dopc2lipid(lipid_coordinates['backbone'], 'DOPG')
# PS
lipid_coordinates['POPS'] = dopc2lipid(lipid_coordinates['backbone'], 'POPS')
lipid_coordinates['DOPS'] = dopc2lipid(lipid_coordinates['backbone'], 'DOPS')

# thickness, area per lipid, distance between headgroups (flat bilayer properties)
bilayer_properties = {
  # PC
  'DHPC': [2.729, 0.606, 0.0],
  'DLPC': [3.418, 0.611, 0.0],
  'DPPC': [4.099, 0.615, 0.0],
  'DSPC': [4.775, 0.619, 0.0],
  'POPC': [4.237, 0.655, 0.0],
  'DOPC': [4.406, 0.686, 0.0],
  'DUPC': [3.483, 0.766, 0.0],
  'DAPC': [3.601, 0.872, 0.0],
  # PE
  'DHPE': [2.830, 0.558, 0.0],
  'DLPE': [3.564, 0.566, 0.0],
  'DPPE': [4.295, 0.570, 0.0],
  'DSPE': [5.023, 0.573, 0.0],
  'POPE': [4.384, 0.619, 0.0],
  'DOPE': [4.543, 0.651, 0.0],
  # PG
  'POPG': [4.294, 0.645, 0.0],
  'DOPG': [4.466, 0.675, 0.0],
  # PS
  'POPS': [4.445, 0.651, 0.0],
  'DOPS': [4.271, 0.681, 0.0]
}
for lipid in bilayer_properties: bilayer_properties[lipid][2] = area2distance(bilayer_properties[lipid][1])

# bead used to defined thickness
bilayer_thickness_markers = {
  # PC
  'DPPC': 'PO4',
  'DHPC': 'PO4',
  'DLPC': 'PO4',
  'DSPC': 'PO4',
  'POPC': 'PO4',
  'DOPC': 'PO4',
  'DAPC': 'PO4',
  'DUPC': 'PO4',
  # PE
  'DPPE': 'PO4',
  'DHPE': 'PO4',
  'DLPE': 'PO4',
  'DSPE': 'PO4',
  'POPE': 'PO4',
  'DOPE': 'PO4',
  # PG
  'DOPG': 'PO4',
  'POPG': 'PO4',
  # PS
  'DOPS': 'PO4',
  'POPS': 'PO4'
}

# requested vesicle
vesicle_properties = {
  'radius': 0.0,
  'composition': {'inner': {}, 'outer': {}, 'cholesterol': 0.0},
  'thickness': {'inner': 0.0, 'outer': 0.0},
  'markers': {'inner': '', 'outer': ''},
  'distance': {'inner': 0.0, 'outer': 0.0}
}

# help needed
for i in range(len(argv)):
  if argv[i].replace('-', '') in ['?', 'h', 'help', 'usage']: help()
if len(argv) == 1: help()

# parse command line arguments; not the smartest way, but at least robust
try:
  vesicle_properties['radius'] = float(argv[1])                                               # REQUESTED VESICLE RADIUS

  if ',' in argv[2]:                                                                          #
    lipids = argv[2].split(',')[0].split(':')                                                 # LIPID(S) required (see above for a list of known lipids)
    vesicle_properties['markers']['inner'] = 'PO4'                                            # names of the beads defining the bilayer thickness (taken from the dopc backbone)
    vesicle_properties['markers']['outer'] = 'PO4'                                            #
    inner_ratio = argv[2].split(',')[1].split(':')                                            # ratio for the inner leaflet
    leaflet_thickness, area_per_lipid = 0.0, 0.0                                              #
    for i in range(len(inner_ratio)):                                                         #
      lipid, number = lipids[i], float(inner_ratio[i])/100.0                                  #
      vesicle_properties['composition']['inner'][lipid] = number                              #
      leaflet_thickness += number*bilayer_properties[lipid][0]                                #
      area_per_lipid += number*bilayer_properties[lipid][1]                                   #
    vesicle_properties['thickness']['inner'] = leaflet_thickness/2.0                          # weighted leaflet thickness for the inner leaflet
    vesicle_properties['distance']['inner'] = area2distance(area_per_lipid)                   # weighted distance between headgroups for the inner leaflet
    try:                                                                                      #
      outer_ratio = argv[2].split(',')[2].split(':')                                          # ratio for the outer leaflet
      leaflet_thickness, area_per_lipid = 0.0, 0.0                                            #
      for i in range(len(outer_ratio)):                                                       #
        lipid, number = lipids[i], float(outer_ratio[i])/100.0                                #
        vesicle_properties['composition']['outer'][lipid] = number                            #
        leaflet_thickness += number*bilayer_properties[lipid][0]                              #
        area_per_lipid += number*bilayer_properties[lipid][1]                                 #
      vesicle_properties['thickness']['outer'] = leaflet_thickness/2.0                        # weighted leaflet thickness for the outer leaflet
      vesicle_properties['distance']['outer'] = area2distance(area_per_lipid)                 # weighted distance between headgroups for the outer leaflet
    except IndexError:                                                                        #
      outer_ratio = argv[2].split(',')[1].split(':')                                          #
      vesicle_properties['composition']['outer'] = vesicle_properties['composition']['inner'] #
      vesicle_properties['thickness']['outer'] = vesicle_properties['thickness']['inner']     # same weighted leaflet thickness as inner leaflet
      vesicle_properties['distance']['outer'] = vesicle_properties['distance']['inner']       # same weighted distance between headgroups as inner leaflet
    lipid = 'backbone'                                                                        # dopc backbone used as a model, lipids will be converted later
  else:                                                                                       #
    lipid = argv[2]                                                                           #
    vesicle_properties['composition']['inner'][lipid] = 1.0                                   # 100% of same lipid for both leaflets
    vesicle_properties['composition']['outer'][lipid] = 1.0                                   #
    vesicle_properties['thickness']['inner'] = bilayer_properties[lipid][0]/2.0               # thickness
    vesicle_properties['thickness']['outer'] = bilayer_properties[lipid][0]/2.0               #
    vesicle_properties['markers']['inner'] = bilayer_thickness_markers[lipid]                 # names of the beads defining the bilayer thickness
    vesicle_properties['markers']['outer'] = bilayer_thickness_markers[lipid]                 #
    vesicle_properties['distance']['inner'] = bilayer_properties[lipid][2]                    # distance between headgroups
    vesicle_properties['distance']['outer'] = bilayer_properties[lipid][2]                    #

  try:
    vesicle_properties['composition']['cholesterol'] = float(argv[3])/100.0                   # CHOLESTEROL CONTENT in percent

    if ',' in argv[4]:                                                                        #
      values = argv[4].split(',')                                                             # BILAYER or LEAFLET THICKNESSES
      vesicle_properties['thickness']['inner'] = float(values[0])                             # inner leaflet
      vesicle_properties['thickness']['outer'] = float(values[1])                             # outer leaflet
    else:                                                                                     #
      vesicle_properties['thickness']['inner'] = float(argv[4])/2.0                           # same thickness for both leaflets
      vesicle_properties['thickness']['outer'] = float(argv[4])/2.0                           #

    if ',' in argv[5]:                                                                        #
      values = argv[5].split(',')                                                             # BILAYER THICKNESS MARKERS if defined differently than the distance between PO4 beads
      vesicle_properties['markers']['inner'] = values[0]                                      # inner leaflet
      vesicle_properties['markers']['outer'] = values[1]                                      # outer leaflet
    else:                                                                                     #
      vesicle_properties['markers']['inner'] = argv[5]                                        # same markers for both leaflets
      vesicle_properties['markers']['outer'] = argv[5]                                        #

    if ',' in argv[6]:                                                                        #
      values = argv[6].split(',')                                                             # AREA PER LIPID, as defined by the area of the box divided by the number of lipids (x*y/N)
      vesicle_properties['distance']['inner'] = area2distance(float(values[0]))               # inner leaflet
      vesicle_properties['distance']['outer'] = area2distance(float(values[1]))               # outer leaflet
    else:                                                                                     #
      distance = area2distance(float(argv[6]))                                                # same distance between headgroups for both leaflets
      vesicle_properties['distance']['inner'] = distance                                      #
      vesicle_properties['distance']['outer'] = distance                                      #

    if ',' in argv[7]:                                                                        #
      values = argv[7].split(',')                                                             # DISTANCE BETWEEN HEADGROUPS, as defined by a RDF or whatever
      vesicle_properties['distance']['inner'] = float(values[0])                              # inner leaflet
      vesicle_properties['distance']['outer'] = float(values[1])                              # outer leaflet
    else:                                                                                     #
      distance = float(argv[7])                                                               # same distance between headgroups for both leaflets
      vesicle_properties['distance']['inner'] = distance                                      #
      vesicle_properties['distance']['outer'] = distance                                      #

  except IndexError: pass

except ValueError: help()

# coordinates of the lipid of the vesicle
lipid_coordinates[lipid] = aroundX(lipid_coordinates[lipid], pi) # rotate lipid towards the center (currently aligned with head oriented along positive z axis)
inner_leaflet = sphere2geodesics(vesicle_properties['radius'], vesicle_properties['distance']['inner'], lipid_coordinates[lipid], vesicle_properties['markers']['inner']) # generate inner membrane
lipid_coordinates[lipid] = aroundX(lipid_coordinates[lipid], pi) # rotate lipid back for the outer membrane
outer_leaflet = sphere2geodesics(vesicle_properties['radius'] + vesicle_properties['thickness']['inner'] + vesicle_properties['thickness']['outer'], vesicle_properties['distance']['outer'], lipid_coordinates[lipid], vesicle_properties['markers']['outer']) # generate outer membrane

# coordinates of the cholesterol
if vesicle_properties['composition']['cholesterol'] > 0.0:
  cholesterols = sphere2geodesics(vesicle_properties['radius'] + vesicle_properties['thickness']['inner'], 0.6, lipid_coordinates['CHOL'], 'R5') # generate cholesterol coordinates,
  total_number_lipids = len(inner_leaflet)/len(lipid_coordinates[lipid]) + len(outer_leaflet)/len(lipid_coordinates[lipid]) # total number of lipids in the vesicle, both leaflets
  number_cholesterols = int(round(vesicle_properties['composition']['cholesterol']*total_number_lipids, 0)) # number of cholesterol according to the ratio requested
  maximum_number_cholesterol = len(cholesterols)/len(lipid_coordinates['CHOL']) # maximum number of cholesterol in the bilayer
  try:
    while len(cholesterols)/len(lipid_coordinates['CHOL']) != number_cholesterols: # remove random cholesterol
      random_index = randrange(0, len(cholesterols), len(lipid_coordinates['CHOL']))
      for index in range(len(lipid_coordinates['CHOL'])): cholesterols.pop(random_index) # remove this set of coordinates from the cholesterol
  except ValueError:
    exit("Can't forcefully place %i molecules of cholesterol molecules in there (maximum: %i molecules). Why do you need that much anyway?" % (number_cholesterols, maximum_number_cholesterol))
else:
  cholesterols = []
  number_cholesterols = 0 # no cholesterol in the system

# convert backbone lipid to other lipids
to_convert, converted_coordinates = {'inner': {}, 'outer': {}}, {'inner': {}, 'outer': {}}
if lipid == 'backbone':
  # inner leaflet
  inner_total_number_lipids = len(inner_leaflet)/len(lipid_coordinates['backbone']) # total number of lipids in the inner membrane
  for lipid in vesicle_properties['composition']['inner']:
    to_convert['inner'][lipid] = int(round(vesicle_properties['composition']['inner'][lipid]*inner_total_number_lipids, 0)) # number of model lipid to convert
    converted_coordinates['inner'][lipid] = [] # converted (dopc backbone > requested lipid) coordinates
    while len(converted_coordinates['inner'][lipid])/len(lipid_coordinates[lipid]) != to_convert['inner'][lipid]: # convert random lipid
      random_index = randrange(0, len(inner_leaflet), len(lipid_coordinates['backbone'])) # pick a random lipid
      for bead in dopc2lipid(inner_leaflet[random_index:random_index + len(lipid_coordinates['backbone'])], lipid): converted_coordinates['inner'][lipid].append(bead)
      for index in range(len(lipid_coordinates['backbone'])): inner_leaflet.pop(random_index) # remove this set of coordinates from the list
  # outer leaflet
  outer_total_number_lipids = len(outer_leaflet)/len(lipid_coordinates['backbone']) # total number of lipids in the outer membrane
  for lipid in vesicle_properties['composition']['outer']:
    to_convert['outer'][lipid] = int(round(vesicle_properties['composition']['outer'][lipid]*outer_total_number_lipids, 0)) # number of model lipid to convert
    converted_coordinates['outer'][lipid] = [] # converted (dopc backbone > requested lipid) coordinates
    while len(converted_coordinates['outer'][lipid])/len(lipid_coordinates[lipid]) != to_convert['outer'][lipid]: # number of model lipid to convert
      random_index = randrange(0, len(outer_leaflet), len(lipid_coordinates['backbone'])) # pick a random lipid
      for bead in dopc2lipid(outer_leaflet[random_index:random_index + len(lipid_coordinates['backbone'])], lipid): converted_coordinates['outer'][lipid].append(bead)
      for index in range(len(lipid_coordinates['backbone'])): outer_leaflet.pop(random_index) # remove this set of coordinates from the list
else:
   # boring vesicle with only one type of lipid in both leaflets
  converted_coordinates['inner'][lipid] = inner_leaflet # lipid coordinates
  converted_coordinates['outer'][lipid] = outer_leaflet
  inner_total_number_lipids = len(converted_coordinates['inner'][lipid])/len(lipid_coordinates[lipid]) # number of lipids in each leaflet
  outer_total_number_lipids = len(converted_coordinates['outer'][lipid])/len(lipid_coordinates[lipid])

# final topology/coordinates
command_line = '; python'
for argument in argv: command_line += ' ' + argument # provided command line
# properties of the vesicle eventually generated
# leaflets
leaflet_composition = ';     inner:\n'
for lipid in vesicle_properties['composition']['inner']: leaflet_composition += ';       %s:      %7i molecules (%.1f%%)\n' % (lipid, len(converted_coordinates['inner'][lipid])/len(lipid_coordinates[lipid]), vesicle_properties['composition']['inner'][lipid]*100.0)
leaflet_composition += ';     outer:\n'
for lipid in vesicle_properties['composition']['outer']: leaflet_composition += ';       %s:      %7i molecules (%.1f%%)\n' % (lipid, len(converted_coordinates['outer'][lipid])/len(lipid_coordinates[lipid]), vesicle_properties['composition']['outer'][lipid]*100.0)
# system
global_composition = ''
total_number_lipids = inner_total_number_lipids + outer_total_number_lipids + number_cholesterols
for lipid in vesicle_properties['composition']['inner']:
  total_number_this_lipid = (len(converted_coordinates['inner'][lipid]) + len(converted_coordinates['outer'][lipid]))/len(lipid_coordinates[lipid])
  global_composition += ';     %s:        %7i molecules (%.1f%%)\n' % (lipid, total_number_this_lipid, total_number_this_lipid*100.0/total_number_lipids)
generated_vesicle_properties = '''; vesicle properties:
;   initial radius:                  %.3f nm (expect ~10 to ~40%% shrinking)
;   ideal weighted thicknesses:      %.3f + %.3f = %.3f nm, using "%s" and "%s" as marker beads (inner|outer|bilayer)
;   ideal weighted areas per lipid:  %.3f | %.3f nm^2 (inner|outer leaflets)
;   leaflet composition:
%s
;   system compostion:
%s
;     cholesterol: %7i molecules (%.1f%%)''' % (
  vesicle_properties['radius'],
  vesicle_properties['thickness']['inner'], vesicle_properties['thickness']['outer'], vesicle_properties['thickness']['inner'] + vesicle_properties['thickness']['outer'], vesicle_properties['markers']['inner'], vesicle_properties['markers']['outer'],
  distance2area(vesicle_properties['distance']['inner']), distance2area(vesicle_properties['distance']['outer']),
  leaflet_composition[:-1],
  global_composition[:-1],
  len(cholesterols)/len(lipid_coordinates['CHOL']), (number_cholesterols)*100.0/(inner_total_number_lipids + outer_total_number_lipids + number_cholesterols)
)
string = '''#include "dry_martini_v2.1.itp"
#include "dry_martini_v2.1_lipids.itp"
#include "dry_martini_v2.1_cholesterol.itp"

[ system ]
vesicle

%s
;
%s

[ molecules ]
''' % (command_line, generated_vesicle_properties)
box_size = 3.0*vesicle_properties['radius'] # box size (used to center the vesicle in the box)
vesicle_coordinates = [] # coordinates of the vesicle
# inner leaflet
string += '; inner leaflet\n'
for lipid in converted_coordinates['inner']:
  string += '%s\t%i\n' % (lipid, len(converted_coordinates['inner'][lipid])/len(lipid_coordinates[lipid])) # topology
  for bead in converted_coordinates['inner'][lipid]: vesicle_coordinates.append([bead[0], bead[1], bead[2], bead[3], bead[4] + box_size/2.0, bead[5] + box_size/2.0, bead[6] + box_size/2.0]) # centered coordinates of the inner membrane
# outer leaflet
string += '; outer leaflet\n'
for lipid in converted_coordinates['outer']:
  string += '%s\t%i\n' % (lipid, len(converted_coordinates['outer'][lipid])/len(lipid_coordinates[lipid])) # topology
  for bead in converted_coordinates['outer'][lipid]: vesicle_coordinates.append([bead[0], bead[1], bead[2], bead[3], bead[4] + box_size/2.0, bead[5] + box_size/2.0, bead[6] + box_size/2.0]) # centered coordinates of the outer membrane
# cholesterol
if vesicle_properties['composition']['cholesterol'] > 0.0:
  string += '; cholesterol\nCHOL\t%i\n' % (len(cholesterols)/len(lipid_coordinates['CHOL'])) # topology
  for bead in cholesterols: vesicle_coordinates.append([bead[0], bead[1], bead[2], bead[3], bead[4] + box_size/2.0, bead[5] + box_size/2.0, bead[6] + box_size/2.0]) # centered coordinates of the cholesterol

# print final topology/coordinates
stderr.write(string)
data2gro('vesicle', vesicle_coordinates, box_size)
