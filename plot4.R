url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"  
dataFileZip <- "exdata-data-household_power_consumption.zip"
dataFile <- "household_power_consumption.txt"

###  load the data
if (!file.exists(dataFileZip) && !file.exists(dataFile))
  download.file(url, destfile = dataFileZip, method="curl")

if (file.exists(dataFile)) {
  data <- read.table(dataFile, sep = ';', header = TRUE, stringsAsFactors = FALSE, na.strings = "?")
} else if (file.exists(dataFileZip)) {
  con <- unz(dataFileZip, dataFile)
  open(con)
  data <- read.table(con, sep = ';', header = TRUE, stringsAsFactors = FALSE, na.strings = "?")
  close(con)
}

###  keep only the necessary data
data <- data[data$Date == "1/2/2007" | data$Date == "2/2/2007", ]

###  prepare graphic device
png(filename = "plot4.png", width = 480, height = 480)

###  set the layout for multiple panels in the plot
par(mfrow = c(2,2))

###  plot (1,1) - lifted from plot2.R
###  first, convert Date and Time columns into a POSIXlt column 
x <- strptime(paste(data$Date, data$Time), format = "%d/%m/%Y %H:%M:%S")
y <- data$Global_active_power 
plot(x, y,
     type = "l", ylab = "Global Active Power", xlab = "")

###  plot (1,2) - similar to (1,1)
y <- data$Voltage
plot(x, y,
     type = "l", ylab = "Voltage", xlab = "datetime")

###  plot (2,1) - lifted from plot3.R
###  first, convert Date and Time columns into a POSIXlt column 
x <- strptime(paste(data$Date, data$Time), format = "%d/%m/%Y %H:%M:%S")
###  then find the y with max value to size the plot correctly
sm1 <- data$Sub_metering_1
sm2 <- data$Sub_metering_2
sm3 <- data$Sub_metering_3
m <- c(max(sm1), max(sm2), max(sm3))
if (m[1] > m[2]) {
  if (m[1] > m[3]) y <- sm1 
  else if (m[2] > m[3]) y <- sm2
  else y <- sm3
} else {
  if (m[2] > m[3]) y <- sm2
  else y <- sm3
}

plot(x, y,
     type = "n", ylab = "Energy sub metering", xlab = "")
points(x, sm1, col = "black", type = "l")
points(x, sm2, col = "red", type = "l")
points(x, sm3, col = "blue", type = "l")
legend("topright",
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
       col =    c("black",          "red",            "blue"),
       pch = "_", bty = "n")

###  plot (2,2) - similar to (1,2)
y <- data$Global_reactive_power
plot(x, y,
     type = "l", ylab = "Global_reactive_power", xlab = "datetime")


###  save file to disk
dev.off()
