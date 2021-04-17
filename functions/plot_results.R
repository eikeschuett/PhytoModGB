require(cmocean)
require(rasterVis)
require(maptools)
require(rgdal)
require(sp)
require(ncdf4)
require(ggplot2)

plot_pp = function(filenames, titles, varname, main){
  
  # read PP data for each offset
  netpp_mod1 = raster(filenames[1], varname = varname)
  netpp_mod2 = raster(filenames[2], varname = varname)
  netpp_mod3 = raster(filenames[3], varname = varname)
  
  # stack them in a raster stack
  data = stack(netpp_mod1, netpp_mod2, netpp_mod3)
  
  # assign names to each variable in the stack
  names(data) = titles

  # define colourmap
  myTheme <- rasterTheme(region = cmocean('balance')(100))
  
  
  filename = paste0("./Figures/Mod_Pred_", varname, ".png")
  
  # define colormap range
  cbar_range = seq(-1, 1, by = 0.05)
  
  # Produce and save the plot
  rastervis_plot(filename = filename,
                 data = data,
                 cbar_range = cbar_range,
                 myTheme = myTheme,
                 main = main,
                 colorkey = list(title = expression("     [gC m"^-2*"d"^-1*"]")))
}


plot_pp_change = function(filenames, titles, varname, main){
  
  netpp_mod1 = raster(filenames[1], varname = varname)
  netpp_mod2 = raster(filenames[2], varname = varname)
  netpp_mod3 = raster(filenames[3], varname = varname)
  
  chg_mod2 = netpp_mod2 - netpp_mod1
  chg_mod3 = netpp_mod3 - netpp_mod1
  
  data = stack(chg_mod2, chg_mod3)
  
  names(data) = titles

  myTheme <- rasterTheme(region = cmocean('balance')(100))
  
  filename = paste0("./Figures/Mod_Pred_", varname, "_change.png")
  cbar_range = seq(-0.5, 0.5, by = 0.05)
  
  rastervis_plot(filename = filename,
                 data = data,
                 cbar_range = cbar_range,
                 myTheme = myTheme,
                 main = main,
                 colorkey = list(title = expression("[gC m"^-2*"d"^-1*"]")))
}




plot_model_chl = function(filename, main){
  
  # read data from the nc file
  model_chl = raster(filename, varname = "model_chl")
  occci_chl = raster(filename, varname = "occci_chl")

  data = stack(occci_chl, model_chl)
  
  names(data) = c("Ground truth", "Model")
  
  # define colourbar
  myTheme <- rasterTheme(region = cmocean('haline')(100))
  
  filename = paste0("./Figures/Model_chl_pred.png")
  
  # The plot will be in log scale but with "normal" tick labels at the colorbar
  ticks_wanted = c(0.25, 0.5, 1, 2, 5, 10, 15, 20)
  log_ticks = log10(ticks_wanted)
  
  # define range of colorbar
  cbar_range = seq(log_ticks[1], log_ticks[length(log_ticks)], 0.2)
  
  # define properties of the colormap
  colorkey=list(at = seq(log_ticks[1], log_ticks[length(log_ticks)], 0.2), 
                labels = list(at = log_ticks, 
                              labels = as.character(ticks_wanted)),
                title = expression("   Chl [mg m"^-3*"]"))
  
  rastervis_plot(filename = filename,
                 data = data,
                 cbar_range = cbar_range,
                 myTheme = myTheme,
                 main = main,
                 colorkey = colorkey,
                 log = 10) # loc10 transormation of data
}



plot_chl_diff = function(filename, main){
  
  # read data from the nc file
  model_chl = raster(filename, varname = "model_chl")
  occci_chl = raster(filename, varname = "occci_chl")
  
  data = model_chl-occci_chl
  
  # define colourbar
  myTheme <- rasterTheme(region = cmocean('balance')(100))
  
  filename = "./Figures/Model_chl_pred_diff.png"
  
  # define range of colorbar
  cbar_range = seq(-10, 10, 0.2)
  
  # define properties of the colormap
  colorkey=list(title = expression("   Chl [mg m"^-3*"]"))
  
  rastervis_plot(filename = filename,
                 data = data,
                 cbar_range = cbar_range,
                 myTheme = myTheme,
                 main = main,
                 colorkey = colorkey,
                 log = FALSE) # loc10 transormation of data
}

################################################################################
#
# Real plotting function
#
################################################################################

rastervis_plot = function(filename, 
                          data, 
                          cbar_range, 
                          myTheme, 
                          main, 
                          colorkey,
                          log=FALSE){
  
  # Read shapefiles with basemap elements
  # Data is available at https://www.naturalearthdata.com
  #rivers = rgdal::readOGR("./data/ne_10m_rivers_lake_centerlines/ne_10m_rivers_lake_centerlines.shp")
  land =  rgdal::readOGR("./data/ne_10m_land/ne_10m_land.shp")
  #islands = rgdal::readOGR("./data/ne_10m_minor_islands/ne_10m_minor_islands.shp")
  lakes = rgdal::readOGR("./data/ne_10m_lakes/ne_10m_lakes.shp")
  
  png(filename, height = 400, width = 1000, unit = "px", res = 150)
  

  
  p = rasterVis::levelplot(data, 
                           zscaleLog = log, # log scale of data
                           at = cbar_range, # define color range
                           main = main, # title
                           colorkey = colorkey,# properties of the colorbar
                           par.settings = myTheme, # set my colorbar 
                           margin = FALSE, # don't plot strange histograms/medians along the axes
                           contour = FALSE, # don't show contour lines
                           ylab = "", #ylab = "Latitude [° N]",
                           xlab = "", #xlab = "Longitude [° E]",
                           scales=list(draw=FALSE), # determine if x and y ticks and labels should be shown
                           layout = c(dim(data)[3], 1, 1)) # 3 plots in a column
  
  
  
  # Add shapefiles to plot
  p = p + latticeExtra::layer(sp.polygons(land, fill = 'darkgray'), 
                              data = list(land=land)) +
  # layer(sp.polygons(islands, fill='darkgray')) + 
          latticeExtra::layer(sp.polygons(lakes, fill='white'), 
                              data = list(lakes=lakes))# + 
  # layer(sp.lines(rivers, lwd=1, col='blue'))+
  # layer(sp.polygons(study_area, lwd=2, col='red'))
  
  plot(p)
  
  dev.off()
}




barplot_netPP_GB = function(scen_titles, sp_netPP){
  data = data.frame(name = factor(scen_titles, levels = scen_titles),
                    value = sp_netPP)
  
  filename = "./Figures/Barplot_netPP_GB.png"
  
  ggplot(data, aes(x=name, y=value, fill=name)) + 
    geom_bar(stat = "identity")+
    xlab("")+
    ylab(expression("tC m"^-2*"d"^-1))+
    ggtitle("Projected total net primary production in the German Bight in 2100")+
    geom_text(aes(label=round(value)), vjust=1.6, color="white", size=3.5)+
    # define colorbar as proposed by colorbrewer2.org (colorblind friendly!)
    # and in the same ordering as in "N over depth"-plot
    scale_fill_manual(values = c("#1b9e77", "#7570b3", "#d95f02"))+ 
    #scale_fill_brewer(palette="Dark2")+
    theme_minimal()+
    theme(legend.position="none")
  
  ggsave(filename, width = 6.2, height = 5.75, unit='in') 
  
  }
  
  



