

require(ncdf4)

# From here:
# https://stackoverflow.com/questions/28949971/writing-data-to-a-netcdf-file-with-r
# in the first example a time dimension is also included

# specify filename
filename="../Project/test_nc.nc"

# get dimensions of lat and lon
nlat = length(GB$lat)
nlon = length(GB$lon)

# assign lat and lon dimensions and data
lon1 <- ncdim_def("longitude", "degrees_east", GB$lon)
lat2 <- ncdim_def("latitude", "degrees_north", GB$lat)

# Specify value for missing data
mv <- -999

# Create a new variable
var_netpp <- ncvar_def("net_PP", # name of variable
                       "weird unit", # unit
                       list(lon1, lat2), # dimensions
                       longname="Average mean primary production and so on and so on", 
                       mv) # missing value

var_bathy <- ncvar_def("bathy", # name of variable
                       "m", # unit
                       list(lon1, lat2), # dimensions
                       longname="Depth", 
                       mv) # missing value

# Create NC file
ncnew <- nc_create(filename, list(var_netpp, var_bathy))

# Add data to variable
ncvar_put(ncnew, var_netpp, net_prod_avg)

ncvar_put(ncnew, var_bathy, GB$bathy)

# Close NC file
nc_close(ncnew)
