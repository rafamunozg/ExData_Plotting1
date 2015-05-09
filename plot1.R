## Exploratory Data Analysis
## Coursera
## John Hopkins - Bloomberg School
## Assignment 1

#import required packages
library(dplyr)

# 1. Search for 1/2 and 2/2 of 2007 to create a shorter file
# Keep headers as needed
write("Date;Time;Global_active_power;Global_reactive_power;Voltage;Global_intensity;Sub_metering_1;Sub_metering_2;Sub_metering_3", 
      "shorter.csv")

# Filter in a variable to debug if needed
shorter <- grep('^[12]{1}/2/2007.*', 
                readLines("household_power_consumption.txt"), 
                perl=TRUE, value = TRUE, ignore.case = TRUE)

# Add the matches to the file
write(shorter, "shorter.csv", append = TRUE)
rm(shorter)

# Read from the shorter file
powerConsumption <- read.csv("shorter.csv", 
                             header=TRUE, sep=";", 
                             na.strings=c("?"))

# Convert columns to required types
powerConsumption <- mutate(powerConsumption, 
                           Date = as.Date(Date, "%d/%m/%Y"), 
                           TimeStr = paste(powerConsumption$Date, powerConsumption$Time))
powerConsumption$TimeFull <- strftime(paste(powerConsumption$Date, powerConsumption$Time))

# Draw the plot
png("plot1.png", width = 480, height = 480, units = "px")

hist(powerConsumption$Global_active_power, 
     main="Global Active Power", 
     ylab="Frecuency", 
     xlab="Global Active Power (kilowatts)", 
     col="red")

dev.off()