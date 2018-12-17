#' Allow users to get alerts of bus.
#'
#' This function allows users to get alerts information based on the specified bus number.
#'
#' @param bus Bus number.
#' @return Dataframe with bus number and its corresponding alert information.
#' @export
#' @examples
#' get_alert(bus = 8)


get_alert <- function(bus){
  url <- "http://www.transitchicago.com/api/1.0/alerts.aspx?"
  query_params <- list(routeid = bus, outputType = "JSON")
  routealert <- httr::GET(url, query = query_params)
  routealert <- jsonlite::fromJSON(httr::content(routealert, as = "text"), flatten = TRUE)
  routealert <- routealert[["CTAAlerts"]][["Alert"]][,c(2,3,8,9)]
  return(routealert)
}
