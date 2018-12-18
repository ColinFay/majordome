#' # Closing connection
#' #' @importFrom ssh ssh_disconnect
#' #'
#' close_connection <- function(session_object) {
#'   session_object$disconnect()
#'   cat("Connection closed\n")
#'   on_connection_closed()
#' }
#'
#' on_connection_closed <- function() {
#'   observer <- getOption("connectionObserver")
#'   if (!is.null(observer))
#'     observer$connectionClosed(type = "Connect", host = "Connect")
#' }
#'
#' # For connection open
#'
#' list_objects <- function(session, includeType  = TRUE) {
#'   # Name of the <details>
#'   tables <- c("status")
#'   if (includeType) {
#'     data.frame(
#'       name = tables,
#'       type = rep_len("table", length(tables)),
#'       stringsAsFactors = FALSE
#'     )
#'   } else {
#'     tables
#'   }
#' }
#'
#' tibble_res <- function(label, type){
#'   tibble(
#'     name = label,
#'     type = type
#'   )
#' }
#'
#' list_columns <- function(session) {
#'   # Content of the <details>
#'   if (table == "status"){
#'     res <- capture.output(session$status())
#'     # res <- tibble(labels = as.character(content(res)))
#'     # if (nrow(res) != 0 ) {
#'     #   res <-   tibble_res(res$labels, "node label")
#'     # }
#'   }
#'   tibble(
#'     name = "label",
#'     type = "type"
#'   )
#'   #res
#' }
#'
#' preview_object <- function(session) {
#'   # What happens when you click on the preview object
#'   # if (table == "nodes"){
#'   #   browser()
#'   #   res <- get_wrapper_for_connect(url, "db/data/labels" ,auth)
#'   #   res <- tibble(labels = as.character(content(res)))
#'   # } else if (table == "relationship"){
#'   #   res <- get_wrapper_for_connect(url, "db/data/relationship/types" ,auth)
#'   #   res <- tibble(labels = as.character(content(res)))
#'   # } else if (table == "constraints"){
#'   #   res <- get_wrapper_for_connect(url, "db/data/schema/constraints" ,auth)
#'   #   res <- tibble(labels = as.character(content(res)))
#'   # } else if (table == "property keys"){
#'   #   res <- get_wrapper_for_connect(url, "db/data/propertykeys" ,auth)
#'   #   res <- tibble(labels = as.character(content(res)))
#'   # }
#'   tibble(labels = names(iris))
#' }
#'
#' #' @importFrom utils browseURL
#'
#' connect_actions <- function(){
#'   list(
#'     # browser = list(
#'     #   icon = system.file("icons","browserlogo.png", package = "neo4r"),
#'     #   callback = function() {
#'     #     browseURL(url)
#'     #   }
#'     # ),
#'     help = list(
#'       icon = system.file("icons","github.png", package = "majordome"),
#'       callback = function() {
#'         browseURL("https://github.com/thinkr-open/majordome")
#'       }
#'     )
#'   )
#' }
#'
#' list_objects_types <- function() {
#'   return(
#'     list(
#'       table = list(contains = "data")
#'     )
#'   )
#' }
#'
#' #' @keywords internal
#' #' @export
#'
#' on_connection_opened <- function(session) {
#'   #browser()
#'   observer <- getOption("connectionObserver")
#'   if(!is.null(observer)){
#'     observer$connectionOpened(type = "Connect",
#'                               host = "Connect",
#'                               displayName = "RStudio Connect",
#'                               icon = system.file("icons","rstudio.png", package = "majordome"),
#'                               connectCode = '# Open Connect\nlibrary(majordome)\nsess <- Connect$new("")\nsess$status()\nlaunch_con_pane(sess)',
#'                               disconnect = function() {
#'                                 close_connection(session_object = session)
#'                               },
#'                               listObjectTypes = function () {
#'                                 list(
#'                                   table = list(contains = "data")
#'                                 )
#'                               },
#'                               listObjects = function() {
#'                                 tables <- "status"
#'                                 data.frame(
#'                                   name = tables,
#'                                   type = rep_len("table", length(tables)),
#'                                   stringsAsFactors = FALSE
#'                                 )
#'                               },
#'                               listColumns = function(table) {
#'                                 if (table == "status"){
#'                                   #browser()
#'                                   tibble::tibble(
#'                                      name = "-",
#'                                      type = capture.output(session$status())
#'                                    )
#'                                 }
#'
#'                               },
#'                               previewObject = function(table, limit, type) {
#'                                 if (table == "status"){
#'                                   tibble::tibble(
#'                                     name = "-",
#'                                     type = capture.output(session$status())
#'                                   )
#'                                 }
#'                                 #tibble::tibble(labels = names(iris))
#'                               },
#'                               actions = connect_actions(),
#'                               connectionObject = session )
#'   }
#' }
#'
#' # Shiny APP
#' #' @importFrom rstudioapi updateDialog
#' update_dialog <- function(code) {
#'   rstudioapi::updateDialog(code = code)
#' }
#'
#' #' @importFrom shiny tags div textInput
#'
#' ui <- function(){
#'   tags$div(
#'     div(style = "table-row",
#'         textInput(
#'           "host",
#'           "host (user@IP):"
#'         )
#'     )
#'   )
#' }
#'
#' #' @importFrom glue glue
#'
#' build_code <- function(host){
#'   paste(
#'     "# Open Connect\n",
#'     "library(majordome)\n",
#'     glue("sess <- Connect$new('{host}')"),
#'     "\nsess$status()",
#'     "\nlaunch_con_pane(sess)"
#'   )
#' }
#'
#' #' @importFrom shiny shinyApp
#'
#' server <- function(input, output, session) {
#'   observe({
#'     update_dialog(build_code(input$url, input$user, input$password))
#'   })
#' }
#'
#' #' @keywords internal
#' #' @importFrom shiny shinyApp
#' #' @export
#'
#' run_app <- function(){
#'   shinyApp(ui, server)
#' }
#'
#' #' Launch Neo4J Connection Pane
#' #'
#' #' @param con a connection object
#' #'
#' #' @importFrom attempt stop_if_not
#' #'
#' #' @return an opened Connection Pane
#' #' @export
#' #'
#'
#' launch_con_pane <- function(session){
#'   #stop_if_not(con$ping(), ~ .x == 200, "Couldn't connect to the Server")
#'   on_connection_opened(session)
#' }
#' # launch_con_pane(con)
