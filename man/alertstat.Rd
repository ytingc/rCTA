% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/alertstat.R
\name{alertstat}
\alias{alertstat}
\title{Provides an overview of current bus alerts.}
\usage{
alertstat(key = Sys.getenv("BUS_CLIENT_KEY"))
}
\arguments{
\item{key}{Key for accessing the API}
}
\value{
Table with the counts of each type of alerts.
}
\description{
This function allows users to obtain an overview of current alerts of all CTA buses
through a summary table that provide the count of each type of alerts.
}
\examples{
alertstat()
}
