##Data Import
##Created: Jan 3, 2018 by annaliseblum@gmail.com

setwd("/Users/annalise/Dropbox/research/LF attribution/TrendsAttribution")

#Covariates from USGS GAGESII: Data sets Dataset 4: Imperv-Canopy and Dataset5_LandUse Dataset 10: WaterUse
#get storage from original gagesII files
#loop through years and pull only matching STAID and aggregate - need to know what the variable names mean

#4 Forest Canopy 2001 - 2011 (NLCD), 1974-2012 (NWALT)
imperv_NWALT_1974_2012 = read.table("data/U_S_GeologicalS/Dataset4_Imperviousness-Canopy/imperv_NWALT_1974-2012.txt",sep=",", header=T) 
names(imperv_NWALT_1974_2012) #1974, 1982, 1992, 2002, 2012

#5 Land use
LandUse_NLCD_2001 = read.table("data/U_S_GeologicalS/Dataset5_LandUse/LandUse_NLCD_2001.txt",sep=",", header=T) 

LandUse_NWALT_1974 = read.table("data/U_S_GeologicalS/Dataset5_LandUse/LandUse_NWALT_1974.txt",sep=",", header=T) 
names(LandUse_NWALT_1974)

View(LandUse_NLCD_2001)
names(LandUse_NLCD_2001)

#10 Water use 1985 1990 1995 2000 2005 2010
WaterUse_1985_2010 = read.table("data/U_S_GeologicalS/Dataset10_WaterUse/WaterUse_1985-2010.txt",sep=",", header=T) 
names(WaterUse_1985_2010)



#get flow data from USGS NWIS

#get the STAID
flows <- read.csv(file="data/Sites/annual_low7Qs.csv", header = TRUE, stringsAsFactors = FALSE)
bchar <- read.csv(file="data/Sites/basin_char.csv", header = TRUE, row.names = 1, stringsAsFactors = FALSE)

#remove sites with zeros
flows <- flows[ -c(which(apply(flows,2,min,na.rm=T)<.00001)) ]

parameterCd<-"00060" #set the parameter of interest at cfs

#split in thirds to import
Sitesp1<-Sites1[1:200]
Sitesp2<-Sites1[201:400]
Sitesp3<-Sites1[401:length(Sites1)]

#Get raw daily data - Only want sites with at least 40 years of data - get all, then pare down:
rawDailyData<-readNWISdv(Sitesp1,parameterCd, startDate = "1950-01-01", endDate = "2010-12-31") #statCd = "00003 defaults
rawDailyData2<-readNWISdv(Sitesp2,parameterCd, startDate = "1950-01-01", endDate = "2010-12-31") #statCd = "00003 defaults
rawDailyData3<-readNWISdv(Sitesp3,parameterCd, startDate = "1950-01-01", endDate = "2010-12-31") #statCd = "00003 defaults

#pull just the relevant columns
dailydata<-data.frame(rawDailyData$site_no,rawDailyData$Date,rawDailyData$X_00060_00003)
names(dailydata)<-c("site_no","Date","Flow")
dailydata2<-data.frame(rawDailyData2$site_no,rawDailyData2$Date,rawDailyData2$X_00060_00003)
names(dailydata2)<-c("site_no","Date","Flow")
dailydata3<-data.frame(rawDailyData3$site_no,rawDailyData3$Date,rawDailyData3$X_00060_00003)
names(dailydata3)<-c("site_no","Date","Flow")

##Combine the 3 raw datasets into one with all the data
AllData<-rbind(dailydata1,dailydata2,dailydata3)

#save
save(AllData, file="HCDN2009.rdata")
