#' Allow users to get route names.
#'
#' This function allows users to get route names based on the specified bus number.
#' If bus number is not specified, it will provide the all bus number with its corresponding route names.
#'
#' @param bus Bus number.
#' @param key Key for accessing the API.
#' @return Dataframe with bus number and its corresponding route name.
#' @export
#' @examples
#' get_route()
#' get_route(bus = 5)


get_route <- function(bus = NULL, key = Sys.getenv("BUS_CLIENT_KEY")){
  url <- "http://ctabustracker.com/bustime/api/v2/getroutes?"
  query_params <- list(key = key,format = "json")
  getroutes <- httr::GET(url, query = query_params)
  routes <- jsonlite::fromJSON(httr::content(getroutes, as = "text"))
  df_routes <- data.frame(routes)[,c(1,2)]
  df_routes <- dplyr::rename(df_routes, bus_number = 1, route_name = 2)

  if(is.null(bus)){
    return(df_routes)
  }else{
    df_routes <- dplyr::filter(df_routes, bus_number == bus)
    return(df_routes)
  }
}
