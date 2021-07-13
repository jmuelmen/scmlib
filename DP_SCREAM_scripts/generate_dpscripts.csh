#!/bin/csh -fe

#  GENERATE DP-SCREAM scripts for each particular case
#  Uses a pre-defined template 

# Who to set these scripts up for?
#  - for general use select: general

#  - for specific user needs select: user
#    - if select user go to bottom of script and fill in deserired data paths etc. so that
#      that the user need not edit all scripts if they planning on running several.

# Time step things to modify:
# se_nsplit, ATM_NCPL, CAM_NAMELIST_OPTS, ELM_NAMELIST_OPTS

# For runs, probably want to have more frequent averaged output for BL cases

setenv setupfor LC

# helpful notes
# path to prescribed aerosol file = atm/cam/chem/presc_aero
# edison /project/projectdirs/e3sm/inputdata

################################
# DYCOMSRF01
################################

set casename = DYCOMSrf01
set outfile = run_dp_scream_$casename.csh 
cp -r run_dp_scream_TEMPLATE.csh $outfile
sed -i s/THECASENAME/$casename/ $outfile
sed -i s/THECASEDESCRIPTION/"Non-precipitating marine stratocumulus"/ $outfile
sed -i s/CASElat/31.5/ $outfile
sed -i s/CASElon/238.500/ $outfile
sed -i s/CASEsrfprop/.true./ $outfile
sed -i s/CASEswoff/.true./ $outfile
sed -i s/CASElwoff/.false./ $outfile
sed -i s/CASEstartdate/1999-07-10/ $outfile
sed -i s/CASEstartinsec/0/ $outfile
sed -i s/CASEstopoption/nhours/ $outfile
sed -i s/CASEstopn/12/ $outfile
sed -i s/CASEdebug/true/ $outfile
sed -i s/CASEnumprocs/16/ $outfile
sed -i s/CASEnex/5/ $outfile
sed -i s/CASEney/5/ $outfile
sed -i s/CASElex/50000/ $outfile
sed -i s/CASEley/50000/ $outfile
sed -i s/CASEtqnudge/.false./ $outfile
sed -i s/CASEuvnudge/.false./ $outfile
sed -i s/CASEdosub/.true./ $outfile
sed -i s/CASEwalltime/00:30:00/ $outfile
sed -i s/CASEnhtfrq/-1/ $outfile

################################
# DYCOMSRF02
################################

set casename = DYCOMSrf02
set outfile = run_dp_scream_$casename.csh 
cp -r run_dp_scream_TEMPLATE.csh $outfile
sed -i s/THECASENAME/$casename/ $outfile
sed -i s/THECASEDESCRIPTION/"Drizzling marine stratocumulus"/ $outfile
sed -i s/AEROTYPE/observed/ $outfile
sed -i s/CASElat/31.5/ $outfile
sed -i s/CASElon/238.500/ $outfile
sed -i s/CASEsrfprop/.true./ $outfile
sed -i s/CASEswoff/.true./ $outfile
sed -i s/CASElwoff/.false./ $outfile
sed -i s/CASEstartdate/1999-07-11/ $outfile
sed -i s/CASEstartinsec/0/ $outfile
sed -i s/CASEstopoption/nhours/ $outfile
sed -i s/CASEstopn/12/ $outfile
sed -i s/CASEdebug/true/ $outfile
sed -i s/CASEnumprocs/16/ $outfile
sed -i s/CASEnex/5/ $outfile
sed -i s/CASEney/5/ $outfile
sed -i s/CASElex/50000/ $outfile
sed -i s/CASEley/50000/ $outfile
sed -i s/CASEtqnudge/.false./ $outfile
sed -i s/CASEuvnudge/.false./ $outfile
sed -i s/CASEdosub/.true./ $outfile
sed -i s/CASEwalltime/00:30:00/ $outfile
sed -i s/CASEnhtfrq/-1/ $outfile

################################
# GATE
################################

set casename = GATEIII
set outfile = run_dp_scream_$casename.csh 
cp -r run_dp_scream_TEMPLATE.csh $outfile
sed -i s/THECASENAME/$casename/ $outfile
sed -i s/THECASEDESCRIPTION/"Maritime deep convection"/ $outfile
sed -i s/CASElat/9.00/ $outfile
sed -i s/CASElon/336.0/ $outfile
sed -i s/CASEsrfprop/.false./ $outfile
sed -i s/CASEswoff/.false./ $outfile
sed -i s/CASElwoff/.false./ $outfile
sed -i s/CASEstartdate/1974-08-30/ $outfile
sed -i s/CASEstartinsec/0/ $outfile
sed -i s/CASEstopoption/ndays/ $outfile
sed -i s/CASEstopn/20/ $outfile
sed -i s/CASEdebug/false/ $outfile
sed -i s/CASEnumprocs/256/ $outfile
sed -i s/CASEnex/20/ $outfile
sed -i s/CASEney/20/ $outfile
sed -i s/CASElex/200000/ $outfile
sed -i s/CASEley/200000/ $outfile
sed -i s/CASEtqnudge/.false./ $outfile
sed -i s/CASEuvnudge/.true./ $outfile
sed -i s/CASEdosub/.false./ $outfile
sed -i s/CASEwalltime/04:00:00/ $outfile
sed -i s/CASEnhtfrq/-24/ $outfile

################################
# ARM97 
################################

set casename = ARM97
set outfile = run_dp_scream_$casename.csh 
cp -r run_dp_scream_TEMPLATE.csh $outfile
sed -i s/THECASENAME/$casename/ $outfile
sed -i s/THECASEDESCRIPTION/"Deep convection over ARM SGP site"/ $outfile
sed -i s/CASElat/36.605/ $outfile
sed -i s/CASElon/262.515/ $outfile
sed -i s/CASEsrfprop/.true./ $outfile
sed -i s/CASEswoff/.false./ $outfile
sed -i s/CASElwoff/.false./ $outfile
sed -i s/CASEstartdate/1997-06-19/ $outfile
sed -i s/CASEstartinsec/84585/ $outfile
sed -i s/CASEstopoption/ndays/ $outfile
sed -i s/CASEstopn/26/ $outfile
sed -i s/CASEdebug/false/ $outfile
sed -i s/CASEnumprocs/256/ $outfile
sed -i s/CASEnex/20/ $outfile
sed -i s/CASEney/20/ $outfile
sed -i s/CASElex/200000/ $outfile
sed -i s/CASEley/200000/ $outfile
sed -i s/CASEtqnudge/.false./ $outfile
sed -i s/CASEuvnudge/.true./ $outfile
sed -i s/CASEdosub/.false./ $outfile
sed -i s/CASEwalltime/05:00:00/ $outfile
sed -i s/CASEnhtfrq/-24/ $outfile

################################
# BOMEX
################################

set casename = BOMEX
set outfile = run_dp_scream_$casename.csh 
cp -r run_dp_scream_TEMPLATE.csh $outfile
sed -i s/THECASENAME/$casename/ $outfile
sed -i s/THECASEDESCRIPTION/"Non-precipitating trade-wind cumulus convection"/ $outfile
sed -i s/CASElat/15.0/ $outfile
sed -i s/CASElon/300.0/ $outfile
sed -i s/CASEsrfprop/.true./ $outfile
sed -i s/CASEswoff/.true./ $outfile
sed -i s/CASElwoff/.true./ $outfile
sed -i s/CASEstartdate/1969-06-25/ $outfile
sed -i s/CASEstartinsec/0/ $outfile
sed -i s/CASEstopoption/ndays/ $outfile
sed -i s/CASEdebug/true/ $outfile
sed -i s/CASEnumprocs/16/ $outfile
sed -i s/CASEstopn/1/ $outfile
sed -i s/CASEnex/5/ $outfile
sed -i s/CASEney/5/ $outfile
sed -i s/CASElex/50000/ $outfile
sed -i s/CASEley/50000/ $outfile
sed -i s/CASEtqnudge/.false./ $outfile
sed -i s/CASEuvnudge/.false./ $outfile
sed -i s/CASEdosub/.true./ $outfile
sed -i s/CASEwalltime/00:30:00/ $outfile
sed -i s/CASEnhtfrq/-1/ $outfile

################################
# TWP06
################################

set casename = TWP06
set outfile = run_dp_scream_$casename.csh
cp -r run_dp_scream_TEMPLATE.csh $outfile
sed -i s/THECASENAME/$casename/ $outfile
sed -i s/THECASEDESCRIPTION/"TWP-ICE deep convection in the warm pool"/ $outfile
sed -i s/CASElat/-12.43/ $outfile
sed -i s/CASElon/130.89/ $outfile
sed -i s/CASEsrfprop/.true./ $outfile
sed -i s/CASEswoff/.false./ $outfile
sed -i s/CASElwoff/.false./ $outfile
sed -i s/CASEstartdate/2006-01-17/ $outfile
sed -i s/CASEstartinsec/10800/ $outfile
sed -i s/CASEstopoption/ndays/ $outfile
sed -i s/CASEstopn/26/ $outfile
sed -i s/CASEdebug/false/ $outfile
sed -i s/CASEnumprocs/256/ $outfile
sed -i s/CASEnex/20/ $outfile
sed -i s/CASEney/20/ $outfile
sed -i s/CASElex/200000/ $outfile
sed -i s/CASEley/200000/ $outfile
sed -i s/CASEtqnudge/.false./ $outfile
sed -i s/CASEuvnudge/.true./ $outfile
sed -i s/CASEdosub/.false./ $outfile
sed -i s/CASEwalltime/05:00:00/ $outfile
sed -i s/CASEnhtfrq/-24/ $outfile

################################
# MPACEB
################################

set casename = MPACEB
set outfile = run_dp_scream_$casename.csh 
cp -r run_dp_scream_TEMPLATE.csh $outfile
sed -i s/THECASENAME/$casename/ $outfile
sed -i s/THECASEDESCRIPTION/"Mixed phase Arctic clouds subset"/ $outfile
sed -i s/CASElat/71.75/ $outfile
sed -i s/CASElon/209.0/ $outfile
sed -i s/CASEsrfprop/.true./ $outfile
sed -i s/CASEswoff/.false./ $outfile
sed -i s/CASElwoff/.false./ $outfile
sed -i s/CASEstartdate/1999-10-09/ $outfile
sed -i s/CASEstartinsec/61200/ $outfile
sed -i s/CASEstopoption/nhours/ $outfile
sed -i s/CASEstopn/12/ $outfile
sed -i s/CASEdebug/false/ $outfile
sed -i s/CASEnumprocs/128/ $outfile
sed -i s/CASEnex/20/ $outfile
sed -i s/CASEney/20/ $outfile
sed -i s/CASElex/200000/ $outfile
sed -i s/CASEley/200000/ $outfile
sed -i s/CASEtqnudge/.false./ $outfile
sed -i s/CASEuvnudge/.false./ $outfile
sed -i s/CASEdosub/.true./ $outfile
sed -i s/CASEwalltime/01:00:00/ $outfile
sed -i s/CASEnhtfrq/-1/ $outfile
sed -i s/FORCINGPROVIDER/"Shuaiqi Tang and Shaocheng Xie"/ $outfile

################################
# MPACE full
################################

set casename = MPACE
set outfile = run_dp_scream_$casename.csh
cp -r run_dp_scream_TEMPLATE.csh $outfile
sed -i s/THECASENAME/$casename/ $outfile
sed -i s/THECASEDESCRIPTION/"Mixed phase Arctic clouds Full IOP"/ $outfile
sed -i s/AEROTYPE/prescribed/ $outfile
sed -i s/CASElat/70.5/ $outfile
sed -i s/CASElon/206.0/ $outfile
sed -i s/CASEsrfprop/.true./ $outfile
sed -i s/CASErelax/.false./ $outfile
sed -i s/CASEswoff/.false./ $outfile
sed -i s/CASElwoff/.false./ $outfile
sed -i s/CASEnccons/50.0D6/ $outfile
sed -i s/CASEnicons/0.00016D6/ $outfile
sed -i s/CASEstartdate/2004-10-05/ $outfile
sed -i s/CASEstartinsec/7200/ $outfile
sed -i s/CASEstopoption/ndays/ $outfile
sed -i s/CASEdebug/true/ $outfile
sed -i s/CASEnumprocs/256/ $outfile
sed -i s/CASEstopn/17/ $outfile
sed -i s/CASEnex/20/ $outfile
sed -i s/CASEney/20/ $outfile
sed -i s/CASElex/200000/ $outfile
sed -i s/CASEley/200000/ $outfile
sed -i s/CASEtqnudge/.false./ $outfile
sed -i s/CASEuvnudge/.false./ $outfile
sed -i s/CASEdosub/.true./ $outfile
sed -i s/CASEwalltime/00:30:00/ $outfile
sed -i s/CASEnhtfrq/-24/ $outfile
sed -i s/FORCINGPROVIDER/"Shuaiqi Tang and Shaocheng Xie"/ $outfile

################################
# RCE
################################

set casename = RCE
set outfile = run_dp_scream_$casename.csh 
cp -r run_dp_scream_TEMPLATE.csh $outfile
sed -i s/THECASENAME/$casename/ $outfile
sed -i s/THECASEDESCRIPTION/"Radiative Convective Equilibrium"/ $outfile
sed -i s/CASElat/0.0/ $outfile
sed -i s/CASElon/0.0/ $outfile
sed -i s/CASEsrfprop/.false./ $outfile
sed -i s/CASEswoff/.false./ $outfile
sed -i s/CASElwoff/.false./ $outfile
sed -i s/CASEstartdate/2000-01-01/ $outfile
sed -i s/CASEstartinsec/0/ $outfile
sed -i s/CASEstopoption/ndays/ $outfile
sed -i s/CASEstopn/20/ $outfile
sed -i s/CASEdebug/false/ $outfile
sed -i s/CASEnumprocs/512/ $outfile
sed -i s/CASEnex/50/ $outfile
sed -i s/CASEney/50/ $outfile
sed -i s/CASElex/500000/ $outfile
sed -i s/CASEley/500000/ $outfile
sed -i s/CASEtqnudge/.false./ $outfile
sed -i s/CASEuvnudge/.false./ $outfile
sed -i s/CASEdosub/.false./ $outfile
sed -i s/CASEwalltime/16:00:00/ $outfile
sed -i s/CASEnhtfrq/-24/ $outfile
sed -i s/F2000-SCREAM-HR/F-EAM-RCEMIP/ $outfile
sed -i s/CASEconfigappend/"'-rce -aquaplanet'"/ $outfile
sed -i s/CASEncdata/"input_data_dir"/ $outfile
sed -i s/CASEsstaqua/"sst_val"/ $outfile
sed -i s/CASEsstval/300/ $outfile
sed -i '/ELM_CONFIG_OPTS/d' $outfile
sed -i '/ELM_NAMELIST_OPTS/d' $outfile
sed -i '/CICE_CONFIG_OPTS/d' $outfile
sed -i '/CALENDAR/d' $outfile

foreach file (*.csh)
  if ($file != run_dp_scream_TEMPLATE.csh && $file != generate_dpscripts.csh) then
    sed -i '/OBSERVEDAERO/d' $file
    sed -i '/LENGTHNOTE/d' $file
    sed -i '/CASEstartdate/d' $file
    sed -i '/CASEstopoption/d' $file
    sed -i '/CASEstopn/d' $file  
    sed -i '/CASEstartinsec/d' $file 
    sed -i '/CASELONGstartdate/d' $file
    sed -i '/CASELONGstopoption/d' $file
    sed -i '/CASELONGstopn/d' $file 
    sed -i '/CASElat/d' $file
    sed -i '/CASElon/d' $file
    sed -i '/CASELONGlat/d' $file
    sed -i '/CASELONGlon/d' $file    
    sed -i '/CASELONGstartinsec/d' $file 
    sed -i '/FORCINGPROVIDER/d' $file 
    sed -i '/THECASELONGNAME/d' $file
    sed -i '/CASEcaltype/d' $file  
    sed -i '/CASEconfigappend/d' $file
    sed -i '/CASEsstaqua/d' $file
    sed -i '/CASEsstval/d' $file
    sed -i '/CASEncdata/d' $file
  endif
end

# Fill in each script with specific user info so you don't have to do it for every script,
#   use example below for how one Peter Bogenschutz sets his scripts for Cori.  Note that 
#   the following may not be exhaustive to get up and running on your machine.
if ($setupfor == LC) then

  foreach file (*.csh)
    if ($file != run_dp_scream_TEMPLATE.csh && $file != generate_dpscripts.csh) then

      # Path to output
      sed -i s+'$CSCRATCH/SCM_runs'+/p/lustre2/bogensch/ACME_simulations+ $file
      
      # Path to code base
      sed -i s+'$HOME/SCREAM_code'+/g/g19/bogensch/code+ $file

      # Name of code base
      sed -i s+'SCREAM_codetag'+SCREAM_DP+ $file

      # Name of machine used
      sed -i s+'mach_name'+quartz+ $file

      # Name of project to be charged
      sed -i s+'proj_name'+cbronze+ $file
    endif
  end

endif

if ($setupfor == cori) then

  foreach file (*.csh)
    if ($file != run_dp_scream_TEMPLATE.csh && $file != generate_dpscripts.csh) then

      # Path to output
      sed -i s+'$CSCRATCH/SCM_runs'+/global/cscratch1/sd/bogensch/IOPSCREAM_simulations+ $file
      
      # Path to code base
      sed -i s+'$HOME/SCREAM_code'+/global/homes/b/bogensch/ACME_development+ $file

      # Name of code base
      sed -i s+'SCREAM_codetag'+SCREAM_DP+ $file

      # Name of machine used
      sed -i s+'mach_name'+cori-knl+ $file

      # Name of project to be charged
      sed -i s+'proj_name'+e3sm+ $file
    endif
  end

endif
