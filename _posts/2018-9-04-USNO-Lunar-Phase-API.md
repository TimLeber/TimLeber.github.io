---
layout: post
title: US Naval Observatory Lunar Phase API
---

I am teaching myself how to use API calls to pull data into R.  I am starting with the United States Naval Observatory.  They have multiple API's that can be accessed to return a variety of astronomical data.  I am starting with Lunar Phase data because it is pretty simple and useful.

## API Call

The USNO has a pretty good [reference page](http://aa.usno.navy.mil/data/docs/api.php) for their API.  There is a wide assortment of astronomical data available, but I am only going to focus on a few in this, and the next few posts.

## Code

The code to run this extract is pretty simple in *R*.  It does require a few packages beyond the base version of *R*, but all of them are things you should have on hand anyway.

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

moon_call <- paste0("http://api.usno.navy.mil/moon/phase?date=",Q_date,"&nump=48");

moon_json <- fromJSON(moon_call);

moon_phases <- moon_json$phasedata;

moon_phases$moon_dt <- as.Date(moon_phases$date, "%Y %b %d");

moon_phases$moon_dow <- as.POSIXlt(moon_phases$moon_dt)$wday;
moon_phases$next_s_int <- (6 - moon_phases$moon_dow)
moon_phases$next_sat <- moon_phases$moon_dt + moon_phases$next_s_int;

# subselect rows based w/o sql
full_moons2 <- moon_phases[ which(moon_phases$phase=='Full Moon'),]
full_moons2 <- full_moons2[,c(1,4,3,7)];

# subselect rows using sql
full_moons <- sqldf("
  select
    phase,
    moon_dt as full_moon_date__Date ,
    time,
    next_sat as next_saturday__Date
  from moon_phases
  where phase = 'Full Moon'
  order by moon_dt, time",method = "name__class");

```

## What is going on

The first block of code is just setting up some basic options and parameters for the program.  Libraries are called to make functions available, and parameters are set.  I like to do all of this at the top of any program that I write.  Technically you can do these steps anywhere prior to where they are needed.  However, best practice dictates that these all be done at the top so that the next person reading your code does not have to hunt through thousands of lines to find them.

I have also created a user defined function called _recode_phenom_.  This will changes codes that an API returns and translate them into user friendly text.  It is not used in this example, but I didn't want to leave it unexplained.  There will be more details in the post that is relevant.

Now we get to the meat of today's post.  The line ``` moon_call <- paste0("http://api.usno.navy.mil/moon/phase?date=",Q_date,"&nump=48");``` creates the text for the API call.  We pass in _Q_date_ which tells it when we want the data returned to start from, and the final parameter tells the system how many lunar phases that we want.

The next line then uses *jsonlite* to make the API call and it holds the returned data as a list.

![moon phases json list](/images/20180904-moon-phases-raw.PNG)

We only want the data about the moon phases so I created a new dataframe called *moon_phases* and filled it with the phasedata part of the json.

``` moon_phases <- moon_json$phasedata; ```

Once I have that filled I have a little clean-up work to do.  The first thing is that the dates come back as text, we want those to be date values so I convert them from text in the 'YYYY mon dd' format to a date field.  The next thing I want to do is find the next Saturday after the lunar phase.  I do this in three steps.

1. Find the numerical day of the week for the full moon.
2. Subtract that number from 6 to find out how many days until the next Saturday.  The day numbering system in R runs 0-6, Sunday to Saturday.
3. Add the second number to the date to get the next Saturday from the lunar phase.

Finally I want to get a list of only the Full Moons and drop the columns I don't need any more.  There are two ways to do this.  The one that I normally default to is to use SQL and select what I need.  On thing to note is that since the dates are being renamed in the SQL, you have to add the method to the end to preserve the formatting.

You can also use R base functions directly to subset the data based on the values in the *phase* column.  Next you can drop the columns you don't need and change the order.  It is a personal choice, but since this one SQL is the only reason I loaded *sqldf*, I would skip it in production code.

![with SQL](/images/20180904-full-moons.PNG)

![using R base functions](/images/20180904-full-moons2.PNG)

## Conclusion

This is a simple example of how to pull some basic data from an API and do elementary data cleaning on it.  I have a few more examples that will build on this in the next few posts.  I had no particular reason to calculate the next Saturday from the Lunar Phase in this example.  But it is useful to know how to do it for other reasons.
