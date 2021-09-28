#!/usr/bin/env Rscript
# -*- coding: utf-8 -*-

#____________________________________________________________________________#
# R-code  for :
# Making a table of distributions of Danish amphibian species
# The distribution areas is adopted from :
# Speybroeck, J., Beukema, W and Crochet, P.-A. (2010). A tentative species list of the European herpetofauna (Amphibia and Reptilia) — an update. Zootaxa 2492: 1–27 

# Authors of this R code: Steen Wilhelm Knudsen.
#set working dir
wd00 <- "/Users/steenknudsen/Documents/Documents/MS_amphibian_eDNA_assays/MS_suppm_amphibia_eDNA"
#define input directories
wdin01.1 <- "supma01_inp_raw_qcpr_csv"
wdin01.2 <- "inp07_distrib_lsts"
#paste file paths together
wd00_wd01 <- paste(wd00,"/",wdin01.1,"/",wdin01.2,sep="")
#define inout files
inpf01 <- "lst_distrib_DK_amphibians.csv"
inpf02 <- "lst_distrib_areas_amphibians.csv"
#paste path and files together
wd00_inpf01 <- paste(wd00_wd01,"/",inpf01,sep="")
wd00_inpf02 <- paste(wd00_wd01,"/",inpf02,sep="")
#read in files
df_di01 <- read.csv(wd00_inpf01, sep="\t",header = F)
df_ar01 <- read.csv(wd00_inpf02, sep="\t",header = T)
#get number of elements in column in data frame
nrdi <- length(df_di01$V2)
stdi <- as.character(df_di01$V2[1])
ls_ar01 <- list()
#iterate over rows in df
for (i in seq(1:nrdi))
{
  #print(i)}
#split string in each element by comma
ls_ars2 <- strsplit(as.character(df_di01$V2[i]),", ")
# get area
#ls_ar01[i] <- list(gsub("^.*\\) (.*)$","\\1",ls_ars2[[1]]))
# get abbreviation for area, sort it, and make it a list
ls_ar01[i] <- list(sort(gsub("^\\((.*)\\) (.*)$","\\1",ls_ars2[[1]])))
}
#make the list a dataframe
df_d02 <- as.data.frame(cbind(as.character(df_d01$V1), 
                              ls_ar01))
#change column names
colnames(df_d02) <- c("species","ab.ar")
#make an empyt to list to fill while iterating over elements
ls_a02 <- list()
#iterate over rows in data frame
for (i in seq(1:nrow(df_d02))){
  #unlist each row to get a species with the distribution area abbr
  lst_prspc <- gsub("_"," ",as.character(as.vector(unlist(df_d02[i,])) ))
  #use gsub to replace in elements that have a space, retain the element, but add a colon
  lst_prspc <- gsub("^(.* .*)$","\\1:",lst_prspc)
  #paste the elements in the list for each row together to one string
  ls_arpsp <- paste(lst_prspc,collapse=", ")
  #add the string to a list
  ls_a02[i] <- gsub(":,",":",ls_arpsp)
}
#unlist the list
  ls3 <- unlist(ls_a02)
  # to be able to paste the entire list together to one string
  ls4 <- paste(ls3,collapse="; ")
#get a list of unique elements in the list, and sort it
lst_ar.abb <- sort(unique(unlist(ls_ar01)))
#match the elements, make them character strings, and bind them in columns
# and make it a dataframe
df_ar02 <- as.data.frame(cbind(as.character(df_ar01$Area[match(lst_ar.abb,df_ar01$Abbr)]),
      as.character(df_ar01$Abbr[match(lst_ar.abb,df_ar01$Abbr)])))
#change column names
colnames(df_ar02 ) <- c("area","abbr")
#exclude any rows with NA
df_ar03 <- na.omit(df_ar02)
#reorder columns by column name
df_ar03[ , c("abbr", "area")] 
#paste parenteses around abbreviation in column
df_ar03$abbr <- paste("(",df_ar03$abbr,")",sep="")
#make the area name a character
df_ar03$area <- as.character(df_ar03$area)
# make an empty list to fill
ls_a03 <- list()
#iterate over rows in data frame
for (i in seq(1:nrow(df_ar03))){
  #unlist each row to get a species with the distribution area abbr
  lst_p1 <- as.character(as.vector(unlist(df_ar03[i,])) )
  #paste the elements in the list for each row together to one string
  ls_2p <- paste(lst_p1,collapse=" ")
  #add the string to a list
  ls_a03[i] <- ls_2p
}
#unlist the list
ls5 <- unlist(ls_a03)
# to be able to paste the entire list together to one string
ls6 <- paste(ls5,collapse=", ")
#paste two lists together to a single string
ls7 <- paste(ls4,ls6,collapse=". ")
ls7
#define output directory
wdout02.1 <- "supma02_Rcodes_for_rawqpcr_and_resultingplots"
# define an output directory
wdout02.2 <- "plotout07_table_distr_area"
wdout02.3 <- paste(wd00,"/",wdout02.1,"/",wdout02.2,sep="")
#delete previous versions of the output directory
unlink(wdout02.3, recursive=TRUE)
#create new directory
dir.create(wdout02.3)
#set output directory
setwd(wdout02.3)
#define filename to write to
fileConn<-file("out07_distr_areas_for_frogs.txt")
#write the list to this file
writeLines(ls7, fileConn)
#close the file again
close(fileConn)
#