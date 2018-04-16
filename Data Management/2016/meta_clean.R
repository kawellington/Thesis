# Clean metadata
# Kelsey Wellington
# 1/20/2018

library(dplyr)
library(stringr)

setwd("D:/Data/2016")

clean_meta <- function(meta) {
  meta1 <- select(meta, SourceFile, FileName, Make, Model, DateTimeOriginal,
                  Flash, FirmwareVersion, TriggerMode, Sequence, MoonPhase,
                  AmbientTemperature, InfraredIlluminator, MotionSensitivity,
                  BatteryVoltage, UserLabel, Megapixels, ShutterSpeed) %>%
    rename(make = Make,
           model = Model,
           sequence = Sequence,
           trigger = TriggerMode,
           tempC = AmbientTemperature,
           cell = UserLabel) %>%
    mutate(FirmwareVersion = gsub(" ", ".", FirmwareVersion),
           timeLST = as.POSIXct(DateTimeOriginal, format = "%Y:%m:%d %H:%M:%S",
                                tz = "GMT"),
           dateLST = as.Date(timeLST),
           sequence = gsub(" ", "/", sequence),
           cam_name = gsub("^(.*)(FS\\d+)(.*)$", "\\2", dirname(SourceFile)),
           cam_id = str_extract(c(cam_name), "\\d+"),
           cell = str_extract(cell, "\\d{1}\\d*"))
  meta1 <- meta1[order(as.numeric(as.character(meta1$cam_id))), ]
}

# "cell" column code mostly works -- some have incorrect user labels (look into
# this later)

meta <- read.csv("E:/Data/2016/metadata.csv", as.is = T)

meta_new <- clean_meta(meta)

write.csv(meta_new, "clean_meta.csv", row.names = FALSE)

################################################################################

