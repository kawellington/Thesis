# Extract metadata from photos
# Kelsey Wellington
# 1/15/2018

library(exifr)

get_meta_fn <- function(dir){
  files <- list.files(path = dir, pattern = ".JPG$", recursive = T, full.names = T)
  meta <- read_exif(files)
  write.csv(meta, file = paste(dir, "metadata.csv", sep = "/"))
  print("Success!")
}

get_meta_fn("D:/2016_cameras")

meta <- read.csv("D:/2016_cameras/FS1/metadata.csv")

