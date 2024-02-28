######################################################################
# PMLDSR_0002: More than 2,000 data sets in R
######################################################################

# Set working directory
# Note: either "/" or "\\" as the proper symbol (NOT "\")
setwd("D:/sharing/T001_PMLDSR/PMLDSR_0002")

rm(list = ls())
ls()

# I like to use this package for data processing/analysis
# Fast, convenient and powerful
library(data.table)

# Built-in data sets
library(datasets)



############################
# Check built-in data sets
data()

# Directly use the data set
AirPassengers
# Or
# data("AirPassengers")
# AirPassengers
# Or
# data(AirPassengers)
# AirPassengers


##########################
# Check data sets in specific package
# Note that you need first install this package
data(package = "liver")
# Output in data.frame format
as.data.frame(data(package = "liver")$result)
# Output in data.table format
# I like this way
data.table::as.data.table(data(package = "liver")$result)
# Another way to get data set in specific packages
# Better way: one can check the dimension and other useful information
vcdExtra::datasets(c("liver"))


# library() vs. detach()
# detach("package:liver", character.only = TRUE)


##########################
# Check data sets in loaded packages
as.data.frame(data()$result)
dt <- data.table::as.data.table(data()$result)
dt[, unique(Package)]

# Check data sets in loaded/unloaded packages
as.data.frame(data(package = .packages(all.available = TRUE))$result)
data.table::as.data.table(data(package = .packages(all.available = TRUE))$result)
dt <- data.table::as.data.table(data(package = .packages(all.available = TRUE))$result)
dt[, unique(Package)]




##########################
# Data sets with many rows
# 01: install package
# pak::pkg_install("openintro")
# 02: load package
library(openintro)
# 03: check data sets
dt <- as.data.table(vcdExtra::datasets(c("openintro")))
dt
#             Item      class      dim                                                     Title
#           <char>     <char>   <char>                                                    <char>
#   1:         COL      array     7x13                               OpenIntro Statistics colors
#   2:      IMSCOL      array     8x13            Introduction to Modern Statistics (IMS) Colors
#   3: absenteeism data.frame    146x5                Absenteeism from school in New South Wales
#   4:       acs12 data.frame  2000x13                           American Community Survey, 2012
#   5:  age_at_mar data.frame   5534x1                  Age at first marriage of 5,534 US women.
# ---                                                                                          
# 220:   world_pop data.frame   216x62                                    World Population Data.
# 221:         xom data.frame     98x7                                   Exxon Mobile stock data
# 222:        yawn data.frame     50x2                                 Contagiousness of yawning
# 223:       yrbss data.frame 13583x13           Youth Risk Behavior Surveillance System (YRBSS)
# 224:  yrbss_samp data.frame   100x13 Sample of Youth Risk Behavior Surveillance System (YRBSS)

# How can one know which data set includes the maximum rows
which.max(as.numeric(sapply(strsplit(dt$dim, split = "x"), function(x) x[1])))
# [1] 127
dt[127, ]
#        Item      class       dim                    Title
#      <char>     <char>    <char>                   <char>
# 1: military data.frame 1414593x6 US Military Demographics

# Order by row size
dt[order(as.numeric(sapply(strsplit(dt$dim, split = "x"), function(x) x[1]))), ]


##########################
# Data sets from "The Statistical Sleuth: A Course in Methods of Data Analysis (3rd ed)"
# pak::pkg_install("Sleuth3")
library(Sleuth3)
# case0101
dt <- as.data.table(vcdExtra::datasets(c("Sleuth3")))
dt[order(as.numeric(sapply(strsplit(dt$dim, split = "x"), function(x) x[1]))), ]


#########################
# Data sets from "Linear Models with R"
# pak::pkg_install("faraway")
library(faraway)
dt <- as.data.table(vcdExtra::datasets(c("faraway")))
dt[order(as.numeric(sapply(strsplit(dt$dim, split = "x"), function(x) x[1]))), ]



##########################
# Download data sets
# Interface to the Penn Machine Learning Benchmarks Data Repository
# pak::pkg_install("pmlbr")
library(pmlbr)
# Features and labels in single data frame
dataset_names

yeast <- fetch_data("yeast")
dim(yeast)
head(yeast)


######################################################################
# Great collection for R data sets
# Powerful
# 2,264 data sets (access date: 2024-02-27)
# https://vincentarelbundock.github.io/Rdatasets/articles/data.html 
######################################################################


# Manually collected data sets, PDF and R script can be downloaded from here:
# https://github.com/gudemoingtech/PMLDSR/tree/main/PMLDSR_0002


######################################################################




# Happy to share PMLDSR and Good Luck!



##################################################
##################################################
##################################################