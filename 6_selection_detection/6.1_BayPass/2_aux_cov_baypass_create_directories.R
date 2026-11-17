create_directories <- function(baypass_setup_list) {

  dirs_to_create <- unlist(baypass_setup_list[["output_directories"]])

  lapply(
    dirs_to_create,
    \(x) dir.create(
      path = x,
      recursive = TRUE,
      showWarnings = FALSE
    )
  )
}
