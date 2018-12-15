#' Allow users to get direction based on bus number.
#'
#' This function allows users to look up the direction of a specified bus number.
#'
#' @param bus Bus number.
#' @param key Key for accessing the API.
#' @return Dataframe with bus number and its corresponding direction.
#' @export
#' @examples
#' get_direction(bus = 156)



get_direction <- function(bus, key = Sys.getenv("BUS_CLIENT_ID")){
  Sys.setenv(BUS_CLIENT_ID = "g4cvcnekeeJdvNQbeBgVVfCPR")
  bus_dir <- data.frame()
  url <- "http://ctabustracker.com/bustime/api/v2/getdirections?"
  result <- httr::GET(url, query = list(rt = bus, key = key, format = "json"))
  result <- jsonlite::fromJSON(httr::content(result, as = "text"))
  result <- data.frame(result)
  return(result)
}
