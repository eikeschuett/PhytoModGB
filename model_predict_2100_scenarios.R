################################################################################
#
# Define model parameters
#
################################################################################
# params$offset has to be changed to the values below to get different
# scenarios

params = list(pmax = 0.4, # maximum photosynthetic rate [1/day] # should not be below 0.3
              K_I = 15, # half saturation time of phytoplankton growth (light!)
              mort = 0.01, # mortality rate. Should change from 0 to 0.05 [d^-1]
              N_0 = 20, # Nutrient concentration at shore. Here for P [mmol m^-3]. Markus: Between 15-30 in Winter. In Summer between 1-5 in coastal zones. Offshore towards 0
              H_0 = 2, # half saturation depth of nutrients [m]
              K_N = 1, # [mmol m^-3] Nutrient half saturation constant. Typically between 0.5 and 1. A little lower than nutrient conc at shore to simulate no nutrient limitation in coastal waters
              KN_0 = 5) # scaling parameter

start_date = "2018-03-01"
end_date = "2018-05-01"
dt = 1/24 # length of time steps (hourly)

# Adding C-based Ratio -> C:Chl = 25
C2Chlorophyll_ratio <- 25    # mass ratio [g/g]

# Define scenarios
scen_titles = c("baseline", "mean scenario", "extreme scenario")
scen_offsets = c(2, 1.4, 0.2)


################################################################################
#
# Set environment, import and prepare required data
#
################################################################################
require(cmocean)
require(ncdf4)
require(plot3D)
require(dplyr)
require(rasterVis)
require(maptools)
require(rgdal)
require(sp)

# Set working directory
#setwd("H:/Eigene Dateien/Studium/9. Semester/Ecosystem_Modeling/Project/PhytoModGB/)

# source all relevant functions
source("./functions/read_nc_file.R")
source("./functions/surface_PAR.R")
source("./functions/primprod.R")
source("./functions/nutrilim.R")
source("./functions/save_pp_as_nc.R")

# Import OCCCI data
fname = "./data/CCI_ALL-v5.0-MONTHLY_1997-2020.nc"
GB = read_nc_file(fname)

# Import Bathymetry data and repair all suspicious values
fname = "./data/esacci_depth.nc"
depth = read_nc_file(fname)
depth = depth$DEPTH

# Take subset of German Bight
source("./functions/GB_subset.R")
rm(depth)

# Repair all suspicious values of the attenuation coefficient and the bathymetry
GB$kd_490[GB$kd_490<0.01] = 0.01
GB$bathy[GB$bathy<0.1] = 0.1

# Do some fancy time conversions
# Define initial date
i_time0 = which(GB$time == start_date)
# Define end date of model run
i_time1 = which(GB$time == end_date)

# Get length of model run (number of days)
jul_start = julian(as.Date(start_date), origin=as.Date("2002-01-01"))%%365
period = GB$jd[i_time1] - jul_start #GB$jd[i_time0]

# all time steps
t = seq(from = 0, to = period, by=dt)

# prepare an empty list to store all output filenames
filenames = rep(NA, length(scen_titles))

################################################################################
#
# Run the model separately for each scenario
#
################################################################################

for (k in 1:length(scen_titles)){
  
  # Assign the respective offset
  params$offset = scen_offsets[k]
  
  ################################################################################
  #
  # Calculate nutrient limitation
  #
  ################################################################################
  
  n_lim = nutrilim(params, GB$bathy)
  
  ################################################################################
  #
  # Prepare loop to predict chl, net PP and gross PP at each time step
  #
  ################################################################################
  
  # Create an empty array to store the model results for each time step
  chl = array(numeric(),c(dim(GB$chl)[1],
                          dim(GB$chl)[2],
                          length(t)))
  
  # Store the OCCCI data for t0 as initial setting
  chl[,,1] = GB$chl[,,i_time0]
  
  # Creating empty arrays to store PP data
  net_PPcarbon = gross_PPcarbon = array(0, c(dim(GB$chl)[1],
                                            dim(GB$chl)[2]))
  
  for (i in 2:length(t)){
    
    ##############################################################################
    #
    # Calculate mean primary production of water column at time t
    #
    ##############################################################################
    
    # calculate surface radiance at time t[i]
    I_0 = surface_PAR(GB$jd[i_time0]+t[i])
    
    # Get index of kd_490/attenuation coefficient measurement closest in time to 
    # use it in the func_PPmean. This is different to what we used in class, but
    # has the advantage that it accounts for leap years and raises no error if
    # we want to predict data for a month with no kd-data
    date_i = GB$time[i_time0]+14+t[i] # add 14 days because we use monthly means
    i_490 = which.min(abs(date_i-GB$time))
    
    # calculate mean pp production at time t[i]
    pp_mean = func_PPmean(I_0 = I_0, 
                          atten = GB$kd_490[,,i_490], # choose closest kd in time
                          depth = GB$bathy, 
                          params = params)
    
    # calculate primary production rate, considering nutrient limitations
    pp_mean = n_lim * pp_mean
    # pp_mean <- pmax(pp_mean, 0, na.rm = TRUE)
    
    # net growth rate
    dchl_dt = (pp_mean-params$mort) * chl[,,i-1]
    
    # calculate the new Chl concentration for each time step and store it in the 
    # array (Euler forward integration)
    chl[,,i] = chl[,,i-1] + dchl_dt * dt
    
    # Adding carbon-based Primary Production to array
    # net pp - params$m subtracted from ppmean
    # gross pp - without params$m subtracted
    # vertical mean pp via Euler Integration made with Markus last day of course
    net_PPcarbon <- net_PPcarbon + (pp_mean - params$mort) * chl[,,i] * C2Chlorophyll_ratio*dt/period
    
    # gross PP
    gross_PPcarbon <- gross_PPcarbon + pp_mean * chl[,,i] * C2Chlorophyll_ratio*dt/period
    
    # rel_Growth_rate <- PPmean - params$mort 
    # mortality growth rate [1/d] 
    # then replace ppmean below with rel_growth rate
    
    # looking at state variable/ state of model at actual time (chlorophyll concentration at given time)
    # multiplying with net growth rate
  }
  
  # Save net and gross primary production in an nc file
  
  filename = paste0("./Results/P_model_result_offset_", params$offset, ".nc")
  filenames[k] = filename
  save_nc_file(filename = filename,
               npp = net_PPcarbon,
               gpp = gross_PPcarbon)
  
  
  print(paste("Done with", scen_titles[k]))
}


# produce a map of final NPP model results
source("./functions/rastervis_plot_npp.R")

plot_pp(filenames = filenames, 
             titles = scen_titles, 
             varname = "netpp", 
             main = "Modelled Net Primary Production 2100")

plot_pp(filenames = filenames, 
             titles = scen_titles, 
             varname = "grosspp", 
             main = "Modelled Gross Primary Production 2100")
