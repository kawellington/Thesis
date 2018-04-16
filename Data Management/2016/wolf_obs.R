# Build a VERY basic encounter history for the entire 2016 season
# Kelsey Wellington
# 1/24/2018

tia <- read.csv("C:/Users/kelsey.wellington/Desktop/Data/2016/clean_tia.csv", as.is = T)
tia$date <- as.Date(tia$date)

# this bit is unneccessary -- playing around
# cam_lst <- as.character(unique(tia$cam_id)) # creates a vector of all cameras

# a function to fill in a "wolfpresent" column from Timelapse data (thanks, Anna!)
wolfpresent_fn <- function(data) {
  wolfcols <- grep("wolf", names(data), ignore.case = T)
  tmp <- data %>%
    mutate(wolf = apply(.[, wolfcols], 1, sum, na.rm = T),
           wolfpresent = ifelse(wolf > 0, T, ifelse(wolfpresent == F & wolf == 0, F, F)),
           wolfpresent = zoo::na.locf(wolfpresent)) %>%
    select(-wolf)
  return(tmp)
}

# test with fake dataset
# data <- data.frame(wolfAd = c(0, 0, 3, 1, 2, 0),
#                    wolfPup = c(0, 0, 0, 0, 0, 1),
#                    wolfpresent = c(F, F, F, F, F, F))

# filter data by summer season
tia_js <- tia %>%
  filter(between(date, as.Date("2016-07-02"), as.Date("2016-09-14")))

# create empty "wolfpresent" column
tia_js$wolfpresent <- FALSE

wolf <- wolfpresent_fn(tia_js)

# change values to fit occupancy
wolf$wolfpresent[wolf$wolfpresent == FALSE] <- 0
wolf$wolfpresent[wolf$wolfpresent == TRUE] <- 1

# number of wolf photos
wolf_sum <- wolf %>%
  summarize(sum(wolfpresent))

# data frame with only wolf photos
wolf_cams <- wolf[which(wolf$wolfpresent == "1"), ]
wolf_cams$cam_id <- as.factor(wolf_cams$cam_id)
wolf_cams <- wolf_cams[order(as.numeric(as.character(wolf_cams$cam_id))), ]
str(wolf_cams) # gives total number of levels for cam_id, which is the total
# number of cameras
