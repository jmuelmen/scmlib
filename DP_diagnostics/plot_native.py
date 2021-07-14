#!/usr/bin/env python2
# -*- coding: utf-8 -*-
"""
Created on Tue Mar 30 09:41:24 2021

@author: bogenschutz1
"""

from netCDF4 import Dataset
import matplotlib.pyplot as plt
import numpy as np
import matplotlib.colors as colors
import scipy.interpolate
import sys
import pylab

np.set_printoptions(threshold=sys.maxsize)

# Directory where output files *.cam.h0* live
datadir="/p/lustre2/bogensch/ACME_simulations/" 
casename="scream_dp_GATEIII.1.5km.001a"

file_append=".eam.h1.1974-08-30-00000.nc"

scream_file=datadir+casename+'/run/'+casename+file_append

fs1=Dataset(scream_file,mode='r')
grid_x=fs1.variables['crm_grid_x'][:]
grid_y=fs1.variables['crm_grid_y'][:]
precl=fs1.variables['PRECL'][:]
#precl=fs1.variables['WINDSPD_10M']

# Take just one time slice of grid_x
grid_x=np.squeeze(grid_x[0,:])/1000.
grid_y=np.squeeze(grid_y[0,:])/1000.

# For testing take just one slice of PRECL
var=np.squeeze(precl[100,:])

# Set up a regular grid of interpolation points
xi, yi = np.linspace(min(grid_x), max(grid_x), 100), np.linspace(min(grid_y), max(grid_y), 100)
xi, yi = np.meshgrid(xi, yi)

# Interpolate
rbf = scipy.interpolate.Rbf(grid_x, grid_y, var, function='linear')
zi = rbf(xi, yi)

plt.figure(figsize=(10,10))
theplt=plt.imshow(zi, vmin=57, vmax=66, origin='lower', extent=[min(grid_x), max(grid_x), min(grid_y), max(grid_y)])

plt.title('Total Precipitable Water (kg/m$^2$)', fontsize=16)
plt.xlabel('x domain (km)')
plt.ylabel('y domain (km)')
plt.contourf(xi, yi, zi, 500, cmap='jet')
cbar=plt.colorbar()
#cbar.set_clim(57,66)
axes=plt.gca()
axes.xaxis.label.set_size(16)
axes.yaxis.label.set_size(16)

pylab.savefig('GATE_var.png')
