# Script to make loop through a folder and make graphs of all raw 6600 csv files
# update 3-22-2017 so you no longer have to delete anything from the raw csv
# contact kimberly.cressman@dmr.ms.gov if you have problems with this script


### IMPORTANT
# The folder-choice pop-up does NOT show up on top of other programs
# You MUST either click on the RStudio icon to minimize RStudio OR just minimize everything else to make the pop-up visible 


### INSTRUCTIONS
# 1 - Put your cursor somewhere in this window
# 2 - Push 'Ctrl' + 'A' to select the whole script
# 3 - Push 'Ctrl' + 'R' to run the script
# 4 - Minimize RStudio to get to the pop-up and choose the folder your files are in
# 5 - Magic happens
# 6 - Look in the folder you selected and pdf files should be there


#Reset R's Brain
rm(list=ls())


# interactively choose which folder you want to work in
library(tcltk) #this package is part of base R and does not need to be installed separately
my.dir <- tk_choose.dir(getwd(), caption = "Set your working directory")
setwd(my.dir)


# get the list of files in the directory that you want to graph
names.dir <- dir(pattern = ".csv")
n <- length(names.dir)


# start the loop
for(i in 1:n)
{
  myFile <- names.dir[i] #whatever name is next in the loop

  # interactively choose the file to work on
  #myFile <-  tk_choose.files(getwd(), caption="Choose file")
  
  # read in a csv, but skip the 2nd row
  all_content <- readLines(myFile)
  skip_second <- all_content[-2]
  ysi.data <- read.csv(textConnection(skip_second), header = TRUE, stringsAsFactors = FALSE)
  
  # generate some names automatically from the original file name
  x <- nchar(myFile) # counting the characters in the file name
  Title = substr(myFile,x-16,x-4) # this should return the full name of the file (minus '.csv')
  Titlepdf <- paste(Title, ".pdf", sep="") #this will be used later for the output file
  
  
  #format Date.Time as POSIXct, which will turn it into a number that can be graphed
  ysi.data$Date.Time <- as.POSIXct(ysi.data$Date.Time, format = "%m/%d/%Y %H:%M")
  
  #check data to make sure it looks the way you think it should
  names(ysi.data)   #column names
  str(ysi.data)    #names; format (number, date, factor, character, etc.); first few values
  head(ysi.data)    #returns the first 6 rows of data, so you can make sure things were read in correctly
  
  # open up a pdf and start graphing
  
  pdf(file=Titlepdf) #pdf file will be saved in the same directory from which you pulled the csv file
  
  #make the graph page layout 4 rows and 2 columns so all graphs will fit on a page
  par(mfcol=c(4,2), mar=c(2.1, 4.1, 1.1, 1.1), oma=c(1,1,2,1))
  
  #make line graphs
  plot(Temp~Date.Time, data=ysi.data, type="l", xlab = "", xaxt='n', col="darkred")
  axis.POSIXct(1, at=seq(min(ysi.data$Date.Time, na.rm=TRUE), max(ysi.data$Date.Time, na.rm=TRUE), length.out=5), format="%m/%d", cex.axis=0.9)
  
  plot(SpCond~Date.Time, data=ysi.data, type="l", xlab = "", xaxt='n', col="darkblue")
  axis.POSIXct(1, at=seq(min(ysi.data$Date.Time, na.rm=TRUE), max(ysi.data$Date.Time, na.rm=TRUE), length.out=5), format="%m/%d", cex.axis=0.9)
  
  plot(Sal~Date.Time, data=ysi.data, type="l", xlab = "", xaxt='n', col="darkgreen")
  axis.POSIXct(1, at=seq(min(ysi.data$Date.Time, na.rm=TRUE), max(ysi.data$Date.Time, na.rm=TRUE), length.out=5), format="%m/%d", cex.axis=0.9)
  
  plot(Depth~Date.Time, data=ysi.data, type="l", xlab = "", xaxt='n', col="darkslategray")
  axis.POSIXct(1, at=seq(min(ysi.data$Date.Time, na.rm=TRUE), max(ysi.data$Date.Time, na.rm=TRUE), length.out=5), format="%m/%d", cex.axis=0.9)
  
  plot(ODOsat~Date.Time, data=ysi.data, type="l", xlab = "", xaxt='n', col="darkorange")
  axis.POSIXct(1, at=seq(min(ysi.data$Date.Time, na.rm=TRUE), max(ysi.data$Date.Time, na.rm=TRUE), length.out=5), format="%m/%d", cex.axis=0.9)
  
  plot(ODO~Date.Time, data=ysi.data, type="l", xlab = "", xaxt='n', col="darkmagenta")
  axis.POSIXct(1, at=seq(min(ysi.data$Date.Time, na.rm=TRUE), max(ysi.data$Date.Time, na.rm=TRUE), length.out=5), format="%m/%d", cex.axis=0.9)
  
  plot(pH~Date.Time, data=ysi.data, type="l", xlab = "", xaxt='n', col="darkturquoise")
  axis.POSIXct(1, at=seq(min(ysi.data$Date.Time, na.rm=TRUE), max(ysi.data$Date.Time, na.rm=TRUE), length.out=5), format="%m/%d", cex.axis=0.9)
  
  plot(Turbid.~Date.Time, data=ysi.data, type="l", xlab = "", xaxt='n', col="darkkhaki")
  axis.POSIXct(1, at=seq(min(ysi.data$Date.Time, na.rm=TRUE), max(ysi.data$Date.Time, na.rm=TRUE), length.out=5), format="%m/%d", cex.axis=0.9)
  
  # put the title of the file above all the plots on the page
  mtext(Title, outer=TRUE, side=3, cex=0.9, font=2)
  
  #reset to one graph per page
  par(mfrow=c(1,1))
  
  #turn off pdf printer
  dev.off()
}

print("Finished!")