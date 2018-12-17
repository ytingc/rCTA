#' Provides an overview of current bus alerts.
#'
#' This function allows users to obtain an overview of current alerts of all CTA buses
#' through a summary table that provide the count of each type of alerts.
#'
#' @param key Key for accessing the API
#' @return Table with the counts of each type of alerts.
#' @export
#' @examples
#' alertstat()



alertstat <- function(key = Sys.getenv("BUS_CLIENT_KEY")){
  alertlist <- data.frame()
  url <- "http://ctabustracker.com/bustime/api/v2/getroutes?"
  query_params <- list(key = key,format = "json")
  route <- httr::GET(url, query = query_params)
  route <- jsonlite::fromJSON(httr::content(route, as = "text"))
  route <- data.frame(route)
  id_bus <- route$bustime.response.routes.rt

  for(i in id_bus){
    url <- "http://www.transitchicago.com/api/1.0/alerts.aspx?"
    query_params <- list(routeid = i, outputType = "JSON")
    routealert <- httr::GET(url, query = query_params)
    routealert <- jsonlite::fromJSON(httr::content(routealert, as = "text"), flatten = TRUE)
    routealert <- routealert[["CTAAlerts"]][["Alert"]][,1:9]
    routealert <- dplyr::mutate(routealert, bus_num = i)
    alertlist <- rbind(alertlist, routealert)
  }
  alertlist <- alertlist[, -c(1,4,5,6)]
  names(alertlist) <- c("headline","description","type","start_time","end_time","bus_num")
  table(alertlist$type)
}
