#Oct 31, 2014
#kac - contact kimberly.cressman@dmr.ms.gov if you have problems with this script
#Script to make graphs of raw EXO files that have been exported to csv
#MAKE SURE THERE IS ONLY ONE ROW OF COLUMN NAMES.
#You'll have to delete a LOT of rows at the top to make this happen.

#This script is based on files that use psu and FNU as units for salinity and turbidity, respectively.
#If you are using ppt and/or NTU, scroll down to the graph part and change those units.

#Reset R's Brain
rm(list=ls())

#Find out where R is looking for files
getwd()

#Set where R ~should~ look for files
#note the forward slashes - you may have trouble if you just copy and paste from windows explorer, as it may use backslashes
setwd("C:/Users/kimberly.cressman/Desktop/R sonde graphing")

#Make sure R is now looking in the right place
getwd()

#read in the dataset
#make sure the name in quotes retains the .csv
ysi.data <- read.csv("GNDPCWQ082115.csv")

names(ysi.data)

#make titles for the graphs and pdf file
Title <- "PCWQ082115"
pdf(file="PCWQ082115.pdf") #pdf file will be saved in the same directory from which you pulled the csv file
#you will not see graphs as they're made when the pdf printer is on

#------------------------------------
#you can stop modifying here unless you want to play with graph settings or need to change units
#------------------------------------

#combine date and time into DateTime 
ysi.data$DateTime <- paste(ysi.data$Date..MM.DD.YYYY., ysi.data$Time..HH.MM.SS.)

#format as POSIXct, which will turn it into a number that can be graphed
#we are retaining the format of mm/dd/yyyy hh:mm
ysi.data$DateTime <- as.POSIXct(ysi.data$DateTime, format = "%m/%d/%Y %H:%M")

#check data to make sure it looks the way you think it should
names(ysi.data)   #column names
str(ysi.data)    #names; format (number, date, factor, character, etc.); first few values
head(ysi.data)    #returns the first 6 rows of data, so you can make sure things were read in correctly


#make the layout 4 rows and 2 columns so all graphs will fit on a page
#look up ?par and scroll to mai and mar for more info on margins
par(mfcol=c(4,2), mar=c(1, 4, 1.5, 1))

#make line graphs; can change colors if you want
#to get a list of R's known colors, type colors() into the console
plot(Temp..C~DateTime, data=ysi.data, type="l", xlab = "", main = Title, col="darkred")
plot(SpCond.mS.cm~DateTime, data=ysi.data, type="l", xlab = "", col="darkblue")
plot(Sal.psu~DateTime, data=ysi.data, type="l", xlab = "", col="darkgreen")
plot(Depth.m~DateTime, data=ysi.data, type="l", xlab = "", col="darkslategray")
plot(ODO...sat~DateTime, data=ysi.data, type="l", xlab = "", col="darkorange")
plot(ODO.mg.L~DateTime, data=ysi.data, type="l", xlab = "", col="darkmagenta")
plot(pH~DateTime, data=ysi.data, type="l", xlab = "", col="darkturquoise")
plot(Turbidity.FNU~DateTime, data=ysi.data, type="l", xlab = "", col="darkkhaki")

#reset to one graph per page
par(mfrow=c(1,1))

#turn off pdf printer
dev.off()

#Reset R's Brain
rm(list=ls())