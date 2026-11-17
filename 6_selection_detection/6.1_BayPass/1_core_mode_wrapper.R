#' Wrapper for runs of BayPass Core Model Mode
#'
#' This is a wrapper function that calls all the necessary functions for a run
#' of BayPass Core Model Mode. This includes an initial run with real data, and a
#' second run with POD data. 
#'
#' @param baypass_setup_list List containing the necessary setup information
#'  necessary for the run (created with baypass_setup.R).
#' @param skip_baypass Set to FALSE if exiting runs of BayPass should be
#'  overwritten.
#'
#' @return Returns a list with the invoked system commands used to
#'  run BayPass and the contents of the BayPass output files that will be useful
#'  in the analysis.
#' @examples
#' core_mode_wrapper(setup_list, skip_baypass = FALSE)
#'
core_mode_wrapper <- function(
    baypass_setup_list,
    skip_baypass = TRUE) {
  
  # create directories
  cat("Creating directories.\n\n")
  create_directories(baypass_setup_list)

  # define commands for the core mode run
  core_commands <- define_baypass_commands(
    baypass_setup_list,
    "core_mode"
  )

  # execute all runs of the core mode
  cat("Executing runs of BayPass.\n\n")
  if (skip_baypass == F) {
    lapply(
      core_commands,
      system
    )
  }

  # gather results of all runs
  cat("Gathering results from runs of BayPass.\n\n")
  run_results <- gather_results(
    baypass_setup_list
  )  
  
  # join all results in a list
  # results <- list(
  #   "initial_core_mode_run" = list(
  #     "command" = core_initial_command,
  #     "skip_baypass" = skip_baypass,
  #     "results" = initial_run_results
  #   ),
  #   "POD_core_mode_run" = list(
  #     "command" = core_POD_command,
  #     "skip_baypass" = skip_baypass,
  #     "results" = pod_run_results
  #     )
  #   )
 
  return(run_results)
  
 }
