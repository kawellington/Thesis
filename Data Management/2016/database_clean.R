# camera data cleanup
# 1/16/2018

# load packages
library(dplyr)
library(tidyverse)

# read in database
cam16 <- read.csv("cams_2016.csv", header = T, as.is = T)

# select only columns I want
cams <- cam16 %>% select(GMU, Date.deployed, Date.camera.retrieved, Cell.number,
                         Camera.ID.number, UTM.Easting,
                         UTM.Northing, Camera.height..ft.,
                         Camera.distance.to.trail.or.road..ft.,
                         Rendezvous.site.habitat..Y.N.,
                         Closed.lightly.used.road..Y.N.,
                         Hiking.trail..Y.N., Game.trail..Y.N.,
                         Drainage...Hillside...Ridge,
                         Habitat..Mesic.forest..Mountain.forest..Riparian..Xeric.,
                         Canopy.cover..0.25...26.50...51.75...76.100..)

# rename columns
cams <- rename(cams,
               deploy = Date.deployed,
               collect = Date.camera.retrieved,
               cell = Cell.number,
               camID = Camera.ID.number,
               easting = UTM.Easting,
               northing = UTM.Northing,
               hght = Camera.height..ft.,
               dist = Camera.distance.to.trail.or.road..ft.,
               rndSite = Rendezvous.site.habitat..Y.N.,
               road = Closed.lightly.used.road..Y.N.,
               hike_trail = Hiking.trail..Y.N.,
               game_trail = Game.trail..Y.N.,
               habLoc = Drainage...Hillside...Ridge,
               habType = Habitat..Mesic.forest..Mountain.forest..Riparian..Xeric.,
               canopy = Canopy.cover..0.25...26.50...51.75...76.100..)

# organize data
  # convert Y/N rendezvous site to 1/0
cams$rndSite <- as.character(cams$rndSite)
cams$rndSite[cams$rndSite == "Y"] <- 1
cams$rndSite[cams$rndSite == "N/A"] <- 0
cams$rndSite[is.na(cams$rndSite)] <- 0
cams$rndSite <- as.factor(cams$rndSite)

  # organize all trail types, then combine to a single column
cams$road <- as.character(cams$road)
cams$road[cams$road == "Y" | cams$road == "Y (ATV)" | cams$road == "Y "] <- "road"
cams$road[cams$road == "N" | cams$road == "M"] <- NA
cams$road <- as.factor(cams$road)
cams$road <- as.character(cams$road)
cams$road[is.na(cams$road)] = ''

cams$hike_trail <- as.character(cams$hike_trail)
cams$hike_trail[cams$hike_trail == "Y"] <- "hiking trail"
cams$hike_trail[cams$hike_trail == "N" | cams$hike_trail == "M"] <- NA
cams$hike_trail <- as.factor(cams$hike_trail)
cams$hike_trail <- as.character(cams$hike_trail)
cams$hike_trail[is.na(cams$hike_trail)] = ''

cams$game_trail <- as.character(cams$game_trail)
cams$game_trail[cams$game_trail == "Y"] <- "game trail"
cams$game_trail[cams$game_trail == "N"] <- NA
cams$game_trail <- as.factor(cams$game_trail)
cams$game_trail <- as.character(cams$game_trail)
cams$game_trail[is.na(cams$game_trail)] = ''

cams <- cams %>%
  unite(trailLoc, 11:13, sep='', remove = TRUE)

cams$habLoc <- as.character(cams$habLoc)
cams$habLoc <- tolower(cams$habLoc)

cams$habType <- as.character(cams$habType)
cams$habType <- tolower(cams$habType)

cams$hght[46] <- 6
cams$hght[31] <- 7

cams$camID <- as.character(cams$camID)
cams$canopy <- as.character(cams$canopy)

cams <- cams %>%
  mutate(deploy = as.Date(deploy, format = "%m/%d/%Y"),
         collect = as.Date(collect, format = "%m/%d/%Y"))

cams$habLoc[cams$habLoc == "drainage bottom"] <- "drainage"

write.csv(cams, "cam_data16.csv")
