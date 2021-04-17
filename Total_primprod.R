################################################################################
###    Calculating the total (net) primary production + pixel area 
###    of German Bight
################################################################################

source("./functions/OCCCI_pixel_area.R")
source("./functions/read_nc_file.R")

# Calculation of total pixel area GB - sum of area of all pixels
total_area <- sum(rowSums(pix_area, dims = 1, na.rm = T))

filename1 = read_nc_file("./Results/P_model_result_offset_2.nc")
filename2 = read_nc_file("./Results/P_model_result_offset_1.4.nc")
filename3 = read_nc_file("./Results/P_model_result_offset_0.2.nc")

# Calculation of sum gross Primary Production in GB per scenario
totalPP0 <- sum(rowSums(filename1$grosspp, dims = 1, na.rm = T))
totalPP24 <- sum(rowSums(filename2$grosspp, dims = 1, na.rm = T))
totalPP7 <- sum(rowSums(filename3$grosspp, dims = 1, na.rm = T))

# storing total PP per scenario in gramm per year in array
TPP_annual_gr <- as.numeric(
  c((totalPP0*365)/1000, (totalPP24*365)/1000, (totalPP7*365)/1000))

# same procedure as every year, or more: above for net pp
totalNPP0 <- sum(rowSums(filename1$netpp, dims = 1, na.rm = T))
totalNPP24 <- sum(rowSums(filename2$netpp, dims = 1, na.rm = T))
totalNPP7 <- sum(rowSums(filename3$netpp, dims = 1, na.rm = T))
NPP_annual_gr <- as.numeric(
  c((totalNPP0*365)/1000, (totalNPP24*365)/1000, (totalNPP7*365)/1000))
