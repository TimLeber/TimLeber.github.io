---
layout: post
title: Regression Model Part 3 - Using The Model For Prediction
---

This model is a pretty good predictor of the value of a single family housing unit in 2013.  But it should be, we are using 2013 data to predict 2013 prices.  This is tantamount to a batter calling his own strike zone.  What we need to do is use data to predict **FUTURE** prices.  What we are doing this time is using the 2011 data to predict the value of the same unit in 2013.

## Data Cleaning

The first thing we have to do is make sure that we doing a pairwise analysis.  What that means is we have to make sure we are using data on a specific housing unit to predict the price of that unit at some future point.  Our source data has a key for the housing units across the years.  So the first thing we do is merge the two data sets together using that key.  In SQL that would be a straightforward join.  But in Excel it is just a bit more complicated.  The way to do it in Excel is to use a VLOOKUP function to pull the 2013 home value into the 2011 data.  We discard any housing units that are not in both data sets, units that are not single family housing, and any units with a very low value.  Pretty much the same data cleaning we did the first time with the added check on making sure the housing unit is available in both files.

We do the same data transformation on the variables that we did the first time, and use the same independent variables.

## Data Model

Now we run a new regression model with the most of the 2011 data and get the following output.  We will address why we say "most of the 2011 data" in a bit.

![Regression Model](/images/20180724-regression-model.PNG)

Notice that the value of **R Square** has dropped quite a bit, it is now _0.589_.  That is lower that before, but still high enough to be a reasonably good model.  I have also labelled the independent variables according to their β designation.

We can create an equation of this model to use for making predictions are follows.

![Regression formula](/images/20180724-regression-model-formula.PNG)

## Elements in the Model

After all of this the variables used in the model to estimate housing prices are as follows:

Variable of Interest **VALUE(LN)** returns the natural log of a single family housing unit from the model **must be raised by exponentiation to get it back to the original format**

1. **Intercept** - the default value of a single family housing unit if all the β variables are zero
2. β1 **URBAN** - is the unit in a central region or not
3. β2 **REGION1** - is the unit in Region 1 or not, Region 4 being the default
4. β3 **REGION2** - is the unit in Region 2 or not, Region 4 being the default
5. β4 **REGION3** - is the unit in Region 3 or not, Region 4 being the default
6. β5 **_LMED(LN)_** - the natural log of the median income of the area **the value used in the model must the natural log of the value you want to test**
7. β6 **_FMR(LN)_** - the natural log of the fair market rent for the unit **the value used in the model must the natural log of the value you want to test**
8. β7 **BEDRMS** - the number of bedrooms in the unit
9. β8 **OCCUPIED** - is the unit occupied or not
10. β9 **ROOMS** - the number of rooms in the unit
11. β10 **ADEQ** - is the unit adequate or not
12. β11 **UTILITY** - the monthly utility costs of the unit
13. β12 **_COSTMED(LN)_** - the natural log of the median monthly mortgage cost of the unit **the value used in the model must the natural log of the value you want to test**

By substituting the values from the model the formula becomes as follows.

![Regression formula](/images/20180724-regression-model-formula-substitution.PNG)

## Checking The Results

When I said that we would use most of the data to run the model there was a good reason for holding some back.  We need to investigate how well the model actually predicts the 2013 value of single family unit housing.  To run that independently we need to have data that is not part of the model to check against.  To that end we selected 1000 records from our data prior to running the model and held the out of the model.  This is called a **Holdout Analysis** and provides and independent check on the model predictions.

After we have the model we then used it to predict the 2013 value of single family housing units using 2011 data.  These results were then checked against the **ACTUAL** 2013 value of those housing units.  Here we can see some of those results.  A few of the values are pretty close and some are pretty far off.  What we need is an objective measure to tell us if we have a good model or not.

![Regression formula](/images/20180724-regression-predictions-vs-actual.PNG)

The measure that is used is called **Mean Absolute Deviation** and is calculated as the average of the absolute difference between the actual and predicted values.  There is a complex formula for doing this, but I found that if I had Excel generate descriptive statistics of the _Absolute Deviation_, it came up with the number for me.

![Regression formula](/images/20180724-regression-mad.PNG)

As you can see the result is that our **Mean Absolute Deviation** is $76,281.76, which seems large, but is only about 31% of the mean value of homes in the holdout sample.

## Conclusion

This brings us to the end of this set of posts on Regression Analysis.  This is a pretty powerful tool to add to your kit for data analysis.  But to really get the full benefits you have to understand what goes into the model and what the various elements of it mean.  It should be noted that one can use Dummy Categorical variables to conduct A/B testing.
