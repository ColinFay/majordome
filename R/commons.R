glue_command <- function(command, sudo, service, product){
  glue('{sudo} {service} {command} {product}')
}

#' @importFrom ssh ssh_connect ssh_exec_wait scp_download
#' @importFrom R6 R6Class
#' @importFrom glue glue

RStudio <- R6Class(
  "RStudio",
  public = list(
    session = list(),
    config_file = character(0),
    server_log = character(0),
    access_log = character(0),
    product = character(0),
    disconnect = function(){
      ssh_disconnect(self$session)
    },
    initialize = function(host,
                          keyfile = NULL, verbose = FALSE,
                          service = c("systemctl", "upstart"),
                          product = c("rstudio-connect", "rstudio-pm"),
                          with_sudo = TRUE){
      service <- match.arg(service)
      if (service == "systemctl"){
        private$service <- "systemctl"
      }
      if (service == "upstart"){
        private$service <- " "
      }
      if (with_sudo){
        private$sudo <- "sudo"
      } else {
        private$sudo <- " "
      }
      self$product <- product
      self$session <- ssh_connect(
        host = host, keyfile = keyfile,verbose = verbose
      )
    },
    status = function(){
      ssh_exec_wait(
        self$session,
        command = glue_command('status',
                               sudo = private$sudo,
                               service = private$service,
                               product = self$product)
      )
    },
    start = function(){
      ssh_exec_wait(
        self$session,
        command = glue_command('start',
                               sudo = private$sudo,
                               service = private$service,
                               product = self$product)
      )
    },
    restart = function(){
      ssh_exec_wait(
        self$session,
        command = glue_command('restart',
                               sudo = private$sudo,
                               service = private$service,
                               product = self$product)
      )
    },
    reload = function(){
      ssh_exec_wait(
        self$session,
        command = glue_command('reload',
                               sudo = private$sudo,
                               service = private$service,
                               product = self$product)
      )
    },
    stop = function(){
      ssh_exec_wait(
        self$session,
        command = glue_command('stop',
                               sudo = private$sudo,
                               service = private$service,
                               product = self$product)
      )
    },
    disable = function(){
      ssh_exec_wait(
        self$session,
        command = glue_command('disable',
                               sudo = private$sudo,
                               service = private$service,
                               product = self$product)
      )
    },
    enable = function(){
      ssh_exec_wait(
        self$session,
        command = glue_command('enable',
                               sudo = private$sudo,
                               service = private$service,
                               product = self$product)
      )
    },
    cat_server_log = function(
      file = self$server_log
    ){
      ssh_exec_wait(
        self$session,
        command = glue('cat {file}')
      )
    },
    cat_access_log = function(
      file = self$access_log
    ){
      ssh_exec_wait(
        self$session,
        command = glue('cat {file}')
      )
    },
    cat_config_file = function(
      file = self$config_file
    ){
      ssh_exec_wait(
        self$session,
        command = glue('cat {file}')
      )
    },
    dl_config_file = function(
      to = ".",
      file = self$config_file
    ){
      scp_download(
        self$session,
        files = file,
        to = to
      )
    },
    upload_config_file = function(
      file,
      to = self$config_file
    ){
      scp_upload(
        self$session,
        files = file,
        to = to
      )
    }
  ),
  private = list(
    service = character(0),
    sudo = character(0)
  )
)
