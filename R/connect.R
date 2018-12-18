#' Ping a connect server
#'
#' @param url the url of connect
#' @param port the port of connect
#'
#' @return The status code of the ping
#' @export
#'
#' @importFrom crul HttpClient
#'
#' @examples
#' \dontrun{
#' ping_connect("url", "3939")
#' }

ping_connect <- function(url, port){
  x <- HttpClient$new(url = glue("{url}:{port}/__ping__"))
  x <- x$get()
  x$status_code
}

#' Open a session to a server running Connect
#'
#' @inheritParams ssh::ssh_connect
#'
#' @return A Connection Object
#' @export
#'

Connect <- R6Class(
  "Connect",
  inherit = RStudio,
  public = list(
    initialize = function(host,
                          keyfile = NULL, verbose = FALSE,
                          service = c("systemctl", "upstart")){
      self$config_file <- "/etc/rstudio-connect/rstudio-connect.gcfg"
      self$server_log <- "/var/log/rstudio-connect.log"
      self$access_log <- "/var/log/rstudio-connect.access.log"
      super$initialize(
        host = host, keyfile = keyfile,verbose = verbose,
        service = service, product = "rstudio-connect"
      )
    }
    )
)

