# July 27, 2016 
# Updated Sep 1, 2016 
# Script by Kim Cressman, Grand Bay NERR
# kimberly.cressman@dmr.ms.gov
# script to make graphs (8 per page) of WQ data by
# looping through all csv files in a folder


### IMPORTANT
# Make sure the ONLY csv files in the folder you want to work in
# are QC files automatically emailed from the CDMO
# This script has not been error-proofed so if you have a file that it doesn't recognize, the script will stop in its tracks


### IMPORTANT 2
# The folder-choice pop-up does NOT show up on top of other programs
# You MUST either click on the RStudio icon to minimize RStudio OR just minimize everything else to make the pop-up visible 


### INSTRUCTIONS
# 1 - Put your cursor somewhere in this window
# 2 - Push 'Ctrl' + 'A' to select the whole script
# 3 - Push 'Ctrl' + 'R' to run the script
# 4 - Minimize RStudio to get to the pop-up and choose the folder your QC files are in
# 5 - Magic happens
# 6 - Look in the folder you selected and pdf files should be there



# interactively choose which folder you want to work in
library(tcltk) #this package is part of base R and does not need to be installed separately
my.dir <- tk_choose.dir(getwd(), caption = "Choose which folder you want to work in")
setwd(my.dir)

# get the list of files in the directory that you want to graph
names.dir <- dir(pattern = ".csv")
n <- length(names.dir)

for(i in 1:n)
{
  myFile <- names.dir[i] #whatever name is next in the loop

  ysi.data <- read.csv(myFile)
  x <- nchar(myFile) # counting the characters in the file name

  Title = substr(myFile,1,x-4) # this should return the full name of the file (minus '.csv')

  Titlepdf <- paste(Title, ".pdf", sep="")
  
  # open up a pdf file to print to
  pdf(file=Titlepdf) 

  # If there's already a DateTime column, don't do anything. If there's not, paste together Date and Time into DateTime.
  ifelse("DateTime" %in% names(ysi.data), ysi.data$DateTime <- ysi.data$DateTime, ysi.data$DateTime <- paste(ysi.data$Date, ysi.data$Time))
  
  
  # Get dates into the same format and turn them into POSIXct
  
  # Getting dates into the same format is important with the 6600 data files
  ysi.data$DateTimeA <- as.POSIXct(ysi.data$DateTime, format = "%m/%d/%Y %H:%M", tz = 'America/Regina') # Produces NA when format is not "%m/%d/%Y"
  ysi.data$DateTimeB <- as.POSIXct(ysi.data$DateTime, format = "%Y-%m-%d %H:%M", tz = 'America/Regina') # Produces NA when format is not "%Y-%m-%d"
  # replace NAs in A with the NOT-NAs in B
  ysi.data$DateTimeA[is.na(ysi.data$DateTimeA)] <- ysi.data$DateTimeB[!is.na(ysi.data$DateTimeB)]
  # make the whole DateTime column that unified column
  ysi.data$DateTime <- ysi.data$DateTimeA
  
  # the above steps return NAs for 0:00
  
  #make the graph page layout 4 rows and 2 columns so all graphs will fit on a page
  par(mfcol=c(4,2), mar=c(2.1, 4.1, 1.1, 1.1), oma=c(1,1,2,1))
  
  #make line graphs
  plot(Temp~DateTime, data=ysi.data, type="l", xlab = "", xaxt='n', col="darkred")
  axis.POSIXct(1, at=seq(min(ysi.data$DateTime, na.rm=TRUE), max(ysi.data$DateTime, na.rm=TRUE), length.out=5), format="%m/%d", cex.axis=0.9)
  
  plot(SpCond~DateTime, data=ysi.data, type="l", xlab = "", xaxt='n', col="darkblue")
  axis.POSIXct(1, at=seq(min(ysi.data$DateTime, na.rm=TRUE), max(ysi.data$DateTime, na.rm=TRUE), length.out=5), format="%m/%d", cex.axis=0.9)
  
  plot(Sal~DateTime, data=ysi.data, type="l", xlab = "", xaxt='n', col="darkgreen")
  axis.POSIXct(1, at=seq(min(ysi.data$DateTime, na.rm=TRUE), max(ysi.data$DateTime, na.rm=TRUE), length.out=5), format="%m/%d", cex.axis=0.9)
  
  plot(Depth~DateTime, data=ysi.data, type="l", xlab = "", xaxt='n', col="darkslategray")
  axis.POSIXct(1, at=seq(min(ysi.data$DateTime, na.rm=TRUE), max(ysi.data$DateTime, na.rm=TRUE), length.out=5), format="%m/%d", cex.axis=0.9)
  
  plot(DO_pct~DateTime, data=ysi.data, type="l", xlab = "", xaxt='n', col="darkorange")
  axis.POSIXct(1, at=seq(min(ysi.data$DateTime, na.rm=TRUE), max(ysi.data$DateTime, na.rm=TRUE), length.out=5), format="%m/%d", cex.axis=0.9)
  
  plot(DO_mgl~DateTime, data=ysi.data, type="l", xlab = "", xaxt='n', col="darkmagenta")
  axis.POSIXct(1, at=seq(min(ysi.data$DateTime, na.rm=TRUE), max(ysi.data$DateTime, na.rm=TRUE), length.out=5), format="%m/%d", cex.axis=0.9)
  
  plot(pH~DateTime, data=ysi.data, type="l", xlab = "", xaxt='n', col="darkturquoise")
  axis.POSIXct(1, at=seq(min(ysi.data$DateTime, na.rm=TRUE), max(ysi.data$DateTime, na.rm=TRUE), length.out=5), format="%m/%d", cex.axis=0.9)
  
  plot(Turb~DateTime, data=ysi.data, type="l", xlab = "", xaxt='n', col="darkkhaki")
  axis.POSIXct(1, at=seq(min(ysi.data$DateTime, na.rm=TRUE), max(ysi.data$DateTime, na.rm=TRUE), length.out=5), format="%m/%d", cex.axis=0.9)
  
  # put the title of the file above all the plots on the page
  mtext(Title, outer=TRUE, side=3, cex=0.9, font=2)
  
  #turn off pdf printer
  dev.off()
}

#reset to one graph per page
par(mfrow=c(1,1))

print('Finished!')
