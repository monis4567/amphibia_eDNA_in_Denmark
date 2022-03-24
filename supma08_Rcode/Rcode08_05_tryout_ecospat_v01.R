#install.packages("ecospat")

library(ecospat)
# https://cran.r-project.org/web/packages/ecospat/vignettes/vignette_ecospat_package.pdf
# https://onlinelibrary.wiley.com/doi/pdfdirect/10.1111/ecog.02671
data(ecospat.testData)
names(ecospat.testData)

#head(ecospat.testData,12)
head(ecospat.testNiche.inv,12)
head(ecospat.testNiche.nat,12)

data(ecospat.testNiche.inv)
names(ecospat.testNiche.inv)

#install.packages("rnaturalearthhires", repos = "http://packages.ropensci.org", type = "source")
# # 
library("rnaturalearth")
library("rnaturalearthdata")
library("rnaturalearthhires")
# # Get a map, use a high number for 'scale' for a coarse resolution
# use a low number for scale for a high resolution
# if the map 'world' does not exist, then download it
if (!exists("world"))
{
world <- ne_countries(scale = 10, returnclass = "sf")
}
#
df_Eco.nat <- ecospat.testNiche.nat
# head(df_Eco.nat,12)
df_Eco.nat$dec_lon <- df_Eco.nat$x
df_Eco.nat$dec_lat <- df_Eco.nat$y
mxlat <- max(df_Eco.nat$dec_lat)
mxlon <- max(df_Eco.nat$dec_lon)
milon <- min(df_Eco.nat$dec_lon)
milat <- min(df_Eco.nat$dec_lat)
mxlonp2 <- ceiling(mxlon)+2
mxlatp2 <- ceiling(mxlat)+2
milonp2 <- floor(milon)+2
milatp2 <- floor(milat)+2

library(ggplot2)
# also see : https://github.com/tidyverse/ggplot2/issues/2037
p01 <- ggplot(data = world) +
  geom_sf(color = "black", fill = "azure3") +
  #https://ggplot2.tidyverse.org/reference/position_jitter.html
  geom_point(data = df_Eco.nat, 
             aes(x = dec_lon, y = dec_lat,
                 colour=species_occ)) +
  
  geom_point(data = df_Eco.nat,
             aes(x = dec_lon, y = dec_lat,
                 colour=predictions)) +
  #define limits of the plot
  ggplot2::coord_sf(xlim = c(-180, -40),
                    ylim = c(12, 76),
                    expand = FALSE)
# see the plot
p01


head(df_Eco.nat,6)
#_______________________________________________________________________________
df_Eco.inv <- ecospat.testNiche.inv

df_Eco.inv$dec_lon <- df_Eco.inv$x
df_Eco.inv$dec_lat <- df_Eco.inv$y
#
df_Eco.nat$dstcat <- "nat" 
df_Eco.inv$dstcat <- "inv" 
#
df_Eco <- as.data.frame(rbind(df_Eco.nat, df_Eco.inv))
#
nspo <- length(unique(df_Eco$dstcat))
safe_colorblind_palette <- c("#88CCEE", "#CC6677", "#DDCC77", "#117733", "#332288", "#AA4499", 
                             "#44AA99", "#999933", "#882255", "#6699CC", "#888888")
scbpl <- safe_colorblind_palette
scales::show_col(safe_colorblind_palette)
# see how to make a number of colurs along color range
# https://stackoverflow.com/questions/15282580/how-to-generate-a-number-of-most-distinctive-colors-in-r
cl2 <- colorRampPalette(c(scbpl))( nspo) 
# also see : https://github.com/tidyverse/ggplot2/issues/2037
p01 <- ggplot(data = world) +
  geom_sf(color = "black", fill = "azure3") +
  #https://ggplot2.tidyverse.org/reference/position_jitter.html
  geom_point(data = df_Eco, 
             aes(x = dec_lon, y = dec_lat,
                 colour=dstcat,
                 fill=dstcat,
                 shape=dstcat)) +
  #manually set the pch shape of the points
  scale_shape_manual(values=c(3,21)) +
#https://stackoverflow.com/questions/54078772/ggplot-scale-color-manual-with-breaks-does-not-match-expected-order
# set alpha values for color intensity of fill color in point
  #set the color of the points
  #use alpha to scale the intensity of the color
  scale_fill_manual(values=alpha(
    c(cl2),
    c(0.1)
  )) #+
# see the plot
p01


# #____________________________________________ __________________________________
df_Eco.nat1 <- df_Eco.nat[c("dec_lat", "dec_lon",
                            "species_occ","predictions")]
# http://www.cookbook-r.com/Manipulating_data/Converting_data_between_wide_and_long_format/
# Specify id.vars: the variables to keep but not split apart on
df_Eco.nat2 <- reshape2::melt(df_Eco.nat1, id.vars=c("dec_lon", "dec_lat"))
#head(df_Eco.nat2,12)
colnames(df_Eco.nat2) <- c("dec_lon","dec_lat","dstcat","val")
df_Eco.nat2$val <- as.numeric(df_Eco.nat2$val)
df_Eco.nat2$dstcat <- as.character(df_Eco.nat2$dstcat)
df_Eco.nat2 <- df_Eco.nat2[!df_Eco.nat2$val==0,]
# also see : https://github.com/tidyverse/ggplot2/issues/2037
p02 <- ggplot(data = world) +
  geom_sf(color = "black", fill = "azure3") +
  #https://ggplot2.tidyverse.org/reference/position_jitter.html
  geom_point(data = df_Eco.nat2, 
             aes(x = dec_lon, y = dec_lat,
                 colour=dstcat,
                 shape=dstcat,
                 fill=val)) +
  #manually set the pch shape of the points
  scale_shape_manual(values=c(3,23)) +
  # #define limits of the plot
  ggplot2::coord_sf(xlim = c(-180, -40),
                    ylim = c(12, 76),
                    expand = FALSE)
# see the plot
p02


# # PCA scores for the whole study area
# scores.globclim <- pca.env$li
# # PCA scores for the species native distribution
# scores.sp.nat <- suprow(pca.env,nat[which(nat[,11]==1),3:10])$li
# # PCA scores for the species invasive distribution
# scores.sp.inv <- suprow(pca.env,inv[which(inv[,11]==1),3:10])$li
# # PCA scores for the whole native study area
# scores.clim.nat <- suprow(pca.env,nat[,3:10])$li
# # PCA scores for the whole invaded study area
# scores.clim.inv <- suprow(pca.env,inv[,3:10])$li
# #native range (North America)
# # gridding the native niche
# grid.clim.nat <- ecospat.grid.clim.dyn(glob=scores.globclim,
#                                        glob1=scores.clim.nat,
#                                        sp=scores.sp.nat, R=100,
#                                        th.sp=0)


#________________________________________________________________________________
# Hi Steen,
# 
# yes you can do something like that:
  
data(ecospat.testData)
occ1<-subset(ecospat.testNiche.nat,species_occ==1,select=c(x,y))
occ2<-subset(ecospat.testNiche.nat,predictions>10,select=c(x,y))
glob<-ecospat.testNiche.nat[c("x","y")]

z1 <- ecospat.grid.clim.dyn(glob, glob, occ1, R = 100, kernel.method = "ks")
z2 <- ecospat.grid.clim.dyn(glob, glob, occ2, R = 100, kernel.method = "ks")

plot(z1$z.uncor) # N distribution
plot(z2$z.uncor) # S distribution
ecospat.niche.overlap(z1,z2,cor=F)
ecospat.plot.niche.dyn(z1,z2)


# So this means that environmental axes are just replaced with 
#longitude and latitude, and that the values of the pixels are 
#the (rescaled 0-1) density of occurrence. Note that there is a 
#geomask argument to delimit a background area.The approach works with 
#a dataset of a minimum of 5 occurrences (of course then you have 
#to be aware that the kernel density estimation is very "smoothed").
# 
# I hope that helps,
# cheers,
# Olivier

#2.5.3 Calculate Niche Overlap with ecospat.niche.overlap()
# Compute Schoener's D, index of niche overlap
D.overlap <- ecospat.niche.overlap (z1,z2, cor = TRUE)$D
D.overlap

# The niche overlap between the native and the invaded range is 22%.
# 2.5.4 Perform the Niche Equivalency Test with ecospat.niche.equivalency.test() according
# to Warren et al. (2008)
#It is reccomended to use at least 1000 replications for the equivalency test.
#As an example we used rep= 10, to reduce the computational time.
eq.test <- ecospat.niche.equivalency.test(z1,z2,rep=10,
                                          intersection = 0.1,
                                          overlap.alternative = "higher",
                                          expansion.alternative = "lower",
                                          stability.alternative = "higher",
                                          unfilling.alternative = "lower")

# Niche equivalency test H1: the observed overlap between the native and 
#invaded niche is higher than if
# the two niches are randomized, the niche expansion of the invaded niche is 
#lower, the niche stability is
# higher and the niche unfilling is lower than if the two niches are randomized.
# Plot Equivalency test
ecospat.plot.overlap.test(eq.test, "D", "Equivalency")

# 2.5.5 Perform the Niche Similarity Test with ecospat.niche.similarity.test()
# Shifts randomly on niche (here the invasive niche) in the study area 
#It is recomended to use at least 1000
# replications for the similarity test. As an example we
#used rep = 10, to reduce the computational time.
sim.test <- ecospat.niche.similarity.test(z1,z2,rep=10,
                                          overlap.alternative = "higher",
                                          expansion.alternative = "lower",
                                          stability.alternative = "higher",
                                          unfilling.alternative = "lower",
                                          intersection = 0.1,
                                          rand.type=2)
# Niche similarity test H1: the observed overlap between the native and 
#invaded is higher than randomly
# shifted invasive niches in the invaded study area, the niche 
#expansion of the invaded niche is lower, the
# niche stability is higher and the niche unfilling is lower 
#than if the two niches are randomized.
#Plot Similarity test
ecospat.plot.overlap.test(sim.test, "D", "Similarity")

# 2.5.6 Delimiting niche categories and quantifying niche dynamics in analogue climates
# with ecospat.niche.dyn.index()
# niche.dyn <- ecospat.niche.dyn.index (grid.clim.nat, grid.clim.inv, intersection = 0.1)
# 2.5.6.1 Visualizing niche categories, niche dynamics and climate analogy between ranges
# with ecospat.plot.niche.dyn() Plot niche overlap
ecospat.plot.niche.dyn(z1,z2, quant=0.25, interest=2,
                       title= "Niche Overlap", name.axis1="PC1",
                       name.axis2="PC2")

#ecospat.shift.centroids(scores.sp.nat, scores.sp.inv, scores.clim.nat, scores.clim.inv)
                          
# Plot Similarity test for niche expansion, stability and unfilling
ecospat.plot.overlap.test(sim.test, "expansion", "Similarity")# 


# #____________________________________________ __________________________________
occ1<-subset(ecospat.testNiche.nat,species_occ==1,select=c(x,y))
occ2<-subset(ecospat.testNiche.nat,predictions>10,select=c(x,y))

occ1a40 <-subset(occ1,y>40,select=c(x,y))
occ2b40 <-subset(occ2,y<40,select=c(x,y))

glob<-ecospat.testNiche.nat[c("x","y")]

z1a40 <- ecospat.grid.clim.dyn(glob, glob, occ1a40, R = 100, kernel.method = "ks")
z2b40 <- ecospat.grid.clim.dyn(glob, glob, occ2b40, R = 100, kernel.method = "ks")

plot(z1a40$z.uncor) # N distribution
plot(z2b40$z.uncor) # S distribution
ecospat.niche.overlap(z1a40,z2b40,cor=F)
ecospat.plot.niche.dyn(z1a40,z2b40)
D.overlap_b40 <- ecospat.niche.overlap (z1a40,z2b40, cor = TRUE)$D
D.overlap_b40
eq.test_b40 <- ecospat.niche.equivalency.test(z1a40,z2b40,rep=10,
                                              intersection = 0.1,
                                              overlap.alternative = "higher",
                                              expansion.alternative = "lower",
                                              stability.alternative = "higher",
                                              unfilling.alternative = "lower")
ecospat.plot.overlap.test(eq.test_b40, "D", "Equivalency")
sim.test_b40 <- ecospat.niche.similarity.test(z1a40,z2b40,rep=10,
                                              overlap.alternative = "higher",
                                              expansion.alternative = "lower",
                                              stability.alternative = "higher",
                                              unfilling.alternative = "lower",
                                              intersection = 0.1,
                                              rand.type=2)
ecospat.plot.overlap.test(sim.test_b40, "D", "Similarity")
ecospat.plot.niche.dyn(z1a40,z2b40, quant=0.25, interest=2,
                       title= "Niche Overlap", name.axis1="PC1",
                       name.axis2="PC2")

#ecospat.shift.centroids(scores.sp.nat, scores.sp.inv, scores.clim.nat, scores.clim.inv)

# Plot Similarity test for niche expansion, stability and unfilling
ecospat.plot.overlap.test(sim.test_b40, "expansion", "Similarity")# 


# #____________________________________________ __________________________________

occ1<-subset(ecospat.testNiche.nat,species_occ==1,select=c(x,y))
occ2<-subset(ecospat.testNiche.nat,predictions>10,select=c(x,y))

occ1a40 <-subset(occ1,y>40,select=c(x,y))
occ2b40 <-subset(occ2,y<40,select=c(x,y))

occ1btw40_50 <-subset(occ1,y>40 & y<50,select=c(x,y))
occ2btw40_50 <-subset(occ2,y>40 & y<50,select=c(x,y))

occ1_M <-subset(occ1btw40_50,x>-120 & x<(-80),select=c(x,y))
occ2_M <-subset(occ2btw40_50,x>-120 & x<(-80),select=c(x,y))

glob<-ecospat.testNiche.nat[c("x","y")]

z1_M <- ecospat.grid.clim.dyn(glob, glob, occ1_M, R = 100, kernel.method = "ks")
z2_M <- ecospat.grid.clim.dyn(glob, glob, occ2_M, R = 100, kernel.method = "ks")

plot(z1_M$z.uncor) # N distribution
plot(z2_M$z.uncor) # S distribution
ecospat.niche.overlap(z1_M,z2_M,cor=F)
ecospat.plot.niche.dyn(z1_M,z2_M)
D.overlap_M <- ecospat.niche.overlap (z1_M,z2_M, cor = TRUE)$D
D.overlap_M
eq.test_M <- ecospat.niche.equivalency.test(z1_M,z2_M,rep=10,
                                            intersection = 0.1,
                                            overlap.alternative = "higher",
                                            expansion.alternative = "lower",
                                            stability.alternative = "higher",
                                            unfilling.alternative = "lower")
ecospat.plot.overlap.test(eq.test_M, "D", "Equivalency")
sim.test_M <- ecospat.niche.similarity.test(z1_M,z2_M,rep=10,
                                            overlap.alternative = "higher",
                                            expansion.alternative = "lower",
                                            stability.alternative = "higher",
                                            unfilling.alternative = "lower",
                                            intersection = 0.1,
                                            rand.type=2)
ecospat.plot.overlap.test(sim.test_M, "D", "Similarity")
ecospat.plot.niche.dyn(z1_M,z2_M, quant=0.25, interest=2,
                       title= "Niche Overlap", name.axis1="PC1",
                       name.axis2="PC2")
# Plot Similarity test for niche expansion, stability and unfilling
ecospat.plot.overlap.test(sim.test_M, "expansion", "Similarity")# 

#_______________________________________________________________________________
ecospat.testNiche.nat02 <- ecospat.testNiche.nat
ecospat.testNiche.nat02 <- subset(ecospat.testNiche.nat02,y>40 & y<50)
ecospat.testNiche.nat02 <- subset(ecospat.testNiche.nat02,x>-120 & x<(-80))


#data(ecospat.testData)
occ1<-subset(ecospat.testNiche.nat02,species_occ==1,select=c(x,y))
occ2<-subset(ecospat.testNiche.nat02,predictions>10,select=c(x,y))
glob<-ecospat.testNiche.nat02[c("x","y")]

z1_M <- ecospat.grid.clim.dyn(glob, glob, occ1, R = 100, kernel.method = "ks")
z2_M <- ecospat.grid.clim.dyn(glob, glob, occ2, R = 100, kernel.method = "ks")

plot(z1_M$z.uncor) # N distribution
plot(z2_M$z.uncor) # S distribution
ecospat.niche.overlap(z1_M,z2_M,cor=F)
ecospat.plot.niche.dyn(z1_M,z2_M)

D.overlap_M <- ecospat.niche.overlap (z1_M,z2_M, cor = TRUE)$D
D.overlap_M
eq.test_M <- ecospat.niche.equivalency.test(z1_M,z2_M,rep=10,
                                            intersection = 0.1,
                                            overlap.alternative = "higher",
                                            expansion.alternative = "lower",
                                            stability.alternative = "higher",
                                            unfilling.alternative = "lower")
ecospat.plot.overlap.test(eq.test_M, "D", "Equivalency")
sim.test_M <- ecospat.niche.similarity.test(z1_M,z2_M,rep=10,
                                            overlap.alternative = "higher",
                                            expansion.alternative = "lower",
                                            stability.alternative = "higher",
                                            unfilling.alternative = "lower",
                                            intersection = 0.1,
                                            rand.type=2)
ecospat.plot.overlap.test(sim.test_M, "D", "Similarity")
ecospat.plot.niche.dyn(z1_M,z2_M, quant=0.25, interest=2,
                       title= "Niche Overlap", name.axis1="PC1",
                       name.axis2="PC2")
# Plot Similarity test for niche expansion, stability and unfilling
ecospat.plot.overlap.test(sim.test_M, "expansion", "Similarity")# 


# 
# #____________________________________________ __________________________________
# #
# niche.dyn <- ecospat.niche.dyn.index (grid.clim.nat, grid.clim.inv, intersection = 0.1)
# # 2.5.6.1 Visualizing niche categories, niche dynamics and climate analogy between ranges
# # with ecospat.plot.niche.dyn() Plot niche overlap
# ecospat.plot.niche.dyn(grid.clim.nat, grid.clim.inv, quant=0.25, interest=2,
#                        title= "Niche Overlap", name.axis1="PC1",
#                        name.axis2="PC2")
# ecospat.shift.centroids(scores.sp.nat, scores.sp.inv, scores.clim.nat, scores.clim.inv)
