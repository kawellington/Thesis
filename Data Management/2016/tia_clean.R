library(purrr)
library(readr)
library(dplyr)
library(tidyverse)
library(lubridate)

setwd("E:/Data/2016/Timelapse")

# create a list of all file names
flnms <- list.files(pattern = "csv$", full.names = T)

#create a master spreadsheet
data <- map_df(flnms, read_csv, col_types = cols(File = "c", RelativePath = "c",
                                                 Folder = "c", Date = "c",
                                                 Time = "t", ImageQuality = "c",
                                                 DeleteFlag = "l", viewer = "c",
                                                 DateProcessed = "c", review = "l",
                                                 greatpic = "l", elkpresent = "l",
                                                 deerpresent = "l", prongpresent ="l",
                                                 humanpresent = "l", otherpresent ="l",
                                                 ElkSpike = "i", ElkAntlerless = "i",
                                                 ElkCalf = "i", MDbuck = "i",
                                                 MDantlerless = "i", MDfawn = "i",
                                                 WTDbuck = "i", WTDantlerless = "i",
                                                 WTDfawn = "i", MooseBull = "i",
                                                 MooseOther = "i", MooseCalf = "i",
                                                 PronghornBuck = "i", PronghornFawn = "i",
                                                 BlackBearAdult = "i", BlackBearCub = "i",
                                                 CougarAdult = "i", CougarKitten = "i",
                                                 WolfAdult = "i", WolfPup = "i",
                                                 other = "i", otherwhat = "c",
                                                 comment = "c", uniquemark = "l",
                                                 PHdoe = "i", CattleCow = "i",
                                                 CattleCalf = "i", ElkRaghorn = "i",
                                                 ElkBull = "i", ElkUnkn = "i",
                                                 YOYcutoff = "c", WTDunkn = "i",
                                                 MDunkn = "i", PHunkn = "i",
                                                 MooseUnkn = "i", ElkPedNub = "i",
                                                 wolfpresent = "l", cougarpresent = "l",
                                                 blackbearpresent = "l", moosepresent = "l",
                                                 bobcatpresent = "l", temperature = "i",
                                                 moonphase = "c", humanwhat = "c",
                                                 Human = "i"))

#save full dataset
write.csv(data, "full_tia.csv", row.names = F)

#select only desired columns, clean up the data
clean_tia <- function(tia){
  tia1 <- tia %>%
    select(File, Folder, Date, Time, ElkAntlerless, ElkCalf, WolfAdult,
           WolfPup, opstate, ElkBull, ElkUnkn, temperature) %>%
    rename(file = File,
           cam_id = Folder,
           date = Date,
           time = Time,
           elkAnt = ElkAntlerless,
           elkCalf = ElkCalf,
           wolfAd = WolfAdult,
           wolfPup = WolfPup,
           opState = opstate,
           elkBull = ElkBull,
           elkUnkn = ElkUnkn,
           tempF = temperature) %>%
    mutate(date = dmy(date)) %>%
    unite(timestamp, date, time, sep = " ", remove = FALSE) %>%
    mutate(timestamp = as.POSIXct(timestamp, format = "%F %H:%M:%S", tz = "GMT"),
           cam_id = gsub("^(FS)(\\d+)$", "\\2", cam_id))
  tia1 <- tia1[order(as.numeric(as.character(tia1$cam_id))), ]
}

tia <- clean_tia(data)

write.csv(tia, "clean_tia.csv", row.names = F)

################################################################################

#separate camera folders by zone

tia[, "zone"] <- NA

for(i in 1:length(tia$cam_id)) {
  if(tia$cam_id[i] >= 1 && tia$cam_id[i] <= 77) {
    tia$zone[i] <- "panhandle"
  } else if(tia$cam_id[i] >= 78 && tia$cam_id[i] <= 158) {
    tia$zone[i] <- "salmon"
  } else if(tia$cam_id[i] >= 159 && tia$cam_id[i] <= 246) {
    tia$zone[i] <- "sawtooth"
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
