# Set up all necessary information for a run of BAYPASS AUXILIARY COVARIATE MODE

baypass_run_setup <- function(
    executable_path,
    baypass_utils_path,
    popfile_path,
    envfile_path,
    genofile_path,
    omegafile_path,
    output_path,
    run_prefix,
    n_pops,
    seeds,
    thread_number) {
  
  # Define necessary directories to run core model mode 
  analysis_outdir <- paste0(output_path, run_prefix, "_analysis_output/")

  # Name seed vector
  names(seeds) <- seeds
  
  seed_outdirs <- map(
    seeds,
    \(x) (paste0(analysis_outdir, "seed_", x, "/")
    )
  )
  
  # Define output files
  summary_beta_params <- lapply(
    seeds,
    \(x) (paste0(seed_outdirs[[as.character(x)]],  run_prefix, "_seed", x, "_summary_beta_params.out")
    )
  )
  
  summary_betai <- lapply(
    seeds,
    \(x) (paste0(seed_outdirs[[as.character(x)]],  run_prefix, "_seed", x, "_summary_betai.out")
    )
  )

  summary_pdelta <- lapply(
    seeds,
    \(x) (paste0(seed_outdirs[[as.character(x)]],  run_prefix, "_seed", x, "_summary_Pdelta.out")
    )
  )
  
  # Join all the information in a single list
  
  baypass_setup_list <- list(
    "paths" = list(
      "executable_path" = executable_path,
      "baypass_utils_path" = baypass_utils_path,
      "popfile_path" = popfile_path,
      "envfile_path" = envfile_path,
      "genofile_path" = genofile_path,
      "omegafile_path" = omegafile_path,
      "output_path" = output_path
    ),
    "run_info" = list(
      "run_prefix" = run_prefix,
      "seeds" = seeds,
      "n_pops" = n_pops,
      "thread_number" = thread_number
    ),
    "output_directories" = list(
      "analysis_outdir" = analysis_outdir,
      "seed_outdirs" = seed_outdirs
    ),
    "output_files" = list(
      "summary_beta_params" = summary_beta_params,
      "summary_betai" = summary_betai,
      "summary_pdelta" = summary_pdelta
    )
  )

  return(baypass_setup_list)
}
