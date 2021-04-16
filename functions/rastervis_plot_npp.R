require(cmocean)
require(rasterVis)
require(maptools)
require(rgdal)
require(sp)
require(ncdf4)

# Import data from NC files as raster layer
filename1 = "./Results/P_model_result_offset2.nc"
filename2 = "./Results/P_model_result_offset1.4.nc"
filename3 = "./Results/P_model_result_offset0.2.nc"

# save NPP data for each offset as variable
netpp_mod1 = raster(filename1, varname = "model_netpp")
netpp_mod2 = raster(filename2, varname = "model_netpp")
netpp_mod3 = raster(filename3, varname = "model_netpp")

data = stack(netpp_mod1, netpp_mod2, netpp_mod3)

names(data) = c("Offset 2", "Offset 1.4", "Offset 0.2")

# Read shapefiles with basemap elements
# Data is available at https://www.naturalearthdata.com
rivers = rgdal::readOGR("./data/ne_10m_rivers_lake_centerlines/ne_10m_rivers_lake_centerlines.shp")
land =  rgdal::readOGR("./data/ne_10m_land/ne_10m_land.shp")
islands = rgdal::readOGR("./data/ne_10m_minor_islands/ne_10m_minor_islands.shp")
lakes = rgdal::readOGR("./data/ne_10m_lakes/ne_10m_lakes.shp")


# define colourbar
myTheme <- rasterTheme(region = cmocean('balance')(100))


png("./Figures/Mod_Pred_NPP.png",
    height = 1000, width = 1000, unit = "px", res = 150)

p = rasterVis::levelplot(data, 
                         zscaleLog = FALSE, # log scale of data
                         at = seq(-.5, 3, by = 0.2), # define range of colorbar
                         main = "Modelled Net Primary Production 2100", # title
                         colorkey = list(title = "[mgC/m2/d]"),# label on colorbar
                         par.settings = myTheme, # set my colorbar 
                         margin = FALSE, # don't plot strange histograms/medians along the axes
                         contour = FALSE, # don't show contour lines
                         ylab = "Latitude [Degree N]",
                         xlab = "Longitude [Degree E]",
                         scales=list(draw=TRUE)) # determine if x and y ticks and labels should be shown

# Add shapefiles to plot
p = p + layer(sp.polygons(land, fill = 'darkgray'))# +
# layer(sp.polygons(islands, fill='darkgray')) + 
# layer(sp.polygons(lakes, fill='white')) + 
# layer(sp.lines(rivers, lwd=1, col='blue'))+
# layer(sp.polygons(study_area, lwd=2, col='red'))

plot(p)

dev.off()