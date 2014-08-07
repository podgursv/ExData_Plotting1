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
png(filename = "plot2.png", width = 480, height = 480)

###  the plot
###  first, convert Date and Time columns into a POSIXlt column 
x <- strptime(paste(data$Date, data$Time), format = "%d/%m/%Y %H:%M:%S")
y <- data$Global_active_power 
plot(x, y,
     type = "l", ylab = "Global Active Power (kilowatts)", xlab = "")

###  save file to disk
dev.off()
