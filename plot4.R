#check if a dedicated folder exists for assignment 

if(!file.exists("Exploratory")){ 
        dir.create("./Exploratory")
}

#download zip file and unzip it 
url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(url, destfile ="./Exploratory/elec.zip")
unzip("./Exploratory/elec.zip", exdir = "./Exploratory")

#Calc a rough estimate of required memory
#2,075,259 * 9 * 8 = ~142MB

#reading the full file
elec <- read.csv("./Exploratory/household_power_consumption.txt", sep = ";", na.strings = "?")

#date and time columns 
elec$Date <- as.Date(elec$Date, format = "%d/%m/%Y") 
elec$Time <- as.POSIXct(as.character(elec$Time), format = "%H:%M:%S")

#filtering by dates - only FEB 1st and 2nd are needed 
dates <- seq(as.Date("2007-02-01"), as.Date("2007-02-02"), by = "days")
elec <- filter(elec, Date %in% dates)

#Time column
elec$Time <- strftime(elec$Time, format = "%H:%M:%S")
#combine time and date to datetime
elec$datetime <- as.POSIXct(paste(elec$Date, elec$Time), format="%Y-%m-%d %H:%M:%S")

#plot 4
png(filename = "./Exploratory/plot4.png", width = 480, height = 480)


par(mfrow = c(2,2), mar = c(4,4,2,1), oma = c(0,0,2,0))
with(elec, {
        plot(Global_active_power ~ datetime, type = "l", 
             ylab = "Global Active Power", xlab = "")
        plot(Voltage ~ datetime, type = "l", ylab = "Voltage", xlab = "datetime")
        plot(Sub_metering_1 ~ datetime, type = "l", ylab = "Energy sub metering",
             xlab = "")
        lines(Sub_metering_2 ~ datetime, col = 'Red')
        lines(Sub_metering_3 ~ datetime, col = 'Blue')
        legend("topright", col = c("black", "red", "blue"), lty = 1, lwd = 2, 
               bty = "n",
               legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
        plot(Global_reactive_power ~ datetime, type = "l", 
             ylab = "Global_rective_power", xlab = "datetime")
})

dev.off()
