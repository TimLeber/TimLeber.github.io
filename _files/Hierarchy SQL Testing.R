# set global options

setwd("/Users/Tim/Documents/R/"); 

#library(reshape2);
#library(XLConnect);
#library(ggplot2);
library(plyr);
#library(dplyr);
library(sqldf);
library(jsonlite);
library(curl);
library(lubridate);

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

write.csv(car_parts, "~/R/Output/car_parts.csv");

write.csv(truck_parts, "~/R/Output/truck_parts.csv");


rm(list=ls());
