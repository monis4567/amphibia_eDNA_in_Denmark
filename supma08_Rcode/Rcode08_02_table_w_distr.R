#!/usr/bin/env Rscript
# -*- coding: utf-8 -*-

#https://cran.r-project.org/web/packages/tableHTML/vignettes/tableHTML.html
if(!require(tableHTML)){
  install.packages("tableHTML")
  library(tableHTML)
}
library(tableHTML)
require(tableHTML)

# see : https://ardata-fr.github.io/flextable-book/index.html
if(!require("flextable")){
  install.packages("flextable", dependencies = TRUE, INSTALL_opts = '--no-lock')
}
library("flextable")

# # IN ubuntu in a terminal, first install
# sudo add-apt-repository -y ppa:cran/imagemagick
# sudo apt-get update
# sudo apt-get install -y libmagick++-dev
# see : https://davidgohel.github.io/flextable/reference/as_image.html
if(!require("magick")){
  install.packages("magick", dependencies = TRUE, INSTALL_opts = '--no-lock')
}
library("magick")

# Insalling "xlsx" requires that you first run in a terminal:
# sudo apt install libbz2-dev
if(!require("xlsx")){
  install.packages("xlsx", dependencies = TRUE, INSTALL_opts = '--no-lock')
}
library("xlsx")
# install "remotes"
if(!require("remotes")){
  install.packages("remotes", dependencies = TRUE, INSTALL_opts = '--no-lock')
}
library("remotes")
#wd00 <- "/Users/steenknudsen/Documents/Documents/MS_amphibian_eDNA_assays"
wd00 <- "/home/hal9000/Documents/Documents/MS_amphibian_eDNA_assays/amphibia_eDNA_in_Denmark"
setwd(wd00)
inpf01 <- "lst_distrib_DK_amphibians.csv"
inpf02 <- "lst_distrib_areas_amphibians.csv"
wd02 <- "MS_suppm_amphibia_eDNA/supma09_plots_from_R_analysis"
wd01 <- "supma01_inp_raw_qcpr_csv"
wd07 <- "inp07_distrib_lsts"

wd00_wd01_wd07 <- paste(wd00,"/",wd01,"/",wd07,sep="")
wd00_inpf01 <- paste(wd00_wd01_wd07,"/",inpf01,sep="")
wd00_inpf02 <- paste(wd00_wd01_wd07,"/",inpf02,sep="")
df_di01 <- read.csv(wd00_inpf01, sep="\t",header = F)
df_ar01 <- read.csv(wd00_inpf02, sep="\t",header = T)
#
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
#
df_d02 <- as.data.frame(cbind(as.character(df_di01$V1), 
                              ls_ar01))
#
colnames(df_d02) <- c("species","ab.ar")
#
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
df_ar02 <- as.data.frame(cbind(as.character(df_ar01$Area[match(lst_ar.abb,df_ar01$Abbr)]),
                               as.character(df_ar01$Abbr[match(lst_ar.abb,df_ar01$Abbr)])))
colnames(df_ar02 ) <- c("area","abbr")
#
#exclude any rows with NA
df_ar03 <- na.omit(df_ar02)
#reorder columns by column name
df_ar03 <- df_ar03[ , c("abbr", "area")] 
#paste parenteses around abbreviation in column
df_ar03$abbr <- paste("(",df_ar03$abbr,")",sep="")
#make the area name a character
df_ar03$area <- as.character(df_ar03$area)
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
# split vector characters
lsp01 <- strsplit(as.character(ls4), "; ")
lsp01 <- strsplit(as.character(lsp01[[1]]), ": ")
# make it a data frame
df_lsp02 <- as.data.frame(do.call(rbind,lsp01))
# change column names
colnames(df_lsp02) <- c("spcNm","loc.abbr")
# reorder the data frame alphabetically by species name
df_lsp02 <- df_lsp02[order(df_lsp02$spcNm),]
# collapse vectors into onw text string
ls7 <- paste(ls4,ls6,collapse=". ")
# make a table caption, using the list of abbreviations for locations
table_capt01 <- paste("Table S1. Geographic occurence of the amphibian species monitored. Area of known occurence  and taxonomy is adopted from the study by Spreybock et al. (2010). The species listed occurs in the areas as indicated by geographic abbreviations. Abbreviations for areas and countries: ",
                      ls6,".")
#ls7
##______________________________________________________________________________
df_lsp03 <- df_lsp02
# count the number of columns in the data frame
ncld03 <- ncol(df_lsp03)
# rename the columns in the data frame
colnames(df_lsp03) <- c("Genus specis","Area of occurence")
# # start preparing the flextable
# ft <- flextable::flextable(df_lsp03)
# ft <- flextable::autofit(ft)
# ft <- flextable::padding(ft, padding = 0.4)
# # add a header row: https://ardata-fr.github.io/flextable-book/layout.html
# ft <- add_header_row(
#   x = ft, values = c(table_capt01),
#   # set the column width of this header row to equal the number of columns
#   # counted in the data frame
#   colwidths = c(ncld03))
# ft1 <- ft
wd00_outfl_tbl01 <-paste0(wd00,"/supma09_plots_from_R_analysis",
                          "/Table_S01_v01_geographic_area_of_occurence_for_amphibians.docx")

# print(ft, preview = "docx")
# print(ft, preview = "html")
# save_as_docx(
#   "Table_S01" = ft1, #"my table 2" = ft2, 
#   path = wd00_outfl_tbl01)
library(htmlTable)
# show the table
t.HTML03 <- df_lsp03 %>%
  htmlTable::addHtmlTableStyle(align = "l") %>%
  htmlTable::htmlTable(caption = table_capt01, rnames = FALSE)
t.HTML03

# #try the tableHTML with no border
# tableHTMLt03 <- df_lsp03 %>%
#   tableHTML(border = 0)
# #and to export in a file a html file
# write_tableHTML(tableHTMLt03, file = wd00_outfl_tbl01)