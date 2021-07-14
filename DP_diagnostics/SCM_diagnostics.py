# -*- coding: utf-8 -*-
"""
SCM Diagnostics package 

Main file to make plots and webpages for the SCM
Diagnsotics package
"""

## ==========================================================
## ==========================================================
## ==========================================================
# Begin User Defined Settings
    
# User defined name used for this comparison, this will be the name 
#   given the directory for these diagnostics
casename="DP_SCREAM.ARM97.rescomp.001a"
    
# Directory where output files *.cam.h0* live
datadir="/p/lustre2/bogensch/ACME_simulations/" 

# Directory where output will be written to (plots, webpages, etc.)
outdir="/p/lustre2/bogensch/ACME_simulations/dp_scream_diags/"

# Here put the output files.  Currently there is a limit of 
#   six cases, but this could be easily fixed if desired
#filelist=["run_acme_scm_ARM97.SCREAM.tune.clubb.eam.h0.1997-06-19-84585.nc",\
#          "scream_dp_ARM97.w3.001a.eam.h0.1997-06-19-84585.nc",
#          "scream_dp_ARM97.prod.003a.eam.h0.1997-06-19-84585.nc"]

filelist_pre=["scream_dp_ARM97.5km.001a",
          "scream_dp_ARM97.3km.001a",
          "scream_dp_ARM97.1.5km.001a",
          "scream_dp_ARM97.500m.001a"]
          
filelist_append=".eam.h0.1997-06-19-84585.nc"

#filelist=["run_e3sm_scm_GATEIII.SCREAM.001a.clubb.eam.h0.1974-08-30-00000.nc",\
#          "scream_dp_GATEIII.shoc.w3.002a.eam.h0.1974-08-30-00000.nc",\
#          "scream_dp_GATEIII.prod.001a.eam.h0.1974-08-30-00000.nc"]

#filelist=["e3sm_scm_TWP06.clubb.001a.eam.h0.2006-01-17-10800.nc",\
#          "scream_dp_TWP06.prod.001a.eam.h0.2006-01-17-10800.nc",\
#          "scream_dp_TWP06.prod.clubb.001a.eam.h0.2006-01-17-10800.nc"]
   
# Easy ID for individual cases, for legends and plot titles
#caselist=["SCM","DP-SCREAM","DP-SCREAM clubb"]
caselist=["5 km","3 km","1.5 km","500 m"]

#################################
# OPTIONS FOR SET1: PROFILE PLOTS       
# Make profile plots
makeprofiles=True
#  Averaging period  
#  Enter "end" for average_end to end averaging at the end of the simulation 
#  Simply enter "0" to start at the beginning of the simulation  
prof_avg_start=0.0 # units in days
prof_avg_end=14.0 # units in days
# Top layer you would like to make your plots, in hPa (useful for 
#   boundary layer cloud cases)
toplev_prof=0.0
#################################
# OPTIONS FOR SET2: 1D TIME SERIES PLOTS     
# Make 1D timeseries plots
make1Dtime=False
#  1D time series plotting period
#  To plot entire simulation simply put 0 for start and "end" for end
time1d_start=0 # units in days
time1d_end="end" # units in days

#################################
# OPTIONS FOR SET3: 2D TIME SERIES PLOTS         
# Make 2D timeseries plots
make2Dtime=False
toplev_time2D=0.0

# Generate a webage for easier viewing?
makeweb=True

# Generate .tar file for webpage and output
maketar=True

# End User Defined Settings    
## ==========================================================
## ==========================================================
## ==========================================================

# Import required packages
import SCM_diagnostics_profiles
import SCM_diagnostics_time
import SCM_diagnostics_webpages
import os
import SCM_diagnostics_functions

filelist=[];
for f in range(0,len(filelist_pre)):
    filelist.append(filelist_pre[f]+"/run/"+filelist_pre[f]+filelist_append)

# Make case directory, remove and replace if it exists
casedir=outdir+casename
print(casedir)

    
if not os.path.exists(casedir):
    os.mkdir(casedir)    
   
if makeprofiles:
    print("Making set1: Profile plots")
    profdir=casedir+'/set1'
    if not os.path.exists(profdir):
        os.mkdir(profdir)
    profwebvars=SCM_diagnostics_profiles.plotprofiles(datadir,profdir,toplev_prof,\
                                                      prof_avg_start,prof_avg_end,\
                                                      filelist,caselist)
    
if make1Dtime:
    print("Making set2: 1D Time series")
    time1Ddir=casedir+'/set2'
    if not os.path.exists(time1Ddir):
        os.mkdir(time1Ddir)
    time1Dwebvars=SCM_diagnostics_time.plot1Dtime(datadir,time1Ddir,\
                                                  time1d_start,time1d_end,\
                                                  filelist,caselist)
    
if make2Dtime:
    print("Making set3: 2D Time series")
    time2Ddir=casedir+'/set3'
    if not os.path.exists(time2Ddir):
        os.mkdir(time2Ddir)
    time2Dwebvars=SCM_diagnostics_time.plot2Dtimepanel(datadir,time2Ddir,toplev_time2D,\
                                    filelist,caselist)

## ============================
# Make Web Page   

# PAB: TODO, make note of when profiles are averaged to and from on the
#   the webpage
 
if makeweb:
    print("Making webpages")
    SCM_diagnostics_webpages.main_web(casename,casedir)
    if (makeprofiles):
        SCM_diagnostics_webpages.sets_web(casename,casedir,profwebvars,"set1",\
                                  "Set 1 - Profile Plots","354","268")
    if (make1Dtime):
        SCM_diagnostics_webpages.sets_web(casename,casedir,time1Dwebvars,"set2",\
                                  "Set 2 - 1D Timeseries Plots","454","318")
    if (make2Dtime):
        SCM_diagnostics_webpages.sets_web(casename,casedir,time2Dwebvars,"set3",\
                                  "Set 3 - 2D Timeseries Plots","454","318")    

if maketar:    
    print("Making tar file of case")
    SCM_diagnostics_functions.make_tarfile(outdir+casename+'.tar',outdir+casename)
    
    


    
