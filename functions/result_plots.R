################################################################################
#
# Plotting of results 
#
################################################################################
source("./model_predict_2100_scenarios.R")

NPP <- net_PPcarbon * GB$bathy
NPP24 <- net_PPcarbon24 * GB$bathy
NPP7 <- net_PPcarbon7 * GB$bathy

png("./Figures/scenarios_NPP.png", 
    width = 800, height = 500, unit = "px", res=115)

par(mfrow = c(1,3), mar = c(5.5,2.5,5.5,2.5))

image2D(x = GB$lon, y = GB$lat, z = NPP,
        ylim = range(GB$lat),
        xlim = range(GB$lon),
        zlim = c(-60, 40),
        cex = 4,
        axes = F,
        main = "NPP vert. integrated; No Offset",
        xlab = "Longitude [° East]",
        ylab = "Latitude [° North]",
        #clab = "[mgC/m²/d]",
        frame.plot = T,
        pch = ".",
        col = cmocean('balance')(100))


image2D(x = GB$lon, y = GB$lat, z = NPP24,
        ylim = range(GB$lat),
        xlim = range(GB$lon),
        zlim = c(-60, 40),
        cex = 4,
        axes = F,
        main = "NPP vert. integrated; Offset: -0.24",
        xlab = "Longitude [° East]",
        ylab = "Latitude [° North]",
        #clab = "[mgC/m²/d]",
        frame.plot = T,
        pch = ".",
        col = cmocean('balance')(100))


image2D(x = GB$lon, y = GB$lat, z = NPP7,
        ylim = range(GB$lat),
        xlim = range(GB$lon),
        zlim = c(-60, 40),
        cex = 4,
        axes = F,
        main = "NPP vert. integrated; Offset: -0.7",
        xlab = "Longitude [° East]",
        ylab = "Latitude [° North]",
        #clab = "[mgC/m²/d]",
        frame.plot = T,
        pch = ".",
        col = cmocean('balance')(100))

dev.off()

################################################################################
# plot GPP
GPP <- gross_PPcarbon * GB$bathy
GPP24 <- gross_PPcarbon24 * GB$bathy
GPP7 <- gross_PPcarbon7 * GB$bathy

png("./Figures/scenarios_GPP.png", 
    width = 800, height = 500, unit = "px", res=115)

par(mfrow = c(1,3), mar = c(5.5,2.5,5.5,2.5))

image2D(x = GB$lon, y = GB$lat, z = GPP,
        ylim = range(GB$lat),
        xlim = range(GB$lon),
        zlim = c(0, 100),
        cex = 4,
        axes = F,
        main = "GPP vert. integrated; No Offset",
        xlab = "Longitude [° East]",
        ylab = "Latitude [° North]",
        #clab = "[mgC/m²/d]",
        frame.plot = T,
        pch = ".",
        col = cmocean('balance')(100))


image2D(x = GB$lon, y = GB$lat, z = GPP24,
        ylim = range(GB$lat),
        xlim = range(GB$lon),
        zlim = c(0, 100),
        cex = 4,
        axes = F,
        main = "GPP vert. integrated; Offset: 0.24",
        xlab = "Longitude [° East]",
        ylab = "Latitude [° North]",
        #clab = "[mgC/m²/d]",
        frame.plot = T,
        pch = ".",
        col = cmocean('balance')(100))


image2D(x = GB$lon, y = GB$lat, z = GPP7,
        ylim = range(GB$lat),
        xlim = range(GB$lon),
        zlim = c(0, 100),
        cex = 4,
        axes = F,
        main = "GPP vert. integrated; Offset: 0.7",
        xlab = "Longitude [° East]",
        ylab = "Latitude [° North]",
        #clab = "[mgC/m²/d]",
        frame.plot = T,
        pch = ".",
        col = cmocean('balance')(100))
dev.off()