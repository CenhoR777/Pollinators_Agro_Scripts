define_baypass_commands <- function(baypass_setup_list) {
  #
  commands <- lapply(
    baypass_setup_list[["run_info"]][["seeds"]],
    \(x) paste0(
      baypass_setup_list[["paths"]][["executable_path"]],
      " -countdatafile ", baypass_setup_list[["paths"]][["genofile_path"]],
      " -efile ", baypass_setup_list[["paths"]][["envfile_path"]],
      " -outprefix ", baypass_setup_list[["output_directories"]][["seed_outdirs"]][[as.character(x)]],
      baypass_setup_list[["run_info"]][["run_prefix"]], "_seed", x,
      " -nthreads ", baypass_setup_list[["run_info"]][["thread_number"]],
      " -seed ", x,
      " -omegafile ", baypass_setup_list[["paths"]][["omegafile_path"]],
      " -auxmodel"
    )
  )

  names(commands) <- baypass_setup_list[["run_info"]][["auxcov_seeds"]]

  return(commands)
  
  }

