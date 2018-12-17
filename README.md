
rCTA
====

`rCTA` is an R interfact to access the APIs of Chicago Transit Authority(CTA) in order to get real-time information of buses and help users make empowered decisions about their trips.The APIs include **Bus Tracker API** and **Customer Alerts API**. Check out the documentations here:

[Bus Tracker API Documentation](https://www.transitchicago.com/assets/1/6/cta_Bus_Tracker_API_Developer_Guide_and_Documentation_20160929.pdf)

[Customer Alerts API Documentation](https://www.transitchicago.com/developers/alerts/)

APIs in rCTA
------------

There are two API contained in this package:

-   **Bus Tracker API:** This API allows developers to request and retrieve the real-time information of buses. Data available through the API includes:
    -   Vehicle locations
    -   Route data (route lists, stop lists geo-positional route definitions, etc.)
    -   Prediction Data
    -   Service Bulletins
-   **Customer Alerts API:** This API allows developers to get detailed information about current alerts. Data available through the API includes:
    -   Route status
    -   Detailed alerts

API Authentication
------------------

You will need an API key to interact with **Bus Tracker API** on every requrest (Customer Alerts API does not need authentication). To become authorized, follow the instructions below:

**1. Get an API key**

-   Sign up and activate your account at [Bus Tracker Sign up](http://www.ctabustracker.com/bustime/createAccount.jsp).
-   Sign into [Bus Tracker Sign in](http://www.ctabustracker.com/bustime/login.jsp).
-   Choose on My Account in the upper right-hand corner of the page.
-   Follow the link under "Developer API" to apply.

**2. Store your API key**

Once you obtain an API key, we encourage you to store it in the `.Renviron` file which is loaded during R's startup.

First, find your R Home directory:

``` r
R.home(component = "home")
```

Then, open the the file `Renviron.site` and add the Bus Tracker API keys with the following lines:

``` r
BUS_CLIENT_KEY = THE_API_KEY_HERE
```

Installation and Setup
----------------------

You can install the released version of rCTA from **GitHub** with:

``` r
devtools::install_github("ytingc/rCTA")
```

Then, you can load rCTA package to play with:

``` r
library(rCTA)
```

Features of rCTA pacakge
------------------------

**Search Routes**

Get routes of bus number 5.

``` r
result <-get_route(bus = 5)
knitr::kable(head(result))
```

| bus\_number | route\_name           |
|:------------|:----------------------|
| 5           | South Shore Night Bus |

**Search Direction**

Get direction of bus number 126.

``` r
result <- get_direction(bus = 126)
knitr::kable(head(result))
```

| dir       |
|:----------|
| Eastbound |
| Westbound |

**Search Stops**

Search for stop information. Useful when stop\_id is unknown.It is not case sensitive. For example:

``` r
result <- lookupstop(bus = 1, stopname = "Michigan", dir = "southbound")
knitr::kable(head(result, 10))
```

| bus\_num | direction  | stop\_id | stop\_name             |       lat|        lon|
|:---------|:-----------|:---------|:-----------------------|---------:|----------:|
| 1        | Southbound | 1606     | 3000 S Michigan        |  41.84045|  -87.62356|
| 1        | Southbound | 1590     | Michigan & 11th Street |  41.86892|  -87.62394|
| 1        | Southbound | 1592     | Michigan & 13th Street |  41.86553|  -87.62399|
| 1        | Southbound | 1593     | Michigan & 14th Street |  41.86391|  -87.62414|
| 1        | Southbound | 1595     | Michigan & 16th Street |  41.85997|  -87.62403|
| 1        | Southbound | 1596     | Michigan & 18th Street |  41.85763|  -87.62405|
| 1        | Southbound | 1598     | Michigan & 21st Street |  41.85404|  -87.62384|
| 1        | Southbound | 16014    | Michigan & 23rd Street |  41.85130|  -87.62383|
| 1        | Southbound | 17243    | Michigan & 24th Street |  41.84946|  -87.62383|
| 1        | Southbound | 1602     | Michigan & 25th Street |  41.84723|  -87.62372|

**Set up favorite route**

Get real-time information of your favorite route. You can obtain estimated arrival time, waiting time, travel time, delay and alert message. It also allows users to collect and save the real-time information for a given period in a data frame through calling the function periodically. Note that it is a real-time data, it may generate error message"No service scheduled" when you request at a time out of operation. Or, it may generate error message "No arrival times" if the system has not been updated yet, since the CTA system update the data about once per minute.

``` r
result <- myfavrt(bus = 126, start_id = 36, end_id = 60, interval= 60, times = 5)
knitr::kable(head(result))
```

|  no.| current\_time  | bus\_num | start\_stop\_id | start\_stop\_name         |  end\_stop\_id| end\_stop\_name    | wait\_time\_in\_min | departurel\_time | arrival\_time  | travel\_time\_in\_min | delay | status          |
|----:|:---------------|:---------|:----------------|:--------------------------|--------------:|:-------------------|:--------------------|:-----------------|:---------------|:----------------------|:------|:----------------|
|  126| 20181217 11:17 | 126      | 36              | Jackson + 2609 West Alley |             60| Jackson + Aberdeen | 7                   | 20181217 11:25   | 20181217 11:36 | 11 mins               | FALSE | Planned Reroute |
|  126| 20181217 11:18 | 126      | 36              | Jackson + 2609 West Alley |             60| Jackson + Aberdeen | 6                   | 20181217 11:25   | 20181217 11:36 | 11 mins               | FALSE | Planned Reroute |
|  126| 20181217 11:20 | 126      | 36              | Jackson + 2609 West Alley |             60| Jackson + Aberdeen | 5                   | 20181217 11:25   | 20181217 11:36 | 11 mins               | FALSE | Planned Reroute |
|  126| 20181217 11:20 | 126      | 36              | Jackson + 2609 West Alley |             60| Jackson + Aberdeen | 5                   | 20181217 11:26   | 20181217 11:37 | 11 mins               | FALSE | Planned Reroute |
|  126| 20181217 11:22 | 126      | 36              | Jackson + 2609 West Alley |             60| Jackson + Aberdeen | 4                   | 20181217 11:26   | 20181217 11:37 | 11 mins               | FALSE | Planned Reroute |

**Get Alerts**

Get the alerts of bus number 8.

``` r
result <-get_alert(bus = 8)
knitr::kable(head(result))
```

| Headline                | ShortDescription                                                                          | EventStart | EventEnd |
|:------------------------|:------------------------------------------------------------------------------------------|:-----------|:---------|
| New Schedules in Effect | Beginning Sunday, December 16, updated schedules went into effect for several bus routes. | 2018-12-16 | NA       |

**Get an Overview of Current Bus Alerts**

Obtain an overview of current alerts of all CTA buses through a summary table that provide the count of each type of alerts.

``` r
result <- alertstat()
knitr::kable(head(result), col.names = c("Type", "Frequency"))
```

| Type                |  Frequency|
|:--------------------|----------:|
| Bus Stop Note       |          2|
| Bus Stop Relocation |          8|
| Planned Reroute     |         15|
| Service Change      |         13|
| Special Note        |        136|

Vignettes
---------

Detailed application of functions can be otained through the following:

``` r
# search for general information
vignette("lookup_info", package = "rCTA")
```

``` r
# set up my favorite route
vignette("setup_myfavorite", package = "rCTA")
```

``` r
# get information of alerts
vignette("Alert_info", package = "rCTA")
```

Contact
-------

<yc3539@columbia.edu> or open GitHub issue.
