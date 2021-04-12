################################################################################
#
# Difference plot PP
#
################################################################################
source("./model_predict_2100_scenarios.R")

# GPP
differences5_2.5 <- GPP - GPP24
differences5_0.9 <- GPP - GPP7
differences2.5_0.9 <- GPP24 - GPP7

diff_5_2.5 <- (differences5_2.5 / GPP ) *100
diff_5_0.9 <- (differences5_0.9 / GPP ) *100
diff_2.5_0.9 <- (differences2.5_0.9 / GPP24 ) *100

# Difference Plot
png("./Figures/difference_GPP.png", 
    width = 800, height = 500, unit = "px", res=115)

par(mfrow = c(1,3), mar = c(5.5,2.5,5.5,2.5))

image2D(x = GB$lon, y = GB$lat, z = diff_5_2.5,
        ylim = range(GB$lat),
        xlim = range(GB$lon),
        zlim = c(0, 60),
        cex = 4,
        main = "Difference 5 - 2.5",
        xlab = "Longitude [Degree East]",
        ylab = "Latitude [Degree North]",
        frame.plot = T,
        pch = ".",
        col = cmocean("haline")(100))

image2D(x = GB$lon, y = GB$lat, z = diff_2.5_0.9,
        ylim = range(GB$lat),
        xlim = range(GB$lon),
        zlim = c(0, 60),
        cex = 4,
        main = "Difference 2.5 - 0.9",
        xlab = "Longitude [Degree East]",
        ylab = "Latitude [Degree North]",
        frame.plot = T,
        pch = ".",
        col = cmocean("haline")(100))

image2D(x = GB$lon, y = GB$lat, z = diff_5_0.9,
        ylim = range(GB$lat),
        xlim = range(GB$lon),
        zlim = c(0,60),
        cex = 4,
        main = "Difference 5 - 0.9",
        xlab = "Longitude [Degree East]",
        ylab = "Latitude [Degree North]",
        frame.plot = T,
        pch = ".",
        col = cmocean("haline")(100))
dev.off()

################################################################################
# NPP

n_differences5_2.5 <- NPP - NPP24
n_differences5_0.9 <- NPP - NPP7
n_differences2.5_0.9 <- NPP24 - NPP7

n_diff_5_2.5 <- (differences5_2.5 / NPP ) *100
n_diff_5_0.9 <- (differences5_0.9 / NPP ) *100
n_diff_2.5_0.9 <- (differences2.5_0.9 / NPP24 ) *100

# Difference Plot

png("./Figures/difference_NPP.png", 
    width = 800, height = 500, unit = "px", res=115)

par(mfrow = c(1,3), mar = c(5.5,2.5,5.5,2.5))

image2D(x = GB$lon, y = GB$lat, z = n_diff_5_2.5,
        ylim = range(GB$lat),
        xlim = range(GB$lon),
        zlim = c(-600, 600),
        cex = 4,
        main = "Difference 5 - 2.5",
        xlab = "Longitude [Degree East]",
        ylab = "Latitude [Degree North]",
        frame.plot = T,
        pch = ".",
        col = cmocean("balance")(100))

image2D(x = GB$lon, y = GB$lat, z = n_diff_2.5_0.9,
        ylim = range(GB$lat),
        xlim = range(GB$lon),
        zlim = c(-600, 600),
        cex = 4,
        main = "Difference 2.5 - 0.9",
        xlab = "Longitude [Degree East]",
        ylab = "Latitude [Degree North]",
        frame.plot = T,
        pch = ".",
        col = cmocean("balance")(100))

image2D(x = GB$lon, y = GB$lat, z = n_diff_5_0.9,
        ylim = range(GB$lat),
        xlim = range(GB$lon),
        zlim = c(-600,600),
        cex = 4,
        main = "Difference 5 - 0.9",
        xlab = "Longitude [Degree East]",
        ylab = "Latitude [Degree North]",
        frame.plot = T,
        pch = ".",
        col = cmocean("balance")(100))
dev.off()