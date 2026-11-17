# Script to merge the two Sentinel Land Use raster files that cover Portugal 

library(terra)

# directory containing land use rasters
landuse_raster_location <- 'input_data/01_raster_data/00_sentinel_land_use_rasters/'

# Create list of files to merge
sentinel_raster_list = list.files(landuse_raster_location, full.names = T, pattern = "29")

# Join rasters into a single object  
sentinel_rasters = sprc(sentinel_raster_list)

# Use terra::mosaic() to join rasters
merge(
  sentinel_rasters,
  file = paste0(landuse_raster_location, "/temp_mosaic_raster.tiff"),
  overwrite = TRUE)

# Read temporary raster
temp_mosaic_raster <- rast(paste0(landuse_raster_location, "/temp_mosaic_raster.tiff"))

# Change colors to match those of original rasters
coltab(temp_mosaic_raster) = coltab(sentinel_rasters[1])

# Remove temporary raster
file.remove(paste0(landuse_raster_location, "/temp_mosaic_raster.tiff"))

# Write the final raster 
writeRaster(temp_mosaic_raster, 'results/00_final_landuse_raster/sentinel_29S_29T_joined.tif', datatype = 'INT1U', overwrite = T)