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

#remove everything in the working environment, without a warning!!
rm(list=ls())

#https://recology.info/2012/10/rgbif-newfxns/
#https://ropensci.github.io/CoordinateCleaner/articles/Cleaning_GBIF_data_with_CoordinateCleaner.html
library(dismo)
library(readxl)
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
#
wd00 <- "/home/hal9000/Documents/Documents/MS_amphibian_eDNA_assays/amphibia_eDNA_in_Denmark"
#wd00 <- rpath
setwd (wd00)
getwd()
#define an output directory
wd09 <- "/supma09_plots_from_R_analysis"
#paste together path
wd00_wd09 <- paste(wd00,wd09,sep="")

wd_ext02 <- "input_files_01_downloaded_from_web"
wd_ext01 <- "/home/hal9000/Documents/Documents/MS_amphibian_eDNA_assays"
wd_ext01_02 <- paste(wd_ext01,"/",wd_ext02,sep="")
#wd00 <- rpath
setwd (wd00)
#define an input directory
wd03 <- "/supma03_inp_files_for_R"
#paste together path
wd00_wd03 <- paste(wd00,wd03,sep="")
# get a list of files in the directory
infls <- list.files(wd00_wd03)
# subset to only include the files from 'arter.dk' 
infls <- infls[grepl("fund_arter.dk_",infls)]
#define empty list
lstg <- list()
# set a running number
i <- 1
#iterate over elements in list
for (f in infls)
{
  #paste path and file name together
  wd00_wd03_inpf01 <- paste0(wd00_wd03,"/",f)
  #read in the excel file
  adkl <-as.data.frame(readxl::read_xlsx(wd00_wd03_inpf01,
                               sheet = "Data")) 
  # add to growing list
  lstg[[i]] <- adkl
  #increase th count by one
  i <- i+1
}
#bind the rows in each list in to one data frame
datbl_af03 <- data.table::rbindlist(lstg, fill=T)
#make it a data fram
df_af03 <- as.data.frame(datbl_af03)
# make a list of columns to keep 
kee <- c("Lat", "Long","Taxon latinsk navn","Systemoprindelse")
# exclude columns not in list
df_af04 <- df_af03[kee]
df_af04$dec_lat <- df_af04$Lat
df_af04$dec_lon <- df_af04$Long
df_af04$taxon.name <- df_af04$`Taxon latinsk navn`
df_af04$eval03 <- "fund_arter.dk"
df_af04$eval03[df_af04$Systemoprindelse=="iNaturalist Research-grade Observations"] <- "iNat_res"

df_af04$eval04 <- df_af04$eval03
#infl1 = "out08_03b_inaturalist_records_amphibia_Denmark_1200lines.csv"
infl2 = "out08_01b_DL_records_amphibia_Denmark.csv"
# paste together path and input flie
pthinf02 <- paste0(wd00_wd09,"/",infl2)
# read in csv files prepared from two previous 
df_DL01 <- read.csv(pthinf02,sep=",",stringsAsFactors = F, header=T)
#change columns names
#make positions numeric
df_DL01$dec_lat <- as.numeric(df_DL01$dec_lat)
df_DL01$dec_lon <- as.numeric(df_DL01$dec_lon)
# add a column for evaluation categories
df_DL01$eval03 <- NA
df_DL01$eval03[df_DL01$eval01=="truezerodetect"] <- "eDNA_zero"
df_DL01$eval03[df_DL01$eval01=="repl2pos"] <- "eDNA_present"
df_DL01$eval03[df_DL01$eval01=="repl1or2"] <- "eDNA_present"
df_DL01$eval04 <- df_DL01$eval03

# assign one column to a new column - to retain this new column later on
df_DL01$taxon.name <- df_DL01$latspc2
#define columns to keep
keep <- c(  "dec_lat",
            "dec_lon",
            "taxon.name",
            "eval03",
            "eval04")
#limit data frames to only keep these columns
df_DL02 <- df_DL01[keep]
df_af05 <- df_af04[keep]
# bind the two data frames together by appending as rows
df_iNDL02 <- rbind(df_DL02,df_af05)
#change species names
df_iNDL02$taxon.name <- gsub("Pelophylax kl.","Pelophylax kl. esculenta",df_iNDL02$taxon.name)
df_iNDL02$taxon.name <- gsub("Pelophylax esculentus","Pelophylax kl. esculenta",df_iNDL02$taxon.name)
df_iNDL02$taxon.name <- gsub("esculenta esculenta","esculenta",df_iNDL02$taxon.name)
df_iNDL02$taxon.name <- gsub("kl. esculenta esculenta"," kl. esculenta",df_iNDL02$taxon.name)
df_iNDL02$taxon.name <- gsub("Bufotes viridis","Bufo viridis",df_iNDL02$taxon.name)
df_iNDL02$taxon.name <- gsub("Epidalea calamita","Bufo calamita",df_iNDL02$taxon.name)
df_iNDL02$taxon.name <- gsub("Ichthyosaurus alpestris","Ichthyosaura alpestris",df_iNDL02$taxon.name)

#unique(df_iNDL02$taxon.name)

# add a column for evaluation categories
df_iNDL02$pchs <- NA
df_iNDL02$pchs[df_iNDL02$eval03=="eDNA_zero"] <- 3
df_iNDL02$pchs[df_iNDL02$eval03=="eDNA_present"] <- 21
df_iNDL02$pchs[df_iNDL02$eval03=="iNat_Res"] <- 22
unique(df_iNDL02$eval03)
# add a column for evaluation categories
df_iNDL02$monit.cat <- NA
df_iNDL02$monit.cat[df_iNDL02$eval03=="eDNA_zero"] <- "eDNA_monit"
df_iNDL02$monit.cat[df_iNDL02$eval03=="eDNA_present"] <- "eDNA_monit"

df_iNDL02$monit.cat[df_iNDL02$eval04=="eDNA_zero"] <- "eDNA_monit"
df_iNDL02$monit.cat[df_iNDL02$eval04=="eDNA_present"] <- "eDNA_monit"
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

world <- ne_countries(scale = 10, returnclass = "sf")

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
#remove entries with NA for lat and lon
df_iNDL02 <- df_iNDL02[!is.na(df_iNDL02$dec_lat),]
df_iNDL02 <- df_iNDL02[!is.na(df_iNDL02$dec_lon),]
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


#copy data frame
df_iNDL04 <- df_iNDL03
#assign taxon name plus monitoring category
df_iNDL04$txnmc <- paste0(df_iNDL04$taxon.name,".",df_iNDL04$monit.cat)
#
misstxnm <- c("Bombina bombina.iNat_Res",
              "Bufo calamita.iNat_Res",
              "Ichthyosaurus alpestris.iNat_Res")
txnm2<- c(unique(df_iNDL04$txnmc), misstxnm)
df_iNDL04$txnmc2 <- factor(df_iNDL04$txnmc,levels=txnm2)

df_iNDL04$pchs <- as.factor(df_iNDL04$pchs)
#unique(df_iNDL04$pchs)
#df_iNDL04$dec_lat
nspo2 <- length(unique(df_iNDL04$txnmc2))
cl2 <- colorRampPalette(c(scbpl))( nspo2) 
#cl2 <- colorRampPalette(c(scbpl))( nspo) 
cl06 <- cl2
length(cl06)
cl06 <- c("red","white","purple3", "green")
nspo2 <- length(unique(df_iNDL04$eval04))
#unique(df_iNDL04$lettx)
# order the dataframe by a column
df_iNDL04 <- df_iNDL04[order(df_iNDL04$lettx),]
# make a datra frame to sort monitoring categories
# 3,4,2,1
df_mcat <- as.data.frame(cbind(unique(df_iNDL04$eval04), c(2,3,1,4)))
# change column names
colnames(df_mcat) <- c("eval04","ordcat")
# match back to main data frame
df_iNDL04$ordcat <- df_mcat$ordcat[match(df_iNDL04$eval04,df_mcat$eval04)]
#unique(df_iNDL04$lettx)
#unique(df_iNDL04$lettx)
ordcat1 <- unique(df_iNDL04$ordcat)
# df_iNDL04 <- df_iNDL04 %>% dplyr::mutate(across(ordcat, factor , c(ordcat1)))
# df_iNDL04$ordcat <- as.factor(df_iNDL04$ordcat)
# df_iNDL04$eval03 <- as.factor(df_iNDL04$eval03)
# df_iNDL04 <- df_iNDL04 %>% dplyr::arrange(taxon.name) %>% dplyr::arrange(ordcat)
# 
# 
df_iNDL04 <- df_iNDL04[order(df_iNDL04$taxon.name, df_iNDL04$ordcat), ]
# 
df_iNDL04 <- df_iNDL04[order(df_iNDL04$taxon.name, df_iNDL04$ordcat), ]
#make plot
p05 <- ggplot(data = world) +
  geom_sf(color = "black", fill = "azure3", lwd=0.4) +
  #https://ggplot2.tidyverse.org/reference/position_jitter.html
  #https://stackoverflow.com/questions/15706281/controlling-the-order-of-points-in-ggplot2
  # use 'geom_jitter' instead of 'geom_point' 
  geom_jitter(data = df_iNDL04  %>%
                dplyr::mutate(dplyr::across(ordcat, factor , c(ordcat1))),
              #dplyr::arrange(taxon.name) %>% dplyr::arrange(ordcat),
              
              aes(x = dec_lon, y = dec_lat,
                  shape=eval04,
                  color=eval04,
                  fill=eval04,
                  size=eval04),
              width = jitlvl, #0.07, jitter width 
              height = jitlvl) + #, #0.07, # jitter height
  #size = 2.0) +
  
  scale_size_manual(values=c(2.8,1.2,1.6,1.6)) +
  #manually set the pch shape of the points
  scale_shape_manual(values=c(21,3,22,22)) +
  #set the color of the points
  
  
  #here it is black, and repeated the number of times
  #matching the number of species listed
  scale_color_manual(values=alpha(
    c(rep("black",nspo2)),
    c(1.0 , 1.0 , 0.2,0.2) 
  )) +
  #set the color of the points
  #use alpha to scale the intensity of the color
  scale_fill_manual(values=alpha(
    c(cl06),
    c(0.8, 1.0, 0.4,0.4)
  ))+
  #
  #df_iNDL04$lettx
  #Arrange in facets
  ggplot2::facet_wrap( ~ taxon.name,
                       drop=FALSE,
                       ncol = 3,
                       labeller = label_bquote(cols = italic(.(as.character(taxon.name))))  )+
  #define limits of the plot
  ggplot2::coord_sf(xlim = c(8, 15.4),
                    ylim = c(54.4, 58.0), 
                    expand = FALSE)
#see the plot
#p05

#change axis labels
p05t <- p05 + xlab("longitude") + ylab("latitude")
#change the header for the legend on the side, 
#this must be done for both 'fill', 'color' and 'shape', to avoid 
#getting separate legends
p05t <- p05t + labs(color='monitoring')
p05t <- p05t + labs(fill='monitoring')
p05t <- p05t + labs(shape='monitoring')
p05t <- p05t + labs(size='monitoring')

#get the number of species
#ncat <- length(unique(df_iNDL03$taxon.name))
ncat <- length(unique(df_iNDL04$eval03))
# https://github.com/tidyverse/ggplot2/issues/3492
#repeat 'black' a specified number of times
filltxc = rep("black", ncat)
#filltxc[10] <- "red"
#filltxc = rep("white", noofspcsnms)
# Label appearance ##http://www.cookbook-r.com/Graphs/Legends_(ggplot2)/
#p05t <- p05t + theme(legend.text = element_text(colour=filltxc, size = 10, face = "italic"))

#adjust tick marks on axis
p05t <- p05t + scale_y_continuous(breaks=seq(54.5,58,1))
p05t <- p05t + scale_x_continuous(breaks=seq(8,16,2))
#alter stripes above facet plots
# p05t <- p05t + theme(strip.background =element_rect(fill=c("black")))
# p05t <- p05t + theme(strip.text = element_text(colour = 'white'))
#p05t <- p05t + theme(strip.text = element_blank())
p05t <- p05t + theme(strip.background = element_blank())
# see the plot
#p05t

# define whether figures are to be saved or not
bSaveFigures <- T
#substitute in file name
infl1 <- gsub(".csv","",infl1)
infl1 <- "fund_arter.dk" 
#define file name to save plot to
fgnm <- paste0("Fig05_v04_",infl1,".pdf")
#paste the path and the file name together
pfnm <- paste0(wd00_wd09,"/",fgnm)
# save plot
if(bSaveFigures==T){
  ggsave(p05t,file=pfnm,
         width=210,height=297, # as portrait
         #width=297,height=210, # as landscape
         units="mm",dpi=600)
}

#________________________
#_____________________________

