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
#
wd00 <- "/home/hal9000/Documents/Documents/MS_amphibian_eDNA_assays/amphibia_eDNA_in_Denmark"
#wd00 <- rpath
setwd (wd00)
#getwd()
wd_ext02 <- "input_files_01_downloaded_from_web"
wd_ext01 <- "/home/hal9000/Documents/Documents/MS_amphibian_eDNA_assays"
wd_ext01_02 <- paste(wd_ext01,"/",wd_ext02,sep="")
#define an output directory
wd09 <- "/supma09_plots_from_R_analysis"
#paste together path
wd00_wd09 <- paste(wd00,wd09,sep="")
#wd00 <- rpath
setwd (wd00)
#define an input directory
wd03 <- "/supma03_inp_files_for_R"
#paste together path
wd00_wd03 <- paste(wd00,wd03,sep="")
#paste path and file together
wd00_wd03_inpf01 <- paste(wd00_wd03,"/DL_dk_specs_to_latspecs06.csv",sep="")
#read excel with species names
dkl <-as.data.frame(read.csv(wd00_wd03_inpf01,
                                             header = TRUE, sep = ",", quote = "\"",
                                             dec = ".", fill = TRUE, comment.char = "", stringsAsFactors = FALSE))
#subset dataframe
bfl <-  dkl[grepl("Bufo",dkl$Species_Latin),]
hyl <-  dkl[grepl("Hyla",dkl$Species_Latin),]
ral <-  dkl[grepl("Rana",dkl$Species_Latin),]
pel <-  dkl[grepl("Pelophylax",dkl$Species_Latin),]
bol <-  dkl[grepl("Bombina",dkl$Species_Latin),]
icl <-  dkl[grepl("Ichthyosaura",dkl$Species_Latin),]
trl <-  dkl[grepl("Triturus",dkl$Species_Latin),]
lil <-  dkl[grepl("Lissotriton",dkl$Species_Latin),]
pel <-  dkl[grepl("Pelobates",dkl$Species_Latin),]
#bind subsets together
aml <- rbind(bfl,
      hyl,
      ral,
      pel,
      bol,
      icl,
      trl,
      lil,
      pel)
nrow(aml)
# define extent of area to get gbif records from
exta <- extent(c(5, 17, 52, 60))
#define columns to keep
kee <- c(#"acceptedScientificName",          
  "datasetName",
  "lat",                            
  "lon",
  "scientificName",
  "species") #,
# define columns with citation information
ctk2 <- c("datasetKey","gbifID")
# add to vector with column names to keep
kee<- c(kee,ctk2)
#define list of species
lsp <- aml$Species_Latin
#correct the species name
# add "Pelophylax_ridibundus" to the list
lsp <- c(lsp,"Pelophylax_ridibundus")
lsp <- c(lsp,"Ichthyosaura_alpestris")
lsp <- c(lsp,"Pelophylax_esculentus")
# try using only the 2nd element in the vector for doing the iteration
#lsp <- lsp[2]
#define empty list
lstg <- list()
# set a running number
i <- 1
#iterate over elements in list
for (e in lsp)
{
  #print(e)
  #substitute in string to get genus and species name
  genus <- sub('\\_.*', '',e)
  species <- sub('.*\\_', '',e)
  #get gbif records
  g <- gbif(genus, species, geo=TRUE, ext = exta, end=3000)
  #View(g)
  #colnames(g)
  if (!"datasetName" %in% colnames(g))
     {g$datasetName <- NA}
  g <- g[kee]
  lstg[[i]] <- g
  i <- i+1
}
#prg <- gbif("Pelophylax", "ridibundus", geo=TRUE, ext = exta, end=30000)
#iag <- gbif("Ichthyosaura", "alpestris", geo=TRUE, ext = exta, end=30000)
#bind the rows in each list in to one data frame
df_g03 <- data.table::rbindlist(lstg, fill=T)
#df_g03$datasetName
#unique(df_g03$scientificName)
#unique(df_g03$species)
#View(df_g03)
dtsKey <- unique(df_g03$datasetKey)
dtsGBID <- unique(df_g03$gbifID)
library(rgbif) 
#derived_dataset(dtsGBID) 
#?derived_dataset_prep(dtsGBID) 

df_g03$species[grepl("Pelophylax esculentus",df_g03$scientificName)] <- "Pelophylax esculentus"
#unique(df_g03$datasetName)
#define column names to keep
#subset data frame
df_g03 <- as.data.frame(df_g03)
# also get the full data frame 
# df_g03.raw <- df_g03
# colnames(df_g03.raw)
# unique(df_g03.raw$datasetName)
 df_g03 <- df_g03[kee]
#define output flie name
outfl1 = "out08_06b_gbif_records_amphibia_Denmark.csv"
# paste together path and input flie
pthoutf01 <- paste0(wd00_wd03,"/",outfl1)
# use tab as separator
write.table(df_g03, file=pthoutf01, sep=";",
            row.names = F, quote = F) # do not use row names
# get column with heysets
datasetKey.g03 <- df_g03$datasetKey
# USe external input file with logon details
# path to file with personal logon
lgl <- "/home/hal9000/Documents/Documents/Dokumenter SWK/logon_gbif.txt"
# read the file as a text file
lgl <- readr::read_delim(lgl, delim = "\t")
# make it a data frame
lgl <- as.data.frame(lgl)
# only grep the row that has username and password
Username_gbif <- lgl[grepl("Username",lgl[,1]),]
Password_gbif <- lgl[grepl("Password",lgl[,1]),]
# substitute in these rows
Username_gbif <- gsub("Username: ","",Username_gbif)
Password_gbif <- gsub("Password: ","",Password_gbif)

# use dplyr to count
library(dplyr)
# count up records
dd_meta <- df_g03 %>% dplyr::count(datasetKey) 
# use rgbif to get DOI records
my_dd<-rgbif::derived_dataset(
  citation_data<-dd_meta,
  title<-"din titel",
  description = "din beskrivelse",
  source_url = pthoutf01,
  user=Username_gbif,
  pwd=Password_gbif
  )
#Herefter kan du finde din DOI i my_dd$doi

# # # 
# library("rnaturalearth")
# library("rnaturalearthdata")
# library("rnaturalearthhires")
# # # Get a map, use a high number for 'scale' for a coarse resolution
# # use a low number for scale for a high resolution
# world <- ne_countries(scale = 10, returnclass = "sf")
# #try defining your own bounding box
# set_nelat= 58
# set_nelng= 15.4
# set_swlat= 54.4
# set_swlng= 8
# # use a defined box to prepare the map
# mxla <- set_nelat
# mxlo <- set_nelng
# mila <- set_swlat
# milo <- set_swlng
# 
# head(g,3)
# g$dec_lon <- g$lon
# g$dec_lat <- g$lat
# jitlvl <- 0.004
# #______________________<________________________________________________________
# p03 <- 
#   ggplot(data = world) +
#   #ggplot(sf_transform(data = world, 4326)) +
#   geom_sf(color = "black", fill = "azure3", lwd =  0.14) +
#   #https://ggplot2.tidyverse.org/reference/position_jitter.html
#   # use 'geom_jitter' instead of 'geom_point' 
#   geom_jitter(data = g, 
#               aes(x = dec_lon, y = dec_lat,
#                   fill=species,
#                   color=species,
#                   shape=species,
#                   lwd =  0.5),
#               
#               width = jitlvl, #0.07, jitter width 
#               height = jitlvl, #0.07, # jitter height
#               size = 3) +
#   #manually set the pch shape of the points
#   scale_shape_manual(values=c(rep(21,length(unique(g$species))))) +
#   #set the color of the points
#   #here it is black, and repeated the number of times
#   #matching the number of species listed
#   scale_color_manual(values=c(rep("black",
#                                   length(unique(g$species))))) +
#   #set the color of the points
#   #use alpha to scale the intensity of the color
#   # scale_fill_manual(values=alpha(
#   #   c(cl_nbg),
#   #   c(0.7)
#   # ))+
#   # # use the boundaries used for getting the data from inaturalist
#   # to set the limits of the plot area
#   ## nelat=62.24410751082821&
#   ## nelng=85.06445707306858&
#   ## swlat=30.25283706916566&
#   ## swlng=-42.552730426931404&
#   ## define limits of the plot
#   ggplot2::coord_sf(xlim = c((milo-1), (mxlo+1)),
#                     ylim = c((mila-1), (mxla+1)), 
#                     expand = FALSE)
# #see the plot
# #wd00 <- "/home/hal9000/Documents/shrfldubuntu18/inaturalist_in_R"
# #wd00_wd09
# #getwd()
# setwd(wd00_wd09)
# p03
# 
# p01 <- p03
# #
# p01t <- p01 + labs(title = "A")#, 
# #change axis labels
# p01t <- p01t + xlab("longitude") + ylab("latitude")