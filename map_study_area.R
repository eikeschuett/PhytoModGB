
setwd("H:/Eigene Dateien/Studium/9. Semester/Ecosystem_Modeling/Project/PhytoModGB")



require(cmocean)
require(rasterVis)
require(maptools)
require(rgdal)
require(sp)
require(ncdf4)

# Import data from NC file as raster layer
filename = "../Data/esacci_depth.nc"
data = raster(filename, varname = "DEPTH")
# replace all very large values by 70 to fit them into our colorbar range
data[data>70] = 70

# Read shapefiles with basemap elements
# Data is available at https://www.naturalearthdata.com
rivers = rgdal::readOGR("../Data/ne_10m_rivers_lake_centerlines/ne_10m_rivers_lake_centerlines.shp")
land =  rgdal::readOGR("../Data/ne_10m_land/ne_10m_land.shp")
islands = rgdal::readOGR("../Data/ne_10m_minor_islands/ne_10m_minor_islands.shp")
lakes = rgdal::readOGR("../Data/ne_10m_lakes/ne_10m_lakes.shp")

# Import shapefile of our study area
study_area = rgdal::readOGR("../Data/Study_Area/study_area_GB.shp")


# define colourbar
myTheme <- rasterTheme(region=cmocean('deep')(100))


png("./Figures/Fig1_Study_Area.png", height= 1000, width = 1000, unit="px", res=150)

# Some examples on using Rastervis are here:
# https://oscarperpinan.github.io/rastervis/
# We will use the levelplot command

p = rasterVis::levelplot(data, 
                        zscaleLog=FALSE, # log scale of data
                        at=seq(0, 70, by=1), # define range of colorbar
                        # main = "German Bight Bathymetry", # title
                        colorkey = list(title = "Depth [m]\n"),# label on colorbar
                        par.settings = myTheme, # set my colorbar 
                        margin = FALSE, # don't plot strange histograms/medians along the axes
                        contour=FALSE, # don't show contour lines
                        ylab = "Latitude [° N]",
                        xlab = "Longitude [° E]",
                        scales=list(draw=TRUE)) # determine if x and y ticks and labels should be shown


# Add shapefiles to plot
p = p + layer(sp.polygons(land, fill='darkgray')) +
    layer(sp.polygons(islands, fill='darkgray')) + 
    layer(sp.polygons(lakes, fill='white')) + 
    layer(sp.lines(rivers, lwd=1, col='blue'))+
    layer(sp.polygons(study_area, lwd=2, col='red'))


plot(p)
dev.off()


