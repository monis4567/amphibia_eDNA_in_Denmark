#!/usr/bin/env Rscript
# -*- coding: utf-8 -*-

#____________________________________________________________________________#
# R-code provided for the project:
# Amphibian_eDNA_assays
# 
#set.seed(123)
# Make random numbers for the A and C cluster of points
ax <- runif(6,10,20)
ay <- runif(6,1,11)
cx <- runif(4,10,20)
cy <- runif(4,1,11)
# Make random numbers for the B and D cluster of points
bx <- runif(8,40,50)
by <- runif(8,60,70)
dx <- runif(4,40,50)
dy <- runif(4,60,70)
# bind them to a data frame
df01 <- as.data.frame(cbind(ax,ay,"A","A1"))
df02 <- as.data.frame(cbind(bx,by,"A","B1"))
df03 <- as.data.frame(cbind(cx,cy,"B","C1"))
df04 <- as.data.frame(cbind(dx,dy,"B","D1"))
# change the columns names
colnames(df01) <- c("rx","ry","cl1","cl2")
colnames(df02) <- c("rx","ry","cl1","cl2")
colnames(df03) <- c("rx","ry","cl1","cl2")
colnames(df04) <- c("rx","ry","cl1","cl2")
# bind them to a data frame by adding them as rows
df05 <- rbind(df01,df02,df03,df04)
# make them numeric
df05$rx <- as.numeric(df05$rx)
df05$ry <- as.numeric(df05$ry)
# plot them with ggplot
p <- ggplot(df05, aes(x=rx, y=ry, color=cl1)) + geom_point()
# store the plot under  a different name
p01 <- p
#https://edwardfung2015.blogspot.com/
# Make the data frame a matrix to be able to use the 'kmeans' function
# to be able to infer the center for all the points
m05 <- as.matrix(df05[,1:2])
library(factoextra)
#set.seed(123)
# K-means on faithful dataset
km.res1 <- kmeans(m05, 2)
# identify the clsuters and plot them
fviz_cluster(list(data = m05, cluster = km.res1$cluster),
             ellipse.type = "norm", geom = "point", stand = FALSE)
# get the center for the each of the clusters of points
x2<- km.res1$centers[1,1]
y2<- km.res1$centers[1,2]
x1<- km.res1$centers[2,1]
y1<- km.res1$centers[2,2]
#find midpoint between center of clusters
# which will be the center of the circle on which the clusters are postioned
c <- as.data.frame(midPoint(c(x1,y1),c(x2,y2)))
# find it again without a spheric surface underneath
# use the traditional approach
m1 <- c((x1+x2)/2, (y1+y2)/2)
#make it a data frame to be able to plot it
m2 <- as.data.frame(rbind(m1))
# find distance between two centers - the diameter
di <- sqrt((x1-x2)^2 + (y1-y2)^2)
#find radius
ra <- di/2
#change the column names
colnames(m2) <- c("rx","ry")
# add the center of the clusters to the plot
p <- p + geom_point(data = m2, col = 'blue')
# copy the data frame
m3 <- m2
m4 <- m2
# add a new 'rx' column to each data frame, but this time with the radius added
m3$rx <- m2$rx+ra
m4$rx <- m2$rx-ra
# add these to the plot
p <- p + geom_point(data = m3, col = 'brown')
p <- p + geom_point(data = m4, col = 'black')
# see the plot
#p

#https://www.webmatematik.dk/lektioner/matematik-c/trigonometri/cosinus-og-sinus
#use cos and sin for shifting points
#get function for converting  degress to radians
#https://r-lang.com/how-to-convert-radians-to-degrees-in-r/
# define a function to transform degrees to radians
deg2rad <- function(deg) {
  (deg * pi) / (180)
}
# define a function to transform radians to degrees
rad2deg <- function(rad) {
  (rad * 180) / (pi)
}
#The R trigononometry functions take radians as input
dr <- deg2rad(45)
# 
nx <- m2$rx+ra*cos(dr)
ny <- m2$ry+ra*sin(dr)
#
n2 <- as.data.frame(rbind(c(nx,ny)))
#change the column names
colnames(n2) <- c("rx","ry")
# add the point to the plot
p <- p + geom_point(data = n2, col = 'green')
# see the plot
#p
# subset the data frame 
df05A <- df05[df05$cl2=="D1",]
#df05A <- df05[df05$cl1=="A",]
# find distance between two centers - the radius
# from the center among the cluster of points to the points themselves
df05A$dstc2 <- sqrt((m2$rx-df05A$rx)^2 + (m2$ry-df05A$ry)^2)
#infer the radians from the degrees for the point
# if the common center for the cluster of points is '(a;b)'
# and the coordinate for the original point is '(c;d)'
# and the new coordinate for the shifted point is '(e;f)'
# and the radius 'r' for circle with the center '(a;b)'
# to the point '(c;d)', and the angle for the point '(c;d)'
# is 'theta'
# Then : r*cos(theta)+a = c
# and : r*sin(theta)+b = d
# which means that : c-a = r*cos(theta)
# and : cos^-1((c-a)/r) = theta
# which then needs to be recalculated into radians from degrees, as the
# 'cos' and 'acos' function in R takes radians as input. 
# Notice that in R 'cos^-1' is called 'acos' 
df05A$degpx <- rad2deg(acos((df05A$rx-m2$rx)/df05A$dstc2))
if (df05A$degpx)
  {
  print(df05A$degpx)
}
# acos((df05A$rx-m2$rx)/df05A$dstc2)
# (df05A$rx-m2$rx)/df05A$dstc2
df05A$degpy <- rad2deg(asin((df05A$ry-m2$ry)/df05A$dstc2))
# asin((df05A$ry-m2$ry)/df05A$dstc2)
# (df05A$ry-m2$ry)/df05A$dstc2
#if (df05A$degpy<0) {df05A$degpy <- df05A$degpy+180}
# calculate the new radian by adding the radian inferred for the points
# plus the radian from the degrees the points needs to be shifted
df05A$degrnx <- deg2rad(df05A$degpx+89)
df05A$degrny <- deg2rad(df05A$degpy+89)
#Calculate the new positions by adding coordinates for the common center for the clusters
# with the cos and sin for the new radian, i.e. the radian where the additional 
# shift in degrees have been added
nx <- m2$rx+df05A$dstc2*cos(df05A$degrnx)
ny <- m2$ry+df05A$dstc2*sin(df05A$degrny)
# make it a new data frame
df06 <- df05A
# add the new points as columns. Keep the column names
# to be able to re use the previous ggplot
df06$rx <- nx
df06$ry <- ny
# add the points to the ggplot
p01 <- p01 + geom_point(data = df06, col = 'red3')
p01
#copy data frame
df05B <- df06[,1:2]
#head(df05B,4)
# add a column to give the subset dataset a name
df05B$cl1 <- "C"
# also assign a second name to perhaps use later on
df05B$cl2 <- "E1"
# bind the rows to the data frame
df07 <- as.data.frame(rbind(df05B,df05))
# plot them with ggplot
p02 <- ggplot(df07, aes(x=rx, y=ry, color=cl1)) + geom_point()
p02

# Follow this example to get distances between points
#https://stackoverflow.com/questions/31668163/geographic-geospatial-distance-between-2-lists-of-lat-lon-points-coordinates
#
library(geosphere)
#rename the columns, just to give them names that are easier to relate to mapping
df07$lon <- df07$rx
df07$lat <- df07$ry
#Subset main data frame
df08A <- df07[df07$cl1=="A",]
df08B <- df07[df07$cl1=="B",]
df08C <- df07[df07$cl1=="C",]
# create distance matrix for A and B
matAB <- distm( df08A[,c('lon','lat')], 
                df08B[,c('lon','lat')], 
             fun=distVincentyEllipsoid)
#make the matrix a list, unlist the nested list to get a vector
dstAB <- unlist(as.list(matAB))
# subset to only include below mean
dstABbm <- dstAB[dstAB<mean(dstAB)]
dstABbm <- dstABbm/100000
# see the number of distances in bins and how they are distributed
hist(dstAB)
hist(dstABbm)
# Now try again , but this time compare A with C
# create distance matrix
matAC <- distm( df08A[,c('lon','lat')], 
                df08C[,c('lon','lat')], 
                fun=distVincentyEllipsoid)
#make the matrix a list, unlist the nested list to get a vector
dstAC <- unlist(as.list(matAC))
# see the number of distances in bins and how they are distributed
hist(dstAC)
# subset to only include below mean
dstACbm <- dstAC[dstAC<mean(dstAC)]
dstACbm <- dstACbm/100000
# see the number of distances in bins and how they are distributed
hist(dstACbm)
hist(dstABbm)
# bind vectors into columns, and then bind them by rows, and
# make it a data frame
dstbm01 <- as.data.frame(rbind( cbind(dstABbm,c("AB")),
                                cbind(dstACbm,c("AC"))))
# bind vectors into columns, and then bind them by rows, and
# make it a data frame
dst01 <- as.data.frame(rbind( cbind(dstAB,c("AB")),
                              cbind(dstAC,c("AC"))))
# change the column names
colnames(dst01) <- c("dist","pntseries")
#make the column numeric
dst01$dist <- as.numeric(dst01$dist)
#make a density plot
p03 <- ggplot(dst01, aes(pntseries, fill = pntseries, colour = pntseries)) +
  geom_density(alpha = 0.1)
#make a histogram
p03 <- ggplot(dstbm01, aes(dstABbm, fill = V2, colour = V2)) +
  geom_histogram(bins = 200)
#make a histogram
p03 <- ggplot(dst01, aes(dist, fill = pntseries, colour = pntseries)) +
  geom_histogram(bins = 200)

# Add titles
# see this example: https://www.datanovia.com/en/blog/ggplot-title-subtitle-and-caption/
p02t <- p02 + labs(title = "A - placement of points")#,
p03t <- p03 + labs(title = "B - distance between series of points")#,
#modify the axis labels
p02t <- p02t + xlab("longitude") + ylab("latitude")
# you will have to change the legend for all legends
p02t <- p02t + labs(color='series')
p02t <- p02t + labs(fill='series')
p02t <- p02t + labs(shape='series')
#p02t

library(patchwork)
# on how to arrange plots in patchwork
pA <- p02t +
      p03t +
  
  plot_layout(ncol=1,byrow=T) + #xlab(xlabel) +
  plot_layout(guides = "collect") #+
  #plot_annotation(caption=fnm03) #& theme(legend.position = "bottom")
#p
#make filename to save plot to
figname02 <- paste0("Fig04.png")
wd00 <- "/home/hal9000/Documents/Documents/MS_amphibian_eDNA_assays/amphibia_eDNA_in_Denmark"
setwd(wd00)
bSaveFigures=T
if(bSaveFigures==T){
  ggsave(pA,file=figname02,width=210,height=297,
         units="mm",dpi=300)
}
#