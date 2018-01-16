library(purrr)
library(readr)
library(dplyr)
library(tidyverse)

setwd("D:/Data/2016")

# create a list of all file names
flnms <- list.files(pattern = "csv$", full.names = T)

#create a master spreadsheet
data <- map_df(flnms, read_csv, col_types = cols(default = "c", 
                                                Time = "t", DeleteFlag = "l",
                                                review = "l",
                                                greatpic = "l", elkpresent = "l",
                                                deerpresent = "l", prongpresent ="l",
                                                humanpresent = "l", otherpresent ="l",
                                                ElkSpike = "i", ElkAntlerless = "i",
                                                ElkCalf = "i", MDbuck = "i", 
                                                MDantlerless = "i", MDfawn = "i",
                                                WTDbuck = "i", WTDantlerless = "i",
                                                WTDfawn = "i", MooseBull = "i",
                                                MooseOther = "i", MooseCalf = "i",
                                                PronghornBuck = "i",
                                                PronghornFawn = "i",
                                                BlackBearAdult = "i", 
                                                BlackBearCub = "i", CougarAdult = "i",
                                                CougarKitten = "i", WolfAdult = "i",
                                                WolfPup = "i", other = "i",
                                                uniquemark = "l", PHdoe = "i",
                                                CattleCow = "i", CattleCalf = "i",
                                                ElkRaghorn = "i", ElkBull = "i",
                                                ElkUnkn = "i", WTDunkn = "i",
                                                MDunkn = "i", PHunkn = "i",
                                                MooseUnkn = "i", ElkPedNub = "i",
                                                wolfpresent = "l", cougarpresent = "l", 
                                                blackbearpresent = "l", moosepresent = "l",
                                                bobcatpresent = "l", temperature = "i",
                                                Human = "i"))

#select only desired columns
data <- data[, c(1, 3:5, 18, 19, 35, 36, 39, 40, 46, 47, 59)]

#format date and time, create timestamp column
data$Date <- as.Date(data$Date, format = "%d-%b-%y")
data <- unite(data, timestamp, Date, Time, sep = " ",  remove = FALSE)
data$timestamp <- as.POSIXct(data$timestamp, format = "%F %H:%M:%S")

#fix camera folder labeling
data <- data %>%
  separate(Folder, c("FS", "cam_id"), sep = "S")
data <- data[, -2, drop = FALSE]

#fix column names
names(data) <- c("file", "cam_id", "timestamp", "date", "time", "elk_ant",
                 "elk_calf", "wolf_ad", "wolf_pup", "comment", "opstate",
                 "elk_bull", "elk_unkn", "temp")

#reorder columns
data <- data[order(as.numeric(as.character(data$cam_id))), ]

#save as .csv
data_16 <- write.csv(data, "data_2016.csv", row.names = FALSE)

################################################################################

#separate camera folders by zone

data_16[, "zone"] <- NA

for(i in 1:length(data_16$cam_id)) {
  if(data_16$cam_id[i] >= 1 && data_16$cam_id[i] <= 77) {
    data_16$zone[i] <- "panhandle"
  } else if(data_16$cam_id[i] >= 78 && data_16$cam_id[i] <= 158) {
    data_16$zone[i] <- "salmon"
  } else if(data_16$cam_id[i] >= 159 && data_16$cam_id[i] <= 246) {
    data_16$zone[i] <- "sawtooth"
  }
}

dat16 <- write.csv(data_16, "dat16.csv", row.names = FALSE)

################################################################################

#function for only reading in selected columns -- doesn't work, why?

#ctypes = c("c", "c", "c", "t", "i", "i", "i", "i", "c", "c", "i", "i", "i")
#cnms = c("File", "Folder", "Date", "Time", "ElkAntlerless", "ElkCalf",
#         "WolfAdult", "WolfPup", "comment", "opstate", "ElkBull", "ElkUnkn",
#         "temperature")

#foo <- function(x){
#  flnms <- as.data.frame(flnms)
#  ctypes <- c("c", "c", "c", "t", "i", "i", "i", "i", "c", "c", "i", "i", "i")
#  cnms <- c("File", "Folder", "Date", "Time", "ElkAntlerless", "ElkCalf",
#           "WolfAdult", "WolfPup", "comment", "opstate", "ElkBull", "ElkUnkn",
#           "temperature")
#  out <- readr::read_csv(x, col_types = ctypes) %>%
#    select_(cnms)

#  return(out)
#    }

#for(i in seq_along(flnms)){
#   tt <- read_csv(flnms[i])
#   cat(paste("\n", flnms[i], "columns = ", ncol(tt), "\n"))
#   }
