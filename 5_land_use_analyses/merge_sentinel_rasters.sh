#!/bin/bash

gdalbuildvrt \
  /mnt/data2/Project_Polli_agro/Operational/4_data_analysis/7_seldetection/environmental_data/input_data/01_raster_data/00_sentinel_land_use_rasters/sentinel_29S_29T_joined.vrt \
  /mnt/data2/Project_Polli_agro/Operational/4_data_analysis/7_seldetection/environmental_data/input_data/01_raster_data/00_sentinel_land_use_rasters/29S.tif \
  /mnt/data2/Project_Polli_agro/Operational/4_data_analysis/7_seldetection/environmental_data/input_data/01_raster_data/00_sentinel_land_use_rasters/29T.tif 
  
gdal_translate \
  /mnt/data2/Project_Polli_agro/Operational/4_data_analysis/7_seldetection/environmental_data/input_data/01_raster_data/00_sentinel_land_use_rasters/sentinel_29S_29T_joined.vrt \
  /mnt/data2/Project_Polli_agro/Operational/4_data_analysis/7_seldetection/environmental_data/input_data/01_raster_data/00_sentinel_land_use_rasters/sentinel_29S_29T_joined.tif
  
rm /mnt/data2/Project_Polli_agro/Operational/4_data_analysis/7_seldetection/environmental_data/input_data/01_raster_data/00_sentinel_land_use_rasters/sentinel_29S_29T_joined.vrt
