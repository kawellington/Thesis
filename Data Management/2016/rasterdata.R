  library(raster)
  library(elevatr)
  
  asp <- raster("F:/Rasters/aspect.tif")
  elev <- raster("F:/Rasters/dem.tif")
  slope <- raster("F:/Rasters/slope.tif")
  
  # Should all be in IDTM, but check
  asp
  elev
  slope
  
  plot(asp)
  plot(elev)
  plot(slope)

################################################################################
#extracting information from rasters
  
points <- newcoords[, -3]

# df_elev_epqs <- get_elev_point(points, prj = "+proj=longlat +datum=WGS84", src = "epqs")
# data.frame(df_elev_epqs)
# camdata <- left_join(cam_dat2, data.frame(df_elev_epqs), by = "longitude")

points <- data[, c(18, 19)]  
  
sppoints <- SpatialPoints(points, proj4string=CRS('+proj=longlat +datum=WGS84'))
tp <- spTransform(sppoints, crs(elev))
elevpoints <- extract(elev, tp)
tp2 <- spTransform(sppoints, crs(slope))
slopepoints <- extract(slope, tp2)
tp3 <- spTransform(sppoints, crs(asp))
asppoints <- extract(asp, tp3)

camdata$elevation <- elevpoints
camdata$slope <- slopepoints
camdata$aspect <- asppoints

write.csv(camdata, "camdata2.csv")
