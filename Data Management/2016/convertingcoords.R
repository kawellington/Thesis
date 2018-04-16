library(raster)

# converting all UTMS to lat/long, but points are in two different zones
# must convert!

cam_dat[which(cam_dat$easting < 300000), ]

utm12 <- cam_dat[c(83, 89, 95, 96, 103, 118), ]        
utm11 <- cam_dat[-c(83, 89, 95, 96, 103, 118), ]

utm12 <- utm12[, c(6, 7)]
zone12 <- SpatialPoints(utm12, proj4string=CRS("+proj=utm +zone=12 +datum=WGS84"))
plot(zone12)

utm11 <- utm11[, c(6,7)]
zone11 <- SpatialPoints(utm11, proj4string=CRS("+proj=utm +zone=11 +datum=WGS84"))
plot(zone11)

newdata <- spTransform(zone12, CRS("+proj=longlat +datum=WGS84"))
newdata2 <- spTransform(zone11, CRS("+proj=longlat +datum=WGS84"))

library(maptools)
# merge two data frames
newcoords <- spRbind(newdata, newdata2)
plot(newcoords)

newcoords <- as.data.frame(newcoords)
colnames(newcoords) <- c("longitude", "latitude")
newcoords <- newcoords[order(as.numeric(rownames(newcoords))),,drop=FALSE]
newcoords$cell <- cam_dat$cell

# combine corrected location data with original data frame
cam_dat2 <- left_join(cam_dat, newcoords, by = "cell")

write.csv(cam_dat2, "camdata.csv")
