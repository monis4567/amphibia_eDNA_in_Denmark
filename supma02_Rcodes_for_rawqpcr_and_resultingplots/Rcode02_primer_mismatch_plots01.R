#!/usr/bin/env Rscript
# -*- coding: utf-8 -*-


########################################################################
#
# R code by Steen Wilhelm Knudsen
#
# run ROBItools on ecoPCR results
# requires the output from ecoPCR and the csv-file with a list of primers and assays
# Modified from Eric Coissac's guide to ecoPCR and OBITools
########################################################################
#First a local database must be build
#then this must tested with primers in ecoPCR
#the check with ecoPCR can be done using the bash code below
############################################################################################################
############################################################################################################
#____________________________________________________________________________#
#remove everything in the working environment, without a warning!!
rm(list=ls())


#see this
#website
#on how to only install required packages
#https://stackoverflow.com/questions/4090169/elegant-way-to-check-for-missing-packages-and-install-them
if (!require("pacman")) install.packages("pacman")
pacman::p_load(
  ROBITools, 
  ROBITaxonomy, 
  ROBIBarcodes
)

#packages must be downloaded from her:
#https://git.metabarcoding.org/obitools/ROBIBarcodes
#and then stored and installed locally
#it only worked when I downloaded tar.gz files
#and stored the tar.gz files locally
#I could not get .zip files working

# set working directory
wd00 <- "/Users/steenknudsen/Documents/Documents/MS_amphibian_eDNA_assays/MS_suppm_amphibia_eDNA/"
setwd (wd00)
getwd()
#define output directory
wd02 <- "supma02_Rcodes_for_rawqpcr_and_resultingplots"
#define input directory
wd03 <- "supma01_inp_raw_qcpr_csv/inp05_inpfiles"

if(!require(ROBITaxonomy)){
  install.packages("/Users/steenknudsen/Documents/Documents/Post doc KU/MS_Brian_2019May_discard/ROBITaxonomy-master-0906caa2cc385512606bfc524563f2e23a1f0fe3.tar.gz", repos = NULL)
  library(ROBITaxonomy)
}
# install ROBITools-master-51f152cca4416c1e8238258225fb6d11b1deee6a.tar.gz
if(!require(ROBITools)){
  install.packages("/Users/steenknudsen/Documents/Documents/Post doc KU/MS_Brian_2019May_discard/ROBITools-master-7a750efaebae7a363e6660fbeb93ac5cb17e7d4c.tar.gz", repos = NULL)
  library(ROBITools)
}  
# install ROBIBarcodes-master-768385486d5e27e222d77a7358a38fd43e2ad18d.tar.gz
##https://git.metabarcoding.org/obitools/ROBIBarcodes
if(!require(ROBIBarcodes)){
  install.packages("/Users/steenknudsen/Documents/Documents/Post doc KU/MS_Brian_2019May_discard/ROBIBarcodes-master-768385486d5e27e222d77a7358a38fd43e2ad18d.tar.gz", repos = NULL)
  library(ROBIBarcodes)
}

#https://git.metabarcoding.org/obitools/ROBIUtils.git
#https://git.metabarcoding.org/obitools/ROBIBarcodes
#https://git.metabarcoding.org/obitools/ROBITaxonomy
#https://git.metabarcoding.org/obitools/ROBITools
#First we have to download the two follong libraries
library(ROBITools)
## Warning: replacing previous import by 'igraph::parent' when loading
## 'ROBITools'
## Warning: replacing previous import by 'igraph::path' when loading
## 'ROBITools'
## ROBITools package
library(ROBITaxonomy)

## Attaching package: 'ROBITaxonomy'
##
## The following object is masked from 'package:stats':
##
## family
library(ROBIBarcodes)
#define output path
wd00_wd02 <- paste(wd00,"/",wd02,sep="")
# set working directory
setwd (wd00_wd02)
getwd()
#define output directory
wd01 <- "plotout01b_amphibia_mismatch"
#delete previous versions of the output directory
unlink(wd01, recursive=TRUE)
#create new directory
dir.create(wd01)
#define input directory
wd00_wd03 <- paste(wd00,wd03,sep="")
#define input filename
inpf01 <- "lst_assays_2020nov22.csv"
#paste path and filename together
pth00_03_inpf01 <- paste(wd00_wd03,"/",inpf01,sep="")
#define directory with input files
wd04 <- "supma01_inp_raw_qcpr_csv/inp05_inpfiles/ecopcr_results_padder_2021jan14"
wd05 <- "supma01_inp_raw_qcpr_csv"
#define full path to input files
pth00_04 <- paste(wd00,"/",wd04,sep="")
pth00_05 <- paste(wd00,"/",wd05,sep="")
#read in a table of the species-specific primer-probe assays
ass.lst <-as.data.frame(read.csv(pth00_03_inpf01,
                                 header = TRUE, sep = ",", quote = "\"",
                                 dec = ".", fill = TRUE, 
                                 comment.char = "", stringsAsFactors = FALSE))

#exclude 'Pelobates fuscus' because this entry is blank
ass.lst <- ass.lst[!ass.lst$Species=="Pelobates fuscus",]
ass.lst <- ass.lst[!ass.lst$Species=="Pelophylax esculentus",]
ass.lst <- ass.lst[!ass.lst$Species=="Pelophylax ridibundus",]
#replace "Urodela" with "Caudata"
ass.lst$order <- gsub("Urodela","Caudata",ass.lst$order)
# split text - see: https://stevencarlislewalker.wordpress.com/2013/02/13/remove-or-replace-everything-before-or-after-a-specified-character-in-r-strings/
# and concatenate text - see: https://stackoverflow.com/questions/7201341/how-can-2-strings-be-concatenated 

# to get 6 letter abbr of latin speciesnames
abbr.spcnm <-  paste(
  substr(sub('\\ .*', '', ass.lst$Species), 1, 3),
  substr(sub('.*\\ ', '', ass.lst$Species), 1, 3),
  sep=""
)
#add back as column
ass.lst$abbr.spcnm <- abbr.spcnm
#make an abbreviated species name with underscore
ass.lst$abbr.spcnmwu <- paste(substr(ass.lst$abbr.spcnm,1,3),
      "_",
      substr(ass.lst$abbr.spcnm,4,6),
      sep="")
# to get 2 letter abbr of latin speciesnames
l2.abbr.spcnm <-  paste(
  substr(sub('\\ .*', '', ass.lst$Species), 1, 1),
  substr(sub('.*\\ ', '', ass.lst$Species), 1, 1),
  sep=""
)
#add back as column
ass.lst$l2.abbr.spcnm <- l2.abbr.spcnm
#add a column to define what oligo type is listed
ass.lst$FRP_type<- gsub("*.*_([A-Za-z]+)$","\\1",ass.lst$Primer_probe_navn_DK)
# add columns with sequence for oligos
ass.lst$FRP_seq <- ass.lst$Sekvens_primer_og_probe_5___3
#add column with oligo name
ass.lst$FRP_nm <- ass.lst$primer_and_probe_name_R_and_F

#head(ass.lst,4)
#bind coluns in to a dataframe
df_ass01 <- as.data.frame(cbind(ass.lst$Species, ass.lst$order, ass.lst$family, ass.lst$Assay_ID))
#limit to unique rows
df_ass02 <- unique(df_ass01)
#make dataframe to with variables to match ecoPCR output file names
# Gm.r <- c("Gm","Actinop","Gadifor","Gadidae")
# Ma.r <- c("Ma","Actinop","Gadifor","Gadidae")
# Mm.r <- c("Mm","Actinop","Gadifor","Gadidae")
# Al.r <- c("Al","Actinop","Percifo","Anarhichadidae")
# #merge to dataframe, then to matrix, then transpose, then to dataframe
# df02 <- as.data.frame(t(data.frame(Gm.r,Ma.r,Mm.r,Al.r)))

#edit column names
colnames(df_ass02)<- c("genspc","order","family","assaynm")
df_ass02$or6l <- substr(df_ass02$order,1,6)
df_ass02$fa6l <- substr(df_ass02$family,1,6)
df_ass02$gs3l <- substr(sub('\\ .*', '', df_ass02$genspc), 1, 3)
df_ass02$genus <- sub('\\ .*', '', df_ass02$genspc)
# #get the genus for each row
# tax.genus <- sub('\\_.*', '', ass.lst$target.spec)
# #add the columns to the dataframe
# ass.lst <- cbind(ass.lst,tax.genus, abbr.spcnm,l2.abbr.spcnm)
#match back to dataframe
ass.lst$fl.ord <- df_ass02$or6l[match(ass.lst$Assay_ID,df_ass02$assaynm)]
ass.lst$fl.fam <- df_ass02$fa6l[match(ass.lst$Assay_ID,df_ass02$assaynm)]
ass.lst$fl.gsp <- df_ass02$gs3l[match(ass.lst$Assay_ID,df_ass02$assaynm)]
ass.lst$fl.gen <- df_ass02$genus[match(ass.lst$Assay_ID,df_ass02$assaynm)]
#get the unique species abbreviations
#head(ass.lst,4)
spcabbrev <- unique(ass.lst$abbr.spcnm)

#make a dataframe that only keeps full lenght latin species name and abbreviation
keeps <- c("abbr.spcnm",
           "l2.abbr.spcnm",
           
           "fl.ord",
           "fl.fam",
           "fl.gsp",
           "fl.gen",           
           "Species")
tmp1 <- ass.lst[keeps]
#get only the unique rows
lstofspecs <- unique(tmp1)
lstofspecs
unique(lstofspecs$abbr.spcnm)

#taxo = read.taxonomy('ncbi20150518')
#Du skal lægge alle de filer fra taxonomy mappen, 
#der hedder noget med ”taxo” i din working directory, 
#og så indlæse taksonomien med taxo=read.taxonomy(’taxo’).
setwd ("/Users/steenknudsen/Documents/Documents/Post doc KU/MS_Brian_2019May_discard/organels.2016_01_05")
taxo = read.taxonomy('taxo')

#change back to the working directory
#pth_outp1 <- paste(wd00,"/",wd01,sep="")
wd05 <- "supma01_inp_raw_qcpr_csv/inp05_inpfiles/ecopcr_results_padder_2021jan14"
# set working directory
pth_wd00_wd05 <- paste(wd00,"/",wd05,sep="")
setwd (pth_wd00_wd05)
getwd()

#################################################################################
# loop over each of the species matched against order level - starts here
#################################################################################
# "Bombom" "Bufbuf" "Bufcal" "Bufvir" "Hylarb" "Ranarv" "Randal" "Ranles" "Rantem"
# "Emyorb" "Ichalp" "Lisvul" "Tricri"

#  spcabb <- "Randal"
#  spcabbrev <- "Randal"
# #loop over species abbreviations
for (spcabb in spcabbrev){
  print(spcabb)
#}  
  #get the order, family and genus to match against
  #this will be the taxonomic level you will search your primers against
  spcgrp <- ass.lst$fl.ord[match(spcabb, ass.lst$abbr.spcnm)]
  #spcgrp <- ass.lst$tax.fam[match(spcabb, ass.lst$abbr.spcnm)]
  spcgrp <- ass.lst$fl.gen[match(spcabb, ass.lst$abbr.spcnm)]
  
  #match species abbreviation with primer names and sequence
  lat.species.nm <- lstofspecs$Species[match(spcabb, lstofspecs$abbr.spcnm)]
  
  #make more matches for the filename
  fl.l2.spc <- ass.lst$l2.abbr.spcnm[match(spcabb, ass.lst$abbr.spcnm)]
  #fl.class.spc <- ass.lst$fl.class[match(spcabb, ass.lst$abbr.spcnm)]
  fl.order.spc <- ass.lst$fl.ord[match(spcabb, ass.lst$abbr.spcnm)]
  fl.fam.spc <- ass.lst$fl.fam[match(spcabb, ass.lst$abbr.spcnm)]
  fl.genus.spc <- ass.lst$fl.gen[match(spcabb, ass.lst$abbr.spcnm)]
  fl.spcnmwu <- ass.lst$abbr.spcnmwu[match(spcabb, ass.lst$abbr.spcnm)]
  # head(ass.lst,4)
  # ass.lst$order
  # #assign a second name to an object
  spcnm <- lat.species.nm
  
  
  #uncomment the line below to seach against only the target species
  #spcgrp <- sub('\\_', ' ', lat.species.nm)
  #make the search ID for the teleo.taxid function below
  taxid.search.name <- paste("^",spcgrp,"$",  sep = "")
  #fish = read.ecopcr.result('output.Gadmor.03.ecopcr.txt')
  #check the working directory
  #getwd()
  #
  #list.files(wd00)
  #list.files(wd00_wd02)
  #get the name of the inputfile, based on the abbrev species name
  #input file for order
  inputfile.ecopcr.txt <- paste("slurm.outp.",fl.spcnmwu,".",fl.order.spc,".ecopcr.txt",  sep = "")
  dblvl <- fl.order.spc
  #define full path and input file to read in
  inputfile01 <- paste(wd00_wd02,"/",inputfile.ecopcr.txt,sep="")
  #read in file from path
  fish = read.ecopcr.result(inputfile01)
  #class(fish)
  #exclude all rows that might have NAs in them
  #na.omit(fish)
  
  #fish = read.ecopcr.result('output.Gadmor.03.ecopcr.txt')
  #fish = read.ecopcr.result('Teleostei.04.vert.ecopcr')
  #taxo = read.taxonomy('ncbi20150518')
  
  #use ecofind on the species grp -i.e. the taxonomic level you are matching primers against
  teleo.taxid = ecofind(taxo,taxid.search.name)
  #only retain the first number in case the taxa has multiple taxnumbers in NCBI
  #Like 'Rana' apparently has
  teleo.taxid <- as.numeric(as.character(teleo.taxid)[1])
  
  #teleo.taxid = ecofind(taxo,'^Gadus$')
  #teleo.taxid = ecofind(taxo,'^Anguilla$')
  #teleo.taxid
  
  #only include rows that has values in all columns
  fish <- fish[complete.cases(fish), ]
  # if complete.cases(fish) returns 'logical(0)'
  # then https://stackoverflow.com/questions/48626193/logical0-in-if-statement
  if(sum(complete.cases(fish)) == 0) {flag <- 'TRUE'}
  if(!sum(complete.cases(fish)) == 0) {flag <- 'FALSE'}
  # if the flag is FALSE
  if (flag ==F)
  #then print the plot
  #{print("make aplot")}
  {
  #use the subclade funcion to see if the match is within the species grp defined above
  is_a_fish=is.subcladeof(taxo,fish$taxid,teleo.taxid)
  
  #replace any NAs with FALSE
  is_a_fish[is.na(is_a_fish)] <- FALSE
  
  #see it as a table of TRUE and FALSE, whether they match the species grp or not
  table(is_a_fish)
  
  ################################################################
  # start pdf to make mismatch plot
  ################################################################
  #Paste variables together to get an output file
  outfile01<- paste("ecoprimer_mismatch_for_",spcnm,"_for_",spcgrp,
                    "_against_dblvl_",dblvl,".pdf", 
                    sep = "")
  # paste variables together to get path and output file
  outfile02 <- paste(wd00,"/",wd02,"/",wd01,"/",outfile01,sep="")  
  #start writing to the output file and the path
  pdf(outfile02,width=(1.6*8.2677),height=(1.6*2*2.9232)
  )
  #define plot area
  par(mfcol=c(1,1))
  #make a mismathc plot
  mismatchplot(fish,group = is_a_fish,
               legend=c(
                 paste('Not a ',spcgrp, sep=''),
                 #'Not a fish',
                 paste(' ',spcgrp, sep='')
                 #'Fish'
               ))
  #add an overall title for the plot
  tmp.title <- paste("ecoprimer_mismatch_for_",lat.species.nm,"_for_",spcgrp,"_against_dblvl_",dblvl,".",  sep = "")
  title(tmp.title, outer=FALSE)
  # end the pdf-file to save as 
  dev.off()
  
  ################################################################
  # end pdf to make mismatch plot
  ################################################################
  
  
  #Testing the conservation of the priming sites
  Fish.forward = ecopcr.forward.shanon(ecopcr = fish,
                                       group = is_a_fish)
  Fish.reverse = ecopcr.reverse.shanon(ecopcr = fish,
                                       group = is_a_fish)
  
  #get sequence and name for F and R primer, and place in a variable
  #for the F primer
  #subset based on variable values, subset by species name and by primer type
  row.primer <- ass.lst[ which(ass.lst$abbr.spcnm==spcabb & ass.lst$FRP_type=="F"), ]
  
  #match species abbreviation with primer names and sequence
  prim_seq_F <- row.primer$FRP_seq[match(spcabb, row.primer$abbr.spcnm)]
  prim_nm_F <- row.primer$FRP_nm[match(spcabb, row.primer$abbr.spcnm)]
  
  #for the R primer
  #subset based on variable values, subset by species name and by primer type
  row.primer <- ass.lst[ which(ass.lst$abbr.spcnm==spcabb & ass.lst$FRP_type=="R"), ]
  #match species abbreviation with primer names and sequence
  prim_seq_R <- row.primer$FRP_seq[match(spcabb, row.primer$abbr.spcnm)]
  prim_nm_R <- row.primer$FRP_nm[match(spcabb, row.primer$abbr.spcnm)]
  ################################################################
  # start pdf to make seq logo plot
  ################################################################
  outfile03 <- paste("ecoprimer_seqlogo_plot_for_",spcnm,"_for_",spcgrp,
           "_against_dblvl_",dblvl,".pdf",  sep = "")
  outfile04 <- paste(wd00,"/",wd02,"/",wd01,"/",outfile03,sep="")  
    #make a pdf for the plot
  pdf(outfile04,
      width=(1.6*8.2677),height=(1.6*2*2.9232)
  )
  #specify plot area
  op <- par(mfrow=c(2,2), # set number of panes inside the plot - i.e. c(2,2) would make four panes for plots
            oma=c(1,1,2,2), # set outer margin (the margin around the combined plot area) - higher numbers increase the number of lines
            mar=c(5,5,5,5) # set the margin around each individual plot 
  )
  
  #check if the table has any rows
  if(length(Fish.forward$'TRUE')>0){flag_FFT=T} else {flag_FFT="FL"}
  if(length(Fish.forward$'FALSE')>0){flag_FFF=T} else {flag_FFF="FL"}
  if(length(Fish.reverse$'TRUE')>0){flag_FRT=T} else {flag_FRT="FL"}
  if(length(Fish.reverse$'FALSE')>0){flag_FRF=T} else {flag_FRF="FL"}
  #Ploting the results
  if(flag_FFT==T){
    dnalogoplot(Fish.forward$'TRUE',
                primer = prim_seq_F,
                main=paste(prim_nm_F,' ', spcgrp, sep='')) } else { 
                  plot.new() }
  if(flag_FFF==T){
    dnalogoplot(Fish.forward$'FALSE',
                primer = prim_seq_F,
                main=paste(prim_nm_F,' not ',spcgrp, sep=''))} else {
                  plot.new() } 
  if(flag_FRT==T){
    dnalogoplot(Fish.reverse$'TRUE',
                primer = prim_seq_R,
                main=paste(prim_nm_R,' ',spcgrp, sep=''))} else {
                  plot.new() }
  if(flag_FRF==T){
    dnalogoplot(Fish.reverse$'FALSE',
                primer = prim_seq_R,
                main=paste(prim_nm_R,' not ',spcgrp, sep=''))} else {
                  plot.new() }
  #apply the par settings for the plot as defined above.
  par(op)
  
  #add an overall title for the plot
  tmp.title <- paste("ecoprimer_seqlogo_for_",lat.species.nm,"_for_",spcgrp,"_against_dblvl_",dblvl,".",  sep = "")
  title(tmp.title, outer=FALSE)
  
  # end the pdf-file to save as 
  dev.off()
  # end the chekc conditions on whether the complete cases is zero
  }
    ################################################################
  # end pdf to make seq logo plot
  ################################################################

}

#################################################################################
# loop over each of the species matched against order level - ends here
###################################################################################




















#################################################################################
# loop over each of the species matched against family level - starts here
#################################################################################
spcabbrev2 <- spcabbrev
#spcabbrev <- spcabbrev2
#  spcabb <- "Bombom"
#  spcabbrev <- "Bombom"
# #loop over species abbreviations
for (spcabb in spcabbrev){
  print(spcabb)
#}
  #get the order, family and genus to match against
  #this will be the taxonomic level you will search your primers against
  spcgrp <- ass.lst$family[match(spcabb, ass.lst$abbr.spcnm)]
  #spcgrp <- ass.lst$tax.fam[match(spcabb, ass.lst$abbr.spcnm)]
  spcgrp <- ass.lst$fl.gen[match(spcabb, ass.lst$abbr.spcnm)]
  
  #match species abbreviation with primer names and sequence
  lat.species.nm <- lstofspecs$Species[match(spcabb, ass.lst$abbr.spcnm)]
  
  #make more matches for the filename
  fl.l2.spc <- ass.lst$l2.abbr.spcnm[match(spcabb, ass.lst$abbr.spcnm)]
  fl.class.spc <- ass.lst$fl.class[match(spcabb, ass.lst$abbr.spcnm)]
  fl.order.spc <- ass.lst$fl.ord[match(spcabb, ass.lst$abbr.spcnm)]
  fl.fam <- ass.lst$family[match(spcabb, ass.lst$abbr.spcnm)]
  fl.fam2 <- ass.lst$fl.fam[match(spcabb, ass.lst$abbr.spcnm)]
  fl.genus.spc <- ass.lst$Species[match(spcabb, ass.lst$abbr.spcnm)]
  fl.gsp <- ass.lst$abbr.spcnmwu[match(spcabb, ass.lst$abbr.spcnm)]
  #assign a second name to an object
  spcnm <- lat.species.nm
  #uncomment the line below to seach against only the target species
  #make the search ID for the teleo.taxid function below
  taxid.search.name <- paste("^",spcgrp,"$",  sep = "")
  #get the name of the inputfile, based on the abbrev species name
  #input file for order
  #input file for class
  #input file for family
  inputfile.ecopcr.txt <- paste("slurm.outp.",
                                  fl.gsp,".",fl.fam2,
                                ".ecopcr.txt",  sep = "")
  dblvl <- fl.fam
  inputfile02 <- paste(wd00,"/",wd02,"/",inputfile.ecopcr.txt,sep="")
  #input file for genus
  fish = read.ecopcr.result(inputfile02)
  #exclude all rows that might have NAs in them
  #na.omit(fish)
  
  #fish = read.ecopcr.result('output.Gadmor.03.ecopcr.txt')
  #fish = read.ecopcr.result('Teleostei.04.vert.ecopcr')
  #taxo = read.taxonomy('ncbi20150518')
  
  #use ecofind on the species grp -i.e. the taxonomic level you are matching primers against
  teleo.taxid = ecofind(taxo,taxid.search.name)
  #only retain the first number in case the taxa has multiple taxnumbers in NCBI
  #Like 'Rana' apparently has
  teleo.taxid <- as.numeric(as.character(teleo.taxid)[1])

  #only include rows that has values in all columns
  fish <- fish[complete.cases(fish), ]
  
  # if complete.cases(fish) returns 'logical(0)'
  # then https://stackoverflow.com/questions/48626193/logical0-in-if-statement
  if(sum(complete.cases(fish)) == 0) {flag <- 'TRUE'}
  if(!sum(complete.cases(fish)) == 0) {flag <- 'FALSE'}
  # if the flag is FALSE
  if (flag ==F)
  {
  #   print("make plot")
  # }
  #use the subclade funcion to see if the match is within the species grp defined above
  is_a_fish=is.subcladeof(taxo,fish$taxid,teleo.taxid)
  
  #replace any NAs with FALSE
  is_a_fish[is.na(is_a_fish)] <- FALSE
  
  #see it as a table of TRUE and FALSE, whether they match the species grp or not
  #table(is_a_fish)
  
  ################################################################
  # start pdf to make mismatch plot
  ################################################################
  outfile05 <-  c(paste("ecoprimer_mismatch_for_",spcnm,"_for_",spcgrp,"_against_dblvl_",dblvl,".pdf",  sep = ""))
  pth_outfile05 <- paste(wd00,"/",wd01,"/",outfile05,sep="")
  pdf(pth_outfile05,
  width=(1.6*8.2677),height=(1.6*2*2.9232)
  )
  par(mfcol=c(1,1))
  mismatchplot(fish,group = is_a_fish,
               legend=c(
                 paste('Not a ',spcgrp, sep=''),
                 #'Not a fish',
                 paste(' ',spcgrp, sep='')
                 #'Fish'
               ))
  #add an overall title for the plot
  tmp.title <- paste("ecoprimer_mismatch_for_",lat.species.nm,"_for_",spcgrp,"_against_dblvl_",dblvl,".",  sep = "")
  title(tmp.title, outer=FALSE)
  # end the pdf-file to save as 
  dev.off()
  
  ################################################################
  # end pdf to make mismatch plot
  ################################################################
  
  
  #Testing the conservation of the priming sites
  Fish.forward = ecopcr.forward.shanon(ecopcr = fish,
                                       group = is_a_fish)
  Fish.reverse = ecopcr.reverse.shanon(ecopcr = fish,
                                       group = is_a_fish)
  
  #get sequence and name for F and R primer, and place in a variable
  #for the F primer
  #subset based on variable values, subset by species name and by primer type
  row.primer <- ass.lst[ which(ass.lst$abbr.spcnm==spcabb & ass.lst$FRP_type=="F"), ]
  #match species abbreviation with primer names and sequence
  prim_seq_F <- row.primer$FRP_seq[match(spcabb, row.primer$abbr.spcnm)]
  prim_nm_F <- row.primer$FRP_nm[match(spcabb, row.primer$abbr.spcnm)]
  
  #for the R primer
  #subset based on variable values, subset by species name and by primer type
  row.primer <- ass.lst[ which(ass.lst$abbr.spcnm==spcabb & ass.lst$FRP_type=="R"), ]
  #match species abbreviation with primer names and sequence
  prim_seq_R <- row.primer$FRP_seq[match(spcabb, row.primer$abbr.spcnm)]
  prim_nm_R <- row.primer$FRP_nm[match(spcabb, row.primer$abbr.spcnm)]
  ################################################################
  # start pdf to make seq logo plot
  ################################################################
  #make a pdf for the plot
  outfile06 <-c(paste("ecoprimer_seqlogo_plot_for_",spcnm,"_for_",spcgrp,"_against_dblvl_",dblvl,".pdf",  sep = ""))
  pth_outfile06 <- paste(wd00,"/",wd01,"/",outfile06,sep="")
  
  pdf(pth_outfile06,
      width=(1.6*8.2677),height=(1.6*2*2.9232)
  )
  #specify plot area
  op <- par(mfrow=c(2,2), # set number of panes inside the plot - i.e. c(2,2) would make four panes for plots
            oma=c(1,1,2,2), # set outer margin (the margin around the combined plot area) - higher numbers increase the number of lines
            mar=c(5,5,5,5) # set the margin around each individual plot 
  )
  #check if the table has any rows
  if(length(Fish.forward$'TRUE')>0){flag_FFT=T} else {flag_FFT="FL"}
  if(length(Fish.forward$'FALSE')>0){flag_FFF=T} else {flag_FFF="FL"}
  if(length(Fish.reverse$'TRUE')>0){flag_FRT=T} else {flag_FRT="FL"}
  if(length(Fish.reverse$'FALSE')>0){flag_FRF=T} else {flag_FRF="FL"}
  #Ploting the results
  if(flag_FFT==T){
    dnalogoplot(Fish.forward$'TRUE',
                primer = prim_seq_F,
                main=paste(prim_nm_F,' ', spcgrp, sep='')) } else { 
                  plot.new() }
  if(flag_FFF==T){
    dnalogoplot(Fish.forward$'FALSE',
                primer = prim_seq_F,
                main=paste(prim_nm_F,' not ',spcgrp, sep=''))} else {
                  plot.new() } 
  if(flag_FRT==T){
    dnalogoplot(Fish.reverse$'TRUE',
                primer = prim_seq_R,
                main=paste(prim_nm_R,' ',spcgrp, sep=''))} else {
                  plot.new() }
  if(flag_FRF==T){
    dnalogoplot(Fish.reverse$'FALSE',
                primer = prim_seq_R,
                main=paste(prim_nm_R,' not ',spcgrp, sep=''))} else {
                  plot.new() }
  #apply the par settings for the plot as defined above.
  par(op)
  
  #add an overall title for the plot
  tmp.title <- paste("ecoprimer_seqlogo_for_",lat.species.nm,"_for_",spcgrp,"_against_dblvl_",dblvl,".",  sep = "")
  title(tmp.title, outer=FALSE)
  
  # end the pdf-file to save as 
  dev.off()
  # if check for whether the table has complete cases
  }
  ################################################################
  # end pdf to make seq logo plot
  ################################################################
  
}

#################################################################################
# loop over each of the species matched against family level - ends here
###################################################################################















#################################################################################
# loop over each of the species matched against family level - starts here
#################################################################################

spcabbrev <- "Bombom"
spcabb <- "Bombom"
#loop over species abbreviations
for (spcabb in spcabbrev){
  print(spcabb)
  
  #get the order, family and genus to match against
  #this will be the taxonomic level you will search your primers against
  spcgrp <- ass.lst$tax.order[match(spcabb, ass.lst$abbr.spcnm)]
  #spcgrp <- ass.lst$tax.fam[match(spcabb, ass.lst$abbr.spcnm)]
  spcgrp <- ass.lst$tax.genus[match(spcabb, ass.lst$abbr.spcnm)]
  
  #match species abbreviation with primer names and sequence
  lat.species.nm <- lstofspecs$Species[match(spcabb, lstofspecs$abbr.spcnm)]
  #get the latin species name without the underscore
  spcgrp<- sub("_"," ", lat.species.nm)
  
  #make more matches for the filename
  fl.l2.spc <- ass.lst$l2.abbr.spcnm[match(spcabb, ass.lst$abbr.spcnm)]
  fl.fam6l <- ass.lst$fl.fam[match(spcabb, ass.lst$abbr.spcnm)]
  fl.order.spc <- ass.lst$fl.ord[match(spcabb, ass.lst$abbr.spcnm)]
  fl.family <- ass.lst$family[match(spcabb, ass.lst$abbr.spcnm)]
  fl.genus3l <- ass.lst$fl.gsp[match(spcabb, ass.lst$abbr.spcnm)]
  fl.genus <- ass.lst$fl.gen[match(spcabb, ass.lst$abbr.spcnm)]
  
  #assign a second name to an object
  spcnm <- lat.species.nm
  #uncomment the line below to seach against only the target species
  #spcgrp <- sub('\\_', ' ', lat.species.nm)
  #make the search ID for the teleo.taxid function below
  taxid.search.name <- paste("^",spcgrp,"$",  sep = "")
  #fish = read.ecopcr.result('output.Gadmor.03.ecopcr.txt')
  
  #get the name of the inputfile, based on the abbrev species name
  
  #input file for order
  
  inputfile.ecopcr.txt <- paste("slurm.output.",fl.l2.spc,".",fl.fam.spc,".ecopcr.txt",  sep = "")
  dblvl <- fl.fam6l
  #input file for genus
  #inputfile.ecopcr.txt <- paste("slurm.output.",fl.l2.spc,".",fl.genus.spc,".ecopcr.txt",  sep = "")
  #dblvl <- fl.genus.spc
  fish = read.ecopcr.result(inputfile.ecopcr.txt)
  #fish = read.ecopcr.result('output.Cluhar.03.ecopcr.txt')
  #fish = read.ecopcr.result('output.Angang.03.ecopcr.txt')
  
  
  #class(fish)
  #exclude all rows that might have NAs in them
  na.omit(fish)
  
  #fish = read.ecopcr.result('output.Gadmor.03.ecopcr.txt')
  #fish = read.ecopcr.result('Teleostei.04.vert.ecopcr')
  #taxo = read.taxonomy('ncbi20150518')
  
  #use ecofind on the species grp -i.e. the taxonomic level you are matching primers against
  teleo.taxid = ecofind(taxo,taxid.search.name)
  #teleo.taxid = ecofind(taxo,'^Gadus$')
  #teleo.taxid = ecofind(taxo,'^Anguilla$')
  teleo.taxid
  
  #only include rows that has values in all columns
  fish <- fish[complete.cases(fish), ]
  #use the subclade funcion to see if the match is within the species grp defined above
  is_a_fish=is.subcladeof(taxo,fish$taxid,teleo.taxid)
  
  #replace any NAs with FALSE
  is_a_fish[is.na(is_a_fish)] <- FALSE
  
  #see it as a table of TRUE and FALSE, whether they match the species grp or not
  table(is_a_fish)
  
  ################################################################
  # start pdf to make mismatch plot
  ################################################################
  pdf(c(paste("ecoprimer_mismatch_for_",spcnm,"_for_",spcgrp,"_against_dblvl_",dblvl,".pdf",  sep = ""))
      ,width=(1.6*8.2677),height=(1.6*2*2.9232)
  )
  par(mfcol=c(1,1))
  mismatchplot(fish,group = is_a_fish,
               legend=c(
                 paste('Not a ',spcgrp, sep=''),
                 #'Not a fish',
                 paste(' ',spcgrp, sep='')
                 #'Fish'
               ))
  #add an overall title for the plot
  tmp.title <- paste("ecoprimer_mismatch_for_",lat.species.nm,"_for_",spcgrp,"_against_dblvl_",dblvl,".",  sep = "")
  title(tmp.title, outer=FALSE)
  # end the pdf-file to save as 
  dev.off()
  
  ################################################################
  # end pdf to make mismatch plot
  ################################################################
  
  
  #Testing the conservation of the priming sites
  Fish.forward = ecopcr.forward.shanon(ecopcr = fish,
                                       group = is_a_fish)
  Fish.reverse = ecopcr.reverse.shanon(ecopcr = fish,
                                       group = is_a_fish)
  
  #get sequence and name for F and R primer, and place in a variable
  #for the F primer
  #subset based on variable values, subset by species name and by primer type
  row.primer <- ass.lst[ which(ass.lst$abbr.spcnm==spcabb & ass.lst$FRP_type=="F"), ]
  #match species abbreviation with primer names and sequence
  prim_seq_F <- row.primer$FRP_seq[match(spcabb, row.primer$abbr.spcnm)]
  prim_nm_F <- row.primer$FRP_nm[match(spcabb, row.primer$abbr.spcnm)]
  
  #for the R primer
  #subset based on variable values, subset by species name and by primer type
  row.primer <- ass.lst[ which(ass.lst$abbr.spcnm==spcabb & ass.lst$FRP_type=="R"), ]
  #match species abbreviation with primer names and sequence
  prim_seq_R <- row.primer$FRP_seq[match(spcabb, row.primer$abbr.spcnm)]
  prim_nm_R <- row.primer$FRP_nm[match(spcabb, row.primer$abbr.spcnm)]
  ################################################################
  # start pdf to make seq logo plot
  ################################################################
  #make a pdf for the plot
  pdf(c(paste("ecoprimer_seqlogo_plot_for_",spcnm,"_for_",spcgrp,"_against_dblvl_",dblvl,".pdf",  sep = ""))
      ,width=(1.6*8.2677),height=(1.6*2*2.9232)
  )
  #specify plot area
  op <- par(mfrow=c(2,2), # set number of panes inside the plot - i.e. c(2,2) would make four panes for plots
            oma=c(1,1,2,2), # set outer margin (the margin around the combined plot area) - higher numbers increase the number of lines
            mar=c(5,5,5,5) # set the margin around each individual plot 
  )
  #Ploting the results
  dnalogoplot(Fish.forward$'TRUE',
              primer = prim_seq_F,
              main=paste(prim_nm_F,' ', spcgrp, sep=''))
  
  dnalogoplot(Fish.forward$'FALSE',
              primer = prim_seq_F,
              main=paste(prim_nm_F,' not ',spcgrp, sep=''))
  
  dnalogoplot(Fish.reverse$'TRUE',
              primer = prim_seq_R,
              main=paste(prim_nm_R,' ',spcgrp, sep=''))
  
  dnalogoplot(Fish.reverse$'FALSE',
              primer = prim_seq_R,
              main=paste(prim_nm_R,' not ',spcgrp, sep=''))
  
  #apply the par settings for the plot as defined above.
  par(op)
  
  #add an overall title for the plot
  tmp.title <- paste("ecoprimer_seqlogo_for_",lat.species.nm,"_for_",spcgrp,"_against_dblvl_",dblvl,".",  sep = "")
  title(tmp.title, outer=FALSE)
  
  # end the pdf-file to save as 
  dev.off()
  ################################################################
  # end pdf to make seq logo plot
  ################################################################
  
}

#################################################################################
# loop over each of the species matched against family level - ends here
###################################################################################


#