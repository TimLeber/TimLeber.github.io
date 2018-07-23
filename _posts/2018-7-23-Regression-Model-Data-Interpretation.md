---
layout: post
title: Regression Model Part 2 - Interpreting the Model
---

Now that we have selected the data to be used in our model and cleaned it properly.  We have a regression model with a high **R Squared** value of *0.970*.  That seems pretty good, but without an understanding of what the variables in the equation mean it is also useless.  Data is only useful in context and to get that context we must evaluate the variables in the equation to get that context.

I am going to walk through each of the variables and how to understand what they mean and give them context in the model.  Then we will walk through an example using the model to understand the meaning of the model. 

## Data Model

Here is the output from the Excel regression model that we developed last time.

![Regression Model](/images/20180723-regression-model-final.PNG)

We can create an equation of this model to use for making predictions are follows.

![Regression formula](/images/20180723-regression-model-formula.PNG)

## A Few Notes About Variables

### Categorical Variables

As I said in my prior post, some of the variables in our model are categorical in nature.  Meaning that I have set them in such a way so that we can see how the model is affected by things that are not numerical in nature.  Such as is a single family housing unit vacant or not.  These are always to be understood in terms of the affect of the category of interest over the base category.  For simple binary categories such as Vacancy, this is easy.  The category of interest is **Occupied** and the base category is **Vacant**.

The categories get a little more complicated than that if there are several choices.  The source data contains a categorical variable called *REGION* that holds four possible values from 1 to 4.  Each number corresponding to region of the country.  The trick is you need one less categorical variable than the total number of categories to do it correctly.  In our data we have *four* categories so we need **three** categorical variables.  One for each of the first three regions and the fourth region becomes the default category.  When calculating the model, if all three region categorical variables are set to zero, then the model is calculating for the default category, or the base category.

### Transformed Variables

As discussed in a prior post several of the variables in the model have been transformed into the natural log version of themselves to improve the fit to a bell curve.  This will have implications for how the variables are interpreted in the model.  The variable of interest **VALUE** has also been transformed into a natural log and must be raised by exponentiation to get it back to the original format.

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

![Regression formula](/images/20180723-regression-model-formula-substitution.PNG)

A caution about how to interpret these results is that they are not all at the same power.  Some of them can be read as direct percentages and other can not.  The variables that have been transformed into natual logs can be read directly as percentages.  All other variables must be multiplied by 100 to get their percentage impact in the model.  Here is how it works in this model.

![Regression formula](/images/20180723-regression-model-formula-impact.PNG)

## Sample Calculations

To see how all this works to get actual predictions out of the model I have run a few sample calculations using data I pulled from the sample data.  The categorical variables have been assigned a flag for the category we are testing and I have selected an average value for most of the rest.

![Regression formula](/images/20180723-regression-model-calculations.PNG)

## Conclusion

Some things that the model show are pretty self evident.  The **β1 URBAN** variable for example.  Most people looking for family housing want neighbourhoods with good schools and open spaces for the kids to play.  Something that is not very common in urban environments.  Also more bedrooms means a higher price for the home.  Again, this is not unexpected.  The thing I found interesting was the fact that an unoccupied home has a higher value than one with people living there.  There is a *6.514%* impact for the home being vacant verses occupied.  That is quite a jump in terms of real dollars, in my test calculations the impact was **$12,259.65** on the price, all other factors being equal.

All of this is well and good, but since we are making predictions based on the data that built the model we can expect it to be highly accurate.  What we need is to develop a model with the data from one year and then to see how well it predicts the value of single family housing units in another year.  Only then will we know how accurate this model really is.  That will be our next instalment.
