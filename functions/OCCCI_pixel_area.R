
require(geosphere)

# Prepare raster to fill with pixel area
pix_area = array(0,c(dim(GB$chl)[1],
                     dim(GB$chl)[2]))

# Calculate pixel area for each latitude and fill it into the raster
# Note that the OCCCI-Raster is flipped! 
# Lat is in x-direction (decreasing)
# Lon is in y-direction (increasing)
for (i in seq(1:dim(GB$chl)[2])){
  p = rbind(c(GB$lon[1], GB$lat[i]), 
            c(GB$lon[2], GB$lat[i]), 
            c(GB$lon[2], GB$lat[i+1]),
            c(GB$lon[1], GB$lat[i+1]),
            c(GB$lon[1], GB$lat[i]))
  pix_area[,i] = geosphere::areaPolygon(p)
}