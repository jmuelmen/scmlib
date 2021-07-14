#!/usr/bin/env python2
# -*- coding: utf-8 -*-
"""
Created on Tue Mar 30 14:51:05 2021

@author: bogenschutz1
"""

import numpy as np
import matplotlib.pyplot as plt
import scipy.interpolate
import pandas as pd

x = [444, 664, 0, 193, 444, 664, 0, 193, 444, 664,193]
y = [0, 0, 553, 553, 553, 553, 726, 726, 726, 726, 1107]

z = [-0.1, -0.25, 0.14, 0.45, 0.5, 0.7, -0.15, 0.27, 0.4, -0.2, 0.1]

# Set up a regular grid of interpolation points
xi, yi = np.linspace(min(x), max(x), 100), np.linspace(min(y), max(y), 100)
xi, yi = np.meshgrid(xi, yi)

# Interpolate
rbf = scipy.interpolate.Rbf(x, y, z, function='linear')
zi = rbf(xi, yi)


plt.figure(figsize=(10,10))
plt.imshow(zi, vmin=-0.25, vmax=1, origin='lower', extent=[min(x), max(x), min(y), max(y)])

plt.contourf(xi, yi, zi, 500, cmap='jet')
plt.colorbar()