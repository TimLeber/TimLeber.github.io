---
layout: post
title: Regression Model Part 1 - Data Cleaning
---

I am working on a certification for Business Statistics and Analysis.  Most of the courses have been pretty routine.  The first couple were **VERY** basic for someone that has any familiarity with Excel.  But they do get more interesting as it goes along.  Right now I am in the final course and doing some practical work building regression models.  The first stage of this is to clean the data to make it more useful.  Some of this was covered by the assignment instructions, and I won't go over that here.  What I am going to talk about is which variables I **DID** select, and how and why I did any relevant transformations on them.

The data for this assignment is housing pricing data.  The variables include the value of the unit, which is the dependent variable in the model, the age and income of the head of household, various factors about the unit such as the type of area it is in (Central City, or elsewhere), the region of the country, utility costs, and other associated costs.  Other included variables describe if the unit is a rental property or is vacant or not.

Several variables could be dismissed out of hand.  The age of the head of household can be dismissed as it contains negative values and unreasonably low values.  Another variable about households that can be dropped is the number of people in the home.  The data contains a negative number for any unit that is vacant.  The same goes for several other variables around the household.

## Categorical Variables

In addition to the numerical data there are several categorical variables that can be examined in the model.  The first of these is the type of metropolitan area the unit is located in.  My data key only indicates if the area is in the urban core or elsewhere.  Normally one would want to compare urban, suburban, and other areas.  However my key did not indicate which category represents Suburban areas.  However since the professor specifically called out that categorical variable I decided to include it.

Another categorical variable is the region of the country where the unit is located.  My data key indicates that these categories represent census regions of the United States.  In this case the Northeast, the Midwest, the South, and the West regions.  Thinking about the data I decided that the default category should be the West region.  I based that decision on a couple of factors.  First the real estate prices on the West Coast are in an period of sustained growth and are higher than other regions of the country.  Secondly, I live in that region and wanted to compare housing prices here against the other regions.  Finally it doesn't really matter which region you make the baseline.  You just have to pick one and remember which is it is.

There is also a categorical variable that indicates if the unit is vacant or not.  This was set to a dummy variable that where a one indicates that the unit is occupied, and zero otherwise.

The final categorical variable is if the unit is adequate or not.  My data key indicates that there are three possible categories for this variable, *adequate*, *moderately adequate*, *severely inadequate*, and *vacant*.  I decided to collapse this to two categories, **Adequate** and **Other**.

## Numerical Variables

There are several numerical variables that can be used as they are, but not all of them are relevant to the model.  For example there are variables that represent the monthly mortgage cost at various interest rates.  Well the monthly mortgage cost is a factor, but we don't need four different variables that all represent the same thing.  I elected to use the estimated monthly mortgage payment that was calculated using the median interest rate.  Some of the other obvious choices are the number of bed rooms, the total number of rooms, and the estimated monthly utility costs.

## Transforming Variables

This is where we get to the crux of the biscuit.  Several of the available variables were obviously important to the analysis.  But when you look at the distribution of the data, it does not neatly fit into a bell curve.  The better your variables fit into a bell curve, the better the model will be.  A common way to do this in regression models is to use the natural log of the variable instead.

The first thing I did was check the unit value variable to see how well it fit a bell curve.  I went ahead and created a natural log version of the variable to do the comparison with.  Here are the summary statistics from Excel.

![Summary Statistics for unit value](/images/20180716-value-descriptive-statistics.png)

As you can see the data has a very wide swing of values in the provided data.  However when the data is transformed with a log function, the spread becomes much more compact.  You can really see this when you render a histogram in Excel with a chart output.

![Histogram of unit value](/images/20180716-value-histogram.png)

![Histogram of unit value - log](/images/20180716-valueln-histogram.png)

The result of this that the output from the regression model must be transformed back out of a natural log to be relevant.

At this point I ran an initial regression model to see how well everything fit.  That first run was promising, but with an R Squared of only 0.695 I felt I could do better.

![First Model](/images/20180716-regression-model-1.PNG)

A couple of notes about the highlighted variables in the model.  The first is the OTHERCOST variable with a P-value of 0.05917.  This value exceeds the Alpha for the model of 0.05.  Which means that this variable is not statistically significant to the model and will be discarded.  The other highlighted variable is REGION1, with a P-value of 0.76406.  This also exceeds the Alpha for the model.  We need to remember that this is a categorical variable that shows relevance to the base category, not the model.  Therefore the interpretation is that the unit values in Region 1 are not statistically different than Region 4, the reference region.

The next variable I looked at was the median income of the area.  I ran descriptive statistics of both the raw data and a natural log transform of the data.  Once more the transformed version fit a bell curve much better than the raw version of the data did.  The fair market rent and median mortgage cost also followed that pattern.

The final thing I looked at was the age of the unit.  To find that I took the year the home was built and subtracted it from 2013, which is the year the data represents.  One would expect that to be a major factor in the price of a home.  However the raw data is decidedly not a bell curve.  I tried to transform the data using a natural log, but that didn't work.  The reason is that the data contains zero values, which throw an error in the formula.  The next idea was to means center the data.  This is done by taking the age of the unit and subtracting the average age of the unit population.  This is commonly done for things like height and body mass.  The fit to the curve did not improve at all with the transformation.

Raw Data
![Unit Age Raw](/images/20180716-unitage-histogram.PNG)

Transformed Data
![Unit Mean Centered](/images/20180716-unitage-mc-histogram.PNG)

The result of all this is that the unit age was discarded from the model.  There are probably ways to transform the data into something more suitable for a regression model, but I am not familiar enough with the process to know what they are.

## Final Model

After all of this the variables used in the model to estimate housing prices are as follows:

1. **URBAN** - is the unit in a central region or not
2. **REGION1** - is the unit in Region 1 or not, Region 4 being the default
3. **REGION2** - is the unit in Region 2 or not, Region 4 being the default
4. **REGION3** - is the unit in Region 3 or not, Region 4 being the default
5. **_LMED(LN)_** - the natural log of the median income of the area
6. **_FMR(LN)_** - the natural log of the fair market rent for the unit
7. **BEDRMS** - the number of bedrooms in the unit
8. **OCCUPIED** - is the unit occupied or not
9. **ROOMS** - the number of rooms in the unit
10. **ADEQ** - is the unit adequate or not
11. **UTILITY** - the monthly utility costs of the unit
12. **_COSTMED(LN)_** - the natural log of the median monthly mortgage cost of the unit

I ran the regression model again and came up with the following results.

![Final Regression Model](/images/20180716-regression-model-final.PNG)

As you can see this model has an R Square value of 0.97, which is a much better fit that the first run of the model.  Also all of the variables become significant and there is now a statistical difference in home values between Region 1 and Region 4.

In the end I ran a couple of iterations of the model with Unit Age trying to see if the model would work with it, but the accuracy was not improved.  I knew that from the work I did trying to transform it, but I just thought that it **SHOULD** make a difference.

## Conclusion

Excel can run a regression model for you.  That is what generated the ones you see here.  The important thing to know is what data should be *included* in the model to make sure it is relevant.  It is easy to take a bunch of data and roughly munge it together.  To make a truly useful model you need to think about each variable you wish to include, does it make sense in the model, does it conform to a bell curve, is it statistically relevant to the final output.  Some of you variables may need transformation to better fit the model, while others that you think are important, may not be relevant at all.  Building a model is an iterative process.  You must examine the results of the model to see if they make sense and make adjustments if needed.
