require(terra)
#require(raster)
require(landscapemetrics)

list = list.files('/mnt/data2/Project_Polli_agro/Operational/4_data_analysis/7_seldetection/rasters/sentinel_land_use_rasters', full.names = T)

r1 = rast(list[1])
r2 = rast(list[2])
  
rasters = sprc(r1, r2)

mosaic(rasters, filename = '/mnt/data2/Project_Polli_agro/Operational/4_data_analysis/7_seldetection/rasters/sentinel_land_use_rasters/mosaicRaster.tiff')

#terra::merge(rasters, filename = '/mnt/data2/Project_Polli_agro/Operational/4_data_analysis/7_seldetection/rasters/sentinel_land_use_rasters/mergedRaster.tiff')
  
#writeRaster(merged, '/mnt/data2/Project_Polli_agro/Operational/4_data_analysis/7_seldetection/rasters/sentinel_land_use_rasters/mergedRaster.tiff')

mosaic = rast('/mnt/data2/Project_Polli_agro/Operational/4_data_analysis/7_seldetection/rasters/sentinel_land_use_rasters/mosaicRaster.tiff')

plot(r1)

coltab(mosaic) = coltab(r1)

plot(mosaic)

writeRaster(mosaic, '/mnt/data2/Project_Polli_agro/Operational/4_data_analysis/7_seldetection/rasters/sentinel_land_use_rasters/29S_29T_joined.tif')
