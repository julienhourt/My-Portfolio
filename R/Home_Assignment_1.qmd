---
title: "Home_Assignment_1"
author: "Julien Hourt"
date: 02/10/2024
description: "<br> Here is my first assignment for the **Programming for Business Analytics** course !"

format:
    html:
      embed-resources: true
      toc: true
      toc-location: left
      toc-depth: 4
      theme: flatly
      
editor: visual

execute: 
  echo: true
  error: true
---

::: callout-warning
Answers are organized around 3 main parts which are: Data preparation, Data analyse and Data visualisation.
:::

## LIBRARIES

```{r}
#| warning: false
library(tidyverse)
library(readxl)
library(gt)
library(lubridate)
library(dplyr)
library(skimr)
library(ggplot2)
```

## 1 - DATA PREPARATION

### 1.1 - Importing the data

```{r}
chicago <- read_excel("Chicago_small.xlsx")
```

In the **Chicago** dataset we have data of criminal incidents in Chicago, detailing the date, type, description, location, and arrest status.

### 1.2 - Head of the data

**How many columns and rows does this data set have ?**

```{r}
print(paste("The dataframe has ", ncol(chicago)," columns and ", nrow(chicago), " rows"))
```

**Head of the data:**

```{r}
chicago |> select(1:5) |> head(10) |> gt()
```

### 1.3 - Cleaning the data

#### 1.3.1 - Columns manipulations

**Removing the "Ward" and "ID" columns and storing the data into a new variable called "chicago_new".**

```{r}
chicago_new <- chicago |> select(-Ward,-ID)
```

**Renaming the column "Domestic" into "Home"**

```{r}
chicago_new <- chicago_new |> rename("Home" = "Domestic")
```

<br> **Dividing "Date" column into "Date" and "Time" columns.**

```{r}
chicago_new <- separate(chicago_new, "Date", c("Date", "Time"), 10)
```

#### 1.3.2 - Format manipulations

**Format of column Date:**

```{r}
#Column "Date"
chicago_new$Date <- mdy(chicago_new$Date)
```

**Format of column Time:** <br> Let's try to transform the date to a 24hrs format, to really understand which hour is the most dangerous without bias.

```{r}
#Column "Time"
#If i would like to do it without taking care of AM and PM, i would do this:
#chicago_new$Time <- hms(chicago_new$Time)

#But let's try to transform it to a 24hrs format: 
chicago_new$Time <-  format(parse_date_time(chicago_new$Time, "%I:%M:%S %p"), "%H:%M:%S")
chicago_new$Time <- hms(chicago_new$Time)
```

::: callout-warning
I received the help of internet to transform hours to a 24hrs format. Especially for the function **parse_date_time** which transform a string into a date format thanks to these parameters : %I for the 12hrs format, %M for minutes, %S for seconds, %p for AM / PM and %H for a 24hrs format.
:::

**The format of columns after modifications:**

```{r}
sapply(chicago_new, class)
```

## 2 - DATA ANALYSE

### 2.1 - Brief analyses

#### 2.1.1 - Number of crimes per year

Creating a new data frame with years and number of crimes

```{r}
#Let's create the group for the tapply function
group_years <- str_sub(chicago_new$Date,1,4)

#Let's count the number of crimes per years
number_of_crimes <- tapply(chicago_new, group_years, count)

#Transformation to a dataframe
number_of_crimes <- as.data.frame(number_of_crimes)

```

Cleaning the new data frame

```{r}
#Cleaning the new dataframe
#reorganization of data
number_of_crimes <- pivot_longer(number_of_crimes,cols = everything(), names_to = "Year", values_to="Number_of_crimes")

#cleaning names and columns
number_of_crimes <- separate(number_of_crimes, "Year", c("X","Year"), 1 )
number_of_crimes <- select(number_of_crimes,-X)
```

Printing data

```{r}
gt(number_of_crimes)
```

::: callout-note
We can notice that the 2017 year is note very relevant in the analysis, and could be removed. Indeed, the data registered in 2017 in our dataset start the 2017-01-01 and end the 2017-01-01.
:::

<br> [**I will create a data visualization of this analysis in the "Data visualization" section**]{style="color:red;"}

#### 2.1.2 - Most dangerous hours

Creating a new data frame with hours and number of crimes

```{r}
#Firstly, we have to create a group of hours for the tapply function.
count_hours <- hour(chicago_new$Time)

#tapply function
dangerous_hour <- tapply(chicago_new, count_hours, count)

#Transformation to a dataframe
dangerous_hour <- as.data.frame(dangerous_hour)
```

Cleaning the new data frame

```{r}
#CLEANING
#reorganization of data
dangerous_hour <- pivot_longer(dangerous_hour, cols = everything(), names_to = "Hour_of_the_day", values_to = "Number_of_crimes")

#cleaning names and columns
dangerous_hour <- separate(dangerous_hour, Hour_of_the_day, c("X","Hour_of_the_day"),1)
dangerous_hour <- select(dangerous_hour,-X)
```

Printing data

**The most dangerous hours are 13h and 15h with 17 crimes.**

```{r}
gt(dangerous_hour)
```

::: callout-warning
The answer takes in consideration the fact we transformed the hours from a **12 hours format** to a **24 hours format**.
:::

[**I will create a data visualization of this analysis in the "Data visualization" section**]{style="color:red;"}

### 2.2 - Exploratory Data Analysis (EDA)

#### 2.2.1 - The data summary

Printing the data summary

```{r}
skim(chicago_new)
```

#### 2.2.2 - Additional analysis

We have some data about the dataset chicago_new but we could go deeper in the analysis. <br>

We could try to cross variables in the analysis to obtain more information. <br>

**Example: What are the number of crimes by category ?** <br> Creating a new data frame with type of crime and number of crimes.

```{r}
crimes_categories <- chicago_new$`Primary Type`
crimes_categories_count <- tapply(chicago_new,crimes_categories, count)

#transform as a data frame
crimes_categories_count <- as.data.frame(crimes_categories_count)
```

Cleaning the new data frame

```{r}
#CLEANING
#reorganization of data
crimes_categories_count <- pivot_longer(crimes_categories_count, cols = everything(), names_to = "Type_of_crime", values_to = "Number_of_crimes")
```

Printing data

```{r}
gt(crimes_categories_count)
```

[**I will create a data visualization of this EDA in the "Data visualization" section**]{style="color:red;"}

#### 2.2.3 - Text summary about the exploratory data analysis

<br> The data in the **chicago_new** table refers to the registered crimes between the 2012-01-09 and the 2017-01-05 in Chicago.<br>

For each crime, we have this data: Date, Time, Type, Description, Location, Arest, Home, Beat, District, Community Area. <br>

Summary: <br> - 200 crimes were registred in Chicago between 2012 and 2017.<br> - 153 on 200 crimes author were not arrested.<br> - The most dangerous hours are 13h and 15h.<br> - The year with the more crimes was 2015 with 49 crimes.<br> - The most common crimes are Theft, Battery and Narcotics with 114 crimes in total (57% of crimes).

## 3 - DATA VISUALISATION

### 3.1 - Number of crimes by year

```{r}
plot(number_of_crimes, type = "l", xlab="Year", ylab="Number of crimes")
```

### 3.2 - Number of crimes by hours

```{r}
plot(dangerous_hour, type = "h", xlab="Hour of the day (24hrs format)", ylab="Number of crimes")
```

### 3.3 - Number of crimes by type of crime

```{r}
ggplot(crimes_categories_count, aes(x = Type_of_crime, y = Number_of_crimes)) +
  geom_bar(stat = "identity") +
  labs(x = "Category of crime", y = "Count of crimes", title = "Count of crimes by type") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
```

## 4 - ADDITIONAL EXERCISE (TASK 3)

### 4.1 - Question

Write a user defined function called AverageVowels, which will calculate the average number of vowels per input string (number of vowels/the length of the input string rounded to 2 decimal places). You should check that the input parameter is string. The function MUST include the for loop! <br>

### 4.2 - Answer

```{r}
AverageVowels <- function(x) {

#Check if x is a string
if (!is.character(x)) {
  stop("Input parameter should be a string !")
}
  
#Variables definition
vowels <- c("a","e","i","o","u","y")
nb_vowels <- 0
nb_char <- 0
x <- tolower(x) #Important to avoid missing a vowel which could be in capital letter.
  
#iteration thanks to a for loop
  for (i in strsplit(x,"")[[1]]) {
    
    if (i %in% vowels) {
      nb_vowels <- nb_vowels + 1
    }
    nb_char <- nb_char + 1
  }
  
#Calculate the average and return it
  average_vowel <- nb_vowels/nb_char
  return(average_vowel)
  
}  
```

### 4.3 - Tests

```{r}
print(paste("John: ", AverageVowels("John")))
print(paste("Jim: ", AverageVowels("Jim")))
print(paste("Eugene: ", AverageVowels("Eugene")))
AverageVowels(12) #Return error as it should.
```
