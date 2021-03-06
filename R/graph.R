graphOrthographic <- function(nim, uid, modality, imgPath, htmlFile,
                              width=750, height=750, cornerText=NULL,
                              captionText=NULL) {
  zrange <- switch(modality,
                   CT = c(-125, 225) - nim@"scl_inter",
                   PT = quantile(nim[nim > 0], c(.005, .995)),
                   NULL)
  graph <- file.path(imgPath, paste(uid, "ortho.png", sep="_"))
  bitmap(graph, type="pnggray", taa=2)
  par(mfrow=c(1,1), mar=rep(0,4), bg="black")
  orthographic(nim, zlim=zrange, crosshairs=FALSE, text=cornerText)
  dev.off()
  graphImage <- hwriteImage(graph, width=width, height=height, center=TRUE)
  hwrite("", htmlFile, br=TRUE)
  hwrite(c(graphImage, captionText), htmlFile, br=TRUE, dim=c(2,1),
         center=TRUE, border=0, style="text-align:center")
  invisible()
}

graphSliceThickness <- function(nim, uid, imagePositionPatient,
                                movingDimensions, imgPath, htmlFile,
                                width=500, height=500) {
  graph <- paste(uid, "sloc.png", sep="_") 
  bitmap(file.path(imgPath, graph), taa=4, gaa=4)
  par(mfrow=c(1,1), mar=c(5,4,4,2)+.5, bg="white")
  dSL <- abs(diff(imagePositionPatient[,movingDimensions]))
  plot(dSL, ylim=range(range(dSL) * 1.5, 0, 10), 
       xlab="Index", ylab="mm", main="Difference in Slice Location")
  dev.off()
  graphImage <- hwriteImage(graph, width=width, height=height, center=TRUE)
  graphCaption <- "Use this graph to detect inconsistent slice thickness.  All points should be equal and constant."
  hwrite(c(graphImage, graphCaption), htmlFile, br=TRUE, dim=c(2,1),
         center=TRUE, border=0, style="text-align:center")
  invisible()
}

graphSingleSlice <- function(nim, uid, modality, imgPath, htmlFile,
                             width=750, height=750) {
  zrange <- switch(modality,
                   CT = c(-125, 225) - nim@"scl_inter",
                   PT = quantile(nim[nim > 0], c(.005, .995)),
                   NULL)
  graph <- paste(uid, "slice.png", sep="_")
  bitmap(file.path(imgPath, graph), type="pnggray")
  par(mfrow=c(1,1), mar=rep(0,4), bg="black")
  image(nim, plot.type="single", zlim=zrange)
  dev.off()
  graphImage <- hwriteImage(graph, width=width, height=height, center=TRUE)
  graphCaption <- paste("Single slice",
                        ifelse(modality == "CT", " in Hounsfield units.", "."),
                        sep="")
  hwrite(c(graphImage, graphCaption), htmlFile, br=TRUE, dim=c(2,1),
         center=TRUE, border=0, style="text-align:center")
  invisible()
}

graphImagePatientPosition <- function(nim, uid, imagePositionPatient,
                                      sliceLocation, imgPath, htmlFile,
                                      width=512, height=512, ...) {
  graph <- paste(uid, "ipp.png", sep="_") 
  png(file.path(imgPath, graph)) # bitmap(file.path(imgPath, graph), taa=4, gaa=4)
  par(mfrow=c(2,2), oma=c(0,0,2,0), mex=0.85)
  plot(str2time(contentTime)$time, ipp[,1], xlab="Time (julian)",
       ylab="ImagePositionPatient[, 1]", cex=0.5)
  plot(str2time(contentTime)$time, ipp[,2], xlab="Time (julian)",
       ylab="ImagePositionPatient[, 2]", cex=.5)
  plot(str2time(contentTime)$time, ipp[,3], xlab="Time (julian)",
       ylab="ImagePositionPatient[, 3]", cex=.5)
  mtext(outer=TRUE, side=3, fname, cex=1.2)
  sliceLocation <- extractHeader(uid.dcm$hdr, "SliceLocation")
  plot(str2time(contentTime)$time, sliceLocation, xlab="Time (julian)",
           ylab="SliceLocation", cex=.5)

  par(mfrow=c(1,1), mar=c(5,4,4,2)+.5, bg="white")
  dSL <- abs(diff(imagePositionPatient[,movingDimensions]))
  plot(dSL, ylim=range(range(dSL) * 1.5, 0, 10), 
       xlab="Index", ylab="mm", main="Difference in Slice Location")
  dev.off()
  graphImage <- hwriteImage(graph, width=width, height=height, center=TRUE)
  graphCaption <- "Use this graph to detect inconsistent slice thickness.  All points should be equal and constant."
  hwrite(c(graphImage, graphCaption), htmlFile, br=TRUE, dim=c(2,1),
         center=TRUE, border=0, style="text-align:center")
  invisible()
}

