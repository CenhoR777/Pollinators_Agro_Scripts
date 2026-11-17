gather_results <- function(baypass_info_list) {
  ## Load results

  ## Load pop names

  pop.names <- c(
    as.matrix(
      read.table(
        baypass_info_list[["paths"]][["popfile_path"]]
      )
    )
  )

  ## Load Results
  # Estimate of omega
  omega <- lapply(
    baypass_info_list[["run_info"]][["seeds"]],
    \(x) as.matrix(
      read.table(
        baypass_info_list[["output_files"]][["core_omega"]][[as.character(x)]]
      ),
      dimnames = list(pop.names, pop.names)
    )
  )

  omega <- 
    lapply(
      omega,
      function(x) {
        row.names(x) <- pop.names
        colnames(x) <- pop.names
        return(x)
        }
      )
  
  # summary_lda_omega
  lda_omega <- lapply(
    baypass_info_list[["run_info"]][["seeds"]],
    \(x) read.table(
      baypass_info_list[["output_files"]][["core_summary_lda_omega"]][[as.character(x)]],
      h = T
    )
  )

  # a_pi and b_pi parameters of the Pi Beta distribution
  pi_beta_coef <- lapply(
    baypass_info_list[["run_info"]][["seeds"]],
    \(x) read.table(
      baypass_info_list[["output_files"]][["core_summary_beta_params"]][[as.character(x)]],
      h = T
    )
  )

  # XtX estimator
  pi_xtx <- lapply(
    baypass_info_list[["run_info"]][["seeds"]],
    \(x) read.table(
      baypass_info_list[["output_files"]][["core_pi_xtx"]][[as.character(x)]],
      h = T
    )
  )

  # # betai
  # betai <- lapply(
  #   baypass_info_list[["run_info"]][["seeds"]],
  #   \(x) read.table(
  #     baypass_info_list[["output_files"]][["core_summary_betai"]][[as.character(x)]],
  #     h = T
  #   )
  # )

  # betai reg
  betai_reg <- lapply(
    baypass_info_list[["run_info"]][["seeds"]],
    \(x) read.table(
      baypass_info_list[["output_files"]][["core_summary_betai_reg"]][[as.character(x)]],
      h = T
    )
  )

  # contrast
  contrast <- lapply(
    baypass_info_list[["run_info"]][["seeds"]],
    \(x) read.table(
      baypass_info_list[["output_files"]][["core_summary_contrast"]][[as.character(x)]],
      h = T
    )
  )

  ## Gather results
  results <- list(
    "pop_names" = pop.names,
    "omega_matrix" = omega,
    "lda_omega" = lda_omega,
    "pi_beta_coef" = pi_beta_coef,
    "xtx_estimator" = pi_xtx,
    # "betai" = betai
    "betai_reg" = betai_reg,
    "contrast" = contrast
  )

  return(results)
}
