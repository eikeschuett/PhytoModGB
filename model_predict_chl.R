#
# To be done:
# - Export results as nc file and plot it with rasteVis package
# - optimize parameter settings
#


################################################################################
#
# Define model parameters
#
################################################################################

params = list(pmax = 0.4, # maximum photosynthetic rate [1/day] # should not be below 0.3
              K_I = 10, # half saturation time of phytoplankton growth (light!)
              mort = 0.01, # mortality rate. Should change from 0 to 0.05 [d^-1]
              N_0 = 20, # Nutrient concentration at shore. Here for P [mmol m^-3]. Markus: Between 15-30 in Winter. In Summer between 1-5 in coastal zones. Offshore towards 0
              H_0 = 2, # half saturation depth of nutrients [m]
              K_N = 1, # [mmol m^-3] Nutrient half saturation constant. Typically between 0.5 and 1. A little lower than nutrient conc at shore to simulate no nutrient limitation in coastal waters
              KN_0 = 5, # scaling parameter
              offset = 0)

start_date = "2005-04-01"
end_date = "2005-06-01"
dt = 1/24 # length of time steps (hourly)


################################################################################
#
# Set environment, import and prepare required data
#
################################################################################

require(cmocean)

# Set working directory to Git-folder
#setwd("H:/Eigene Dateien/Studium/9. Semester/Ecosystem_Modeling/Project/PhytoModGB/")

# source all relevant functions
source("./functions/read_nc_file.R")
source("./functions/surface_PAR.R")
source("./functions/primprod.R")
source("./functions/nutrilim.R")

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
jul_start = julian(as.Date(start_date), origin = as.Date("2002-01-01"))%%365
period = GB$jd[i_time1] - jul_start #GB$jd[i_time0]

# all time steps
t = seq(from = 0, to = period, by = dt)


################################################################################
#
# Calculate nutrient limitation
#
################################################################################

n_lim = nutrilim(params, GB$bathy)


################################################################################
#
# Loop to predict Chl at each time step
#
################################################################################

# Create an empty array to store the model results for each time step
chl = array(numeric(),c(dim(GB$chl)[1],
                            dim(GB$chl)[2],
                            length(t)))

# Store the OCCCI data for t0 as initial setting
chl[,,1] = GB$chl[,,i_time0]

for (i in 2:length(t)){
  
  ##############################################################################
  #
  # Calculate mean primary production of water column at time t
  #
  ##############################################################################
  
  # calculate surface radiance at time t[i]
  I_0 = surface_PAR(GB$jd[i_time0]+t[i])
  
  # Get index of kd_490/attenuation coefficient measurement closest in time to 
  # use it in the func_PPmaen
  date_i = GB$time[i_time0]+14+t[i] # add 14 days because we use monthly means
  i_490 = which.min(abs(date_i-GB$time))
  
  # calculate mean phot production at time t[i]
  phot = func_PPmean(I_0 = I_0, 
                     atten = GB$kd_490[,,i_490], # choose closest kd/atten in time
                     depth = GB$bathy, 
                     params = params)
  
  # calculate primary production rate, considering nutrient limitations
  pp = n_lim * phot
  
  # net growth rate
  dchl_dt = (pp-params$mort) * chl[,,i-1]
  # calculate the new Chl concentration for each time step and store it in the 
  # array (Euler forward integration)
  chl[,,i] = chl[,,i-1] + dchl_dt * dt
}

  
# Save results as nc file
source("./functions/save_chl_as_nc.R")

# produce a map of final model results and OCCCI data
source("./functions/rastervis_plot_chl.R")

################################################################################
#
# Difference plot
#
################################################################################

# Not ready yet, just overview

z_array <- chl[,,length(t)]

differences <- (z_array-GB$chl[,,i_time1])/GB$chl[,,i_time1]*100

z_array <- differences

### Difference Plot
image2D(x = GB$lon, y = GB$lat, z = differences,
        ylim = range(GB$lat),
        xlim = range(GB$lon),
        zlim = c(-100, 100),
        cex = 4,
        main = paste0("Diff Sim - Actual ", GB$time[i_time1], " [%]"),
        xlab = "Longitude [Degree East]",
        ylab = "Latitude [Degree North]",
        frame.plot = T,
        pch = ".",
        col = cmocean('balance')(100))
