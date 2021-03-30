


# Subset to German Bight
min_lat = 52.2
max_lat = 56.8
min_lon = 4.2
max_lon = 9.0

ilat = which(GB$lat>min_lat & GB$lat<max_lat)
ilon = which(GB$lon>min_lon & GB$lon<max_lon)

GB = list(bathy = depth[ilon, ilat],
          chl = GB$chlor_a[ilon,ilat,],
          kd_490 = GB$kd_490[ilon,ilat,],
          secchi = 1/GB$kd_490[ilon,ilat,],
          lat = GB$lat[ilat],
          lon = GB$lon[ilon],
          time = as.Date(GB$time, origin="1970-01-01"))

yr = format(GB$time[1], '%Y')
d_str = as.Date(paste0(yr, '-01-01'))
GB$jd = julian(GB$time, origin=d_str)%%365