
crop_raster_with_buffer <- function(buffer_sv, raster) {
  
  # extract poll name
  poll_name <- buffer_sv$poll
  
  # crop land use raster using the buffer area as a mask
  cropped_raster <- crop(raster, buffer_sv, mask = TRUE)
  
  # remove class "water"
  #cropped_raster <- subst(cropped_raster, "Water", NA)
  
  # set name
  names(cropped_raster) <- poll_name
  
  return(cropped_raster)
}
