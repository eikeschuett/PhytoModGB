
#
# This function reads all variables, lat, lon and time data from an nc-file.
# It returns the data in a list.
#

require(ncdf4)

read_nc_file = function(filename){
  # open dataset
  ds = nc_open(filename)
  
  # Create empty vector of characters to store the variable names
  ds_varnames = character(ds$nvars)
  # get each variable name
  for (i in 1: ds$nvars) {
    ds_varnames[i] = ds$var[[i]]$name
  }
  
  # Create a list to store the data
  ds_varlist = vector('list', ds$nvars)
  # assign variable names to each list
  names(ds_varlist) = ds_varnames
  
  # get the data of each variable
  for (i in 1:ds$nvars){
    ds_varlist[[i]] = ncvar_get(ds, ds_varnames[i], verbose=F)
  }  
  
  # Add Lat, Lon and time
  ds_varlist$lat = ds$dim$lat$vals
  ds_varlist$lon = ds$dim$lon$vals
  ds_varlist$time = as.Date(ds$dim$time$vals, origin="1970-01-01")

  # Close the nc file
  nc_close(ds)
  
  # return the data
  return(ds_varlist)
}  
