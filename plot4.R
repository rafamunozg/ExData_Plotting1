## Exploratory Data Analysis
## Coursera
## John Hopkins - Bloomberg School
## Assignment 1
Sys.timezone(location = TRUE)

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
png("plot4.png", width = 480, height = 480, units = "px")

par(mfrow = c(2,2), mar=c(4,4,2,1))

# Plot for top-left
plot(as.POSIXct(powerConsumption$TimeFull), powerConsumption$Global_active_power, 
     ylab="Global Active Power (kilowatts)", 
     type="l",
     xaxt="n",
     xlab="")

r <- as.POSIXct(round(range(as.POSIXct(powerConsumption$TimeFull)), "days"))
axis.POSIXct(1, 
             format="%a",
             at=c(seq(r[1], r[2]+1, by = "day")))

# Plot for top-right
plot(as.POSIXct(powerConsumption$TimeFull), powerConsumption$Voltage, 
     ylab="Voltage", 
     type="l",
     xaxt="n",
     xlab="datetime")
axis.POSIXct(1, 
             format="%a",
             at=c(seq(r[1], r[2]+1, by = "day")))

# Plot for bottom-left
plot(as.POSIXct(powerConsumption$TimeFull), powerConsumption$Sub_metering_1, 
     type="l", xaxt="n", yaxt="n",
     col="black", 
     ylab = "Energy sub metering", 
     xlab="",
     ylim = c(0,40))
legend("topright", inset=.02, cex=0.6, 
       c("Sub_metering_1","Sub_metering_2","Sub_metering_3"), 
       fill=c("black", "red", "blue"))
par(new=T)

plot(as.POSIXct(powerConsumption$TimeFull), powerConsumption$Sub_metering_2, 
     type="l", xaxt="n", yaxt="n",
     col="red", 
     ylab = "Energy sub metering", 
     xlab="",
     ylim = c(0,40))
par(new=T)

plot(as.POSIXct(powerConsumption$TimeFull), powerConsumption$Sub_metering_3, 
     type="l", xaxt="n", yaxt="n",
     col="blue", 
     ylab = "Energy sub metering", 
     xlab="",
     ylim = c(0,40))

axis(2, at=c(0, 10, 20, 30))
r <- as.POSIXct(round(range(as.POSIXct(powerConsumption$TimeFull)), "days"))
axis.POSIXct(1, 
             format="%a",
             at=c(seq(r[1], r[2]+1, by = "day")))

# plot for Bottom-right
plot(as.POSIXct(powerConsumption$TimeFull), powerConsumption$Global_reactive_power, 
     ylab="Global_reactive_power", 
     type="l",
     xaxt="n",
     xlab="datetime")

r <- as.POSIXct(round(range(as.POSIXct(powerConsumption$TimeFull)), "days"))
axis.POSIXct(1, 
             format="%a",
             at=c(seq(r[1], r[2]+1, by = "day")))

dev.off()
