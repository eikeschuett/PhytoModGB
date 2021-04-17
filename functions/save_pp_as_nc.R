
require(ncdf4)

# From here:
# https://stackoverflow.com/questions/28949971/writing-data-to-a-netcdf-file-with-r
# in the first example a time dimension is also included


save_nc_file = function(filename, npp, gpp){
  # specify filename
  #filename = paste0("./Results/P_model_result_offset_", params$offset, ".nc")
  
  # get dimensions of lat and lon
  nlat = length(GB$lat)
  nlon = length(GB$lon)
  
  # assign lat and lon dimensions and data
  lon1 <- ncdim_def("longitude", "degrees_east", GB$lon)
  lat2 <- ncdim_def("latitude", "degrees_north", GB$lat)
  
  # Specify value for missing data
  mv <- -999
  
  # Create a new variable
  var_mod_netpp <- ncvar_def("netpp", # name of variable
                           "[gC m-2 d-1]", # unit
                           list(lon1, lat2), # dimensions
                           longname = paste("Net primary production for 2100", 
                                            params$offset),
                           mv) # missing value
  
  var_mod_grosspp <- ncvar_def("grosspp", # name of variable
                           "[gC m-2 d-1]", # unit
                           list(lon1, lat2), # dimensions
                           longname = paste("Gross primary production for 2100", 
                                            params$offset),
                           mv) # missing value
  
  # Create NC file
  ncnew <- nc_create(filename, list(var_mod_netpp, var_mod_grosspp))
  
  # Add data to variable
  # this only adds the last slice of the Chl variable. In theory we could save all
  # time steps by adding an additional time dimension. This may be nice, but I
  # don't think it's necessary now
  ncvar_put(ncnew, var_mod_netpp, net_PPcarbon)
  ncvar_put(ncnew, var_mod_grosspp, gross_PPcarbon)
  # Close NC file
  nc_close(ncnew)
}