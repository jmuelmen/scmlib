# -*- coding: utf-8 -*-
"""
Spyder Editor

This is a temporary script file.
"""

from netCDF4 import Dataset
import matplotlib.pyplot as plt
import numpy as np
import scipy as sp
import pylab
import os
import SCM_diagnostics_functions

def plotprofiles(datadir,plotdir,toplev,avg_start,avg_end,filelist,caselist,derived_prof): 
    
    colorarr=["r","b","g","c","m","y"]
    
    numfiles=len(filelist)
        
    ############################################################
    # Make the variable list for variables to plot
    # This will make profile plots for every variable possible
    
    # Initialize list
    varstoplot=[];
    
    # temporarily limit to searching just the first file for speed
    listtodo=filelist[0]
    SCM_diagnostics_functions.makevarlist(datadir,listtodo,4,varstoplot)
    
    # append the derived variables to the list
    numderived=len(derived_prof)
    for d in range(0,numderived):
        varstoplot.append(derived_prof[d])
    
    ############################################################
    # loop over the variables to plot
    for x in range(0,len(varstoplot)):
        
        varname=varstoplot[x]
    
        legendlist=[];
        # loop over the number of simulations to plot
        for f in range(0,numfiles):
            
            filename=filelist[f]
            file=datadir+filename
            
            # Read in file and the dataset information
            fh=Dataset(file,mode='r')
            
            # Read in appropriate coordinate variables
            lat=fh.variables['lat'][:]
            lon=fh.variables['lon'][:]
            time=fh.variables['time'][:]
            lev=fh.variables['lev'][:]
            ilev=fh.variables['ilev'][:]
            
            # Generate a list to see if variables are in there
            varsinfile=fh.variables.keys()
                
            # The True check is a temporary hack
            if (varname in varsinfile or True):
            
                # If derived variable search first for that
                if (varname == "CLDLIQICE"):
                    vartoplot1=fh.variables['CLDLIQ'][:]
                    vartoplot2=fh.variables['CLDICE'][:]
                    vartoplot=vartoplot1+vartoplot2
                    theunits="kg/kg"
                    thelongname="Liquid + Ice Condensate"
                elif (varname == "WT_RES"):
                    vartoplot1=fh.variables['T'][:]
                    vartoplot2=fh.variables['OMEGA'][:]
                    vartoplot3=fh.variables['CLDLIQ'][:]
                    vartoplot=compute_res_flux(vartoplot1,vartoplot2,vartoplot3,lev)
                    theunits="W/m2"
                    thelongname="Resolved Potential Temperature Flux"
                elif (varname == "TOT_WQW"):
                    vartoplot1=fh.variables['WQW_RES'][:]
                    vartoplot2=fh.variables['WQW_SEC'][:]
                    vartoplot=vartoplot1+vartoplot2
                    theunits="W/m2"
                    thelongname="Total (Resolved + SGS) Moisture Flux"
                elif (varname == "TOT_WTHL"):
                    vartoplot1=fh.variables['WTHL_RES'][:]
                    vartoplot2=fh.variables['WTHL_SEC'][:]
                    vartoplot=vartoplot1+vartoplot2
                    theunits="W/m2"
                    thelongname="Total (Resolved + SGS) Heat Flux"
                else:
                    # DEFAULT GOES HERE
                    vartoplot=fh.variables[varname][:]
                    theunits=fh.variables[varname].units
                    thelongname=fh.variables[varname].long_name
                
                if (avg_end == "end"):
                    plottimes=np.squeeze(np.where(time >= avg_start))
                else:
                    plottimes=np.squeeze(np.where((time >= avg_start) & \
                                                  (time <= avg_end)))

                if (vartoplot.ndim == 4):
                    avgprof=np.mean(vartoplot[plottimes,:,:,:],axis=0)
                    if (plottimes.size == 1):
#                        avgprof=np.mean(vartoplot[avg_start,:,:,:])
                        avgprof=vartoplot[plottimes,:,0,0]
                elif (vartoplot.ndim == 3):
                    avgprof=np.mean(vartoplot[plottimes,:,:],axis=0)
                    if (lat.size > 1):
                        avgprof=np.mean(avgprof[:,1:lat.size-1],axis=1)
                elif (vartoplot.ndim == 2):
                    avgprof=np.mean(vartoplot[plottimes,:],axis=0)                    
           
                if (len(avgprof) == len(lev)):
                    levarr=lev
                elif (len(avgprof) == len(ilev)):
                    levarr=ilev
            
                legendlist.append(caselist[f])
                
                # Exceptions for plotting ease                
                if (theunits == "kg/kg"):
                    avgprof=avgprof*1000.
                    theunits="g/kg"
                    
                if (varname == "WQW_SEC"):
                    thelongname="SGS Moisture Flux"
                    
                if (varname == "WQW_RES"):
                    thelongname="Resolved Moisture Flux"
                    
                if (varname == "WTHL_SEC"):
                    thelongname = "SGS Heat Flux"
                    
                if (varname == "WTHL_RES"):
                    thelongname = "Resolved Heat Flux"
                    
#                if (theunits == "fraction"):
#                    if (f == 1):
#                        avgprof=avgprof*2.5
#                        theunits="g/kg"                    
                
                # Only plot to top level
                plotlevs=np.where(levarr > toplev)
            
                plt.figure(x)
                plt.plot(np.squeeze(avgprof[plotlevs]),levarr[plotlevs],colorarr[f])   
                
                plt.ylim(max(levarr),toplev)
                plt.title(thelongname + '\n' + \
                '(' + varname + ')')
                plt.ylabel('P (hPa)')
                plt.xlabel('('+theunits+')')
                plt.grid(True)
                plt.ticklabel_format(style='sci', axis='x', scilimits=(-4,4))
                
        plt.legend(legendlist)        
        pylab.savefig(plotdir+'/'+varname+'.png')
        plt.close(x)
        
    return varstoplot
    
def compute_res_flux(temp,omega,cldliq,levarr):

    # compute density
    rgas = 287.058
    gravit = 9.80665
    R_over_Cp = 0.286
    latvap = 2.5*10**6
    Cp = 1004.0
    
    theshape=np.shape(temp)
    timedim=theshape[0]
    levdim=theshape[1]
    ptsdim=theshape[2]
    
    rho=np.zeros((ptsdim))
    vert=np.zeros((timedim,levdim,ptsdim))
    pottemp=np.zeros((timedim,levdim,ptsdim))
    avgtemp=np.zeros((timedim,levdim))
    flux=np.zeros((timedim,levdim,ptsdim))
    
    # Compute Omega
    for t in range(0,timedim):
        for k in range(0,levdim):
            rho[:] = (levarr[k]*100.)/(rgas*temp[t,k,:])
            vert[t,k,:] = -omega[t,k,:]/(rho[:]*gravit)
            pottemp[t,k,:] = (temp[t,k,:]*(1000.0/levarr[k])**(R_over_Cp)) - \
            ((latvap/Cp)*cldliq[t,k,:])
            avgtemp[t,k] = np.mean(pottemp[t,k,:])
            flux[t,k,:] = vert[t,k,:]*(pottemp[t,k,:]-avgtemp[t,k])
            flux[t,k,:] = flux[t,k,:]*rho[:]*Cp
        
    vartoplot = flux
    return vartoplot
        
