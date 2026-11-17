# Set up all necessary information for a run of BAYPASS

baypass_run_setup <- function(
    executable_path,
    baypass_utils_path,
    popfile_path,
    envfile_path,
    genofile_path,
    contrast_path,
    output_path,
    run_prefix,
    n_pops,
    seeds,
    thread_number) {
  
  # Define necessary directories to run core model mode 
  analysis_outdir <- paste0(output_path, run_prefix, "_analysis_output/")
  core_mode_outdir <- paste0(analysis_outdir, "0_core_mode_output/")

  # Name seed vector
  names(seeds) <- seeds
  
  seed_outdirs <- map(
    seeds,
    \(x) (paste0(core_mode_outdir, "seed_", x, "/")
    )
  )
  
  # Define output files created by core model mode that are used in the analysis
  core_omega <- lapply(
    seeds,
    \(x) (paste0(seed_outdirs[[as.character(x)]],  run_prefix, "_seed", x, "_core_mat_omega.out")
    )
  )
  
  core_summary_lda_omega <- lapply(
    seeds,
    \(x) (paste0(seed_outdirs[[as.character(x)]],  run_prefix, "_seed", x, "_core_summary_lda_omega.out")
    )
  )
  
  core_pi_xtx <- lapply(
    seeds,
    \(x) (paste0(seed_outdirs[[as.character(x)]],  run_prefix, "_seed", x, "_core_summary_pi_xtx.out")
    )
  )
  
  core_summary_beta_params <- lapply(
    seeds,
    \(x) (paste0(seed_outdirs[[as.character(x)]],  run_prefix, "_seed", x, "_core_summary_beta_params.out")
    )
  )
  
  # core_summary_betai <- lapply(
  #   seeds,
  #   \(x) (paste0(seed_outdirs[[as.character(x)]],  run_prefix, "_seed", x, "_core_summary_betai.out")
  #   )
  # )
  
  core_summary_betai_reg <- lapply(
    seeds,
    \(x) (paste0(seed_outdirs[[as.character(x)]],  run_prefix, "_seed", x, "_core_summary_betai_reg.out")
    )
  )

  core_summary_contrast <- lapply(
    seeds,
    \(x) (paste0(seed_outdirs[[as.character(x)]],  run_prefix, "_seed", x, "_core_summary_contrast.out")
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
      "contrast_path" = contrast_path,
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
      "core_mode_outdir" = core_mode_outdir,
      "seed_outdirs" = seed_outdirs
    ),
    "output_files" = list(
      "core_omega" = core_omega,
      "core_pi_xtx" = core_pi_xtx,
      "core_summary_beta_params" = core_summary_beta_params,
      # "core_summary_betai" = core_summary_betai,
      "core_summary_betai_reg" = core_summary_betai_reg,
      "core_summary_contrast" = core_summary_contrast,
      "core_summary_lda_omega" = core_summary_lda_omega
    )
  )

  return(baypass_setup_list)
}
