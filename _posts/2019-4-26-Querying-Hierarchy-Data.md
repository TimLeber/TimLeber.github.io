---
layout: post
title: Querying Hierarchial Data with SQL
---

Hierarchial data is not easy to handle in SQL if it is all contained in the same table.  There are some data base management systems such as IMS that deal with hierarchies well, but those are very rare.

In this example we are going to look at a parts table and extract a part from it, plus all of the sub-parts for that.  This will allow us to check the inventory tables to see if we have all of the parts required to build a specific item.  This example only deals with getting the parts list.  We will then check the inventory tables in future examples.

## Code

This code is pretty basic but it does not hurt to go over the initial phases again.

``` r
# set global options

setwd("/Users/Tim/Documents/R/"); 

library(sqldf);

## This program gets a list of a final product and all of the parts that go into that product from a single parts table

# get data

raw <- read.csv("~/R/Data/Parts_List.csv");

id <- 1;

car_parts <- fn$sqldf("
-- Get the top level part number 
  select * from raw where Part_ID = $id

union
-- get the first level of assemblies for the master part
  SELECT * FROM raw WHERE Parent_ID = $id

union
-- get the first level of sub-assemblies 
  SELECT * FROM raw WHERE Parent_ID IN (
    SELECT Part_ID FROM raw WHERE Parent_ID = $id)

--UNION
-- get the second level of sub-assemblies
--  SELECT * FROM raw WHERE Parent_ID IN (
--    SELECT Part_ID FROM raw WHERE Parent_ID IN (
--      SELECT Part_ID FROM raw WHERE Parent_ID = $id))

--UNION
-- get the second level of sub-assemblies
--  SELECT * FROM raw WHERE Parent_ID IN (
--    SELECT Part_ID FROM raw WHERE Parent_ID IN (
--      SELECT Part_ID FROM raw WHERE Parent_ID IN (
--        SELECT Part_ID FROM raw WHERE Parent_ID = $id)))

-- and so on...

");

# Now let's do the same thing for Truck Parts

id <- 2; # change the top level part we are interested in

truck_parts <- fn$sqldf("
-- Get the top level part number 
  select * from raw where Part_ID = $id

union
-- get the first level of assemblies for the master part
  SELECT * FROM raw WHERE Parent_ID = $id

union
-- get the first level of sub-assemblies 
  SELECT * FROM raw WHERE Parent_ID IN (
    SELECT Part_ID FROM raw WHERE Parent_ID = $id)


");

# output our parts lists
write.csv(car_parts, "~/R/Output/car_parts.csv");

write.csv(truck_parts, "~/R/Output/truck_parts.csv");

# clean up after ourselves
rm(list=ls());

```

## What is going on

# Get Data

The first thing that I do is read in a **CSV** file that contains my raw data and assign it to the data frame _'raw'_.

This data is just an example and is not drawn from any specific place.  But here is a peak at it.  I also set a parameter that is the master part number I am interested in.

![Parts List](/images/20190426-parts-list.PNG)

# Car Parts

The tricky thing is that you need to do a couple of different sorts of querries to get the full parts list.  First you have to get the _Master Part_ by selecting its part number directly.  Then you need to start a series of querries using the Part Number of the Master Part as the Parent Part Number for the assemblies and sub-assemblies of that part.  The first layer is the assemblies that go into the part.  After that you nest progressivly deeper into each level, always using the _Parent_ID_ to make sure you are in the right tree.  This example only goes two levels deep, but you could go any number that you needed.

To make sure that you get everything in one file, the querries are unioned together, but you don't have to do it this way.  We could have just as easily made each part of the union its own data frame and then stuck them all together in the end.  Here is the result of our query.

![Car Parts](/images/20190426-car-parts.PNG)

# Truck Parts

The reason that we used a parameter for the Master Part was so that we could easily re-use the code.  To that end we can just change that id and get a parts list for a truck with the same code.  One thing you may note is that there are fewer items on the list of truck parts.  That is because trucks have a bench seat and no rear seats.

![Truck Parts](/images/20190426-truck-parts.PNG)

## Conclusion

The code required to query a hierarchy from a flat table is not terribly complicated.  The trick will be in resources required to pull recursive data from tables as that can become very expensive.  This example is for when your data is designed as an Adjacency List, other hierarchy structures may require a different solution.  Fortunately the other major forms of table hierarchies are actually easier to get this sort of data from.
