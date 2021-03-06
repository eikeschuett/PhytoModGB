################################################################################
#
# spatially integrated PP
#
################################################################################


sp_integ_netPP = function(GB, net_PPcarbon){
  require(geosphere)
  
  # Prepare raster to fill with pixel area
  pix_area = array(0,c(dim(GB$chl)[1],
                       dim(GB$chl)[2]))
  
  # Calculate pixel area for each latitude and fill it into the raster
  # Note that the OCCCI-Raster is flipped! 
  # Lat is in x-direction (decreasing)
  # Lon is in y-direction (increasing)
  for (i in 1:(dim(GB$chl)[2]-1)){
    # Create a polygon of the pixels at the current latitude
    p = rbind(c(GB$lon[1], GB$lat[i]), 
              c(GB$lon[2], GB$lat[i]), 
              c(GB$lon[2], GB$lat[i+1]),
              c(GB$lon[1], GB$lat[i+1]),
              c(GB$lon[1], GB$lat[i]))
    # calculate the area of the pixel [m^2]
    pix_area[,i] = geosphere::areaPolygon(p)
  }
  # Last column/row of lat has to be faked, because we don't have the coordinates
  # of the next row of latitudes. But the error is small...
  pix_area[,i+1] = pix_area[,i]
  
  # invalid pixels somehow have a value of -999 instead of NA (?)
  net_PPcarbon[net_PPcarbon==-999] = NA
  
  # Calculate the spatially integrated net primary production [gC d-1]
  sp_netPP = sum(pix_area*net_PPcarbon, na.rm=T)
  sp_netPP = sp_netPP*10**(-6) # conversion to [tC d-1]
  return(sp_netPP)
  }

