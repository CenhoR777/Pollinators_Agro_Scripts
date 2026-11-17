define_baypass_commands <- function(baypass_setup_list, run) {
  #
  if (run == "core_mode") {

    commands <- lapply(
      baypass_setup_list[["run_info"]][["seeds"]],
      \(x) paste0(
        baypass_setup_list[["paths"]][["executable_path"]],
        " -npop ", baypass_setup_list[["run_info"]][["n_pops"]],
        " -countdatafile ", baypass_setup_list[["paths"]][["genofile_path"]],
        " -contrastfile ", baypass_setup_list[["paths"]][["contrast_path"]],
        " -efile ", baypass_setup_list[["paths"]][["envfile_path"]],
        " -outprefix ", baypass_setup_list[["output_directories"]][["seed_outdirs"]][[as.character(x)]],
        baypass_setup_list[["run_info"]][["run_prefix"]], "_seed", x, "_core",
        " -nthreads ", baypass_setup_list[["run_info"]][["thread_number"]],
        " -seed ", x
        )
      )
    
    return(commands)
    
  }
}
  
  #   } else if (run == "core_mode_pod") {
  #   command <- paste0(
  #     baypass_setup_list[["paths"]][["executable_path"]],
  #     " -npop ", baypass_setup_list[["run_info"]][["pop_number"]],
  #     " -gfile ", baypass_setup_list[["output_files"]][["gbtapods"]],
  #     " -outprefix ", baypass_setup_list[["output_directories"]][["outliers"]][["core_mode_pod_run_outdir"]],
  #     baypass_setup_list[["run_info"]][["run_prefix"]], "_core_POD",
  #     " -nthreads ", baypass_setup_list[["run_info"]][["thread_number"]]
  #   )
  # 
  #   return(command)
  # } else if (run == "aux_cov_mode") {
  #   commands <- lapply(
  #     baypass_setup_list[["run_info"]][["auxcov_seeds"]],
  #     \(x) paste0(
  #       baypass_setup_list[["paths"]][["executable_path"]],
  #       " -npop ", baypass_setup_list[["run_info"]][["pop_number"]],
  #       " -gfile ", baypass_setup_list[["paths"]][["genofile_path"]],
  #       " -efile ", baypass_setup_list[["paths"]][["envfile_path"]],
  #       " -outprefix ", baypass_setup_list[["output_directories"]][["gea"]][["auxcov_outdirs"]][[as.character(x)]],
  #       baypass_setup_list[["run_info"]][["run_prefix"]], "_seed", x, "_mcmc_aux",
  #       " -nthreads ", baypass_setup_list[["run_info"]][["thread_number"]],
  #       " -seed ", x,
  #       " -omegafile ", baypass_setup_list[["output_files"]][["core_omega"]],
  #       " -auxmodel"
  #     )
  #   )
# 
#     names(commands) <- baypass_setup_list[["run_info"]][["auxcov_seeds"]]
# 
#     return(commands)
