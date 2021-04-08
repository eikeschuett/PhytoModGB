
require(ncdf4)

# From here:
# https://stackoverflow.com/questions/28949971/writing-data-to-a-netcdf-file-with-r
# in the first example a time dimension is also included

# specify filename
filename = paste0("./Results/Chl_model_result_", params$offset, ".nc")

# get dimensions of lat and lon
nlat = length(GB$lat)
nlon = length(GB$lon)

# assign lat and lon dimensions and data
lon1 <- ncdim_def("longitude", "degrees_east", GB$lon)
lat2 <- ncdim_def("latitude", "degrees_north", GB$lat)

# Specify value for missing data
mv <- -999

# Create a new variable
var_mod_chl <- ncvar_def("model_chl", # name of variable
                       "mg m-3", # unit
                       list(lon1, lat2), # dimensions
                       longname = paste("Chlorophyll a concentration model results for", GB$time[i_time0]),
                       mv) # missing value

var_mod_netpp <- ncvar_def("model_netpp", # name of variable
                         "?", # unit
                         list(lon1, lat2), # dimensions
                         longname = paste("Moduled net pp result for 2100", params$offset),
                         mv) # missing value

var_mod_grosspp <- ncvar_def("model_grosspp", # name of variable
                         "?", # unit
                         list(lon1, lat2), # dimensions
                         longname = paste("Moduled gross pp result for 2100", params$offset),
                         mv) # missing value

# Create NC file
ncnew <- nc_create(filename, list(var_mod_chl))

# Add data to variable
# this only adds the last slice of the Chl variable. In theory we could save all
# time steps by adding an additional time dimension. This may be nice, but I
# don't think it's necessary now
ncvar_put(ncnew, var_mod_chl, chl[,,dim(chl)[3]])

# Close NC file
nc_close(ncnew)
