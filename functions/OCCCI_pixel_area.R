################################################################################
#
# PP spatial average
#
################################################################################

# Determine lon / lat distance
# determine km per pixel width
# m² of pixels
# add up all pixels
# multiply with the mean pixel width and divide by the total area

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

# Sum of Pixel
# g_pix_sum0 <- sum(rowSums(GPP, dims = 1, na.rm = T))
# g_pix_sum24 <- sum(rowSums(GPP24, dims = 1, na.rm = T))
# g_pix_sum7 <- sum(rowSums(GPP7, dims = 1, na.rm = T))
# 
# # List production for each scenario
# # GPP
# TPP <- as.numeric(c((g_pix_sum0*365)/1000, (g_pix_sum24*365)/1000, (g_pix_sum7*365)/1000))
# 
# g_pix_sum0 <- sum(rowSums(GPP, dims = 1, na.rm = T))
# g_pix_sum24 <- sum(rowSums(GPP24, dims = 1, na.rm = T))
# g_pix_sum7 <- sum(rowSums(GPP7, dims = 1, na.rm = T))
# 
# # List production for each scenario
# TPP <- as.numeric(c((g_pix_sum0*365)/1000, (g_pix_sum24*365)/1000, (g_pix_sum7*365)/1000))
