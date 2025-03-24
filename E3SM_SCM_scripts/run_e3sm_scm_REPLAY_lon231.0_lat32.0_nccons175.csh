#!/bin/csh

#######################################################################
#######################################################################
#######  Script to run E3SM in SCM for
#######  REPLAY
#######  REPLAY an E3SM column
#######
#######  Script Author: P. Bogenschutz (bogenschutz1@llnl.gov)

#######################################################
#######  BEGIN USER DEFINED SETTINGS

  # Set the name of your case here
  setenv casename e3sm_scm_REPLAY_lon231.0_lat32.0_nccons175

  # Set the case directory here
  setenv casedirectory $PSCRATCH/SCM_runs

  # Directory where code lives
  setenv code_dir $HOME/scratch/e3sm-scratch/pm-cpu/main-3.0_test/code

  # Code tag name
  setenv code_tag maint-3.0

  # Name of machine you are running on (i.e. pm-cpu, anvil, chrysalis, compy, etc)
  setenv machine pm-cpu

  # Name of project to run on, if submitting to queue
  setenv projectname e3sm

  # Aerosol specification
  # Options include:
  #  1) cons_droplet (sets cloud liquid and ice concentration
  #                   to a constant)
  #  2) prescribed (uses climatologically prescribed aerosol
  #                 concentration)
  setenv init_aero_type none # keep this as none for REPLAY option

  set startdate = 2000-07-01 # set desired start date
  set stop_option = nhours # set desired stop option
  set stop_n = 2040 # set desired stop n
  set start_in_sec = 0 # set start time in seconds
  ## set iop_file = ${PSCRATCH}/main-3.0_test.lon231.0_lat32.0.replaydata_for_SCM.nc # supply the name of your forcing file
  set iop_file = ${PSCRATCH}/v3_test.lon231.0_lat32.0.replaydata_for_SCM.nc # supply the name of your forcing file
  set lat = 32.0 # set desired latitude
  set lon = 231.0 # set desired longitude

  # What version of E3SM? (v1, v2, or master)
  #  Select "v1" if you are running with E3SMv1 RELEASE code
  #  Select "v2" if you are running with E3SMv2 RELEASE code
  #  Select "master" if you are running with the master development branch of E3SM
  #  As of this writing (April 24, 2024) this is what you run if you want to run v3.
  #  (If you are running with non-up-to-date master code then you may need to modify
  #    aspects of this script to get it to compile.)

  setenv e3sm_version master

  # Set the dynamical core
  #   1) Select "Eulerian" ONLY if you are running E3SMv1 release code
  #
  #   2) Select "SE" IF you are running code from recent E3SM master or v2
  setenv dycore SE
  #  WARNING:  EULERIAN DYCORE SCM IS NO LONGER SUPPORTED. You are only safe
  #  to use Eulerian dycore SCM if you are using E3SMv1 release code.  Else,
  #  user be(very)ware

# User enter any needed modules to load or use below
#  EXAMPLE:
#  module load python/2.7.5

####### END USER DEFINED SETTINGS
####### Likely POSSIBLE EXCEPTION (not limited to):
#######  - If the user wants to add addition output, for example, the EAM
#######	   namelist (user_nl_eam) should be modified below to accomodate for this
###########################################################################
###########################################################################
###########################################################################

# Case specific information kept here
  set do_iop_srf_prop = .true. # Use surface fluxes in IOP file?
  set do_scm_relaxation = .false. # Relax case to observations?
  set do_turnoff_swrad = .false. # Turn off SW calculation
  set do_turnoff_lwrad = .false. # Turn off LW calculation
  set do_turnoff_precip = .false. # Turn off precipitation
  set micro_nccons_val = 175.0D6 # cons_droplet value for liquid
  set micro_nicons_val = 0.0001D6 # cons_droplet value for ice
# End Case specific stuff here

  # Location of IOP file
  set iop_path = atm/cam/scam/iop

  set presc_aero_path = atm/cam/chem/trop_mam/aero
  # Prescribed aerosol file path and name
  if ($e3sm_version != master) then
    set presc_aero_file = mam4_0.9x1.2_L72_2000clim_c170323.nc
  else
    set presc_aero_file = mam5_0.9x1.2_L80_F2010_c013024.nc
  endif

  set PROJECT=$projectname
  set E3SMROOT=${code_dir}/${code_tag}

  cd $E3SMROOT/cime/scripts

  if ($e3sm_version == v1) then
    set compset = F_SCAM5
    set atm_mod = cam
    set physset = cam5
  else
    # Since v1 the naming convention has changed
    set atm_mod = eam
    set physset = default
    set compset = FSCM-ARM97
  endif

  if ($e3sm_version == master) then
    set nudge_flag = iop_nudge_tq
  else
    set nudge_flag = scm_relaxation
  endif

  if ($dycore == Eulerian) then
    set grid=T42_T42
  endif

  if ($dycore == SE) then
    set grid=ne4_ne4
  endif

  set CASEID=$casename

  set CASEDIR=${casedirectory}/$CASEID

  set run_root_dir = $CASEDIR
  set temp_case_scripts_dir = $run_root_dir/case_scripts

  set case_scripts_dir = $run_root_dir/case_scripts
  set case_build_dir   = $run_root_dir/build
  set case_run_dir     = $run_root_dir/run

  set walltime = '00:10:00'

# COSP, set to false unless user really wants it
  setenv do_cosp  false

# Create new case
  ./create_newcase -case $casename --script-root $temp_case_scripts_dir -mach $machine -project $PROJECT -compset $compset -res $grid
  cd $temp_case_scripts_dir

# SCM must run in serial mode
  if ($dycore == Eulerian) then
    ./xmlchange --id MPILIB --val mpi-serial
  endif

  ./xmlchange JOB_WALLCLOCK_TIME=$walltime

# Define executable and run directories
  ./xmlchange --id EXEROOT --val "${case_build_dir}"
  ./xmlchange --id RUNDIR --val "${case_run_dir}"

# Set to debug, only on certain machines
  if ($machine =~ 'pm*') then
    ./xmlchange --id JOB_QUEUE --val 'debug'
  endif

  if ($machine == 'quartz' || $machine == 'syrah') then
    ./xmlchange --id JOB_QUEUE --val 'pdebug'
  endif

# Get local input data directory path
  set input_data_dir = `./xmlquery DIN_LOC_ROOT -value`

# need to use single thread
  set npes = 1
  foreach component ( ATM LND ICE OCN CPL GLC ROF WAV )
    ./xmlchange  NTASKS_$component=$npes,NTHRDS_$component=1
  end

# CAM configure options.  By default set up with settings the same as E3SMv1
  if ($e3sm_version != master) then
    set CAM_CONFIG_OPTS="-phys ${physset} -scam -nlev 72 -clubb_sgs"
  else
    set CAM_CONFIG_OPTS="-phys ${physset} -scam -nlev 80 -clubb_sgs -microphys p3"
  endif

  if ($dycore == Eulerian) then
    set CAM_CONFIG_OPTS="$CAM_CONFIG_OPTS -nospmd -nosmp"
  endif

  if ( $do_cosp == true ) then
    set  CAM_CONFIG_OPTS="$CAM_CONFIG_OPTS -cosp -verbose"
  endif

# This option ONLY to be used for the REPLAY mode
  if ($init_aero_type == none) then
    if ($e3sm_version != master) then
      set CAM_CONFIG_OPTS="$CAM_CONFIG_OPTS -chem linoz_mam4_resus_mom_soag -rain_evap_to_coarse_aero -bc_dep_to_snow_updates"
    else
      set CAM_CONFIG_OPTS="$CAM_CONFIG_OPTS -chem chemuci_linozv3_mam5_vbs -rain_evap_to_coarse_aero -vbs"
    endif
  endif

  if ($init_aero_type == cons_droplet || $init_aero_type == prescribed || $init_aero_type == observed) then
    set CAM_CONFIG_OPTS="$CAM_CONFIG_OPTS -chem none"
  endif

  ./xmlchange CAM_CONFIG_OPTS="$CAM_CONFIG_OPTS"
  set clubb_micro_steps = 8
# If SE dycore is used then we need to change the timestep
# to be consistent with ne30 timestep.  Also change the
# cld_macmic_num_steps to be consistent
  if ($dycore == SE) then
    ./xmlchange ATM_NCPL='48'
    set clubb_micro_steps = 6
  endif

  if ($e3sm_version != v1) then
    ./xmlchange CAM_TARGET=theta-l
  endif

# if we want to turn off SW radiation, then set appropriate namelist settings here
  if ($do_turnoff_swrad == true) then
    set iradsw_in = 0
  else
    set iradsw_in = 1
  endif

# if we want to turn off LW radiation, then set appropriate namelist settings here
  if ($do_turnoff_lwrad == true) then
    set iradlw_in = 0
  else
    set iradlw_in = 1
  endif

# User enter CAM namelist options
#  Add additional output here for example
cat <<EOF >> user_nl_${atm_mod}
 cld_macmic_num_steps = $clubb_micro_steps
 cosp_lite = .true.
 use_gw_front = .true.
 iopfile = '$iop_file'
 mfilt = 10000
 nhtfrq = 1
 scm_iop_srf_prop = $do_iop_srf_prop
 $nudge_flag = $do_scm_relaxation
 iradlw = $iradlw_in
 iradsw = $iradsw_in
 precip_off = $do_turnoff_precip
 scmlat = $lat
 scmlon = $lon
EOF

#  Settings shared by v1 and v2
cat <<EOF >> user_nl_${atm_mod}
 use_hetfrz_classnuc = .true.
 micro_mg_dcs_tdep = .true.
 microp_aero_wsub_scheme = 1
 sscav_tuning = .true.
 convproc_do_aer = .true.
 demott_ice_nuc = .true.
 liqcf_fix = .true.
 regen_fix = .true.
 resus_fix = .false.
 mam_amicphys_optaa = 1
 fix_g1_err_ndrop = .true.
 ssalt_tuning = .true.
 relvar_fix = .true.
 mg_prc_coeff_fix = .true.
 rrtmg_temp_fix = .true.
 mam_amicphys_optaa = 1
 fix_g1_err_ndrop = .true.
 ssalt_tuning = .true.
 use_rad_dt_cosz = .true.
 ice_sed_ai = 500.0
 do_tms = .false.
 n_so4_monolayers_pcage = 8.0D0
 se_ftype = 2
EOF

# Set v1 parameters if running EAMv1
if ($e3sm_version == v1) then
cat <<EOF >> user_nl_${atm_mod}
 cldfrc_dp1 = 0.045D0
 clubb_ice_deep = 16.e-6
 clubb_ice_sh = 50.e-6
 clubb_liq_deep = 8.e-6
 clubb_liq_sh = 10.e-6
 clubb_C2rt = 1.75D0
 zmconv_c0_lnd = 0.007
 zmconv_c0_ocn = 0.007
 zmconv_dmpdz = -0.7e-3
 zmconv_ke = 1.5E-6
 effgw_oro = 0.25
 seasalt_emis_scale = 0.85
 dust_emis_fact = 2.05D0
 clubb_gamma_coef = 0.32
 clubb_gamma_coefb = 0.32
 clubb_c1b = 1.335
 clubb_C8 = 4.3
 cldfrc2m_rhmaxi = 1.05D0
 clubb_c_K10 = 0.3
 effgw_beres = 0.4
 so4_sz_thresh_icenuc = 0.075e-6
 micro_mg_accre_enhan_fac = 1.5D0
 zmconv_tiedke_add = 0.8D0
 zmconv_cape_cin = 1
 zmconv_mx_bot_lyr_adj = 2
 taubgnd = 2.5D-3
 clubb_C1 = 1.335
 raytau0 = 5.0D0
 prc_coef1 = 30500.0D0
 prc_exp = 3.19D0
 prc_exp1 = -1.2D0
 se_ftype = 2
 clubb_C14 = 1.3D0
EOF

else

# V2 tunings.  WARNING: may not be final yet
cat <<EOF >> user_nl_${atm_mod}
 zmconv_trigdcape_ull = .true.
 cld_sed   = 1.0D0
 effgw_beres  = 0.35
 gw_convect_hcf  = 12.5
 effgw_oro  = 0.375
 dust_emis_fact =  1.50D0
 linoz_psc_T = 197.5
 clubb_tk1 = 253.15D0
 clubb_c1               = 2.4
 clubb_c11              = 0.70
 clubb_c11b             = 0.20
 clubb_c11c             = 0.85
 clubb_c14              = 2.5D0
 clubb_c1b              = 2.8
 clubb_c1c              = 0.75
 clubb_c6rtb            = 7.50
 clubb_c6rtc            = 0.50
 clubb_c6thlb           = 7.50
 clubb_c6thlc           = 0.50
 clubb_c8               = 5.2
 clubb_c_k10            = 0.35
 clubb_c_k10h           = 0.35
 clubb_gamma_coef       = 0.12D0
 clubb_gamma_coefb      = 0.28D0
 clubb_gamma_coefc      = 1.2
 clubb_mu               = 0.0005
 clubb_wpxp_l_thresh    = 100.0D0
 clubb_ice_deep         = 14.e-6
 clubb_ice_sh           = 50.e-6
 clubb_liq_deep         = 8.e-6
 clubb_liq_sh           = 10.e-6
 clubb_C2rt             = 1.75D0
 clubb_use_sgv          = .true.
 seasalt_emis_scale     = 0.6
 zmconv_dmpdz  = -0.7e-3
 zmconv_c0_lnd          = 0.0020
 zmconv_c0_ocn          = 0.0020
 zmconv_ke              = 5.0E-6
 zmconv_alfa            = 0.14D0
 zmconv_tp_fac          = 2.0D0
 zmconv_tiedke_add      = 0.8D0
 zmconv_cape_cin        = 1
 zmconv_mx_bot_lyr_adj  = 1
 prc_coef1               = 30500.0D0
 prc_exp                 = 3.19D0
 prc_exp1                = -1.40D0
 micro_mg_accre_enhan_fac = 1.75D0
 microp_aero_wsubmin     = 0.001D0
 so4_sz_thresh_icenuc    = 0.080e-6
 micro_mg_berg_eff_factor = 0.7D0
 cldfrc_dp1              = 0.018D0
 cldfrc2m_rhmaxi         = 1.05D0
 taubgnd                 = 2.5D-3
 raytau0                 = 5.0D0
EOF

endif

# if constant droplet was selected then modify name list to reflect this
if ($init_aero_type == cons_droplet && $e3sm_version != master) then

cat <<EOF >> user_nl_${atm_mod}
  micro_do_nccons = .true.
  micro_do_nicons = .true.
  micro_nccons = $micro_nccons_val
  micro_nicons = $micro_nicons_val
EOF

endif

# if running v3 (p3) only constant droplet is supported (not ice)
if ($init_aero_type == cons_droplet && $e3sm_version == master) then

cat <<EOF >> user_nl_${atm_mod}
  micro_aerosolactivation = .false.
  micro_nccons = $micro_nccons_val
EOF

endif

# if prescribed or observed aerosols set then need to put in settings for prescribed aerosol model
if ($init_aero_type == cons_droplet || $init_aero_type == prescribed ||$init_aero_type == observed) then

cat <<EOF >> user_nl_${atm_mod}
  use_hetfrz_classnuc = .false.
  aerodep_flx_type = 'CYCLICAL'
  aerodep_flx_datapath = '$input_data_dir/$presc_aero_path'
  aerodep_flx_file = '$presc_aero_file'
  aerodep_flx_cycle_yr = 01
  prescribed_aero_type = 'CYCLICAL'
  prescribed_aero_datapath='$input_data_dir/$presc_aero_path'
  prescribed_aero_file='$presc_aero_file'
  prescribed_aero_cycle_yr = 01
EOF

endif

cat <<EOF >> user_nl_${atm_mod}
  micro_aerosolactivation = .false.
  p3_micro_nccons = $micro_nccons_val
EOF

cat <<EOF >> user_nl_${atm_mod}
  cosp_lite = .true.
  do_aerocom_ind3      = .true.

  fincl8 = 'cdnc', 'lwp', 'iwp', 'lcc', 'icc', 'clt', 'cod', 'ccn', 'ttop', 'OMEGA500', 'OMEGA700', 'TH7001000', 'U850', 'V850', 'SOLIN', 'FSNT', 'FSNTOA', 'FSUTOA', 'FSUTOAC', 'FLUT', 'FLNT', 'FLUTC', 'FLNTC', 'FSNSC', 'FSDSC' ! , 'CLDLOW_CAL', 'CLDMED_CAL', 'CLDHGH_CAL' ! , 'FSUTOAC_d1', 'FSUTOA_d1'
  fincl9 = 'T', 'Q', 'CLDLIQ', 'PS', 'OMEGA500', 'OMEGA700', 'TH7001000', 'Z3'
  fincl10 = 'PRECC', 'PRECL', 'QFLX', 'SHFLX', 'OMEGA500', 'OMEGA700', 'TH7001000', 'PS', 'Z3', 'U', 'V', 'T', 'Q', 'CLDLIQ', 'OMEGA', 'QRL', 'QRS', 'CLOUD', 'NUMLIQ', 'CCN4', 'DMS' ! , 'PRAO', 'PRCO', 'DTCORE', 'DQCORE', 'DTCOND'
  fincl11 = 'CLDST', 'CLOUDCOVER_CLUBB', 'CLOUDFRAC_CLUBB', 'CMELIQ', 'CONCLD', 'DPDLFICE', 'DPDLFLIQ', 'DPDLFT', 'NITENDICE', 'PBLH', 'QITENDICE', 'QT', 'QVTENDICE', 'RCM_CLUBB', 'RCMINLAYER_CLUBB', 'RCMTEND_CLUBB', 'RELVAR', 'RELVARC', 'RHO_CLUBB', 'RIMTEND_CLUBB', 'RTP2_CLUBB', 'RTPTHLP_CLUBB', 'RVMTEND_CLUBB', 'SL', 'THETAL', 'THLP2_CLUBB', 'TPERTBLT', 'TTEND_CLUBB', 'TTENDICE', 'UM_CLUBB', 'UP2_CLUBB', 'UPWP_CLUBB', 'UTEND_CLUBB', 'VMAGCL', 'VMAGDP', 'VMAGGUST', 'VM_CLUBB', 'VP2_CLUBB', 'VPWP_CLUBB', 'VTEND_CLUBB', 'WP2_CLUBB', 'WP3_CLUBB', 'WPRCP_CLUBB', 'WPRTP_CLUBB', 'WPTHLP_CLUBB', 'WPTHVP_CLUBB', 'ZM_CLUBB', 'ZMDLF', 'ZT_CLUBB'
  
  avgflag_pertape(8) = 'I'
  avgflag_pertape(9) = 'I'
  avgflag_pertape(10) = 'I'
  avgflag_pertape(11) = 'I'
  
  nhtfrq(8) = 1
  nhtfrq(9) = 1
  nhtfrq(10) = 1
  nhtfrq(11) = 1
  
  ! files are 90-day chunks
  mfilt(8) =  10000
  mfilt(9) =  10000
  mfilt(10) = 10000
  mfilt(11) = 10000
EOF

# if observed aerosols then set flag
if ($init_aero_type == observed) then

cat <<EOF >> user_nl_${atm_mod}
  scm_observed_aero = .true.
EOF

endif

# avoid the monthly cice file from writing as this
#   appears to be currently broken for SCM
cat <<EOF >> user_nl_cice
  histfreq='y','x','x','x','x'
EOF

# Set correct version of CLM or ELM (depending on version of code base)
if ($e3sm_version == v1) then
  set CLM_CONFIG_OPTS="-phys clm4_5"
  ./xmlchange CLM_CONFIG_OPTS="$CLM_CONFIG_OPTS"
else
  set ELM_CONFIG_OPTS="-phys elm"
  ./xmlchange ELM_CONFIG_OPTS="$ELM_CONFIG_OPTS"
endif

# Modify the run start and duration parameters for the desired case
  ./xmlchange RUN_STARTDATE="$startdate",START_TOD="$start_in_sec",STOP_OPTION="$stop_option",STOP_N="$stop_n"

# Modify the latitude and longitude for the particular case
  ./xmlchange PTS_MODE="TRUE",PTS_LAT="$lat",PTS_LON="$lon"
  ./xmlchange MASK_GRID="USGS"
  ./xmlchange CALENDAR="NO_LEAP"


  ./case.setup

# Don't want to write restarts as this appears to be broken for
#  CICE model in SCM.  For now set this to a high value to avoid
  ./xmlchange PIO_TYPENAME="netcdf"
  ./xmlchange REST_N=30000

# Modify some parameters for CICE to make it SCM compatible
  ./xmlchange CICE_AUTO_DECOMP="FALSE"
  ./xmlchange CICE_DECOMPTYPE="blkrobin"
  ./xmlchange --id CICE_BLCKX --val 1
  ./xmlchange --id CICE_BLCKY --val 1
  ./xmlchange --id CICE_MXBLCKS --val 1
  ./xmlchange CICE_CONFIG_OPTS="-nodecomp -maxblocks 1 -nx 1 -ny 1"

# Build the case
  ./case.build

  ./case.submit --no-batch

  exit
