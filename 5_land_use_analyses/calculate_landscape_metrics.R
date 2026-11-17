calculate_landscape_metrics <- function(landscape_raster, function_list) {
  
  # use nested lapply to apply the list of functions to a single object
  landscape_metrics_df <- lapply(
    function_list, 
    \(x) lapply(landscape_raster, x)
    ) %>%
    # bind list entries into a dataframe
    bind_rows() %>%
    # add poll information
    mutate(poll = names(landscape_raster))
  
}
