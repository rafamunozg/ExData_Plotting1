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
powerConsumption$TimeFull <- strftime(paste(powerConsumption$Date, powerConsumption$Time), tz = "")


# Draw the plot
png("plot3.png", width = 480, height = 480, units = "px")

plot(powerConsumption$Sub_metering_1, 
     type="l", xaxt="n", 
     col="black", 
     ylab = "Energy sub metering", 
     ylim = c(0,30),
     at=c(0, 10, 20, 30))
legend("topright", inset=.05, cex=0.6, 
       c("Sub_metering_1","Sub_metering_2","Sub_metering_3"), 
       fill=c("black", "red", "blue"))
par(new=T)

plot(powerConsumption$Sub_metering_2, 
     type="l", xaxt="n", 
     col="red", 
     ylab = "Energy sub metering", 
     ylim = c(0,30),
     at=c(0, 10, 20, 30))
par(new=T)

plot(powerConsumption$Sub_metering_3, 
     type="l", xaxt="n", 
     col="blue", 
     ylab = "Energy sub metering", 
     ylim = c(0,30),
     at=c(0, 10, 20, 30))

axis.POSIXct(1, powerConsumption$TimeFull, 
             format="%a", 
             at=seq(as.POSIXct(min(powerConsumption$TimeFull)), 
                    as.POSIXct(max(powerConsumption$TimeFull)), by="hour"))

dev.off()
