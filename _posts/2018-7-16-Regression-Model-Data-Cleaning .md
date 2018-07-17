---
layout: post
title: Regression Model Part 1 - Data Cleaning
---

## Introduction

I am working on a certification for Business Statistics and Analysis.  Most of the courses have been pretty routine.  The first couple were **VERY** basic for someone that has any familiarity with Excel.  
But they do get more interesting as it goes along.  Right now I am in the final course and doing some practical work building regression models.  The first stage of this is to clean the data to make it more 
useful.  Some of this was covered by the assignment instructions, and I won't go over that here.  What I am going to talk about is which variables I **DID** select, and how and why I did any relevant transformations on them.

The data for this assignment is housing pricing data.  The variables include the value of the unit, which is the dependent variable in the model, the age and income of the head of household, various factors about the unit 
such as the type of area it is in (Central City, or elsewhere), the region of the country, utility costs, and other associated costs.  Other included variables describe if the unit is a rental property or is vacant or not.

Several variables could be dismissed out of hand.  The age of the head of household can be dismissed as it contains negative values and unreasonably low values.  Another variable about households that can be dropped is 
the number of people in the home.  The data contains a negative number for any unit that is vacant.  The same goes for several other variables around the household.

## Categorical Variables

In addition to the numerical data there are several categorical variables that can be examined in the model.  The first of these is the type of metropolitan area the unit is located in.  My data key only indicates if 
the area is in the urban core or elsewhere.  Normally one would want to compare urban, suburban, and other areas.  However my key did not indicate which category represents Suburban areas.  However since the professor 
specifically called out that categorical variable I decided to include it.

Another categorical variable is the region of the country where the unit is located.  My data key indicates that these categories represent census regions of the United States.  In this case the Northeast, the Midwest, 
the South, and the West regions.  Thinking about the data I decided that the default category should be the West region.  I based that decision on a couple of factors.  First the real estate prices on the West Coast are 
in an period of sustained growth and are higher than other regions of the country.  Secondly, I live in that region and wanted to compare housing prices here against the other regions.  Finally it doesn't really matter which 
region you make the baseline.  You just have to pick one and remember which is it is.

There is also a categorical variable that indicates if the unit is vacant or not.  This was set to a dummy variable that where a one indicates that the unit is occupied, and zero otherwise.

The final categorical variable is if the unit is adequate or not.  My data key indicates that there are three possible categories for this variable, *adequate*, *moderately adequate*, *severely inadequate*, and *vacant*.  
I decided to collapse this to two categories, **Adequate** and **Other**.

## Numerical Variables

There are several numerical variables that can be used as they are, but not all of them are relevant to the model.  For example there are variables that represent the monthly mortgage cost at various interest rates.  
Well the monthly mortgare cost is a factor, but we don't need four different variables that all represent the same thing.  I elected to use the estimated monthly mortgage payment that was calculated using the median interest 
rate.  Some of the other obvious choices are the number of bed rooms, the total number of rooms, and the estimated monthly utility costs.

## Transformed Variables

This is where we get to the crux of the biscuit.  Several of the available variables were obviously important to the analysis.  But when you look at the distribution of the data, it does not neatly fit into a bell curve.  
The better your variables fit into a bell curve, the better the model will be.  A common way to do this in regression models is to use the natural log of the variable instead.

The first thing I did was check the unit value variable to see how well it fit a bell curve.  I went ahead and created a natural log version of the variable to do the comparison with.  Here are the summary statistics from Excel.

![Summary Statistics for unit value](TimLeber.github.io/images/20180716-Value-Descriptive-Statistics.jpg)

As you can see the data has a very wide swing of values in the provided data.  However when the data is transformed with a log function, the spread becomes much more compact.  You can really see this effect when you render 
a histogram in Excel with a chart output.

![Histogram of unit value](TimLeber.github.io/images/20180716-Value-Histogram.jpg)

![Histogram of unit value - log](TimLeber.github.io/images/20180716-ValueLN-Histogram.jpg)

