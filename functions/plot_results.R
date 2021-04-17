require(cmocean)
require(rasterVis)
require(maptools)
require(rgdal)
require(sp)
require(ncdf4)

plot_pp = function(filenames, titles, varname, main){
  
  # save NPP data for each offset as variable
  netpp_mod1 = raster(filenames[1], varname = varname)
  netpp_mod2 = raster(filenames[2], varname = varname)
  netpp_mod3 = raster(filenames[3], varname = varname)
  
  data = stack(netpp_mod1, netpp_mod2, netpp_mod3)
  
  names(data) = titles

  # define colourbar
  myTheme <- rasterTheme(region = cmocean('haline')(100))
  
  
  filename = paste0("./Figures/Mod_Pred_", varname, ".png")
  cbar_range = seq(-.5, 3, by = 0.2)
  
  rastervis_plot(filename = filename,
                 data = data,
                 cbar_range = cbar_range,
                 myTheme = myTheme,
                 main = main)
}


plot_pp_change = function(filenames, titles, varname, main){
  
  # save NPP data for each offset as variable
  netpp_mod1 = raster(filenames[1], varname = varname)
  netpp_mod2 = raster(filenames[2], varname = varname)
  netpp_mod3 = raster(filenames[3], varname = varname)
  
  chg_mod2 = netpp_mod2 - netpp_mod1
  
  chg_mod3 = netpp_mod3 - netpp_mod1
  
  data = stack(chg_mod2, chg_mod3)
  
  names(data) = titles

  # define colourbar
  myTheme <- rasterTheme(region = cmocean('balance')(100))
  
  filename = paste0("./Figures/Mod_Pred_", varname, "_change.png")
  cbar_range = seq(-0.5, 0.5, by = 0.05)
  
  rastervis_plot(filename = filename,
                 data = data,
                 cbar_range = cbar_range,
                 myTheme = myTheme,
                 main = main)
}


rastervis_plot = function(filename, data, cbar_range, myTheme, main){
  
  # Read shapefiles with basemap elements
  # Data is available at https://www.naturalearthdata.com
  #rivers = rgdal::readOGR("./data/ne_10m_rivers_lake_centerlines/ne_10m_rivers_lake_centerlines.shp")
  land =  rgdal::readOGR("./data/ne_10m_land/ne_10m_land.shp")
  #islands = rgdal::readOGR("./data/ne_10m_minor_islands/ne_10m_minor_islands.shp")
  #lakes = rgdal::readOGR("./data/ne_10m_lakes/ne_10m_lakes.shp")
  
  png(filename, height = 400, width = 1000, unit = "px", res = 150)
  
  p = rasterVis::levelplot(data, 
                           zscaleLog = FALSE, # log scale of data
                           at = cbar_range, # define range of colorbar
                           main = main, # title
                           colorkey = list(title = expression("gC m"^-2*"d"^-1)), # label on colorbar
                           par.settings = myTheme, # set my colorbar 
                           margin = FALSE, # don't plot strange histograms/medians along the axes
                           contour = FALSE, # don't show contour lines
                           ylab = "", #ylab = "Latitude [° N]",
                           xlab = "", #xlab = "Longitude [° E]",
                           scales=list(draw=FALSE), # determine if x and y ticks and labels should be shown
                           layout = c(dim(data)[3], 1, 1)) # 3 plots in a column
  
  
  
  # Add shapefiles to plot
  p = p + layer(sp.polygons(land, fill = 'darkgray'), data = list(land=land))# +
  # layer(sp.polygons(islands, fill='darkgray')) + 
  # layer(sp.polygons(lakes, fill='white')) + 
  # layer(sp.lines(rivers, lwd=1, col='blue'))+
  # layer(sp.polygons(study_area, lwd=2, col='red'))
  
  plot(p)
  
  dev.off()
}
  
  