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

# save GPP data for each offset as variable
gpp_mod1 = raster(filename1, varname = "model_grosspp")
gpp_mod2 = raster(filename2, varname = "model_grosspp")
gpp_mod3 = raster(filename3, varname = "model_grosspp")

diff1 = gpp_mod1 - gpp_mod2
diff2 = gpp_mod1 - gpp_mod3
diff3 = gpp_mod2 - gpp_mod3

data1 = stack(diff1, diff2, diff3)

names(data1) = c("Diff_2-1.4", "Diff_2-0.2", "Diff_1.4-0.2")

# save NPP data for each offset as variable
netpp_mod1 = raster(filename1, varname = "model_netpp")
netpp_mod2 = raster(filename2, varname = "model_netpp")
netpp_mod3 = raster(filename3, varname = "model_netpp")

diffnpp1 = netpp_mod1 - netpp_mod2
diffnpp2 = netpp_mod1 - netpp_mod3
diffnpp3 = netpp_mod2 - netpp_mod3

data2 = stack(diffnpp1, diffnpp2, diffnpp3)

names(data2) = c("Diff_2-1.4", "Diff_2-0.2", "Diff_1.4-0.2")

# Read shapefiles with basemap elements
# Data is available at https://www.naturalearthdata.com
rivers = rgdal::readOGR("./data/ne_10m_rivers_lake_centerlines/ne_10m_rivers_lake_centerlines.shp")
land =  rgdal::readOGR("./data/ne_10m_land/ne_10m_land.shp")
islands = rgdal::readOGR("./data/ne_10m_minor_islands/ne_10m_minor_islands.shp")
lakes = rgdal::readOGR("./data/ne_10m_lakes/ne_10m_lakes.shp")

# define colourbar
myTheme <- rasterTheme(region = cmocean('balance')(100))


png(paste0("./Figures/DifferencePlots_NPP.png"),
    height = 1000, width = 1000, unit = "px", res = 150)


p = rasterVis::levelplot(data2, 
                         zscaleLog = FALSE, # log scale of data
                         at = seq(0, 2, by = 0.05), # define range of colorbar
                         main = "Absolute Differences Modelled NPP 2100", # title
                         colorkey = list(title = "[mgC/m2/d]"),# label on colorbar
                         par.settings = myTheme, # set my colorbar 
                         margin = FALSE, # don't plot strange histograms/medians along the axes
                         contour = FALSE, # don't show contour lines
                         ylab = "Latitude [Degree N]",
                         xlab = "Longitude [Degree E]",
                         scales = list(draw = TRUE)) # determine if x and y ticks and labels should be shown

# Add shapefiles to plot
p = p + layer(sp.polygons(land, fill = 'darkgray'))
plot(p)
dev.off()

png(paste0("./Figures/DifferencePlots_GPP.png"),
    height = 1000, width = 1000, unit = "px", res = 150) 
p2 = rasterVis::levelplot(data1, 
                         zscaleLog = FALSE, # log scale of data
                         at = seq(0, 2, by = 0.05), # define range of colorbar
                         main = "Absolute Differences Modelled GPP 2100", # title
                         colorkey = list(title = "[mgC/m2/d]"),# label on colorbar
                         par.settings = myTheme, # set my colorbar 
                         margin = FALSE, # don't plot strange histograms/medians along the axes
                         contour = FALSE, # don't show contour lines
                         ylab = "Latitude [Degree N]",
                         xlab = "Longitude [Degree E]",
                         scales = list(draw = TRUE))
p2 = p2 + layer(sp.polygons(land, fill = 'darkgray'))
plot(p2)

dev.off()