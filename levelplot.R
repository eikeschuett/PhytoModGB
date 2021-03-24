
setwd("H:/Eigene Dateien/Studium/9. Semester/Ecosystem_Modeling/Project")

# Some examples are here:
# https://oscarperpinan.github.io/rastervis/

require(cmocean)
require(rasterVis)
require(maptools)
require(rgdal)
require(sp)
require(ncdf4)

# Import data from NC file as raster layer
filename = "test_nc.nc"
data = raster(filename, varname = "bathy")

# Read shapefile with coastline of the german bight
rivers = rgdal::readOGR("../Data/ne_10m_rivers_lake_centerlines/ne_10m_rivers_lake_centerlines.shp")
land =  rgdal::readOGR("../Data/ne_10m_land/ne_10m_land.shp")
islands = rgdal::readOGR("../Data/ne_10m_minor_islands/ne_10m_minor_islands.shp")
proj4string(land) <- CRS("+init=epsg:4326")

# define colourbar
myTheme <- rasterTheme(region=cmocean('deep')(100))


png("test_map.png", height= 500, width = 500, unit="px")
# levelplot!
p = rasterVis::levelplot(data, 
                        zscaleLog=FALSE, # log scale of data
                        at=seq(0, 70, by=1), # define range of colorbar
                        main = "German Bight Bathymetry", # title
                        colorkey = list(title = "[m]"),# label on colorbar
                        par.settings = myTheme, # set my colorbar 
                        margin = FALSE, # don't plot strange histograms/medians along the axes
                        contour=FALSE) # don't show contour lines


# Add coastline to plot
p = p + layer(sp.polygons(land, fill='darkgray')) +
    layer(sp.polygons(islands, fill='darkgray')) + 
    layer(sp.lines(rivers, lwd=1, col='blue'))


plot(p)
dev.off()


