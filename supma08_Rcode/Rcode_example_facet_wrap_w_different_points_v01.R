#!/usr/bin/env Rscript
# -*- coding: utf-8 -*-

#remove everything in the working environment, without a warning!!
rm(list=ls())
# set working directory
wd00 <- "/home/hal9000/Documents/Documents/MS_amphibian_eDNA_assays/amphibia_eDNA_in_Denmark/supma09_plots_from_R_analysis"
setwd(wd00)
#_______________________________________________________________________________
# Make plot on map with facet wrap - start
#_______________________________________________________________________________

library(ggplot2)
library(fields)
library(maps)

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
#if (!exists("world"))
#{  
world <- ne_countries(scale = 10, returnclass = "sf")


# # define columns to keep
# col.to.keep <- c("dec_lat","dec_lon")
# # # only keep specific columns
# smpl.loc <- amph_smpl05_df[col.to.keep]
# # only keep unique rows
# smpl.loc <- dplyr::distinct(smpl.loc)
# # # 
# nsmpl <- nrow(smpl.loc)
# # get the unique species names
# latspc5 <- unique(amph_smpl05_df$latspc)
# # get the number of unique species names
# n.latspc5 <- length(latspc5)
# # repeat the species names n times
# r.latspc5 <- rep(latspc5,nsmpl)[order(rep(latspc5,nsmpl))]
# # repeat a dataframe n times  : https://stackoverflow.com/questions/8753531/repeat-rows-of-a-data-frame-n-times
# r.smpl.loc <- do.call("rbind", replicate(n.latspc5, smpl.loc, simplify = FALSE))
# #combine to a dataframe
# df_smpl5 <- cbind(r.latspc5,r.smpl.loc)
# # count columns and rows
# nc_a05<- ncol(amph_smpl05_df)
# nr_s05 <- nrow(df_smpl5)
# #make an empty data frame
# df_empt <- data.frame(matrix(NA,    # Create empty data frame
#                           nrow = nr_s05,
#                           ncol = nc_a05))
# #replace the column names in the empty data frame
# colnames(df_empt) <- colnames(amph_smpl05_df)
# 
# # assign species names
# df_empt$latspc <- df_smpl5$r.latspc5
# df_empt$dec_lat <- df_smpl5$dec_lat
# df_empt$dec_lon <- df_smpl5$dec_lon
# df_empt$pchsymb <- "3"
# df_empt$latspc2 <- df_empt$latspc
# df_empt$latspc3 <- amph_smpl05_df$latspc3[match(df_empt$latspc2,amph_smpl05_df$latspc2)]
# # bind data frames together  -  see: https://stackoverflow.com/questions/8169323/r-concatenate-two-dataframes#8365050
# df_as07<- rbind(amph_smpl05_df,df_empt)
# 
# # subset data frame and keep only selected columns
# df_as08 <- amph_smpl05_df[(amph_smpl05_df$latspc=="Bufo bufo" | amph_smpl05_df$latspc=="Bufo calamita"),] 
# c.to.keep <- c("dec_lon", "dec_lat", "latspc2", "llatspc3")
# df_as08 <- df_as08[c.to.keep]
# 
# dput(df_as08)

#make data, unless you got it from the section above
df_as08 <- structure(list(dec_lon = c(15.18797, 15.18797, 10.165626, 12.506443, 
                           12.313641, 12.313641, 8.536297, 10.473298, 10.473298, 11.871638, 
                           12.383023, 12.383023, 12.585, 12.585, 8.885876, 8.885876, 12.38, 
                           12.38, 9.50709, 9.50709, 12.280072, 12.280072, 10.856494, 9.527786, 
                           9.527786, 12.314189, 10.272052, 10.269853, 12.474679, 8.973381, 
                           9.899299, 9.899299, 8.303745, 10.479156, 10.479156, 10.429668, 
                           10.429, 10.429, 9.26164, 10.271033, 9.609253, 8.922321, 11.876954
), dec_lat = c(55.32029, 55.32029, 55.57885, 55.71739, 55.92368, 
               55.92368, 55.905, 56.29135, 56.29135, 55.9675, 55.73673, 55.73673, 
               55.6507, 55.6507, 55.75814, 55.75814, 55.74, 55.74, 55.71026, 
               55.71026, 55.9486, 55.9486, 56.41465, 56.79541, 56.79541, 55.92355, 
               57.16855, 57.16786, 55.70511, 56.15156, 57.53746, 57.53746, 56.53997, 
               57.41674, 57.41674, 55.40704, 55.407, 55.407, 56.79622, 57.16625, 
               56.88063, 55.76843, 54.77456), latspc2 = c("Bufo bufo", "Bufo bufo", 
                                                          "Bufo bufo", "Bufo bufo", "Bufo bufo", "Bufo bufo", "Bufo bufo", 
                                                          "Bufo bufo", "Bufo bufo", "Bufo bufo", "Bufo bufo", "Bufo bufo", 
                                                          "Bufo bufo", "Bufo bufo", "Bufo bufo", "Bufo bufo", "Bufo bufo", 
                                                          "Bufo bufo", "Bufo bufo", "Bufo bufo", "Bufo bufo", "Bufo bufo", 
                                                          "Bufo bufo", "Bufo bufo", "Bufo bufo", "Bufo bufo", "Bufo bufo", 
                                                          "Bufo bufo", "Bufo bufo", "Bufo bufo", "Bufo bufo", "Bufo bufo", 
                                                          "Bufo bufo", "Bufo bufo", "Bufo bufo", "Bufo bufo", "Bufo bufo", 
                                                          "Bufo bufo", "Bufo bufo", "Bufo bufo", "Bufo bufo", "Bufo bufo", 
                                                          "Bufo calamita"), llatspc3 = c("A", "A", "A", "A", "A", "A", 
                                                                                         "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", 
                                                                                         "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", 
                                                                                         "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "B")), row.names = c(5575L, 
                                                                                                                                                                5579L, 5807L, 6027L, 6411L, 6415L, 6651L, 6739L, 6743L, 7243L, 
                                                                                                                                                                7571L, 7575L, 8323L, 8327L, 8595L, 8599L, 10759L, 10763L, 10895L, 
                                                                                                                                                                10899L, 11127L, 11131L, 14755L, 14995L, 14999L, 15091L, 15499L, 
                                                                                                                                                                15675L, 16135L, 16407L, 16811L, 16815L, 16947L, 17083L, 17087L, 
                                                                                                                                                                17223L, 17715L, 17719L, 17851L, 18263L, 18515L, 18919L, 7083L
                                                                                         ), class = "data.frame")
# add jitter level
jitlvl <- 0.1
#plot with long species names
p05 <- ggplot(data = world) +
  geom_sf(color = "black", fill = "azure3") +
  #https://ggplot2.tidyverse.org/reference/position_jitter.html
  # use 'geom_jitter' instead of 'geom_point' 
  geom_jitter(data = df_as08, 
              aes(x = dec_lon, y = dec_lat,
                  #amph_smpl05_df$abbr.nm
                  shape=latspc2,
                  color=latspc2,
                  fill=latspc2),
              width = jitlvl, #0.07, jitter width 
              height = jitlvl, #0.07, # jitter height
              size = 3.0) +

  geom_point(data = df_as08, 
              aes(x = dec_lon, y = dec_lat,
                  shape="3",
                  fill="0"),
              size = 3.0) +
  
  
  # #manually set the pch shape of the points
  # scale_shape_manual(values=c(rep(21,nrow(amph_smpl05_df)))) +
  # #set the color of the points
  # #here it is black, and repeated the number of times
  # #matching the number of species listed
  # scale_color_manual(values=c(rep("black",nspo))) +
  # #set the color of the points
  # #use alpha to scale the intensity of the color
  # scale_fill_manual(values=alpha(
  #   c(cl05),
  #   c(0.7)
  # ))+
  #Arrange in facets
  #ggplot2::facet_wrap( ~ latspc2,
  ggplot2::facet_wrap(. ~ llatspc3 + latspc2,
                      
                      ncol = 3,
                      labeller = label_bquote(cols = .(llatspc3) ~ .(" ") ~ italic(.(latspc2))) ) +
  #labeller = label_bquote(col = italic(.(latspc2))) ) +
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
p05t <- p05t + labs(color='species')
p05t <- p05t + labs(fill='species')
p05t <- p05t + labs(shape='species')

#get the number of species
noofspcsnms <- length(unique(df_as08$latspc))
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
# add label to plot
#p05t <- p05t + patchwork::plot_annotation(caption="FigS32_v01_2022sep") #& theme(legend.position = "bottom") 
# see the plot
#p05t
# set bSaveFigures to TRUE
bSaveFigures=T
figname06A <- paste0("FigS32_v03.png")
# save plot
if(bSaveFigures==T){
  ggsave(p05t,file=figname06A,width=210,height=297*0.55,
         units="mm",dpi=600)
}
#
#_______________________________________________________________________________
# Make plot on map with facet wrap - end
#_______________________________________________________________________________


# Solution 1:


# facet wrap i ggplot med forskellige punktserier
# 
# Steen Knudsen
# Man 08-05-2023 15:27
# Hej Ciaran, Jeg er kørt sur i ggplot2. Jeg har vedhæftet en kode med et eksempel datasæt. Jeg har indsamlingssteder og så har jeg fund per eDNA af arten. I mit eksempel er det 'Bufo bufo' og 'Bufo calamita'. For hvert enkelt facet-wrap plot skal jeg gerne ende
# Ciaran Joseph Murray
# Steen Knudsen
# 
#Her er et lille eksempel. Hjælper det?
library(dplyr)
library(ggplot2)
n_pos <- 10
# create table random lat, lon positions
df_posns <- data.frame(lat=runif(n_pos,min=55,max=56),
                       lon=runif(n_pos,min=11,max=12))
# create table with species
species <- c("species A","species B")
species <- data.frame(species=species)
# create table with duplicate positions for each species so that it 
# appears in each facet:
df_posns_species <- merge(df_posns,species,all=T)
# make a table using random numbers to make up some finds for species 
# at the positions
df_find <- df_posns_species
df_find$find <- runif(nrow(df_find),min=0,max=1)
df_find <- df_find %>%
  mutate(find=ifelse(find >0.7,TRUE,FALSE)) %>%
  filter(find==T)
# show a summary of finds for each table
df_find %>% group_by(species,find) %>% summarise(n=n())
# plot:
# 1) positions of positive finds
# 2) all sampling positions, repeated for each species (or whatever
# facet variable you use)
shape_list <- c(15,17)
colour_list <- c("#CC0000","#0033BB")
ggplot(df_find,aes(x=lon,y=lat,
                   shape=factor(species),
                   color=factor(species)) ) +
  geom_jitter(size=3,width = 0.01, height = 0.01) +
  scale_shape_manual(values=shape_list) +
  scale_colour_manual(values=colour_list) +
  geom_point(data=df_posns_species,shape=3,colour="#000000",size=2) +
  facet_wrap(.~species)
#Her er der skruet lidt op for ”jitter” (width = 0.03, height = 0.03)…


# Solution 2:

colour_list <- c("black","blue")
fill_list <- c("orange","cyan")
shape_list <- c(21,23)
# define columns to keep
col.to.keep <- c("dec_lat","dec_lon")
# # only keep specific columns
smpl.loc <- df_as08[col.to.keep]
# # only keep unique rows
df_smpl.loc <- dplyr::distinct(smpl.loc)
df_spec <- df_as08 %>% dplyr::distinct(latspc2)
# create table with duplicate positions for each species so that it 
# appears in each facet:
df_posns_species <- merge(df_smpl.loc,df_spec,all=T)

ggplot(df_as08,aes(x=dec_lon,y=dec_lat,
                   shape=factor(latspc2),
                   color=factor(latspc2),
                   fill=factor(latspc2)) ) +
  geom_jitter(size=3,width = 0.01, height = 0.01) +
  scale_shape_manual(values=shape_list) +
  scale_colour_manual(values=colour_list) +
  scale_fill_manual(values=fill_list) +
  geom_point(data=df_posns_species,shape=3,colour="#000000",size=2) +
  facet_wrap(.~latspc2)
#Her er der skruet lidt op for ”jitter” (width = 0.03, height = 0.03)

#Her er der skruet lidt op for ”jitter” (width = 0.03, height = 0.03)
