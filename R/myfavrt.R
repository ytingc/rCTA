#' Allow users get real-time information of your favorite route.
#'
#' Users will obtain real-time information of their favorite routes,
#' including the estimated arrival time, waiting time, travel time,
#' current status, delay and alert message. It also allows users to collect and save the
#' real-time information for a given period in a data frame through calling the function periodically.
#'
#' @param bus Bus number.
#' @param start_id ID of the departure stop.
#' @param end_id ID of the destination stop.
#' @param key Key for accessing the API.
#' @param interval Time interval between calling the function.
#' @param times The number of times calling the function.
#' @return Dataframe with a set of real-time information in a given period.
#' @export
#' @examples
#' myfavrt(bus = 126, start_id = 36, end_id = 48, interval= 0, times = 1)



myfavrt <- function(bus, start_id, end_id, key = Sys.getenv("BUS_CLIENT_ID"), interval= 60, times = 3){
  myfavoritert <- data.frame()
  Sys.setenv(BUS_CLIENT_ID = "g4cvcnekeeJdvNQbeBgVVfCPR")
  for(i in 1:times){
    url <- "http://ctabustracker.com/bustime/api/v2/getpredictions?"
    query_params <- list(key = key, rt = bus, stpid = start_id, format = "json")
    start_pred <- httr::GET(url, query = query_params)
    if(httr::http_error(start_pred)){
      stop ("The request produced an error.")
    }
    start_pred <- jsonlite::fromJSON(httr::content(start_pred, as = "text"))
    start_pred <- data.frame(start_pred)

    if(colnames(start_pred)[1] == "bustime.response.error.rt"){
      stop (start_pred$bustime.response.error.msg)
    }else {
      start_pred <- start_pred[,-c(2,8,10,12,13,16)]
      start_pred <- dplyr::rename(start_pred, current_time = 1, start_stop = 2, start_stop_id = 3, vehicle_id = 4, distance_to_stop = 5, bus_number = 6, direction = 7, arrival_time = 8, delay = 9, wait_time = 10)
      # names(start_pred) <- c("current_time","start_stop","start_stop_id", "vehicle_id", "distance_to_stop", "bus_number",  "direction", "arrival_time", "delay", "wait_time")
      start_pred <- start_pred[1,]
    }

    query_params <- list(key = key, vid = start_pred$vehicle_id, format = "json")
    end_pred <- httr::GET(url, query = query_params)
    if(httr::http_error(end_pred)){
      stop ("The request produced an error.")
    }
    end_pred <- jsonlite::fromJSON(httr::content(end_pred, as = "text"))
    end_pred <- data.frame(end_pred)

    if (colnames(end_pred)[1] == "bustime.response.error.rt"){
      stop (end_pred$bustime.response.error.msg)
    }else{
      end_pred <- end_pred[,-c(2,8,10,12,13,16)]
      end_pred <- dplyr::rename(end_pred, current_time = 1, end_stop = 2, end_stop_id = 3, vehicle_id = 4, distance_to_stop = 5, bus_number = 6, direction = 7, arrival_time = 8, delay = 9, wait_time = 10)
      # names(end_pred) <- c("current_time","end_stop","end_stop_id", "vehicle_id", "distance_to_stop", "bus_number",  "direction", "arrival_time", "delay", "wait_time")
      end_pred <- dplyr::filter(end_pred, end_stop_id == end_id)
    }

if(nrow(end_pred)==0){
  stop("The bus is currently not operated in this direction/route.")
}else{
  myfavorite <- data.frame("no." = bus, "current_time" = start_pred$current_time, "bus_num" = start_pred$bus_number, "start_stop_id" = start_pred$start_stop_id,
                           "start_stop_name" = start_pred$start_stop,"end_stop_id" = end_id, "end_stop_name" = end_pred$end_stop,
                           "wait_time_in_min" = start_pred$wait_time, "departurel_time" = start_pred$arrival_time, "arrival_time" = end_pred$arrival_time,
                           "travel_time_in_min" = as.POSIXct(end_pred$arrival_time, format = "%Y%m%d %H:%M") - as.POSIXct(start_pred$arrival_time, format = "%Y%m%d %H:%M"),"delay" = start_pred$delay)
}
if(myfavorite$travel_time_in_min<0){
  stop("This bus is currently not operated in this direction/route.")
}else{
  url <- "http://www.transitchicago.com/api/1.0/routes.aspx?"
  query_params <- list(routeid = bus, outputType = "JSON")
  alert <- httr::GET(url, query = query_params)
  alert <- jsonlite::fromJSON(httr::content(alert, as = "text"))
  alert <- data.frame(alert)
  myfavorite <-  dplyr::mutate(myfavorite, status = alert[,7])
  myfavoritert <- rbind(myfavoritert, myfavorite)
  myfavoritert <<- myfavoritert
}
Sys.sleep(interval)
  }
  return(myfavoritert)
}
