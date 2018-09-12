---
layout: post
title: US Naval Observatory Seasons and Sun Moon Times
---

Some other things that the USNO API can give you are the dates and times of the season changes for a year, and the times of solar and lunar events for a given day.  Both of these are pretty simple so I will cover them both today.

## API Call

As stated before, the USNO has a pretty good [reference page](http://aa.usno.navy.mil/data/docs/api.php) for their API.  Today we are going to look at the one for the seasons and the one for the Sun and Moon times.

## Code

The inital set-up of the code is the same as before, but I will skip over the code related to the lunar phases.

``` r
# set global options

setwd("/Users/Tim/Documents/R/"); 

library(plyr);
library(sqldf);
library(jsonlite);
library(curl);
library(lubridate);

## This program makes basic calls to the USNO API to return astronomical data

## set inputs

# get the current system date
curr_date <- Sys.Date();
# format it for the API call
Q_date <- format.Date(curr_date, "%m/%d/%Y"); # put the date into the format used by the API
P_date <- format.Date(curr_date -1, "%m/%d/%Y"); # increment current date by -1 in API format
# format it to just the year for the season API call
q_year <- format.Date(curr_date,"%Y")
lat = "47.39N"     # latitude of Kent, WA
lon = "122.22W"    # longitude of Kent, WA
time_zone <- "-8"  # UTC offset of Kent, WA
loc = "Kent, WA"   # location parameter for Kent, WA

## Functions

recode_phenom <- function(x) {
  # This function will recode the phenom variable from the USNO API to a full text version for easy reading
  
  x[x=="BC"] <- "Begin Civil Twilight"
  x[x=="R"] <- "Rise"
  x[x=="U"] <- "Upper Transit"
  x[x=="S"] <- "Set"
  x[x=="EC"] <- "End Civil Twilight"
  x[x=="L"] <- "Lower Transitt"
  x[x=="**"] <- "Object Continuously Above Horizon"
  x[x=="--"] <- "Object Continuously Below Horizon"
  x[x=="^^"] <- "Object Continuously Above The Twilight Limit"
  x[x=="~~"] <- "Object Continuously Below The Twilight Limit"
  x[is.na(x)] <- "N/A"
  
  return(x)
};

## lunar phase code goes here

## season code

season_call <- paste0("http://api.usno.navy.mil/seasons?year=",q_year,",&tz=",time_zone,"&dst=true")

season_json <- fromJSON(season_call);

seasons <- season_json$data;

seasons$date <- as.Date(paste0(seasons$year, "-", seasons$month, "-", seasons$day),"%Y-%m-%d");

seasons <- seasons[,c(1,6,5)];

## sun/moon code

sunmoon_call <- paste0("http://api.usno.navy.mil/rstt/oneday?date=",Q_date,"&coords=",lat,",",lon,"&tz=",time_zone);

sunmoon_json <- fromJSON(sunmoon_call);

sun <- sunmoon_json$sundata;
sun$object <- rep('Sun',nrow(sun))
sun$date <- rep(Q_date,nrow(sun))
sun <- sun[,c(4,3,1,2)];

moon <- sunmoon_json$moondata;
moon$object <- rep('Moon',nrow(moon))
moon$date <- rep(Q_date,nrow(moon))
moon <- moon[,c(4,3,1,2)];

prevmoon <- sunmoon_json$prevmoondata;
prevmoon$object <- rep('Prior Moon',nrow(prevmoon))
prevmoon$date <- rep(P_date,nrow(prevmoon))
prevmoon <- prevmoon[,c(4,3,1,2)];

sunmoon <- rbind(sun,moon,prevmoon);
sunmoon$date <- as.Date(sunmoon$date, "%m/%d/%Y");

sunmoon$phen <- recode_phenom(sunmoon$phen);
names(sunmoon)[names(sunmoon)=="phen"] <- "Phenomena"

sunmoon <- sunmoon[
  with(sunmoon, order(date, time)),
]

```

## What is going on

# Seasons

In the seasons block I am constructing a an API call using some variables that I set above.  Mainly the _year_ of the query, the _latitude_, _longitude_, and _time zone_ of the location we want the seasons for.  Note this could be any location on the face of the Earth, I am using the proximal location of my address outside of Seattle Washington for this example.  Note that the prior example took a date, and the final example will too.  But the seasons are returned for an entire calendar year.  Once that query string is constructed, it just a matter of passing it to the API and pulling out the data.

Since the API returns the date of the season change as text in three different columns for the year, month, and day we have to change it to a date field we can use.  To do that we paste together the date elements with the proper delimiter and tell **R** that that is a date.

The last thing that we do is rearrange the columns in the data frame into the order that we want and drop columns that we don't in the process.

The resulting data frame looks like this:

![Seasons](/images/20180912-seasons.PNG)

# Sun and Moon

This code is a little trickier only because there is a little more going on, but it is the same thing over and over again.

Once more the first thing that we do is construct the API call.  This uses the _query date_, _latitude_, _longitude_, and _time zone_.  This is then fed to the API which returns a JSON blob with several different data objects in it.  Fortunately these are all pretty much the same thing, but set up slightly differently.

The first data object that we grab is for the #Solar# related times.  One odd thing that about this data is that there is no date returned with the data.  I suppose normally you don't care because you know what day you are interested in.  I however like things to be well described.  For that reason I insert a couple of new columns to the data frame.  The first is simply a label so that we know which object we are dealing with.  In this case the text __'Sun'__ is inserted.  The code will repeat that entry for every row in the data frame.  The next thing that we insert is the __date__ from the query string.  Times are already in the data frame.  Finally we rearrange the columns in the data frame to put them in a logical order.

The same thing is done with the #Lunar# data.  However there is a wrinkle to this data that has to be dealt with.  When the time of the Moon Rise is for the day prior to the query date, an additional data type is included in the JSON blob, that being _sunmoon$prevmoondata_.  The problem is that the date that should be included in this object is ##NOT## the query date, it is the day prior to the query date.  Fortunately we set a variable called #P_date# by subtracting one date from the query date.  So when we have previous moon data, that is the date we append to the data frame.  All other changes are the same.  Please note that if the previous moon occurs on the same calendar day, there will be no prevmoondata to work with.  This will not abend the program, but will throw error messages.

Once we have made all of our data frame changes we have a few more changes to finish the job off.  The first thing we do is create a new data frame by using _rbind_ on the original data frames to stick them together.  We then change the format of the date to make it a little more user friendly.  This is not needed, but it is a nice thing to do for your end users.  That is also why we change the name of one of the columns from "phen" to "Phenomena".

We also want to change the codes that the API gives you for the phenomena into a user friendly format.  We could have constructed a case statement in SQL do do this.  It is better practice to put something that you will have to use often into a function.  This is exactly what the #recode_phenom# function is doing.  You will note that some of the items on the translation list will not apply to the sun and the moon.  The USNO API allows calls for all of the planets, and the Galilean Moons of Jupiter which these codes will apply to.  You should always make functions as generic as possible to maximize reuse of code and standardization.

The last step is to sort them into chronological order using the date and time column in the data frame.  Giving you a final data frame that looks like this:

![Sun and Moon](/images/20180912-sunmoon.PNG)

## Conclusion

The United States Naval Observatory offers a lot of data via API call and this is just a taste of what can be done with it.  The important thing is to know what the format of the returned data is and how best to take advantage of it.  We could use the data from these calls to construct a complete solar/lunar calendar for a specific location on the planet.  Or try and calculate when #Golden Hour# begins and ends at specific locations.  There is a LOT of data available via API calls, so we must learn how to use them to be complete at our jobs.
