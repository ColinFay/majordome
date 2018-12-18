#' Open a session to a server running RStudio Package Manager
#'
#' @inheritParams ssh::ssh_connect
#'
#' @return A Connection Object
#' @export

RSPM <- R6Class(
  "RSPM",
  inherit = RStudio,
  public = list(
    initialize = function(host,
                          keyfile = NULL, verbose = FALSE,
                          service = c("systemctl", "upstart")){
      self$config_file <- "/etc/rstudio-connect/rstudio-connect.gcfg"
      self$server_log <- "/var/log/rstudio-pm.log"
      self$access_log <- "/var/log/rstudio-pm.access.log"
      super$initialize(
        host = host, keyfile = keyfile,verbose = verbose,
        service = service, product = "rstudio-pm"
      )
    }
    )
)

