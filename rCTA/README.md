
<!-- README.md is generated from README.Rmd. Please edit that file -->
rCTA
====

`rCTA` is an R interfact to access the APIs of Chicago Transit Authority(CTA) in order to get real-time information of buses and help users make empowered decisions about their trip.The APIs include **Bus Tracker API** and **Customer Alerts API**. Check out the documentations here:

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

You will need an API key to interact with **Bus Tracker API** on every requrest (Customer Alerts API does not need Authentication). To become authorized, follow the instructions below:

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

You can install the released version of rCTA from **CRAN** with:

``` r
install.packages("rCTA")
```

Or, development version from **GitHub**:

``` r
devtools::install_github("ytingc/rCTA")
```

Then, you can load rCTA package to play with:

``` r
library(rCTA)
```

Basic Features of rCTA pacakge
------------------------------

**Search Stops**

Search for stop information. Useful when stop\_id is unkown. You can specify bus number, and/or stop name, and/or direciton.

``` r
lookupstop(bus = 1, stopname = "Indiana", dir = "Northbound")
```

What is special about using `README.Rmd` instead of just `README.md`? You can include R chunks like so:

``` r
summary(cars)
#>      speed           dist       
#>  Min.   : 4.0   Min.   :  2.00  
#>  1st Qu.:12.0   1st Qu.: 26.00  
#>  Median :15.0   Median : 36.00  
#>  Mean   :15.4   Mean   : 42.98  
#>  3rd Qu.:19.0   3rd Qu.: 56.00  
#>  Max.   :25.0   Max.   :120.00
```

You'll still need to render `README.Rmd` regularly, to keep `README.md` up-to-date.

You can also embed plots, for example:

<img src="man/figures/README-pressure-1.png" width="100%" />

In that case, don't forget to commit and push the resulting figure files, so they display on GitHub!

Vignettes
---------

Detailed information about functions can be otained through the following:

``` r
# search for stop information
vignette("lookupstop", package = "rCTA")
```

``` r
# set up my favorite route
vignette("myfavrt", package = "rCTA")
```

``` r
# get statistical information of alerts
vignette("alertstat", package = "rCTA")
```

Contact
-------

<yc3539@columbia.edu> or open GitHub issue.
