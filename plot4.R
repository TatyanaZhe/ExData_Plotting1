## Coursera
## The "Data Science" Specialization 
## Exploratory data analysis
## Course Project 1 
##------------------------------------------------------------------------------
##------------------------------------------------------------------------------

## Preparation for plotting 

library(plyr)
library(dplyr)

## If necessary txt-file don't exist in working directory 
## foolowing fragment of code 
## will download (if it is necessary) the zip-file into working_directory 
## and unzip its
if( !file.exists("household_power_consumption.txt") ) {
        if ( !file.exists("exdata_data_household_power_consumption.zip") ) {
                ## downloading and unzipping file into 'working_directory/data'
                library(downloader)
                url <- "http://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
                download(url, "exdata_data_household_power_consumption.zip", mode="wb")
                unlink(url)
                rm(url) ## removing spent variable
        }
        unzip("exdata_data_household_power_consumption.zip")
}

## Reading file into data frame
PowerConsump0 <- read.table("household_power_consumption.txt", 
                            header = FALSE, 
                            sep = ";", 
                            skip = 1, 
                            stringsAsFactors = FALSE ## very importent
                            )
## Reading string with names of columns
cnames <- read.table("household_power_consumption.txt", 
                     nrows = 1, 
                     stringsAsFactors = FALSE, ## very importent!
                     sep = ";"
                     )
## Renaming of DF columns
colnames(PowerConsump0) <- cnames 

## Subsetting of rows with necessaries dates
## and pasting of columns 'Date' and 'Time' for following format conversion from char to POSIXlt
data1 <- "1/2/2007"
data2 <- "2/2/2007"
PowerConsump <- 
        PowerConsump0 %>%
        filter(Date==data1 | Date==data2) %>%
        mutate(Time = paste(Date, Time, sep = " ")) %>%
        select(-Date)

## Removing spent variables
rm(PowerConsump0, cnames, data1, data2)

## Format conversion from 'char' to 'POSIXlt'
PowerConsump$Time <- strptime(PowerConsump$Time, 
                              format = "%d/%m/%Y %H:%M:%S",
                              tz = "Europe/Paris" 
                              )
## I set tz = "Europe/Paris"
## because in accordance with Data Set Description on 
## https://archive.ics.uci.edu/ml/datasets/Individual+household+electric+power+consumption
## household is in Clamart, France
## but it is not important for this task

## All columns in data frame are character vectors 
## because in this dataset missing values are coded as character "?".
## For future plotting I convert  
## some character vectors into numeric vectors  
PowerConsump[,2:8] <- apply(PowerConsump[,2:8], MARGIN = 2, FUN = as.numeric)

##------------------------------------------------------------------------------
## plot4
## In accordance with instruction 
## on https://class.coursera.org/exdata-010/human_grading/view/courses/973504/assessments/3/submissions
## I construct the plot with a width of 480 pixels and a height of 480 pixels:
png(file = "plot4.png", width = 480, height = 480, bg = "transparent")
par(mfrow = c(2,2))
with(PowerConsump, {
        # plot 4.1.1
        plot(Time, Global_active_power,  
             col = "black",
             type = "l",
             xlab = "", ylab = "Global Active Power (kilowatts)"
             )
        
        # plot 4.1.2
        plot(Time, Voltage,  
             col = "black",
             type = "l",
             xlab = "datetime", ylab = "Voltage"
             )
        
        # plot 4.2.1
        {plot(Time, Sub_metering_1, 
                type = "l", col = "black",
                xlab = "", ylab = "Energy sub metering")
        lines(Time, Sub_metering_2, 
                type = "l", col = "red",
                xlab = "", ylab = "Energy sub metering")
        lines(Time, Sub_metering_3, 
                type = "l", col = "blue",
                xlab = "", ylab = "Energy sub metering")
        legend("topright", 
                lty = "solid", 
                col = c("black", "red", "blue"), 
                legend = c("Sub_metering_1", "Sub_metering_2","Sub_metering_3"),
                bty = "n"
               )
        }

        # plot 4.2.2
        plot(Time, Global_reactive_power,  
                col = "black",
                type = "l",
                xlab = "datetime", ylab = "Global_reactive_power"
             )
        }
)
dev.off() ## Close the PNG file device
## Now you can view the file 'plot4.png' in working directory on your computer

## removing spent variable
rm(PowerConsump)
