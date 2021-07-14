#!/bin/csh
## ==========================================================
# Purpose is to run SCM diagnostics
#
# Author: Peter Bogenschutz

## ==========================================================
# Begin User Defined Settings

# User defined casename for output results
setenv casename DYCOMSRF02_comparison_001

# Directory where data lives
setenv datadir "scmoutput/" 

# Top layer you would like to make your plots, in hPa (useful for 
#   boundary layer cloud cases)
setenv toplev 800.0     

# How many cases are you comparing?
setenv numcases 4

# Enter the name of the *.nc outfile
setenv file01 run_acme_scm_DYCOMSRF02_consdrop.norelax.clubb.001.cam.h0.1999-07-11-00000.nc
setenv file02 run_acme_scm_DYCOMSRF02_consdrop.norelax.noclubb.001.cam.h0.1999-07-11-00000.nc
setenv file03 run_acme_scm_DYCOMSRF02_consdrop.norelax.clubb.018.cam.h0.1999-07-11-00000.nc
setenv file04 run_acme_scm_DYCOMSRF02_consdrop.norelax.clubb.30L.018.cam.h0.1999-07-11-00000.nc

# Easy ID for cases, for legends and plots
setenv caseid01 CLUBB_72L
setenv caseid02 NOCLUBB_72L
setenv caseid03 CLUBB_TUNE_72L
setenv caseid04 CLUBB_TUNE_30L

# Which sets do you want to plot
#  and do you want to make a webpage
setenv makeweb false
setenv makeprofiles false
setenv make1Dtime true
setenv make2Dtime false

## ==========================================================
# End User Defined Settings

# Profile variables to plot
if (! -d profileplots) mkdir profileplots
if (! -d make1Dtime) mkdir make1Dtime
if (! -d make2Dtime) mkdir make2Dtime
   
#setenv plotdir plots   

# Make the profile plots
if ($makeprofiles == true) then
  python SCM_diagnostics_profiles.py
endif

# Make the 1D diagnostics plots
if ($make1Dtime == true) then
  python SCM_diagnostics_1Dtime.py
endif

# Make the 2D diagnostics plots
if ($make2Dtime == true) then
  python SCM_diagnostics_2Dtime.py
endif

# See what plots were made and 
#  put them in webpage 

#if ($makeweb == true) then
   
#  cp set1_base.htm set1.htm

#  set theline=19
#  foreach plot(plots/*.png)
#    set plotname = $plot
#    sed '19 a\''""''\nhuh' set1.htm > set1_temp.htm
#    @ theline++
#  end
  
#endif