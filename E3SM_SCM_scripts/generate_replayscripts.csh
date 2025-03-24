#!/bin/csh -fe

#  GENERATE SCM scripts for each particular case
#  Uses a pre-defined template 

# Who to set these scripts up for?
#  - for general use select: general

#  - for specific user needs select: user
#    - if select user go to bottom of script and fill in deserired data paths etc. so that
#      that the user need not edit all scripts if they planning on running several.

setenv setupfor general

# helpful notes
# path to prescribed aerosol file = atm/cam/chem/presc_aero
# edison /project/projectdirs/e3sm/inputdata


################################
# REPLAY
################################

foreach nccons (20 40 60 80 100 120 150 175 200 250 300 400 500 750 1000)
    set lon = 231.0
    set lat = 32.0
    set casename = REPLAY_lon${lon}_lat${lat}_nccons${nccons}
    set outfile = run_e3sm_scm_$casename.csh 
    cp -r run_e3sm_scm_REPLAY_TEMPLATE.csh $outfile
    sed -i s/THECASENAME/$casename/ $outfile
    # sed -i s/THECASEDESCRIPTION/"REPLAY an E3SM column"/ $outfile
    # sed -i s/AEROTYPE/"none # keep this as none for REPLAY option"/ $outfile
    # sed -i s/THECASELONGNAME_iopfile_4scam.nc/"# supply the name of your forcing file"/ $outfile
    # sed -i s/CASELONGstartdate/"# set desired start date"/ $outfile
    # sed -i s/CASELONGstartinsec/"# set start time in seconds"/ $outfile
    # sed -i s/CASELONGstopoption/"# set desired stop option"/ $outfile
    # sed -i s/CASELONGstopn/"# set desired stop n"/ $outfile
    # sed -i s/CASELONGlat/"# set desired latitude"/ $outfile
    # sed -i s/CASELONGlon/"# set desired longitude"/ $outfile
    # sed -i s/"dycore Eulerian"/"dycore SE # do NOT change for REPLAY mode"/ $outfile
    # sed -i s/CASEsrfprop/.true./ $outfile
    # sed -i s/CASErelax/.false./ $outfile
    # sed -i s/CASEswoff/.false./ $outfile
    # sed -i s/CASElwoff/.false./ $outfile
    # sed -i s/CASEprecipoff/.false./ $outfile
    sed -i s/CASEnccons/${nccons}.0D6/ $outfile
    # sed -i s/CASEnicons/0.0001D6/ $outfile
    # sed -i s/FSCM/FSCM-ARM97/ $outfile
    # sed -i '/REPLAY_iopfile_4scam/d' $outfile
    # sed -i s/CASEcaltype/NO_LEAP/ $outfile
end

# Fill in each script with specific user info so you don't have to do it for every script,
#   use example below for how one Peter Bogenschutz sets his scripts for Cori.  Note that 
#   the following may not be exhaustive to get up and running on your machine.
if ($setupfor == user) then

  foreach file (*.csh)
    if ($file != run_e3sm_scm_TEMPLATE.csh && $file != generate_scmscripts.csh) then

      # Path to output
      sed -i s+'$CSCRATCH/SCM_runs'+/global/cscratch1/sd/bogensch/SCM_sims+ $file
      
      # Path to code base
      sed -i s+'$HOME/e3sm_code'+/global/homes/b/bogensch/ACME_development+ $file

      # Name of code base
      sed -i s+e3sm_codetag+E3SM_master+ $file

      # Name of machine used
      sed -i s+mach_name+cori-knl+ $file

      # Name of project to be charged
      sed -i s+proj_name+e3sm+ $file
    endif
  end

endif

