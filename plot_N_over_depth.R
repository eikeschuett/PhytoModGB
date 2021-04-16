
require(cmocean)

params = list(N_0 = 20, # Nutrient concentration at shore. Here for P [mmol m^-3]. Markus: Between 15-30 in Winter. In Summer between 1-5 in coastal zones. Offshore towards 0
              H_0 = 2) # half saturation depth of nutrients [m]

offsets = c(2,1.4,0.2)

h = seq(1,70)

# define colorbar as proposed by colorbrewer2.org (colorblind friendly!)
colors = c("#1b9e77", "#7570b3", "#d95f02") 

png("./Figures/N_over_depth.png", 
    width = 800, height = 500, unit = "px", res=115)

i = 1

for (offset in offsets){
  N_h = (params$N_0-offset)*(params$H_0/(params$H_0+h))+offset

  print(N_h[70])
  if (offset == offsets[1]){
    plot(h, N_h, type='l', col = colors[i],
         ylim = c(0,15), lwd = 2,
         xlab = "depth [m]", 
         ylab = "")
    # manually set y label to prevent cut off of superscript
    ylab.text = bquote('nutrient concentration [mmol   ' ~m^-3 ~ ']')
    mtext(ylab.text,side = 2, line = 2.5)
  }
           #expression(nutrient concentration [mmol m^{-3} ])))}
  else{
    
    
    lines(h, N_h, lwd = 2, col = colors[i])
  } 
  i = i+1
}

legend(x = "topright",
       title = "scenario",
       title.adj = 0.5,
       legend = c("baseline (2)", "RCP8.5 mean (1.4)", "RCP8.5 extreme (0.2)"),
       col = colors,
       lwd = 2)

dev.off()
