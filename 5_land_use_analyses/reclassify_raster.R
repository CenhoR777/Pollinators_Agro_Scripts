# load the raster and rgdal libraries
library(raster)
library(rgdal)

#open raster
lu_raster<-raster("/home/saraema/MEOCloud/10_Niche_Modelling/SDM_analyses/landuse_vars_100m/clip_g100_clc12_V18_5_correctedCRS.tif")
plot(lu_raster)

lu_raster_reclassified<-reclassify(lu_raster, c(0,11,11, 11,22,22, 22,25,25, 25,29,29, 29,34,34, 34,36,36, 36,39,39, 39,41,36, 41,44,39, 48,255,255)) #from classes 1 to 11, convert to 1, etc
plot(lu_raster_reclassified)

writeRaster(lu_raster_reclassified,paste("/home/saraema/MEOCloud/10_Niche_Modelling/SDM_analyses/landuse_vars_100m/clip_g100_clc12_V18_5_correctedCRS_reclassified.tif"),format="GTiff", overwrite=TRUE)

