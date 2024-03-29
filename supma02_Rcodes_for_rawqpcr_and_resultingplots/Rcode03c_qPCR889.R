# for this code
########################################################################################
# R-code for making sigmoid curve plots from MxPro 3005 qPCR probe plots


# Make sigmoid curve qPCR plots from excel files exported from MxPro
########################################################################################
# > version
# _                           
# platform       x86_64-apple-darwin10.8.0   
# arch           x86_64                      
# os             darwin10.8.0                
# system         x86_64, darwin10.8.0        
# status                                     
# major          3                           
# minor          2.1                         
# year           2015                        
# month          06                          
# day            18                          
# svn rev        68531                       
# language       R                           
# version.string R version 3.2.1 (2015-06-18)
# nickname       World-Famous Astronaut
########################################################################################
#remove everything in the working environment, without a warning!!
rm(list=ls())
########################################################################################
# set working directory
#wd00 <- "/Users/steenknudsen/Documents/Documents/MS_amphibian_eDNA_assays/MS_suppm_amphibia_eDNA"
wd00 <- "/home/hal9000/Documents/Documents/MS_amphibian_eDNA_assays/MS_suppm_amphibia_eDNA"
setwd (wd00)
getwd()
wdin01.1 <- "supma01_inp_raw_qcpr_csv"
wdout02.1 <- "supma02_Rcodes_for_rawqpcr_and_resultingplots"
#define directory with input flies
wdin01.2 <- "inp01_speci_ampl_plots_amphibia"
# define full path for input directory
inpfdir01 <- paste(wd00,"/",wdin01.1,"/",wdin01.2,sep="")
wd <- inpfdir01
# define an outout directory
wdout02.2 <- "plotout02_amphibia_specificity"
wdout02.2 <- paste(wd00,"/",wdout02.1,"/",wdout02.2,sep="")
#install packages
#get readxl package
if(!require(readxl)){
  install.packages("readxl")
}  
library(readxl)
#get ggplot package
if(!require(ggplot2)){
  install.packages("ggplot2")
}  
library(ggplot2)

#get pdp package
if(!require(pdp)){
  install.packages("pdp")
}  
library(pdp)

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

##########################################################################################
# begin - install packages to be able to do the ggplot below
##########################################################################################
#get tidyverse package
if(!require(tidyverse)){
  install.packages("tidyverse")
}  
library(tidyverse)

#get broom package
if(!require(broom)){
  install.packages("broom")
}  
library(broom)

#get mgcv package
if(!require(mgcv)){
  install.packages("mgcv")
}  
library(mgcv)

#get tibble package
if(!require(tibble)){
  install.packages("tibble")
}  
library(tibble)

#library(tidyverse)
#library(broom)
#library(mgcv)  #For the gam model
##########################################################################################
# end - install packages to be able to do the ggplot below
##########################################################################################

##########################################################################################
# Note about the input files for this code
##########################################################################################
# The excel files are prepared in the MxPro software as individual amplification plots
# and exported  from MxPro as individual excel spreadsheets
# all spreadsheets can then be zipped together, and transfered to your own computer
# unzip the zip file with all xls-files in a folder that also works as working directory
##########################################################################################

#list all files in wd - all the xls-files for which you want to prepare plots from 
ls.fl01 <- list.files(wd)
#make a variable with the element you want to search for
id1 <- "xls"
#grep for this variable in the list -  see this example: https://stackoverflow.com/questions/35880242/r-selecting-element-from-list
ls.fl01.xls <- ls.fl01[grep(paste0(id1), ls.fl01)]
ls.fl01.xls<- ls.fl01.xls[grep("889", ls.fl01.xls)]

#get the number of elements in the list
nos.xls.fls <- length(grep(".xls", ls.fl01))
nos.xls.fls <- 3
#make a sequence
nos.in.ls <- seq(1:nos.xls.fls)
nos.in.ls <- seq(1:nos.xls.fls)
#combine to a dataframe
list.xls.inp01 <- as.data.frame(cbind(ls.fl01.xls, nos.in.ls))

#Split up a dataframe by number of rows 
#https://stackoverflow.com/questions/7060272/split-up-a-dataframe-by-number-of-rows
#it will be put in a list of dataframes
spl_df01 <- split(list.xls.inp01,rep(1:nos.xls.fls,each=3))
#get the first element from this list
#spl_df01[1]
#get the second element from this list
#spl_df01[2]
#get the third element from this list
#spl_df01[3]

#take one of these elements from this list and convert to an individual dataframe
#mxpro_ampl.plot.files <- as.data.frame(spl_df01[1])
mxpro_ampl.plot.files <- as.data.frame(spl_df01[2])
#mxpro_ampl.plot.files <- as.data.frame(spl_df01[3])
#add a column with numbers for plot - here it is from 1 to 4
mxpro_ampl.plot.files$no.f.plot <- seq(1:nos.xls.fls)
#change the column names
colnames(mxpro_ampl.plot.files)[1] <- c("filenm1")
colnames(mxpro_ampl.plot.files)[2] <- c("nos.ls")
#put one column from this dataframe in to a list, to be used to loop over
files <- mxpro_ampl.plot.files$filenm1
files <- as.vector(files)
#define xls file
mxpro_ampl.plot.filename <- "ampl_plot_qpcr842_Lisvul_01_20210413.xls"
files <- "ampl_plot_qpcr842_Lisvul_01_20210413.xls"
mxpro_ampl.plot.filename <- ls.fl01.xls 
files <- ls.fl01.xls

#define primers used 

prim1 <- c("Esoluc_F01", "Esoluc_R01", "Esoluc_P01")
#prim2 <- c("CBL", "CBR", "CBprobe")
# prim3 <- c("NA", "NA", "NA")
# prim4 <- c("NA", "NA", "NA")
# prim5 <- c("NA", "NA", "NA")
# prim6 <- c("NA", "NA", "NA")
#bind them to a data frame
hc <- data.frame(
  prim1)#,
  #prim2)#,
# prim3,
# prim4,
# prim5,
# prim6)
hc <- as.data.frame(t(hc))
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
prim1.1 <- rep.row(prim1,16)
#prim2.1 <- rep.row(prim2,8)
# prim3.1 <- rep.row(prim3,16)
# prim4.1 <- rep.row(prim4,16)
# prim5.1 <- rep.row(prim5,16)
# prim6.1 <- rep.row(prim6,16)
# append the rows to each other, and make it a dataframe
prim.df <- as.data.frame(rbind(prim1.1, prim2.1))#, prim3.1, prim4.1, prim5.1, prim6.1))
prim.df <- as.data.frame(rbind(prim1.1))
#change the column names
colnames(prim.df) <- c("F.prim","R.prim", "Probe")
#head(prim.df)
#make sequence of  numbers - to match the qPCR plate
a <- LETTERS[seq( from = 1, to = 8 )]
#make sequence of letters  - to match the qPCR plate
b <- seq(1:2)
#Make all possible combinations : see this website : https://stackoverflow.com/questions/11388359/unique-combination-of-all-elements-from-two-or-more-vectors
df <- expand.grid(a,b)
#sort by the second column with numbers, and put it in a dataframe
well.no.df <- df[order(df$Var2), ]
well.no.df$well.nm <- paste(df$Var1, df$Var2, sep="")
#append to the previous dataframe as columns
well.prim.df <- cbind(well.no.df,prim.df)
#head(well.prim.df)
#get list of files
lstfi01<- list.files(paste("./",wdin01.1,"/",wdin01.2,sep=""))
incsvfl <- lstfi01[grepl(".csv",lstfi01)]
incsvfl2 <- incsvfl[grepl("888",incsvfl)]
pthinfcsv  <- paste("./",wdin01.1,"/",wdin01.2,"/",incsvfl2,sep="")
#read csv file with smpl locations and positions
df_wllnmrepl <-as.data.frame(read.csv(pthinfcsv,
                                      header = TRUE, sep = "\t", quote = "\"",
                                      dec = ".", fill = TRUE, comment.char = "",
                                      stringsAsFactors = FALSE))
#match replacement well names
well.prim.df$well.nm2 <- df_wllnmrepl$Well.Name[match(well.prim.df$well.nm,df_wllnmrepl$Well)]

##____________________________________________________________________________________
# start- loop over filenames in dataframe prepared from list above
##____________________________________________________________________________________
#for (mxpro_ampl.plot.filename in files){

#match the current filename in the loop with the filename in the dataframe that also holds
#the number for the file - notice that the match-value needs to be converted to a 
#character
no.f.f2 <- mxpro_ampl.plot.files$nos.ls[match(mxpro_ampl.plot.filename, 
                                              as.character(mxpro_ampl.plot.files$filenm1))]
#match between current filename and return the sequence number
no.fpl1 <- mxpro_ampl.plot.files$no.f.plot[match(mxpro_ampl.plot.filename, 
                                                 as.character(mxpro_ampl.plot.files$filenm1))]
pthinf2 <- paste(wd00,"/",wdin01.1,"/",wdin01.2,sep="")

inpf3 <- paste(pthinf2,"/",mxpro_ampl.plot.filename,sep="")
# read in xls files as tibble
tib01 <- read_excel(inpf3)
#change to a dataframe
df01 <- as.data.frame(tib01)
#delete row number 1 -  as this only contains 'NA'
#https://stackoverflow.com/questions/7942519/deleting-every-n-th-row-in-a-dataframe
df02 <- df01[-1,]
#the data frame is off, and need the first column value to be the second value
df02[2,1] <- df02[1,1]
#head(df02)
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

# Fill the leading NA's with the first good value
#fillNAgaps(x, firstBack=TRUE)
#split by delimiter
#https://stackoverflow.com/questions/7069076/split-column-at-delimiter-in-data-frame

#replace Qty and up until comma with space
df02$well <- gsub(" Qty*.*,"," ",df02$well)
#head(df02)

well.splt01 <- data.frame(do.call('rbind', strsplit(as.character(df02$well),',',fixed=TRUE)))
well.splt02 <- data.frame(do.call('rbind', strsplit(as.character(well.splt01$X3),'_',fixed=TRUE)))

well.splt03 <- data.frame(do.call('rbind', strsplit(as.character(well.splt01$X2),' ',fixed=TRUE)))
well.splt03 <- data.frame(do.call('rbind', strsplit(as.character(well.splt01$X3),' ',fixed=TRUE)))
well.splt04 <- data.frame(do.call('rbind', strsplit(as.character(well.splt03$X2),'_',fixed=TRUE)))
#head(well.splt01)
#unique(well.splt01$X1)
#head(well.splt02)
#head(well.splt04)
#head(well.splt03)
#Match the primer and the probe name back on to the dataframe with amplification levels
df02$F.prim <-  well.prim.df$F.prim[match(well.splt01$X1, well.prim.df$well.nm)]
df02$R.prim <-  well.prim.df$R.prim[match(well.splt01$X1, well.prim.df$well.nm)]
df02$Probe <-  well.prim.df$Probe[match(well.splt01$X1, well.prim.df$well.nm)]
#
df02$FRP.comb <- paste(df02$F.prim, df02$R.prim, df02$Probe, sep="_")
#append back to dataframe
df02$well.no <- well.splt01$X1
#also replace using 'sub' and convert to factor
df02$repl.no <- as.numeric(as.factor(sub("Repl. ", "",well.splt01$X2)))
df02$probe.col <- well.splt01$X4
df02$probe.col <- well.splt03$X5
#append more back to the original dataframe
df02$repl.symb <- well.splt02$X1
df02$spc.abbr <- well.splt02$X2

df02$spc.abbr <- well.splt04$X3
df02$spc.abbr <- well.splt04$X2

df02$well.type <- well.splt02$X3
df02$well.vol <- well.splt02$X4
#append back to df as numeric and replace with 'gsub' function
#df02$well.vol.val <- as.numeric(sub("uL", "",df02$well.vol))
df02$well.conc1 <- df02$well.type

df02$wll <- well.splt01$X1
df02$wllnm2 <- df_wllnmrepl$Well.Name[match(df02$wll,df_wllnmrepl$Well)]
wllnm2spl <- data.frame(do.call('rbind', strsplit(as.character(df02$wllnm2),'_',fixed=TRUE)))
unique(wllnm2spl$X1)
df02$wllnm3 <-  wllnm2spl$X1
df02$wllnm3 <- gsub("T.vulgaris","Trivul",df02$wllnm3)
df02$wllnm3 <- gsub("T.alpestris","Ichalp",df02$wllnm3)
df02$wllnm3 <- gsub("T.cristatus","Tricri",df02$wllnm3)
df02$wllnm3 <- gsub("T.cristatus","Tricri",df02$wllnm3)
df02$wllnm3 <- gsub("I.alpestris.stubbaek","Ichalp",df02$wllnm3)


unique(df02$wllnm3)
df03 <- df02[(!df02$wllnm3=="Trivul"),]
df03 <- df03[(!df03$wllnm3=="Ichalp"),]
df03 <- df03[(!df03$wllnm3=="Hylarb"),]
df03 <- df03[(!df03$wllnm3=="NK"),]
df03 <- df03[(!df03$wllnm3=="B.bufo"),]

#head(df03,6)
df03$well.type.spc.abbr <- paste(df03$well.type,df03$spc.abbr, sep = ".")
#get the part of the textstring in front of the space
#df03$well.type.spc.abbr02 <- sub("(.*?) .*", "\\1", as.character(df03$well.type.spc.abbr))
#df03$FRP.comb.spc <- paste(df03$repl.symb, df03$FRP.comb, sep="_")
#head(df03)
#df03$repl.symb
#df03$FRP.comb.spc
#check if value is NTC
#is.na(df03$well.conc1=="NTC")
#get the unique assays - to use for loop
unq.FRP.comb <- unique(df03$FRP.comb)
#make a table of the unique assays, and turn in to a data frame
tu_df <- as.data.frame(table(unq.FRP.comb))
#count the elements
cul <- length(unq.FRP.comb)
#make a sequence of numbers and append to the data frame
tu_df$cul <- 1:cul
#get the number of elements
seq.cul <- tu_df$cul

#make column for probe concentration
df03$prob.conc <- as.numeric(gsub("P0[.]","",df03$spc.abbr))
# paste the columns together
df03$spc.abbr.prob.conc <- paste(df03$repl.symb,"_P",df03$prob.conc,"nM", sep="")  
#head(df03)
head(df02)
df02$wllnm2 <- df02$well.type
#https://stackoverflow.com/questions/31751022/a-function-to-create-multiple-plots-by-subsets-of-data-frame
library(ggplot2)
plot01 <- ggplot(df02, aes(x = Cycles,
                           y = Fluorescence_dRn, 
                           group= well, 
                           color = wllnm2)) +
  geom_point() + 
  facet_wrap(~FRP.comb, nrow = 3) + #'facet_wrap' subsets by column value in dataframe
  geom_line() + #add lines
  ggtitle(mxpro_ampl.plot.filename)


plot01
#substitute in the the variable, escape the point with double backslash
plot.nm2 <- sub("\\.xls", "_", mxpro_ampl.plot.filename)
plot.nm3 <-paste(plot.nm2,"plots_1", sep="")
plot.nm4 <-paste(plot.nm2,"plots_2", sep="")
plot.nm3 <- paste(wdout02.2,"/",plot.nm3, sep="")
#print the plot in a pdf
pdf(c(paste(plot.nm3,".pdf",  sep = ""))
    ,width=(1*8.2677),height=(3*2.9232))
print(plot01)
dev.off()

df04 <- df02[(!df02$wllnm3=="Trivul"),]
df04 <- df04[(!df04$wllnm3=="Ichalp"),]
df04 <- df04[(!df04$wllnm3=="Hylarb"),]
df04 <- df04[(!df04$wllnm3=="NK"),]
df04 <- df04[(!df04$wllnm3=="B.bufo"),]


plot02 <- ggplot(df04, aes(x = Cycles,
                           y = Fluorescence_dRn, 
                           group= well, 
                           color = wllnm2)) +
  geom_point() + 
  facet_wrap(~FRP.comb, nrow = 3) + #'facet_wrap' subsets by column value in dataframe
  geom_line() + #add lines
  ggtitle(mxpro_ampl.plot.filename)


#plot02
plot.nm4 <- paste(wdout02.2,"/",plot.nm4, sep="")
#print the plot in a pdf
pdf(c(paste(plot.nm4,".pdf",  sep = ""))
    ,width=(1*8.2677),height=(3*2.9232))
print(plot02)
dev.off()




#exclude cross contaminated samples
df04 <- df02[(!df02$wllnm2=="Trialp_1_02_1:10"),]
df04 <- df04[(!df04$wllnm2=="Tricri_1:100"),]
df04 <- df04[(!df04$wllnm2=="Tricri_p100.13_1:10_2014jan15"),]
df04 <- df04[(!df04$wllnm2=="Tricri_1:10_2013sep13"),]
df04 <- df04[(!df04$wllnm2=="Tricri_p100.13_1:10_2014mar19"),]
df04 <- df04[(!df04$wllnm2=="Tricri_p8.8_1:10_2021feb"),]


plot03 <- ggplot(df04, aes(x = Cycles,
                           y = Fluorescence_dRn, 
                           group= well, 
                           color = wllnm2)) +
  geom_point() + 
  facet_wrap(~FRP.comb, nrow = 3) + #'facet_wrap' subsets by column value in dataframe
  geom_line() + #add lines
  ggtitle(mxpro_ampl.plot.filename)

#specify colors
plot03 <- plot03 + scale_colour_manual(values=c(rep("green",1),
                                      rep("blue",1),
                                      rep("brown",3),
                                      rep("black",1),
                                      rep("brown",3),
                                      rep("orange",2),
                                      rep("seagreen",2),
                                      rep("brown",1),
                                      rep("seagreen",4)
))

plot.nm5 <-paste(plot.nm2,"plots_3", sep="")
plot.nm5 <- paste(wdout02.2,"/",plot.nm5, sep="")
#print the plot in a pdf
pdf(c(paste(plot.nm5,".pdf",  sep = ""))
    ,width=(1*8.2677),height=(3*2.9232))
print(plot03)
dev.off()

# another website that has sigmoid plots:
#https://stackoverflow.com/questions/43728424/bacterial-growth-curve-logistic-sigmoid-with-multiple-explanatory-variables-in

# df03 %>%
#   #group_by(Culture, nutrition) %>%
#   group_by(well.type) %>%
#   #do(fit = gam(OD600 ~ s(Time), data = ., family=gaussian())) %>% # Change this to whatever model you want (e.g., non-linear regession, sigmoid)
#   do(fit = gam(Fluorescence_dRn ~ s(Cycles), data = ., family=gaussian())) %>% # Change this to whatever model you want (e.g., non-linear regession, sigmoid)
#   #do(fit = lm(OD600 ~ Time, data = .,)) %>% # Example using linear regression
#   augment(fit) %>% 
#   #ggplot(aes(x = Time, y = OD600, color = Culture)) + # No need to group by nutrition because that is broken out in the facet_wrap
#   ggplot(aes(x = Cycles, y = Fluorescence_dRn, color = well.type)) + # No need to group by nutrition because that is broken out in the facet_wrap
#   theme_bw() +  xlab("Time/hr") + ylab("OD600") +
#   #geom_point() + facet_wrap(~nutrition, scales = "free") +
#   #geom_line(aes(y = .fitted, group = Culture ))
#   geom_line(aes(y = .fitted, group = well.type))



