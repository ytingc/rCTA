#' Allow users lookup the information of bus stop.
#'
#' This function allows to lookup the information of stops,
#' including stop ID, direction, longitude and latitude based on
#' the arguments of bus number, stop name and stop direction.
#'
#' @param bus Bus numebr.
#' @param stopname Name of bus stop.It is optional.
#' @param dir Direction of routes.It is optional.
#' @param key Key for accessing the API.
#' @return Dataframe with potential matching stop with bus number, stop ID, direction, longitude and latidude columns.
#' @export
#' @examples
#' lookupstop(bus = 1, stopname = "Michigan")
#' lookupstop(bus = 1, dir = "Southbound")
#' lookupstop(bus = 1, stopname = "Indiana", dir = "Northbound")

lookupstop <- function(bus, stopname = NULL, dir = NULL, key = Sys.getenv("BUS_CLIENT_ID")){
  Sys.setenv(BUS_CLIENT_ID = "g4cvcnekeeJdvNQbeBgVVfCPR")
  url <- "http://ctabustracker.com/bustime/api/v2/getroutes?"
  query_params <- list(key = key,format = "json")
  getroutes <- httr::GET(url, query = query_params)
  routes <- jsonlite::fromJSON(httr::content(getroutes, as = "text"))
  df_routes <- data.frame(routes)
  bus_id <- df_routes$bustime.response.routes.rt

  url <- "http://ctabustracker.com/bustime/api/v2/getdirections?"
  bus_dir <- data.frame()
  for(i in bus_id){
    result <- httr::GET(url, query = list(rt = i, key = key, format = "json"))
    result <- jsonlite::fromJSON(httr::content(result, as = "text"))
    result <- data.frame(result)
    result <- dplyr::mutate(result, bus_num = rep(i, length(result)))
    bus_dir <- rbind(bus_dir,result)
  }

  url <- "http://ctabustracker.com/bustime/api/v2/getstops?"

  bus_stop <- data.frame()
  for(i in bus_id){
    for(k in 1:sum(bus_dir$bus_num == i)){
      response <- httr::GET(url, query = list(key = key,rt = i, dir = bus_dir$dir[bus_dir$bus_num == i][k], format = "json"))
      response <- jsonlite::fromJSON(httr::content(response, as = "text"))
      response <- data.frame(response)
      response <- dplyr::mutate(response, bus_num = i, direction = bus_dir$dir[bus_dir$bus_num == i][k])
      bus_stop <- rbind(bus_stop, response)
    }
  }
  bus_stop <- dplyr::rename(bus_stop, stop_id = 1, stop_name = 2, lat = 3, lon = 4, bus_num = 5, direction = 6)
  bus_stop <- bus_stop[,c(5,6,1:4)]

  if(is.null(stopname)){
    if(is.null(dir)){
      bus_stop_filter <- dplyr::filter(bus_stop, bus_num == bus)
      bus_stop_filter <<- bus_stop_filter
    }else{
      bus_stop_filter <- dplyr::filter(bus_stop,bus_num == bus, direction == dir)
      bus_stop_filter <<- bus_stop_filter
    }
  }else{
    if(is.null(dir)){
      bus_stop_filter <- dplyr::filter(bus_stop,bus_num == bus)
      bus_stop_filter <- bus_stop_filter[stringr::str_detect(bus_stop_filter$stop_name, stopname),]
      bus_stop_filter <<- bus_stop_filter
    }else{
      bus_stop_filter <- dplyr::filter(bus_stop,bus_num == bus, direction == dir)
      bus_stop_filter <- bus_stop_filter[stringr::str_detect(bus_stop_filter$stop_name, stopname),]
      bus_stop_filter <<- bus_stop_filter
    }
  }
  return(bus_stop_filter)
}
