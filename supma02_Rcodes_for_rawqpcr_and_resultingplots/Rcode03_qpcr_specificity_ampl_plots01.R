#!/usr/bin/env Rscript
# -*- coding: utf-8 -*-

#____________________________________________________________________________#
# R-code  for :
# 
#
# “Standard dilution curves from qPCR MxPro txt files”
#
# Authors: Steen Wilhelm Knudsen.

#

# Change the working directory to a path on your own computer , and run
# the individual parts below to reproduce the diagrams presented in the paper
#
# All input data required needs to be available as csv-files in the same directory 
# as this R-code use for working directory.
#
# Occassionally the code will have difficulties producing the correct diagrams,
# if the packages and libraries are not installed.
# Make sure the packages are installed, and libraries are loaded, if the R-code
# fails in producing the diagrams.
#
#________________IMPORTANT!!_________________________________________________#
# (1)
#You have to change the path to the working directory before running this code
#
# (2)
# The 4 data input files required:
#
#
# must be located in the same working directory - as specified in the code below
#
#This code is able to run in:
#
#R studio: Version 0.98.994 – © 2009-2013 RStudio, Inc.
#Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_3) AppleWebKit/537.76.4 (KHTML, like Gecko)
#
#
#____________________________________________________________________________#

#see this
#website
#on how to only install required packages
#https://stackoverflow.com/questions/4090169/elegant-way-to-check-for-missing-packages-and-install-them
if (!require("pacman")) install.packages("pacman")
pacman::p_load(
  scales, 
  fields, 
  gplots,
  plyr)



## install the package 'scales', which will allow you to make points on your plot more transparent
#install.packages("scales")
if(!require(scales)){
  install.packages("scales")
  library(scales)
}
library(scales)

#install.packages("fields")
if(!require(fields)){
  install.packages("fields")
  library(fields)
}
library(fields)

## install the package 'gplots', to be able to translate colors to hex - function: col2hex
#install.packages("gplots")
if(!require(gplots)){
  install.packages("gplots")
  library(gplots)
}
library(gplots)

## install the package 'glad', to be able to color using the function 'myPalette'
#install.packages("glad")
#library(glad)

require(graphics)

#get package to read excel files
if(!require(readxl)){
  install.packages("readxl")
  library(readxl)
}

#get package to do count number of observations that have the same value at earlier records:
# see this website: https://stackoverflow.com/questions/11957205/how-can-i-derive-a-variable-in-r-showing-the-number-of-observations-that-have-th
#install.packages("plyr")
if(!require(plyr)){
  install.packages("plyr")
  library(plyr)
}
library(plyr)


##########################################################################################
# begin -  Function to fill NAs with previous value
##########################################################################################
#fill NAs with latest non-NA value
#http://www.cookbook-r.com/Manipulating_data/Filling_in_NAs_with_last_non-NA_value/
#https://stackoverflow.com/questions/7735647/replacing-nas-with-latest-non-na-value

fillNAgaps <- function(x, firstBack=FALSE) {
  ## NA's in a vector or factor are replaced with last non-NA values
  ## If firstBack is TRUE, it will fill in leading NA's with the first
  ## non-NA value. If FALSE, it will not change leading NA's.
  
  # If it's a factor, store the level labels and convert to integer
  lvls <- NULL
  if (is.factor(x)) {
    lvls <- levels(x)
    x    <- as.integer(x)
  }
  
  goodIdx <- !is.na(x)
  
  # These are the non-NA values from x only
  # Add a leading NA or take the first good value, depending on firstBack   
  if (firstBack)   goodVals <- c(x[goodIdx][1], x[goodIdx])
  else             goodVals <- c(NA,            x[goodIdx])
  
  # Fill the indices of the output vector with the indices pulled from
  # these offsets of goodVals. Add 1 to avoid indexing to zero.
  fillIdx <- cumsum(goodIdx)+1
  
  x <- goodVals[fillIdx]
  
  # If it was originally a factor, convert it back
  if (!is.null(lvls)) {
    x <- factor(x, levels=seq_along(lvls), labels=lvls)
  }
  
  x
}
##########################################################################################
# end -  Function to fill NAs with previous value
##########################################################################################


# set working directory
wd00 <- "/Users/steenknudsen/Documents/Documents/MS_amphibian_eDNA_assays/MS_suppm_amphibia_eDNA"
setwd (wd00)
getwd()
wdin01.1 <- "supma01_inp_raw_qcpr_csv"
wdout02.1 <- "supma02_Rcodes_for_rawqpcr_and_resultingplots"
#define directory with input flies
wdin01.2 <- "inp01_speci_ampl_plots_amphibia"
# define full path for input directory
inpfdir01 <- paste(wd00,"/",wdin01.1,"/",wdin01.2,sep="")
# define an outout directory
wdout02.2 <- "plotout02_amphibia_specificity"
wdout02.2 <- paste(wd00,"/",wdout02.1,"/",wdout02.2,sep="")
#delete previous versions of the output directory
unlink(wdout02.2, recursive=TRUE)
#create new directory
dir.create(wdout02.2)
#make a list of the input files
xls.qpcr.fls <- list.files(path=inpfdir01, 
  pattern="*.xls", full.names=TRUE, recursive=FALSE)

# How to add to a matrix initiated before the loop starts
# see https://stackoverflow.com/questions/13442461/populating-a-data-frame-in-r-in-a-loop
#number of files
ntrf <-  length(xls.qpcr.fls)
#prepare a matrix that matches
mtrx_fls01 <- matrix(ncol=2, nrow=ntrf)



#make a variable with the element you want to search for
id1 <- "xls"
#grep for this variable in the list -  see this example: https://stackoverflow.com/questions/35880242/r-selecting-element-from-list
ls.fl01.xls <- xls.qpcr.fls[grep(paste0(id1), xls.qpcr.fls)]
#get the number of elements in the list
nos.xls.fls <- length(grep(".xls", xls.qpcr.fls))
#nos.xls.fls <- 3
#make a sequence
nos.in.ls <- seq(1:nos.xls.fls)
#nos.in.ls <- seq(1:nos.xls.fls)
#combine to a dataframe
list.xls.inp01 <- as.data.frame(cbind(xls.qpcr.fls, nos.in.ls))
#Split up a dataframe by number of rows 
#https://stackoverflow.com/questions/7060272/split-up-a-dataframe-by-number-of-rows
#it will be put in a list of dataframes
spl_df01 <- split(list.xls.inp01,rep(1:nos.xls.fls,each=3))

#take one of these elements from this list and convert to an individual dataframe
mxpro_ampl.plot.files <- as.data.frame(spl_df01[2])
#add a column with numbers for plot - here it is from 1 to 4
mxpro_ampl.plot.files$no.f.plot <- seq(1:nos.xls.fls)
#change the column names
colnames(mxpro_ampl.plot.files)[1] <- c("filenm1")
colnames(mxpro_ampl.plot.files)[2] <- c("nos.ls")
#put one column from this dataframe in to a list, to be used to loop over
files <- mxpro_ampl.plot.files$filenm1
files <- xls.qpcr.fls
files <- as.vector(files)
#
####################################################################################
#Function for repating rows
#from this website:
#https://www.r-bloggers.com/a-quick-way-to-do-row-repeat-and-col-repeat-rep-row-rep-col/
####################################################################################
rep.row<-function(x,n){
  matrix(rep(x,each=n),nrow=n)
}
rep.col<-function(x,n){
  matrix(rep(x,each=n), ncol=n, byrow=TRUE)
}
####################################################################################

#define species names
spcls <- c(
  "Bombina_bombina", 
  "Bufo_bufo", 
  "Bufo_calamita", 
  "Bufo_viridis", 
  "Hyla_arborea", 
  "Pelobates_fuscus", 
  "Rana_esculentus",
  "Pelophylax_esculentus",
  "Pelophylax_ridibundus",
  "Rana_ridibundus",
  "Rana_arvalis", 
  "Rana_dalmatina", 
  "Rana_lessonae", 
  "Rana_temporaria", 
  "Ichthyosaura_alpestris", 
  "Lissotriton_vulgaris", 
  "Triturus_cristatus", 
  "Triturus_vulgaris", 
  "Triturus_alpestris",
  "Emys_orbicularis")
#use gsub to split between underscores
gnnm <- gsub("(.*)_.*","\\1",spcls) 
spnm <- gsub("(.*)_(.*)","\\2",spcls)
#combine to a dataframe
df_spcabbr01 <- as.data.frame(cbind(gnnm,spnm))
#get only the first 3 letters
df_spcabbr01$abbrgnnm <- substr(df_spcabbr01$gnnm,1,3)
df_spcabbr01$abbrspnm <- substr(df_spcabbr01$spnm,1,3)
#paste together
df_spcabbr01$Abbrnm <- paste(df_spcabbr01$abbrgnnm,df_spcabbr01$abbrspnm,sep="")
df_spcabbr01$Long_Lt_nm <- paste(df_spcabbr01$gnnm,"_",df_spcabbr01$spnm,sep="")
#get only the first letter
df_spcabbr01$flgnnm <- substr(df_spcabbr01$gnnm,1,1)
#make a short spc nm
df_spcabbr01$shspcnm <- paste(df_spcabbr01$flgnnm,". ",df_spcabbr01$spnm,sep="")

#get a single file from a list
files <- xls.qpcr.fls[-9]
#files <- files[-17:-19]
files <- files[-7]
# files <- files[-16]
# files <- files[-22]
# files <- files[-23]
#mxpro_ampl.plot.filename <- files[17]
#files <- mxpro_ampl.plot.filename[13]
#mxpro_ampl.plot.filename <- files
#files <- files[grepl("758",files)]
files <- files[!grepl("842_Lisvul_01",files)]
#files <- files[!grepl("842_Lisvul_01",files)]
#files <- files[!grepl("842",files)]
#files <- files[1:2]
#files <- files[2]
files
#
##____________________________________________________________________________________
# start- loop over filenames in dataframe prepared from list above
##____________________________________________________________________________________
#make  a number to ad to while terating over files
i <- 1
#make empty lists
lqnos <- list()
lspc <- list()
lplotno <- list()
linpf  <- list()
#iterate over files
for (mxpro_ampl.plot.filename in files){
  inpfilnm <- gsub("*.*/(*.*)","\\1",mxpro_ampl.plot.filename)
  #print(mxpro_ampl.plot.filename)}
  #get qpcrno
  qpcrno <- gsub("^*.*qpcr([0-9]+).*.$","\\1",inpfilnm)
  #get species abbreviation in file name
  flnmspab <- gsub("^*.*qpcr([0-9]+)_([A-Za-z]{6}).*.$","\\2",inpfilnm)
  #match the long species name to the abbreviated name
  long_spc_mn <- df_spcabbr01$Long_Lt_nm[match(flnmspab,df_spcabbr01$Abbrnm)]
  #get a long title for the plot
  plt_titl_w_long_spc_mn <- paste("qpcrno",qpcrno,"targeting",long_spc_mn,sep=" ")
  #match the current filename in the loop with the filename in the dataframe that also holds
#the number for the file - notice that the match-value needs to be converted to a 
#character
no.f.f2 <- mxpro_ampl.plot.files$nos.ls[match(mxpro_ampl.plot.filename, 
      as.character(mxpro_ampl.plot.files$filenm1))]
#match between current filename and return the sequence number
no.fpl1 <- mxpro_ampl.plot.files$no.f.plot[match(mxpro_ampl.plot.filename, 
      as.character(mxpro_ampl.plot.files$filenm1))]
# read in xls files as tibble
tib01 <- read_excel(mxpro_ampl.plot.filename)
#change to a dataframe
df01 <- as.data.frame(tib01)
#delete row number 1 -  as this only contains 'NA'
#https://stackoverflow.com/questions/7942519/deleting-every-n-th-row-in-a-dataframe
df02 <- df01[-1,]
#the data frame is off, and need the first column value to be the second value
df02[2,1] <- df02[1,1]
#replace the first column value with a column heading
df02[1,1] <- "well"
#chnage column names
colnames(df02)<- df02[1,]
#put the df back in to the same name but without the first row
df02 <- df02[-1,]
# use the function defined above
#Fill NA gaps on a selected column
df02$well <- fillNAgaps(df02$well)
#delete row if the column 'Cycles' matches the word 'Cycles'
df02 <- df02[!(df02$Cycles=="Cycles"),]
#convert to numeric
df02$Cycles  <- as.numeric(df02$Cycles)
# Rename column where names is "Fluorescence (dRn)"
names(df02)[names(df02) == "Fluorescence (dRn)"] <- "Fluorescence_dRn"
#convert to numeric
df02$Fluorescence_dRn <- as.numeric(df02$Fluorescence_dRn)
#plot the curves
#plot(df02$Cycles,df02$Fluorescence_dRn, type="o", col="blue" ) 
#split by delimiter
#https://stackoverflow.com/questions/7069076/split-column-at-delimiter-in-data-frame
#replace Qty and up until comma with space
df02$well <- gsub(" Qty*.*,"," ",df02$well)
#nrow(df02)
#replace some of the unneeded underscores
df02$well <- gsub("PFT_Ranesc_","Ranesc",df02$well)
df02$well <- gsub("Bucal","Bufcal",df02$well)
#unique(df02$well)
#df02$well <- gsub("\\.","",df02$well)
#df02$well <- gsub(":","",df02$well)
#unique(df02$well)
#head(df02)
#exclude rows where 'ROX' appear
df02 <- df02[!grepl("ROX",df02$well),]
df02$well <- gsub(" FAM",", FAM ",df02$well)
df02$well <- gsub(",,",",",df02$well)
#unique(df02$well)
well.splt01 <- data.frame(do.call('rbind', strsplit(as.character(df02$well),',',fixed=TRUE)))
#nrow(well.splt02)
well.splt02 <- data.frame(do.call('rbind', strsplit(as.character(well.splt01$X3),'_',fixed=TRUE)))
well.splt03 <- data.frame(do.call('rbind', strsplit(as.character(well.splt01$X2),' ',fixed=TRUE)))
well.splt03 <- data.frame(do.call('rbind', strsplit(as.character(well.splt01$X3),' ',fixed=TRUE)))
well.splt04 <- data.frame(do.call('rbind', strsplit(as.character(well.splt03$X2),'_',fixed=TRUE)))
#append back to dataframe
#also replace using 'sub' and convert to factor
df02$repl.no <- as.numeric(as.factor(sub("Repl. ", "",well.splt01$X2)))
#check if the xls-plot-file is 'wrong' i.e. without any rows, and needs to be skipped
if(length(df02$repl.no)==0)
{print("repl.no is 0")} else {
#}
  #check 
  if (is.null(well.splt01$X4)) {
    df02$probe.col <- as.factor(well.splt01$X3)} else {
    df02$probe.col <- well.splt01$X4}

#append more back to the original dataframe
  if (is.null(well.splt02$X1)) {
      df02$repl.symb <- as.factor(well.splt01$X1)} else {
      df02$repl.symb <- well.splt02$X1}
  if (is.null(well.splt02$X1)) {
      df02$spc.abbr <- as.factor(well.splt01$X2)} else {
      df02$spc.abbr <- well.splt02$X2}
df02$well.type <- well.splt01$X2
df02$well.vol <- well.splt02$X4
df02$well.no <- well.splt01$X1
df02$spctest_flcol <- well.splt01$X2

#(length(well.splt02$X1)==0)
#head(well.splt02,6)
#df02$spctest
#well.splt02$
# check the spcs name is in the df of abbreviated names, 
#if yes, then use the long name, if not then do not change
df02$spc.abbr <- ifelse(df02$spc.abbr %in% df_spcabbr01$Abbrnm, df_spcabbr01$shspcnm[match(df02$spctest,df_spcabbr01$Abbrnm)],gsub(" ","",as.character(well.splt02$X1)))

df02$repl.symb <-  df02$spc.abbr
well.splt05 <- data.frame(do.call('rbind', strsplit(as.character(df02$spctest_flcol),' ',fixed=TRUE)))
#check if the column has 'Repl'
df02$spctest <- ifelse(grepl("Repl",df02$spctest),as.character(df02$repl.symb),as.character(well.splt05$X2))
df02$spctest <- gsub(" ","",df02$spctest)
# #replace numbers
 df02$spctest <- (gsub("[0-9]+","",df02$spctest))
# #replace unneeded spaces
 df02$spctest <- (gsub(" ","",df02$spctest))
 #replace odd 'Ranesc'
 df02$spctest <- gsub("Ranescp.","Ranesc",df02$spctest)
 df02$spctest <- gsub("Ranescp","Ranesc",df02$spctest)
# check the spcs name is in the df of abbreviated names, if yes, then use the long name, if not then do not change
 df02$spctest2 <- ifelse(df02$spctest %in% df_spcabbr01$Abbrnm, df_spcabbr01$shspcnm[match(df02$spctest,df_spcabbr01$Abbrnm)],df02$spctest)
 #check if the string needs to be split
 df02$spctest2 <- ifelse(grepl("_",df02$spctest2),
   as.character(data.frame(do.call('rbind', strsplit(as.character(df02$spctest2),'_',fixed=TRUE)))[,1]),
   df02$spctest2)
 #check again
 df02$spctest2 <- ifelse(df02$spctest2 %in% df_spcabbr01$Abbrnm, df_spcabbr01$shspcnm[match(df02$spctest2,df_spcabbr01$Abbrnm)],df02$spctest2)
#check if the species is NA
 if (is.na(df02$spctest2)) {df02$spctest2 <- well.splt02$X2}
  #unique(df02$spctest2)
 #replace unneeded spaces
 df02$spctest2 <-gsub(" ","",df02$spctest2)
  #get a column for a colur
df02$fl_col <- well.splt05$X5
#remove rows that has 'ROX'
df02 <- df02[!grepl("ROX",df02$well),]
#append back to df as numeric and replace with 'gsub' function
#df02$well.vol.val <- as.numeric(sub("uL", "",df02$well.vol))
df02$well.conc1 <- df02$well.type
#replace to w gsub to get only file name
inpflnm01 <- gsub("*.*/(*.*$)","\\1",mxpro_ampl.plot.filename)

#inpflnm01
#df_spcabbr01$Abbrnm
#https://stackoverflow.com/questions/31751022/a-function-to-create-multiple-plots-by-subsets-of-data-frame
library(ggplot2)
plot01 <- ggplot(df02, aes(x = Cycles,
                y = Fluorescence_dRn, 
                group= well.no, 
                color = spctest2)) +
  #https://stackoverflow.com/questions/41631806/change-facet-label-text-and-background-colour/60046113#60046113
  #ggtitle(inpflnm01) +
  ggtitle(long_spc_mn) +
  
  #ggtitle(plt_titl_w_long_spc_mn) +
  #
  geom_point() + 
  #facet_wrap(~spctest, nrow = 3) + #'facet_wrap' subsets by column value in dataframe
  geom_line() #add lines

#plot01  
#substitute in the the variable, escape the point with double backslash

inpflnm02 <- gsub(" ","_",inpflnm01)
plot.nm2 <- sub("\\.xls", "_",inpflnm02)
plot.nm3 <-  paste(plot.nm2,"out02",sep="")
plot.nm4 <- paste(wdout02.2,"/",plot.nm3,".pdf",sep="")
#print the plot in a pdf
pdf(c(plot.nm4)
    ,width=(1*8.2677),height=(3*2.9232))
print(plot01)
dev.off()
pltno <- paste("plot01_no_",i,"_qpcrno",qpcrno,sep="")
assign(pltno,plot01)

lqnos[[i]] <- qpcrno 
lspc[[i]] <- flnmspab
linpf[[i]] <- inpfilnm
lplotno[[i]] <- pltno
i <- i+1
#end if test for repl is 0
}
#end iterate over files
}

#

#combine lists to a data frame
df_plots01 <- as.data.frame(as.matrix(cbind(lqnos, lspc, linpf,lplotno)))
#get the plots with the best in vitro tested primers 
pl_Bombom <- get(df_plots01[grepl("qpcr545",df_plots01$linpf),]$lplotno[[4]]) #Bombina bombina #qpcr 545-04
pl_Bufbuf <- get(df_plots01[grepl("qpcr608",df_plots01$linpf),]$lplotno[[5]]) #Bufo bufo # qpcr 608-05
pl_Bufcal <- get(df_plots01[grepl("qpcr800",df_plots01$linpf),]$lplotno[[1]]) #Bufo_calamita # qpcr800-01
pl_Bufvir <- get(df_plots01[grepl("qpcr802",df_plots01$linpf),]$lplotno[[1]]) #Bufo viridis # qpcr802-01
pl_Emyorb <- get(df_plots01[grepl("qpcr504",df_plots01$linpf),]$lplotno[[1]]) #Emys_orbicularis #qpcr 504-01
pl_Hylarb <- get(df_plots01[grepl("qpcr800",df_plots01$linpf),]$lplotno[[3]]) #Hyla_arborea # qpcr800-04
pl_Ichalp <- get(df_plots01[grepl("qpcr618",df_plots01$linpf),]$lplotno[[1]]) #Ichthyosaura_alpestris # qpcr 618-01
pl_Pelfus <- get(df_plots01[grepl("qpcr800",df_plots01$linpf),]$lplotno[[5]]) #Pelobates_fuscus # qpcr800-05
pl_Ranarv <- get(df_plots01[grepl("qpcr617",df_plots01$linpf),]$lplotno[[5]]) #Rana_arvalis # qpcr 617-05
pl_Randal <- get(df_plots01[grepl("qpcr506",df_plots01$linpf),]$lplotno[[2]]) #Rana_dalmatina # qpcr 506-02
pl_Ranles <- get(df_plots01[grepl("qpcr635",df_plots01$linpf),]$lplotno[[1]])  #Rana_lessonae (and thereby also Rana kl. esculenta) # qpcr 635-02
pl_Ranrid <- get(df_plots01[grepl("qpcr612",df_plots01$linpf),]$lplotno[[1]]) #Rana ridibunda # qpcr 612-01
pl_Rantem <- get(df_plots01[grepl("qpcr610",df_plots01$linpf),]$lplotno[[5]]) #Rana temporaria # qpcr 610-05
pl_Tricri <- get(df_plots01[grepl("qpcr802",df_plots01$linpf),]$lplotno[[3]]) #Triturus cristatus # qpcr802-02
pl_Lisvul1 <- get(df_plots01[grepl("qpcr842",df_plots01$linpf),]$lplotno[[2]]) #Lissitriton vulgaris # qpcr842-03
pl_Lisvul2 <- get(df_plots01[grepl("qpcr842",df_plots01$linpf),]$lplotno[[1]])
pl_Lisvul <- pl_Lisvul2
plot_empt <- plot.new()

plt2 <- c(pl_Bombom,
pl_Bufbuf,
pl_Bufcal,
pl_Bufvir,
pl_Emyorb,
pl_Hylarb,
pl_Ichalp,
pl_Lisvul,
pl_Pelfus,
pl_Ranarv,
pl_Randal,
pl_Ranles,
pl_Ranrid,
pl_Rantem,
pl_Tricri)

#change column names
colnames(df_plots01) <- c("qpcrNo", "spc","flnm", "plotno")

df_plots01$qpcrNo <- as.numeric(df_plots01$qpcrNo)
df_plots01$spc <- as.character(df_plots01$spc)
df_plots01$flnm <- as.character(df_plots01$flnm)
df_plots01$plotno <- as.character(df_plots01$plotno)
#https://community.rstudio.com/t/how-to-select-top-n-highest-value-and-create-new-column-with-it/38914
#https://stackoverflow.com/questions/24237399/how-to-select-the-rows-with-maximum-values-in-each-group-with-dplyr
#load the dplyr package
library(dplyr)
#use the dplyr to group by 'spc' and then filter inside each group
tibl_plt03 <- df_plots01 %>% 
  dplyr::group_by(spc) %>%
  dplyr::distinct(spc, .keep_all = T) %>%
  #select among the highest qPCRno
  #because the highest number equals the most recent qPCR performed
  dplyr::filter(qpcrNo == max(qpcrNo))
#make the tibble a data frame
df_plt04 <- as.data.frame(tibl_plt03)
# Sort by vector name [query_def] then [Hsp_bit_score]
df_plt05 <- df_plt04[with(df_plt04, order(spc)),]

get(df_plt05$plotno[1])

# because it fits nicely with two plots in one column on an A4 page
df_plt05 <-  as.data.frame(matrix(unlist(df_plt05), nrow=2))


#plt06_qpcrno637
#plt11_qpcrno811



#________________________________________________________________________________
#________________________________________________________________________________
#http://www.cookbook-r.com/Graphs/Multiple_graphs_on_one_page_(ggplot2)/
# Multiple plot function
#
# ggplot objects can be passed in ..., or to plotlist (as a list of ggplot objects)
# - cols:   Number of columns in layout
# - layout: A matrix specifying the layout. If present, 'cols' is ignored.
#
# If the layout is something like matrix(c(1,2,3,3), nrow=2, byrow=TRUE),
# then plot 1 will go in the upper left, 2 will go in the upper right, and
# 3 will go all the way across the bottom.
#
multiplot <- function(..., plotlist=NULL, file, cols=1, layout=NULL) {
  library(grid)
  
  # Make a list from the ... arguments and plotlist
  plots <- c(list(...), plotlist)
  
  numPlots = length(plots)
  
  # If layout is NULL, then use 'cols' to determine layout
  if (is.null(layout)) {
    # Make the panel
    # ncol: Number of columns of plots
    # nrow: Number of rows needed, calculated from # of cols
    layout <- matrix(seq(1, cols * ceiling(numPlots/cols)),
                     ncol = cols, nrow = ceiling(numPlots/cols))
  }
  
  if (numPlots==1) {
    print(plots[[1]])
    
  } else {
    # Set up the page
    grid.newpage()
    pushViewport(viewport(layout = grid.layout(nrow(layout), ncol(layout))))
    
    # Make each plot, in the correct location
    for (i in 1:numPlots) {
      # Get the i,j matrix positions of the regions that contain this subplot
      matchidx <- as.data.frame(which(layout == i, arr.ind = TRUE))
      
      print(plots[[i]], vp = viewport(layout.pos.row = matchidx$row,
                                      layout.pos.col = matchidx$col))
    }
  }
}

#try saving as jpeg instead - then comment out the 'pdf' part above
jpeg(c(paste(wdout02.2,"/combplot_01",
             ".jpg",  sep = ""))
     ,width=(1.6*8.2677),height=(2*1.6*2*2.9232),
     units="in",res=300,pointsize=16)
#plot the plot
#combine plots with function
multiplot(
  pl_Bombom,
  pl_Bufbuf,
  pl_Bufcal,
  pl_Bufvir
  , cols=2)
# end plot
dev.off()

#try saving as jpeg instead - then comment out the 'pdf' part above
jpeg(c(paste(wdout02.2,"/combplot_02",
             ".jpg",  sep = ""))
     ,width=(1.6*8.2677),height=(2*1.6*2*2.9232),
     units="in",res=300,pointsize=16)
#plot the plot
#combine plots with function
multiplot(
  pl_Lisvul, 
  pl_Hylarb, 
  pl_Ichalp, 
  pl_Pelfus
  
  , cols=2)
# end plot
dev.off()

#try saving as jpeg instead - then comment out the 'pdf' part above
jpeg(c(paste(wdout02.2,"/combplot_03",
             ".jpg",  sep = ""))
     ,width=(1.6*8.2677),height=(2*1.6*2*2.9232),
     units="in",res=300,pointsize=16)
#plot the plot
#combine plots with function
multiplot(
  pl_Ranarv, 
  pl_Randal, 
  pl_Ranles, 
  pl_Ranrid
  
  , cols=2)
# end plot
dev.off()


#try saving as jpeg instead - then comment out the 'pdf' part above
jpeg(c(paste(wdout02.2,"/combplot_04",
             ".jpg",  sep = ""))
     ,width=(1.6*8.2677),height=(2*1.6*2*2.9232),
     units="in",res=300,pointsize=16)
#plot the plot
#combine plots with function
multiplot(
  pl_Rantem, 
  pl_Tricri,
  plot.new(),
  plot.new()
  , cols=2)
# end plot
dev.off()

##
#try saving as pdf instead - then comment out the 'pdf' part above
pdf(c(paste(wdout02.2,"/primer_specific_combplot_01",
      ".pdf",  sep = ""))
,width=(1.6*8.2677),height=(2*1.6*2*2.9232))#,
#units="in",res=300,pointsize=16)
#plot the plot
#combine plots with function
multiplot(
  pl_Bombom,
  pl_Bufbuf,
  pl_Bufcal,
  pl_Bufvir
  , cols=2)
# end plot
dev.off()

#try saving as pdf instead - then comment out the 'pdf' part above
pdf(c(paste(wdout02.2,"/primer_specific_combplot_02",
            ".pdf",  sep = ""))
    ,width=(1.6*8.2677),height=(2*1.6*2*2.9232))#,
#units="in",res=300,pointsize=16)
#plot the plot
#combine plots with function
multiplot(
  pl_Lisvul, 
  pl_Hylarb, 
  pl_Ichalp, 
  pl_Pelfus
  
  , cols=2)
# end plot
dev.off()

#try saving as pdf instead - then comment out the 'pdf' part above
pdf(c(paste(wdout02.2,"/primer_specific_combplot_03",
            ".pdf",  sep = ""))
    ,width=(1.6*8.2677),height=(2*1.6*2*2.9232))#,
#units="in",res=300,pointsize=16)
#plot the plot
#combine plots with function
multiplot(
  pl_Ranarv, 
  pl_Randal, 
  pl_Ranles, 
  pl_Ranrid
  
  , cols=2)
# end plot
dev.off()


#try saving as pdf instead - then comment out the 'pdf' part above
pdf(c(paste(wdout02.2,"/primer_specific_combplot_04",
            ".pdf",  sep = ""))
    ,width=(1.6*8.2677),height=(2*1.6*2*2.9232))#,
#units="in",res=300,pointsize=16)
#plot the plot
#combine plots with function
multiplot(
  pl_Rantem, 
  pl_Tricri,
  plot_empt,
  plot_empt
  , cols=2)
# end plot
dev.off()



#____

#https://stackoverflow.com/questions/25401111/left-adjust-title-in-ggplot2-or-absolute-position-for-ggtitle
library(ggplot2)
library(grid)
library(gridExtra)
# prepare titles to use for subfigure letters in grid arranged plots
#make a title for one plot to use in the grid arrange
title.grob01 <- textGrob(
  label = "A",
  x = unit(0, "lines"), 
  y = unit(0, "lines"),
  hjust = 0, vjust = 0,
  gp = gpar(fontsize = 32))
#make a title for the second plot to use in the grid arrange
title.grob02 <- textGrob(
  label = "B",
  x = unit(0, "lines"), 
  y = unit(0, "lines"),
  hjust = 0, vjust = 0,
  gp = gpar(fontsize = 32))
#make a title for the 3rd plot to use in the grid arrange
title.grob03 <- textGrob(
  label = "C",
  x = unit(0, "lines"), 
  y = unit(0, "lines"),
  hjust = 0, vjust = 0,
  gp = gpar(fontsize = 32))
#make a title for the 4th plot to use in the grid arrange
title.grob04 <- textGrob(
  label = "D",
  x = unit(0, "lines"), 
  y = unit(0, "lines"),
  hjust = 0, vjust = 0,
  gp = gpar(fontsize = 32))

#arrange plots in grid
p3_01 <-grid.arrange(
  arrangeGrob(pl_Bombom, top = title.grob01),
  arrangeGrob(pl_Bufbuf, top = title.grob02),
  arrangeGrob(pl_Bufcal, top = title.grob03),
  arrangeGrob(pl_Bufvir, top = title.grob04),
                  #top = "Global Title", ncol=1) #Use this if you want a global title
                  top = " ", ncol=2)

#arrange plots in grid
p3_02 <-grid.arrange(
  arrangeGrob(	pl_Hylarb, top = title.grob01),
  arrangeGrob(	pl_Ichalp, top = title.grob02),
  arrangeGrob(	pl_Pelfus, top = title.grob03),
  arrangeGrob(	pl_Ranarv, top = title.grob04),
  #top = "Global Title", ncol=1) #Use this if you want a global title
  top = " ", ncol=2)


#arrange plots in grid
p3_03 <-grid.arrange(
  arrangeGrob( 	pl_Randal, top = title.grob01),
  arrangeGrob(	pl_Ranles, top = title.grob02),
  arrangeGrob(	pl_Ranrid, top = title.grob03),
  arrangeGrob(	pl_Rantem, top = title.grob04),
  #top = "Global Title", ncol=1) #Use this if you want a global title
  top = " ", ncol=2)

#arrange plots in grid
p3_04 <-grid.arrange(
  arrangeGrob( 	pl_Tricri, top = title.grob01),
  arrangeGrob(	pl_Lisvul, top = title.grob02),
  arrangeGrob(	plot.new(), top = title.grob03),
  arrangeGrob(	plot.new(), top = title.grob04),
  #top = "Global Title", ncol=1) #Use this if you want a global title
  top = " ", ncol=2)

# set working directory
setwd (wd00)
getwd()
pthout <- paste(wd00,wd02,"/",sep="")
# get the number of columns from the df with plots
nclpl <- ncol(df_plt05)



#try saving as pdf instead - then comment out the 'pdf' part above
pdf(c(paste(wdout02.2,"/primer_spec_combplot_01",
            ".pdf",  sep = ""))
    ,width=(1.6*8.2677),height=(2*1.6*2*2.9232))#,
#units="in",res=300,pointsize=16)
#plot the plot
p3_01
# end plot
dev.off()


#try saving as pdf instead - then comment out the 'pdf' part above
pdf(c(paste(wdout02.2,"/primer_spec_combplot_02",
            ".pdf",  sep = ""))
    ,width=(1.6*8.2677),height=(2*1.6*2*2.9232))#,
#units="in",res=300,pointsize=16)
#plot the plot
p3_02
# end plot
dev.off()

#try saving as pdf instead - then comment out the 'pdf' part above
pdf(c(paste(wdout02.2,"/primer_spec_combplot_03",
            ".pdf",  sep = ""))
    ,width=(1.6*8.2677),height=(2*1.6*2*2.9232))#,
#units="in",res=300,pointsize=16)
#plot the plot
p3_03
# end plot
dev.off()


#try saving as pdf instead - then comment out the 'pdf' part above
pdf(c(paste(wdout02.2,"/primer_spec_combplot_04",
            ".pdf",  sep = ""))
    ,width=(1.6*8.2677),height=(2*1.6*2*2.9232))#,
#units="in",res=300,pointsize=16)
#plot the plot
p3_04
# end plot
dev.off()
#

#

