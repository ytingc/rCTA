% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/myfavrt.R
\name{myfavrt}
\alias{myfavrt}
\title{Allow users get real-time information of your favorite route.}
\usage{
myfavrt(bus, start_id, end_id, key = Sys.getenv("BUS_CLIENT_KEY"),
  interval = 0, times = 1)
}
\arguments{
\item{bus}{Bus number.}

\item{start_id}{ID of the departure stop.}

\item{end_id}{ID of the destination stop.}

\item{key}{Key for accessing the API.}

\item{interval}{Time interval between calling the function.}

\item{times}{The number of times calling the function.}
}
\value{
Dataframe with a set of real-time information in a given period.
}
\description{
Users will obtain real-time information of their favorite routes,
including the estimated arrival time, waiting time, travel time,
current status, delay and alert message. It also allows users to collect and save the
real-time information for a given period in a data frame through calling the function periodically.
}
\examples{
myfavrt(bus = 126, start_id = 36, end_id = 60, interval= 0, times = 1)
}
