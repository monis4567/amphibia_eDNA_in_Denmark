#!/usr/bin/env Rscript
# -*- coding: utf-8 -*-

#____________________________________________________________________________#
# R-code provided for the project:
# 
#
# “Monitoring distribution of frogs and salamanders using 
#  environmental DNA and citizen science”
#
# Authors: Steen Wilhelm Knudsen, 
#
wd00 <- "/home/hal9000/Documents/Documents/MS_amphibian_eDNA_assays/amphibia_eDNA_in_Denmark"
#wd00 <- rpath
setwd (wd00)
getwd()
#define an output directory
wd09 <- "/supma09_plots_from_R_analysis"
#paste together path
wd00_wd09 <- paste(wd00,wd09,sep="")
#https://www.r-bloggers.com/2014/03/accessing-inaturalist-data/
#https://www.eleanor-jackson.com/post/searching-for-spring/
    options(stringsAsFactors = F)
#get spocc package
if(!require(spocc)){
  install.packages("spocc")
  library(spocc)
}  
#get rinat package
if(!require(rinat)){
  install.packages("rinat")
}  
#load libraries
library("tidyverse")
library("httr")
library("jsonlite")
library("dplyr") 
# to avoid : https://stackoverflow.com/questions/30248583/error-could-not-find-function

#define an input  files
infl1 = "out08_03b_inaturalist_records_amphibia_Denmark.csv"
#infl1 = "out08_03b_inaturalist_records_amphibia_Denmark_1200lines.csv"
infl2 = "out08_01b_DL_records_amphibia_Denmark.csv"
# paste together path and input flie
pthinf01 <- paste0(wd00_wd09,"/",infl1)
pthinf02 <- paste0(wd00_wd09,"/",infl2)
# read in csv files prepared from two previous 
df_iN01 <- read.table(pthinf01,sep=";",stringsAsFactors = F, header=F, fill=T)
df_DL01 <- read.csv(pthinf02,sep=",",stringsAsFactors = F, header=T)
#change columns names
colnames(df_iN01) <- df_iN01[1,]
#remove first row
df_iN01 <- df_iN01[-1,]
#limit to when quality_grade is research
df_iN01 <- df_iN01[df_iN01$quality_grade=="research",]
#make positions numeric
df_iN01$dec_lat <- as.numeric(df_iN01$dec_lat)
df_iN01$dec_lon <- as.numeric(df_iN01$dec_lon)
#make positions numeric
df_DL01$dec_lat <- as.numeric(df_DL01$dec_lat)
df_DL01$dec_lon <- as.numeric(df_DL01$dec_lon)
# add a column for evaluation categories
df_DL01$eval03 <- NA
df_DL01$eval03[df_DL01$eval01=="truezerodetect"] <- "eDNA_zero"
df_DL01$eval03[df_DL01$eval01=="repl2pos"] <- "eDNA_present"
df_DL01$eval03[df_DL01$eval01=="repl1or2"] <- "eDNA_present"
# add a column for the iNaturalist research records
df_iN01$eval03 <- "iNat_Res"
# assign one column to a new column - to retain this new column later on
df_DL01$taxon.name <- df_DL01$latspc2
#define columns to keep
keep <- c("dec_lat",
            "dec_lon",
            "taxon.name",
            "eval03")
#limit data frames to only keep these columns
df_iN02 <- df_iN01[keep]
df_DL02 <- df_DL01[keep]
# bind the two data frames together by appending as rows
df_iNDL02 <- rbind(df_DL02,df_iN02)
#change species names
df_iNDL02$taxon.name <- gsub("Pelophylax esculentus","Pelophylax kl. esculenta",df_iNDL02$taxon.name)
# add a column for evaluation categories
df_iNDL02$pchs <- NA
df_iNDL02$pchs[df_iNDL02$eval03=="eDNA_zero"] <- 3
df_iNDL02$pchs[df_iNDL02$eval03=="eDNA_present"] <- 21
df_iNDL02$pchs[df_iNDL02$eval03=="iNat_Res"] <- 22

# add a column for evaluation categories
df_iNDL02$monit.cat <- NA
df_iNDL02$monit.cat[df_iNDL02$eval03=="eDNA_zero"] <- "eDNA_monit"
df_iNDL02$monit.cat[df_iNDL02$eval03=="eDNA_present"] <- "eDNA_monit"
df_iNDL02$monit.cat[df_iNDL02$eval03=="iNat_Res"] <- "iNat_Res"
#unique(df_iNDL02$monit.cat)
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

# https://uchicagoconsulting.wordpress.com/tag/r-ggplot2-maps-visualization/
#install packages needed
if(!require(maps)){
  install.packages("maps")
  library(maps)
}

if(!require(ggplot2)){
  install.packages("ggplot2")
  library(ggplot2)
}


library(ggplot2)
library(maps)


# # #https://www.r-spatial.org/r/2018/10/25/ggplot2-sf-2.html
# To get rgdal and googleway to work,
#first run these in a terminal:

# $ sudo apt install netcdf-*
# $   sudo apt install libnetcdf-dev
# $ sudo apt install libjq-dev
# $ sudo apt install gdal-bin libgdal-dev libproj-dev
# $ sudo apt install libudunits2-dev
if(!require(cowplot)){
  install.packages("cowplot")
  library(cowplot)
}

if(!require(googleway)){
  install.packages("googleway")
  library(googleway)
}
if(!require(ggrepel)){
  install.packages("ggrepel")
  library(ggrepel)
}
if(!require(ggspatial)){
  install.packages("ggspatial")
  library(ggspatial)
}
# if(!require(libwgeom)){
#   install.packages("libwgeom")
#   library(libwgeom)
# }
if(!require(sf)){
  install.packages("sf")
  library(sf)
}

if(!require(rnaturalearth)){
  install.packages("rnaturalearth")
  library(rnaturalearth)
}
if(!require(rnaturalearthdata)){
  install.packages("rnaturalearthdata")
  library(rnaturalearthdata)
}
#install rgeos
if(!require(rgeos)){
  install.packages("rgeos")
  library(rgeos)
}
#get 'rnaturalearthhires' installed
if(!require(rnaturalearthhires)){
  #install.packages("rnaturalearthhires")
  install.packages("rnaturalearthhires", repos = "http://packages.ropensci.org", type = "source")
  library(rnaturalearthhires)
}
# # 
library("ggplot2")
theme_set(theme_bw())
library("sf")

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

#_______________________________________________________________________________
# start plot with iNaturalist and eDNA monitoring in the same plot
#_______________________________________________________________________________


# get number of unique species names in column
nspo <- length(unique(df_iNDL02$taxon.name))

#get unique species names
ulsp <- unique(df_iNDL02$taxon.name)[order(unique(df_iNDL02$taxon.name))]
# assign letters for species 
letsp <- LETTERS[1:nspo]
df_Lsp <- as.data.frame(cbind(letsp,ulsp))
df_Lsp$Ls3 <- paste0(letsp,")   ",ulsp)
df_iNDL02$latspc3 <- df_Lsp$Ls3[match(df_iNDL02$taxon.name,df_Lsp$ulsp )]
df_iNDL02$lettx <- df_Lsp$letsp[match(df_iNDL02$taxon.name,df_Lsp$ulsp )]


#http://www.cookbook-r.com/Graphs/Colors_(ggplot2)/
# The palette with black:
cbbPalette <- c("#000000", "#E69F00", "#56B4E9", 
                "#009E73", "#F0E442", "#0072B2", 
                #"#D55E00", 
                "#CC79A7")

cl <- cbbPalette
# #variables for legend - not used
cl <- c(colfunc(length(unique(df_iNDL02$taxon.name))))
# Information on colour blind colours
#https://stackoverflow.com/questions/57153428/r-plot-color-combinations-that-are-colorblind-accessible
# using only 14 colours
safe_colorblind_palette <- c("#88CCEE", "#CC6677", "#DDCC77", "#117733", "#332288", "#AA4499", 
                             "#44AA99", "#999933", "#882255", "#661100", "#6699CC", "#888888",
                             "black","pink")
# # using only 11 colours
# safe_colorblind_palette <- c("#88CCEE", "#CC6677", "#DDCC77", "#117733", "#332288", "#AA4499", 
#                              "#44AA99", "#999933", "#882255", "#6699CC", "#888888")
# # using only 11 colours
# safe_colorblind_palette <- c("#88CCEE", "#CC6677", "#DDCC77", "#117733", "#332288", "#AA4499", 
#                              "#44AA99", "#999933", "#882255", "black", "#888888")
scbpl <- safe_colorblind_palette
scales::show_col(safe_colorblind_palette)
# see how to make a number of colurs along color range
# https://stackoverflow.com/questions/15282580/how-to-generate-a-number-of-most-distinctive-colors-in-r
cl2 <- colorRampPalette(c(scbpl))( nspo) 
cl05 <- cl2
#cl2 <- scbpl
#cl <- cl2
#cl05 <- cl
# set a value for jittering the points in the plots
jitlvl <- 0.07
jitlvl <- 0.10


# make a copy of the data frame
df_iNDL03 <- df_iNDL02
df_iNDL03$pchs <- as.factor(df_iNDL03$pchs)
#_______________________________________________________________________________
# Make plot on map with facet wrap - start
#_______________________________________________________________________________
#plot with long species names
p05 <- ggplot(data = world) +
  geom_sf(color = "black", fill = "azure3") +
  #https://ggplot2.tidyverse.org/reference/position_jitter.html
  # use 'geom_jitter' instead of 'geom_point' 
  geom_jitter(data = df_iNDL03, 
              aes(x = dec_lon, y = dec_lat,
                  #df_iNDL03$abbr.nm
                  shape=eval03,
                  color=eval03,
                  fill=taxon.name),
              width = jitlvl, #0.07, jitter width 
              height = jitlvl, #0.07, # jitter height
              size = 2.0) +
  #manually set the pch shape of the points
  scale_shape_manual(values=c(21,3,22)) +
  #set the color of the points
  #here it is black, and repeated the number of times
  #matching the number of species listed
  scale_color_manual(values=c(rep("black",nspo))) +
  #set the color of the points
  #use alpha to scale the intensity of the color
  scale_fill_manual(values=alpha(
    c(cl05),
    c(0.7)
  ))+
  #
  
  #Arrange in facets
  ggplot2::facet_wrap(. ~ lettx + taxon.name,
                      
                      ncol = 5,
                      labeller = label_bquote(cols = .(lettx) ~ .(" ") ~ italic(.(taxon.name))) ) +
  #define limits of the plot
  ggplot2::coord_sf(xlim = c(8, 15.4),
                    ylim = c(54.4, 58.0), 
                    expand = FALSE)
#see the plot
p05

p05t <- p05 +
  guides(
    fill = guide_legend("species"),
    size = guide_legend("species"),
    shape = guide_legend("species")
  )

p05t
#
#change axis labels
p05t <- p05 + xlab("longitude") + ylab("latitude")
#change the header for the legend on the side, 
#this must be done for both 'fill', 'color' and 'shape', to avoid 
#getting separate legends
p05t <- p05t + labs(color='species')
p05t <- p05t + labs(fill='species')
p05t <- p05t + labs(shape='species')

#get the number of species
noofspcsnms <- length(unique(df_iNDL03$taxon.name))
# https://github.com/tidyverse/ggplot2/issues/3492
#repeat 'black' a specified number of times
filltxc = rep("black", noofspcsnms)
#filltxc[10] <- "red"
#filltxc = rep("white", noofspcsnms)
# Label appearance ##http://www.cookbook-r.com/Graphs/Legends_(ggplot2)/
p05t <- p05t + theme(legend.text = element_text(colour=filltxc, size = 10, face = "italic"))

#adjust tick marks on axis
p05t <- p05t + scale_y_continuous(breaks=seq(54.5,58,1))
p05t <- p05t + scale_x_continuous(breaks=seq(8,16,2))
#alter stripes above facet plots
# p05t <- p05t + theme(strip.background =element_rect(fill=c("black")))
# p05t <- p05t + theme(strip.text = element_text(colour = 'white'))
#p05t <- p05t + theme(strip.text = element_blank())
p05t <- p05t + theme(strip.background = element_blank())
# see the plot
p05t

# define whether figures are to be saved or not
bSaveFigures <- T
#substitute in file name
infl1 <- gsub(".csv","",infl1)
#define file name to save plot to
fgnm <- paste0("Fig03_v01_",infl1,".pdf")
#paste the path and the file name together
pfnm <- paste0(wd00_wd09,"/",fgnm)
# save plot
if(bSaveFigures==T){
  ggsave(p05t,file=pfnm,
         #width=210,height=297, # as portrait
         width=297,height=210, # as landscape
         units="mm",dpi=600)
}

#_______________________________________________________________________________
# end plot with iNaturalist and eDNA monitoring in the same plot
#_______________________________________________________________________________

#_______________________________________________________________________________
# start plot with iNaturalist and eDNA monitoring in plots side by side
#_______________________________________________________________________________

#copy data frame
df_iNDL04 <- df_iNDL03

#assign taxon name plus monitoring category
df_iNDL04$txnmc <- paste0(df_iNDL04$taxon.name,".",df_iNDL04$monit.cat)
# re order columns
df_iNDL05 <- df_iNDL04
#colnames(df_iNDL05)
#unique(df_iNDL05$pchs)
# for rows for species not present in the iNaturalist search
# to avoid the facet plot ebds up being without plots needed for iNaturalist records
# nrta <- c(1,1,"Bombina bombina","iNat_Res","iNat_Res",3,"A)   Bombina bombina","A","Bombina bombina.iNat_Res" )
# df_iNDL05 <- rbind(df_iNDL05,nrta)
# nrta <- c(1,1,"Bufo calamita","iNat_Res","iNat_Res",3,"C)   Bufo calamita","C","Bufo calamita.iNat_Res" )
# df_iNDL05 <- rbind(df_iNDL05,nrta)
# nrta <- c(1,1,"Ichthyosaurus alpestris","iNat_Res",3,"iNat_Res","F)   Ichthyosaurus alpestris","F","Ichthyosaurus alpestris.iNat_Res" )
# df_iNDL05 <- rbind(df_iNDL05,nrta)



misstxnm <- c("Bombina bombina.iNat_Res",
              "Bufo calamita.iNat_Res",
              "Ichthyosaurus alpestris.iNat_Res")
txnm2<- c(unique(df_iNDL04$txnmc), misstxnm)
df_iNDL05$txnmc2 <- factor(df_iNDL04$txnmc,levels=txnm2)

df_iNDL05$pchs <- as.factor(df_iNDL05$pchs)
#unique(df_iNDL05$pchs)
#df_iNDL05$dec_lat
nspo2 <- length(unique(df_iNDL05$txnmc))
cl2 <- colorRampPalette(c(scbpl))( nspo2) 
#cl2 <- colorRampPalette(c(scbpl))( nspo) 
cl06 <- cl2
length(cl06)
#make plot
p06 <- ggplot(data = world) +
  geom_sf(color = "black", fill = "azure3") +
  #https://ggplot2.tidyverse.org/reference/position_jitter.html
  # use 'geom_jitter' instead of 'geom_point' 
  geom_jitter(data = df_iNDL04, 
              aes(x = dec_lon, y = dec_lat,
                  shape=eval03,
                  color=eval03,
                  fill=txnmc),
              width = jitlvl, #0.07, jitter width 
              height = jitlvl, #0.07, # jitter height
              size = 2.0) +
  #manually set the pch shape of the points
  scale_shape_manual(values=c(21,3,22)) +
  #set the color of the points
  #here it is black, and repeated the number of times
  #matching the number of species listed
  scale_color_manual(values=c(rep("black",nspo2))) +
  #set the color of the points
  #use alpha to scale the intensity of the color
  scale_fill_manual(values=alpha(
    c(cl06),
    c(0.7)
  ))+
  #
  
  #Arrange in facets
  ggplot2::facet_wrap( ~ txnmc,
                       drop=FALSE,
                       ncol = 8,
                       labeller = label_bquote(cols = italic(.(txnmc))) ) +
  #define limits of the plot
  ggplot2::coord_sf(xlim = c(8, 15.4),
                    ylim = c(54.4, 58.0), 
                    expand = FALSE)
#see the plot
p06


#_______________________________________________________________________________

#copy data frame
df_iNDL04 <- df_iNDL03

#assign taxon name plus monitoring category
df_iNDL04$txnmc <- paste0(df_iNDL04$taxon.name,".",df_iNDL04$monit.cat)
# re order columns
df_iNDL05 <- df_iNDL04
#colnames(df_iNDL05)
#unique(df_iNDL05$pchs)
# for rows for species not present in the iNaturalist search
# to avoid the facet plot ebds up being without plots needed for iNaturalist records
# nrta <- c(1,1,"Bombina bombina","iNat_Res","iNat_Res",3,"A)   Bombina bombina","A","Bombina bombina.iNat_Res" )
# df_iNDL05 <- rbind(df_iNDL05,nrta)
# nrta <- c(1,1,"Bufo calamita","iNat_Res","iNat_Res",3,"C)   Bufo calamita","C","Bufo calamita.iNat_Res" )
# df_iNDL05 <- rbind(df_iNDL05,nrta)
# nrta <- c(1,1,"Ichthyosaurus alpestris","iNat_Res",3,"iNat_Res","F)   Ichthyosaurus alpestris","F","Ichthyosaurus alpestris.iNat_Res" )
# df_iNDL05 <- rbind(df_iNDL05,nrta)



misstxnm <- c("Bombina bombina.iNat_Res",
              "Bufo calamita.iNat_Res",
              "Ichthyosaurus alpestris.iNat_Res")
txnm2<- c(unique(df_iNDL04$txnmc), misstxnm)
df_iNDL05$txnmc2 <- factor(df_iNDL04$txnmc,levels=txnm2)

df_iNDL05$pchs <- as.factor(df_iNDL05$pchs)
#unique(df_iNDL05$pchs)
#df_iNDL05$dec_lat
nspo2 <- length(unique(df_iNDL05$txnmc2))
cl2 <- colorRampPalette(c(scbpl))( nspo2) 
#cl2 <- colorRampPalette(c(scbpl))( nspo) 
cl06 <- cl2
length(cl06)
#make plot
p07 <- ggplot(data = world) +
  geom_sf(color = "black", fill = "azure3") +
  #https://ggplot2.tidyverse.org/reference/position_jitter.html
  # use 'geom_jitter' instead of 'geom_point' 
  geom_jitter(data = df_iNDL05, 
              aes(x = dec_lon, y = dec_lat,
                  shape=eval03,
                  color=eval03,
                  fill=txnmc2),
              width = jitlvl, #0.07, jitter width 
              height = jitlvl, #0.07, # jitter height
              size = 2.0) +
  #manually set the pch shape of the points
  scale_shape_manual(values=c(21,3,22)) +
  #set the color of the points
  #here it is black, and repeated the number of times
  #matching the number of species listed
  scale_color_manual(values=c(rep("black",nspo2))) +
  #set the color of the points
  #use alpha to scale the intensity of the color
  scale_fill_manual(values=alpha(
    c(cl06),
    c(0.7)
  ))+
  #
  
  #Arrange in facets
  ggplot2::facet_wrap( ~ txnmc2,
                       drop=FALSE,
                       ncol = 8,
                       labeller = label_bquote(cols = italic(.(as.character(txnmc2)))) ) +
  #define limits of the plot
  ggplot2::coord_sf(xlim = c(8, 15.4),
                    ylim = c(54.4, 58.0), 
                    expand = FALSE)
#see the plot
p07
# 
# p07t <- p07 +
#   guides(
#     fill = guide_legend("species"),
#     #color  = guide_legend("species"),
#     shape = guide_legend("species")
#   )
# 
# p07t

#_______________________________________________________________________________
# end plot with iNaturalist and eDNA monitoring in plots side by side
#_______________________________________________________________________________

#




#