
require(cmocean)
require(rasterVis)
require(maptools)
require(rgdal)
require(sp)
require(ncdf4)



# Import data from NC file as raster layer
filename = paste0("./Results/P_model_result_offset", params$offset, ".nc")

chl_mod = raster(filename, varname = "model_chl")

chl_netpp = raster(filename, varname = "model_netpp")

chl_grosspp = raster(filename, varname = "model_grosspp")

data = stack(chl_mod, chl_netpp, chl_grosspp)

names(data) = c("Model Result Chl", "Net PrimProd", "Gross PrimProd")



# Read shapefiles with basemap elements
# Data is available at https://www.naturalearthdata.com
rivers = rgdal::readOGR("./data/ne_10m_rivers_lake_centerlines/ne_10m_rivers_lake_centerlines.shp")
land =  rgdal::readOGR("./data/ne_10m_land/ne_10m_land.shp")
islands = rgdal::readOGR("./data/ne_10m_minor_islands/ne_10m_minor_islands.shp")
lakes = rgdal::readOGR("./data/ne_10m_lakes/ne_10m_lakes.shp")


# define colourbar
myTheme <- rasterTheme(region = cmocean('haline')(100))


png(paste0("./Figures/Mod_Pred_Chl_PP_", params$offset, ".png"),
           height = 1000, width = 1000, unit = "px", res = 150)

p = rasterVis::levelplot(data, 
                         zscaleLog = FALSE, # log scale of data
                         at = seq(0, 20, by = 1), # define range of colorbar
                         # main = "German Bight Bathymetry", # title
                         colorkey = list(title = "Chl [mg m-3]\n"),# label on colorbar
                         par.settings = myTheme, # set my colorbar 
                         margin = FALSE, # don't plot strange histograms/medians along the axes
                         contour = FALSE, # don't show contour lines
                         ylab = "Latitude [° N]",
                         xlab = "Longitude [° E]",
                         scales = list(draw = TRUE)) # determine if x and y ticks and labels should be shown

# Add shapefiles to plot
p = p + layer(sp.polygons(land, fill = 'darkgray'))# +
  # layer(sp.polygons(islands, fill='darkgray')) + 
  # layer(sp.polygons(lakes, fill='white')) + 
  # layer(sp.lines(rivers, lwd=1, col='blue'))+
  # layer(sp.polygons(study_area, lwd=2, col='red'))

plot(p)

dev.off()