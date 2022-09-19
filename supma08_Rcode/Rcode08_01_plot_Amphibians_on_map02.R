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
# The 3 data input files:
# "DL_dk_specs_to_latspecs.xls"
# "DL_harbour_and_pos_water_samples.xls"
# "outfile01_merged_csv_files_from_mxpro.csv"
#
#
# must be located in the same working directory

#____________________________________________________________________________#
# in browser connect to:

# https://webfile.ku.dk/
#
#Locate MxPro files in:

# N:\SCI-SNM-Citizen_Science\DNA&liv projektdokumenter\DNA & LIV\Data\qPCR resultater\MxPro_tekstfiler

# copy to your own computer
# use the unix code named:
# bashpart02_merge_multipl_csv_files_from_mxpro_qPCR_eDNA_padder03.sh
# on the MxPro files
#
#then you should be able to run the code here below

#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
#     bash code for assembling mxpro txt files is inserted here below 
#     this bash code cannot be run in R. It must be executed in a termnail
#     I hvae included it here, in case the code gets lost
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
#     bash code - start
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# 
# #!/bin/bash
# # -*- coding: utf-8 -*-
# 
# ##get the present directory
# WD=$(pwd)
# 
# 
# 
# # in Finder on Macintosh connect to
# # https://webfile.science.ku.dk/webdav
# #
# #Locate MxPro files in:
# #I:\SCIENCE-SNM-ZMDISK\5. FORMIDLINGSAFDELING\DNA & LIV\Data\qPCR resultater\MxPro_tekstfiler
# 
# #copy to your own computer
# 
# # and place them in INDIR1="mxpro_fra_dnaogliv_2019apr"
# 
# #then you should be able to run the code here below
# #
# 
# INDIR1="mxpro_fra_dnaogliv_2019apr"
# INDIR2="input02_padde_csv_files_to_merge"
# 
# OUTDIR1="out02a_merged_csv_files_from_mxpro"
# OUTFILE1="outfile02_merged_csv_files_from_mxpro.csv"
# 
# #remove the old versions of the in- and output directory
# rm -rf ${OUTDIR1}
# rm -rf ${INDIR2}
# #make new versions of the in- and output directory
# mkdir ${OUTDIR1}
# mkdir ${INDIR2}
# 
# #change directory to the directory w raw input files
# cd ${INDIR1}
# #copy these files to the new directory
# cp *.txt "${WD}"/"${INDIR2}"/
#   #change directory to new directory w copied input files
#   cd "${WD}"/"${INDIR2}"/
#   
#   pwd
# 
# for FILENAME in *.txt
# do
# NEWFILENAME=$(echo "${FILENAME}" | sed 's/ /_/g' | sed 's/_-_Text_Report_Data//g' | sed 's/\#/no/g')
# mv "${FILENAME}" "${NEWFILENAME}"
# done
# 
# 
# #TXT_FILEs=$(ls *.txt | sed s/.txt//g)
# for FILE in *.txt
# do
# FILENM=$(echo ${FILE} | sed s/.txt//g | \
#          sed 's/RoskildeHTX_BorupgaardGym/RoskildeHTXBorupgaardGym/g' |\
#          sed 's/GentofteHF_AkademiskStudenterkursus/GentofteHFAkademiskStudenterkursus/g' |\
#          sed 's/GladsaxeGym_SvendborgGym/GladsaxeGymSvendborgGym/g' |\
#          sed 's/FrederiksvaerkGym_BorupgaardGym/FrederiksvaerkGymBorupgaardGym/g' |\
#          sed 's/Frederiksborg_Ordrup/FrederiksborgOrdrup/g' |\
#          sed 's/Frederiksborg_SktAnnaeGym/FrederiksborgSktAnnaeGym/g' |\
#          sed 's/Frederiksvaerk_SktAnnaeGym/FrederiksvaerkSktAnnaeGym/g' |\
#          sed 's/Aurehoej_SktAnnaeGym/AurehoejSktAnnaeGym/g'| \
#          sed 's/GladsaxeGymSvendborgGym_FrederiksvaerkGym/GladsaxeGymSvendborgGymFrederiksvaerkGym/g' |\
#          sed 's/RoskildeGym_text/RoskildeGym_koersel1_text/g' |\
#          sed 's/AurehoejGym_text/AurehoejGym_koersel1_text/g' |\
#          sed 's/ErhvervsskolenNordsjaelland_text/ErhvervsskolenNordsjaelland_koersel1_text/g' |\
#          sed 's/HoejeTaastrupGym_text/HoejeTaastrupGym_koersel1_text/g' |\
#          sed 's/OerstadGym_text/OerstadGym_koersel1_text/g' |\
#          sed 's/HTXHilleroed/HTXHilleroed_koersel1/g' |\
#          sed 's/GentofteHF$/GentofteHF_koersel1/g' |\
#          sed 's/NordfynsGym_text/NordfynsGym_koersel1_text/g' |\
#          sed 's/korsel/koersel/g')
# #		sed 's/Frederiksborg_Ordrup/FrederiksborgOrdrup/g'|\
# #		sed 's/GladsaxeGym_SvendborgGym_FrederiksvaerkGym/GladsaxeGymSvendborgGymFrederiksvaerkGym/g')
# #echo ${FILENM}
# cat ${FILE} | \
# LC_ALL=C sed 's/_+K_/_PosK/g' | \
# LC_ALL=C sed 's/_-K_/_NegK/g' | \
# LC_ALL=C sed 's/_eDNA_/_eDNA/g' | \
# LC_ALL=C sed 's/_PosK_/_PosK/g' | \
# LC_ALL=C sed 's/_NegK_/_NegK/g' | \
# LC_ALL=C sed 's/e+K/e_PosK/g' | \
# LC_ALL=C sed 's/e-K/e_NegK/g' | \
# LC_ALL=C sed 's/eeDNA/e_eDNA/g' | \
# LC_ALL=C sed 's/leDNA/l_eDNA/g' | \
# LC_ALL=C sed 's/deDNA/d_eDNA/g' | \
# LC_ALL=C sed 's/keDNA/k_eDNA/g' | \
# LC_ALL=C sed 's/eDNADL/eDNA_DL/g' | \
# LC_ALL=C sed 's/+K/PosK/g' | \
# LC_ALL=C sed 's/-K/NegK/g' | \
# LC_ALL=C sed 's/negK/NegK/g' | \
# LC_ALL=C sed 's/posK/PosK/g' | \
# # see this weblink for how to ignore foreign characters:	#https://stackoverflow.com/questions/19242275/re-error-illegal-byte-sequence-on-mac-os-x/19770395#19770395
# #	LC_ALL=C sed '/multiplex/d' | \ # delete lines with multiplex occuring
# LC_ALL=C sed 's/R.*dsp.*tte/Roedspaette/g' | \
# LC_ALL=C sed 's/r.*dsp.*tte/Roedspaette/g' | \
# LC_ALL=C sed 's/Europ.*isk.*l/EuropaeiskAal/g' | \
# LC_ALL=C sed 's/KinesiskUldh.*ndskrabbe/KinesiskUldhaandskrabbe/g' | \
# LC_ALL=C sed 's/Stillehavs.*sters/Stillehavsoesters/g' | \
# LC_ALL=C sed 's/Nordamerikansk.*mudderkrabbe/NordamerikanskMudderkrabbe/g' | \
# LC_ALL=C sed 's/Nordamerikansk.*Mudderkrabbe/NordamerikanskMudderkrabbe/g' | \
# LC_ALL=C sed 's/Latterfr.*_eDN/Latterfroe_eDN/g' | \
# LC_ALL=C sed 's/Latterfr.*_Pos/Latterfroe_Pos/g' | \
# LC_ALL=C sed 's/Latterfr.*_Neg/Latterfroe_Neg/g' | \
# 
# sed 's/BudsnudetFroe/ButsnudetFroe/g' | \
# sed 's/Spidssnudetfroe/SpidssnudetFroe/g' | \
# sed 's/Solvkarusse/Soelvkarusse/g' | \
# sed 's/AmerikanskRibbegople/AmerikanskRibbegoble/g' | \
# sed 's/AtlantiskSild/Sild/g' | \
# sed 's/AlmindeligMakrel/Makrel/g' | \
# 
# #see how to remove tabs here: https://stackoverflow.com/questions/5398395/how-can-i-insert-a-tab-character-with-sed-on-os-x?noredirect=1&lq=1
# sed -E $'s/\t/;/g' | sed 's/ //g' > ${FILENM}.csv
# #	echo ${FILE}.csv
# #	cat ${FILE}.txt | grep multi 
# 
# done
# 
# #Manipulate double DL files
# for FILE in *_DL*_DL*.csv
# do
# echo $FILE
# #delete them for now - I have not yet worked out what to do with them
# rm $FILE
# done
# 
# #delete the files with odd columns -  - I have not yet worked out what to do with them
# #they contain data from MONIS3-5 species -  not relevant for Amphibians
# rm 20180412_DL2017082_GlHellerupGym* 
#   rm 20180419_DL2017068_VUCAarhus*
#   rm 20190319_DL2018170_EgedalGym*
#   rm 20190114_Standardkurve_koersel1*
#   rm 20190115_Standardkurve_koersel*
#   
#   
#   # get only the first part of the filename
#   #CSV_FILENAMES=$(ls *.csv | sed s/.csv//g)
#   
#   for FILE in *.csv
# do
# CSV_FILENAME=$(echo ${FILE} | sed s/.csv//g)
# # for how to convert line endings in DOS-file
# #see this website: https://stackoverflow.com/questions/2613800/how-to-convert-dos-windows-newline-crlf-to-unix-newline-lf-in-a-bash-script
# #echo "inputfile format is:"
# #file ${CSV_FILENAME}.csv #check the file format of the input file 
# tr -d '\015' <${CSV_FILENAME}.csv >${CSV_FILENAME}01.csv # replace DOS CRLF-end-of-lines
# #echo "outputfile format is:"
# #file ${CSV_FILENAME}01.csv #check the file format of the output file
# # use sed command on every line except the first line, but instead add ";qpcrrundate_DLsamplno_gymnasiumnm1_gymnasiumnm2" to first line
# sed '1 s,$,;qpcrrundate_DLsamplno_gymnasiumnm1_koerselno_txt,; 1! s,$,'';'${CSV_FILENAME}',' ${CSV_FILENAME}01.csv > "${CSV_FILENAME}"02.csv
# #use sed to remove spaces in values
# sed 's/ //g' "${CSV_FILENAME}"02.csv > "${CSV_FILENAME}"03.csv
# #only print the last column in the file
# #	awk -F ";" '{print $NF}' ${CSV_FILENAME}03.csv
# #replace in a specified column, see: https://stackoverflow.com/questions/42004482/shell-script-replace-a-specified-column-with-sed
# # for some reason this replaces semicolons w spaces in the other columns - I do not know why
# awk -F";" '{gsub("_",";",$NF)}1' ${CSV_FILENAME}03.csv | \
# #but with sed the spaces can be replaced back to semicolons
# sed 's/ /;/g' | \
# #and the remaining underscores can be replaced
# sed 's/_/;/g' | \
# #and the ;WellName; can be split into new column names and added semicolons
# #correct format is: Well;replno;specs;smpltp;WellType;ThresholddRn;CtdRn;qpcrrundate;DLsamplno;gymnasiumnm1;koerselno
# sed 's/;WellName;/;replno;specs;smpltp;/g' | \
# #use square brackets to allow sed to replace parentheses
# sed 's/[(]//g' | sed 's/[)]//g' | \
# #the csv-file had decimal numbers with commas instead of points, replace commas w points
# sed 's/,/./g' | \
# #use sed to replace eDNa with eDNA
# sed 's/eDNa/eDNA/g' | \
# 
# #use sed to replace double separators with single separators
# sed 's/;;/;/g' | \
# #delete line with 'multiplex'
# awk '!/multiplex/' | \
# #delete line with 'NotinUse'
# awk '!/NotinUse/' | \
# #delete line with '---;---;Unknown;0.1'
# awk '!/---;---;Unknown;0.1/' | \
# #delete line with 'Reference'
# awk '!/Reference/' > ${CSV_FILENAME}04.csv 
# done	
# 
# #check incorrect headers
# #for FILE in *04.csv
# #do
# #	echo $FILE
# #delete them for now - I have not yet worked out what to do with them
# #	head -1 $FILE
# 
# #done
# 
# 
# 
# #in a loop check if the input .csv-files have the word 'Dye' included
# CSV04_FILENAMES=$(ls *04.csv | sed s/04.csv//g)
# 
# for ENDING in ${CSV04_FILENAMES}
# do
# ## check if the input file has the word 'Dye' included
# if grep -Fq Dye ${ENDING}04.csv; then
# while IFS= read -r line
# do
# ## Assuming the fifth column always holds the 'Dye' column
# ## With cut fields 1 to 4 and from 6 an onwards are retained : see this website https://www.cyberciti.biz/faq/unix-linux-bsd-appleosx-skip-fields-command/
# cut -d ';' -f1-4,6- <<<"$line"
# ### same stuff with awk ###
# ### awk '{print substr($0, index($0,$3))}' <<< "$line" ###
# done < "${ENDING}"04.csv > ${ENDING}05.csv
# else NEWFILENAME=$(echo "${ENDING}05.csv")
# cp "${ENDING}"04.csv "${NEWFILENAME}"
# fi
# done
# 
# CSV05_FILENAMES=$(ls *05.csv | sed s/05.csv//g)
# #in a loop check if the input .csv-files have the word 'Replicate' included
# for ENDING in ${CSV05_FILENAMES}
# do
# ## check if the input file has the word 'Replicate' included
# if grep -Fq Replicate ${ENDING}05.csv; then
# while IFS= read -r line
# do
# ## Assuming the sixth column always holds the 'Replicate' column
# ## With cut fields 1 to 5 and from 7 an onwards are retained : see this website https://www.cyberciti.biz/faq/unix-linux-bsd-appleosx-skip-fields-command/
# cut -d ';' -f1-5,7- <<<"$line"
# ### same stuff with awk ###
# ### awk '{print substr($0, index($0,$3))}' <<< "$line" ###
# done < "${ENDING}"05.csv > ${ENDING}06.csv
# else NEWFILENAME=$(echo "${ENDING}06.csv")
# cp "${ENDING}"05.csv "${NEWFILENAME}"
# fi
# done
# 
# #see note about quotes around variables: https://stackoverflow.com/questions/2462385/getting-an-ambiguous-redirect-error
# # especially for writing to a file in a path that incl. spaces
# for FILE in *06.csv
# do
# #write the first line of every csv-file into a temporary file
# head -1 ${FILE} >> "${WD}"/"${OUTDIR1}"/tmp01.txt
# done
# 
# #get the unique lines from the tmp01.txt file, 
# #if all csv-files are set up in the same way, this should return only a single line
# #this line can put into the outputfile and serve as a header with column names
# cat "${WD}"/"${OUTDIR1}"/tmp01.txt | uniq > "${WD}"/"${OUTDIR1}"/"${OUTFILE1}"
# 
# #see this website on how to use sed to get all lines apart from the first line: https://unix.stackexchange.com/questions/55755/print-file-content-without-the-first-and-last-lines/55757
# for FILE in *06.csv
# do
# sed '1d' ${FILE} >> "${WD}"/"${OUTDIR1}"/"${OUTFILE1}"
# done
# 
# #head -10 "${WD}"/"${OUTDIR1}"/"${OUTFILE1}"
# #tail -10 "${WD}"/"${OUTDIR1}"/"${OUTFILE1}"
# 
# # see this website about : Echo newline in Bash prints literal \n
# # https://stackoverflow.com/questions/8467424/echo-newline-in-bash-prints-literal-n
# # -e flag did it for me, which "enables interpretation of backslash escapes"
# 
# echo -e " \n make sure there only is one unique line for headers \n"
# #see the content of the tmp01.txt file, to check all input files have the same header
# #using the uniq command in the end , will make sure it only returns the unique lines 
# cat "${WD}"/"${OUTDIR1}"/tmp01.txt | uniq
# 
# echo -e " \n make sure there only is one unique species name per species \n"
# #Print the third column
# # and sort the output, and get only uniq values
# awk -F";" '{print $3}' "${WD}"/"${OUTDIR1}"/"${OUTFILE1}" | sort | uniq
# 
# echo -e " \n make sure there only is one unique sample type name per sample type \n"
# #Print the fourth column
# # and sort the output, and get only uniq values
# awk -F";" '{print $4}' "${WD}"/"${OUTDIR1}"/"${OUTFILE1}" | sort | uniq
# 
# printf "${WD}"/"${OUTDIR1}"/"${OUTFILE1}"
# 
# #delete all the temporary files
# rm *01.csv
# rm *02.csv
# rm *03.csv
# rm *04.csv
# rm *05.csv
# rm *06.csv
# rm "${WD}"/"${OUTDIR1}"/tmp01.txt



#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
#     bash code - end
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::


#____________________________________________________________________________#
#remove everything in the working environment, without a warning!!
rm(list=ls())

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

## install the package 'marmap', which will allow you to plot bathymetric maps
# to get marmap running you need 'netcdf'
# got to a terminal, and install with this line:
#$ sudo apt install libnetcdf-dev
#install.packages("marmap")
if(!require(marmap)){
  install.packages("marmap")
  library(marmap)
}
library(marmap)

#install.packages("ncdf4")
#get the package that enables the function 'subplot'
#install.packages("TeachingDemos")
if(!require(TeachingDemos)){
  install.packages("TeachingDemos")
  library(TeachingDemos)
}
library(TeachingDemos)

#get package to make maps
#install.packages("rworldmap")
if(!require(rworldmap)){
  install.packages("rworldmap")
  library(rworldmap)
}
require (rworldmap)

#install.packages("rworldxtra")
if(!require(rworldxtra)){
  install.packages("rworldxtra")
  library(rworldxtra)
}
require(rworldxtra)

#get package to read excel files
#install.packages("readxl")
if(!require(readxl)){
  install.packages("readxl")
  library(readxl)
}
library(readxl)

#get package to do count number of observations that have the same value at earlier records:
# see this website: https://stackoverflow.com/questions/11957205/how-can-i-derive-a-variable-in-r-showing-the-number-of-observations-that-have-th
#install.packages("plyr")
if(!require(plyr)){
  install.packages("plyr")
  library(plyr)
}
library(plyr)

#get package to make maps - see this website: http://www.molecularecologist.com/2012/09/making-maps-with-r/
#install.packages("mapdata")
if(!require(mapdata)){
  install.packages("mapdata")
  library(mapdata)
}
library(mapdata)

#get package to make maps - see this website: http://www.molecularecologist.com/2012/09/making-maps-with-r/
#install.packages("maps")
if(!require(maps)){
  install.packages("maps")
  library(maps)
}
library(maps)
# #get package for shapefiles see this website: http://www.molecularecologist.com/2012/09/making-maps-with-r/
# install.packages(maptools)
# library(maptools)  #for shapefiles

# #get package for adding pies on the map
#install.packages("mapplots")
if(!require(mapplots)){
  install.packages("mapplots")
  library(mapplots)
}
library(mapplots)

library(lubridate)
library(tidyverse)
library(scales)

# set working directory
#wd00 <- "/home/hal9000/MS_amphibia_eDNA"
wd00 <- "/home/hal9000/Documents/Documents/MS_amphibian_eDNA_assays/MS_suppm_amphibia_eDNA"
rpath = "."
wd00 <- "/home/hal9000/Documents/Documents/MS_amphibian_eDNA_assays/amphibia_eDNA_in_Denmark"
#wd00 <- rpath
setwd (wd00)
getwd()
#define an output directory
wd09 <- "/supma09_plots_from_R_analysis"
#paste together path
wd00_wd09 <- paste(wd00,wd09,sep="")
#Delete any previous versions of the output directory
unlink(wd00_wd09, recursive=TRUE)
#Create a directory to put resulting output files in
dir.create(wd00_wd09)
#define an input directory
wd07 <- "/supma07_qpcr_merged_csvs"
#paste together path
wd00_wd07 <- paste(wd00,wd07,sep="")

#define an input directory
wd03 <- "/supma03_inp_files_for_R"
#paste together path
wd00_wd03 <- paste(wd00,wd03,sep="")
#paste path and file together
wd00_wd03_inpf01 <- paste(wd00_wd03,"/DL_dk_specs_to_latspecs06.csv",sep="")
#read excel with species names
dkspecs_to_latspecs <-as.data.frame(read.csv(wd00_wd03_inpf01,
                                             header = TRUE, sep = ",", quote = "\"",
                                             dec = ".", fill = TRUE, comment.char = "", stringsAsFactors = FALSE))
#names(dkspecs_to_latspecs)
#read excel with harbours and positions
#harbours <-as.data.frame(read_excel("DL_harbour_and_pos_water_samples.xls"))
#paste path and file together
wd00_wd03_inpf02 <- paste(wd00_wd03,"/DL_padde_pos_water_samples03.csv",sep="")
#
harbours <-as.data.frame(read.csv(wd00_wd03_inpf02,
                                  header = TRUE, sep = ";", quote = "\"",
                                  dec = ".", fill = TRUE, comment.char = "", stringsAsFactors = FALSE))
# or better yet -  make the harbour dataframe directly from the xls file downloaded from:
# www.dnaogliv.snm.ku.dk
# using the login and password
#
#Login:
#  name: 'Steen Knudsen',
#email: 'swknudsen@snm.ku.dk',
#password: 'swknudsen1234',


#paste path and file together for 'DNA og Liv' samples analysed
wd00_wd03_inpf03 <- paste(wd00_wd03,"/DNAogLiv_Proever_14-3-2022.xls",sep="")
#paste path and file together for table with aquatic periods for the amphibians
wd00_wd03_inpf04 <- paste(wd00_wd03,"/aquatic_periods_for_DK_amphibians_v01.xls",sep="")
# read in the excel file
ha <- as.data.frame(read_excel(wd00_wd03_inpf03))
df_aqp <- as.data.frame(read_excel(wd00_wd03_inpf04))
#change column names
colnames(ha) <- ha[1,]
hb <- (ha[-1,])
#head(hb,4)
# # rename column with area
 hb$Areal_m2 <- hb$`Areal (m^2)`
 
DL_No <- hb$PrøveID
LatGr <- floor(as.numeric(hb$Latitude))
LatMin <- floor((as.numeric(hb$Latitude)-LatGr)*60)
LatSek <- (((as.numeric(hb$Latitude)-LatGr)*60)-LatMin)*60
LatHemisph <- "N"
LonGr <- floor(as.numeric(hb$Longitude))
LonMin <- floor((as.numeric(hb$Longitude)-LonGr)*60)
LonSek <- (((as.numeric(hb$Longitude)-LonGr)*60)-LonMin)*60
LonHemisph <- "E"
dec_lat <- as.numeric(as.character(hb$Latitude))
dec_lon <- as.numeric(as.character(hb$Longitude))

DNAconcinwtsmpl_ng_uL <- as.numeric(hb$"DNA ng/µl")
Areal_m2 <- as.numeric(hb$Areal_m2)
elute01 <- sub(' µl EB','',hb$Elueringsvolumen)
elute02 <- sub(' x ','*',elute01)
elute03 <- sub(' µl H2O','',elute02)
elute04 <- sub('x','*',elute03)
elute05 <- sub(' EB buffer','',elute04)
elute_vol_uL <- as.numeric(elute05)
ddH2O_add_per_elute <- as.numeric(hb$"Aliquot volumen")
tot_vol_elute <- elute_vol_uL+ddH2O_add_per_elute
sampling_date <- hb$Indsamlingsdato
Filt.vol <- NA
lokal01 <- gsub(' ','_',hb$Lokalitet)
lokal02 <- gsub('\\(','',lokal01)
lokal03 <- gsub('\\)','',lokal02)
lokal04 <- gsub('\\.','',lokal03)
lokal05 <- gsub('\\,','',lokal04)
lokal06 <- gsub('ø','oe',lokal05)
lokal07 <- gsub('å','aa',lokal06)
lokal08 <- gsub('æ','ae',lokal07)
lokal09 <- gsub('Æ','ae',lokal08)
lokal10 <- gsub('Å','aa',lokal09)
lokal11 <- gsub('Ø','oe',lokal10)
lokal12 <- gsub('-','',lokal11)
lokal13 <- gsub('////','',lokal12)
Area_wt_coll_loc <- lokal13
#Make a dataframe from the selected vectors
hc <- t(data.frame(
  DL_No,
  LatGr,
  LatMin,
  LatSek,
  LatHemisph,
  LonGr,
  LonMin,
  LonSek,
  LonHemisph,
  dec_lat,
  dec_lon,
  DNAconcinwtsmpl_ng_uL,
  elute_vol_uL,
  ddH2O_add_per_elute,
  tot_vol_elute,
  sampling_date,
  Filt.vol,
  Area_wt_coll_loc,
  Areal_m2
))
hc <- as.data.frame(t(hc))
#head(hc,5)
#unique(hc$Area_wt_coll_loc)
#make an extra data frame for matching regions
wtsmplloc2 <- c("Aarhus_Havn_bassin3", "Gedser_Havn", "Kalvebod_brygge_3", "Mosede_Fort_Koege_Bugt", "Koege_Havn", "Helsingoer_Havn", "Koebenhavns_havn_Indiakaj", "Koebenhavn_Havn", "Aalborg_Beddingen", "Koebenhavn_Nordhavn_skudehavn", "Aarhus_Havn_oestmolen", "Frederikshavn_Havn", "Hirtshals_Havn", "wtsmplloc2", "Nyborg_Vold", "Katedralskolens_Dam", "Pumpen_Christians_oe", "Gentofte_Soe_Soe_i_Gentofte", "Hyrdehoej_skovsoe", "Himmelsoeen_Soe_i_Roskilde", "Soe_ved_Hindsgavl", "Gammel_teglgrav_v_Mariager", "Engsoe_ved_Gyldensten_Strand_Nordfyn", "Soe_naer_Vadum", "Hasle_Bakker_soe_1", "Engsoeen_Soe_i_Grindsted", "Nykoebing_Katedralskoles_soe", "Borupgaard_soe", "Rolighedsmosen_Espergaerde", "oeregaardsparken", "Soe_v_Oddenvejen_i_oeksenrade_skov", "EG_Soeen", "Teglgaardssoeen_Hilleroed", "Elmegaarden_Melby", "Groenjordssoeen", "Borupgaards_soe", "Snogesoeen_i_Frederiksvaerk", "Gentofte_soe", "Hundested", "Spejdersoeen_Tarm", "Furesoeen_Virum", "Skanderborg_Soe", "Soeen_v_Bellingestien", "Store_Fuglesoe_oesteraadal", "Lille_soe_v_Bakkehusene", "Engsoeen_Grindsted", "Soe_i_udkant_af_Hestehave_skov", "Vandhul_vTennisbaner", "Vandhul_v_Tennisbaner", "Skovsoeen", "Salamanderdammen_Egebaekvang_skov", "Lillelund_engsoe", "Gymnasiesoeen", "Soe_ved_Ring_4", "Soeen_bag_Folkeparken", "Utterslev_mose", "Soe_v_Registerstien", "Soelsted_mose", "Marksoe_v_Noerre_Vejdrup", "Stavnsholt_gadekaer", "Rema_soe", "10", "Vitsoe", "5", "16", "Sillebro_aadalen_Frederikssund", "Dam_vVester_Engvej_Vejle", "Selskov_Hilleroed", "Dam_ved_Vester_Engvej", "Ejby_Fyn", "Vordingborg", "Alsted", "Quellinghoej_4245_Stenlille", "Svendborg", "Glamsbjerg", "Suserup_Overdrev", "Damhussoeen", "Lille_Tranemose", "Birkeroed_soe", "Teglgaardssoeen", "Soe_vTornby_Raevskaer_strand")
Harbour2 <- c("Aarhus_havn", "Gedser_havn", "Koebenhavn_havn", "Koege_havn", "Koege_havn", "Helsingoer_havn", "Koebenhavn_havn", "Koebenhavn_havn", "Aalborg_havn", "Koebenhavn_havn", "Aarhus_havn", "Frederikshavn_havn", "Hirtshals_havn", "Area_wt_coll_loc", "Nyborg", "NykoebingF", "Bornholm", "Gentofte", "Roskilde", "Roskilde", "Middelfart", "Hobro", "Bogense", "Aalborg", "Aarhus", "Billund", "NykoebingF", "Ballerup", "Espergaerde", "Hellerup", "Middelfart", "Espergaerde", "Hilleroed", "Hundested", "Koebenhavn", "Ballerup", "Frederiksvaerk", "Gentofte", "Hundested", "Hvidesande", "Lyngby", "Aarhus", "Koege", "Aalborg", "Helsingoer", "Billund", "Helsingoer", "Naestved", "Naestved", "Djursland", "Helsingoer", "Herning", "Ballerup", "Ballerup", "Soeen_bag_Folkeparken", "Koebenhavn", "Ballerup", "Vadehavet", "Esbjerg", "Lyngby", "Lyngby", "Aeroe_S_for_Fyn", "Aeroe_S_for_Fyn", "Aeroe_S_for_Fyn", "Aeroe_S_for_Fyn", "Frederikssund", "Vejle", "Hilleroed", "Vejle", "Middelfart", "Vordingborg", "Ringsted", "NV_Sjaelland", "Svendborg", "Assens", "Slagelse", "Koebenhavn", "Hilleroed", "Birkeroed", "Hilleroed", "Hirtshals")
loc2.df01 <- t(data.frame(
  wtsmplloc2,
  Harbour2
))
loc2.df01 <- as.data.frame(t(loc2.df01))
#match harbours
hc$Harbour2 <- loc2.df01$Harbour2[match(hc$Area_wt_coll_loc, loc2.df01$wtsmplloc2)]
#see the unmatched locations
hc2 <- hc[ which(is.na(hc$Harbour2)), ]
hc4 <- as.data.frame(unique(hc2[,"Area_wt_coll_loc"]))
#change working directory
setwd(wd00_wd09)
#write it to a csv
write.csv(hc4, file ="DL_unmatched_harbours.csv", row.names=FALSE)
#change working directory
setwd(wd00)
#define harbours
# unmtch.harb03 <- c("Solbjerg_Stilling_Soe", "Boelle_Soe", "Pouls_Smeds_Mose", "Vejby_Overdrev_vandhul", "Krobaek_Tappernoeje", "Gentofte_Soe", "Tubaek_Praestoe", "Lille_privat_soe_oelsted", "Gymnasiesoeen_Alleroed", "Alleroed_Soe", "Hyrdehoej_Skov_soe",
#                    "Boendernes_Egehoved", "Horsekaer_Tisvilde_Hegn", "Beiths_Vaenge_Hjoerring", "Kong_oeres_Grav", "Arresoe_Kanal", "Kildevaeld_naer_Mordal_Mariager_Fjord", "Utterslev_Mose",
#                    "Farum_Overdrev_soe", "Soroe", "Skensved_aa", "Moellesoe_Gjorslev", "Lillesoe_Skanderborg", "?", "Alleroed_gymnasie_regnvandsbassin",
#                    "Alleroed_lilleroed", "aasenKoege", "Avnsoe", "Birkeroed", "Birkeroed_Soe", "Boellemosen_Skodsborg", 
#                    "Boellesoe_Saerloese_overdrev_Hvalsoe", "Borupgaard_Gymnasium_lille_soe", "Boestrup_aa", "Bringe_Mose_Flyvestation_Vaerloese",
#                    "Bruunshaab_Moelleaa", "Dam_v_Helsingoer_Elforsyning", "Davinde_soe", "Digterparken_Ballerup", "Dumpedalen_vandhul", "Dumpedalen_Birkeroed", "Dybesoe", "Egebaeksvang", "Egebaeksvang_Soe", "Ejby_Mose",
#                    "Ellesoeen", "Ellesoeen_GlKoege_Gaard", "Emdrup_Soe", "Frederiksberg_Have", "Frederiksvaerk", "Fuglesangssoe", "Furesoe", "Furesoe_Soe", "Furesoeen", "Furesoeen_Frederiksdal_Fribad", "Gentofte_Soe_ved_badebro", "Grevinge_Soe", "Grindsted_aadal", "Grindsted_Engsoe", "Grindsted_Langsoe", "Gurre_Soe_Nordsjaelland", "Hakkemosen", "Hampen_soe", "Harrestrup_aa_v_Vigerslev_Allé", "Himmelev_Baek_opdaemmet_soe_ved_RUC", "Himmelev_Grusgrav", "Holtug_Kridtbrud", "Hornbaek_soe",
#                    "Hvidehusvej_Alleroed", "Ishoej_Soepark", "Karlstrup_Kalkgrav_Solroed", "Kastrupfortet", "Kobberdammen_Hellebaek", "Koege_aa", "Koege_aas", "Kragemosen_Samsoe_nord", "Kvaerkeby_Mose_karpesoe", "Kvaerkeby_Mose_store_soe", "Lille_Fuglsoe_oesteraadal", "Lustrup_faellesjord_1", "Lustrup_faellesjord_2", "Lustrup_faellesjord_3", "Lyngby_soe", "Maglesoe", "Maaloev",
#                    "Marielundssoeen_Kolding", "Mlm_Hakkemosemosevej_og_Lervangen", "Moelholm_Soe_Norholmsvej_55_Aalborg", "Moelleaaen_ved_Frederiksdal_Friluftsbad", "Moelleaaen_v_Sorgenfri_Slotspark", "Moellesoe_v_Virket", "Odense_aa", "Odense_aa_ved_Stryget_Munke_Mose", "oestermosen_Femoe", "oestre_Anlaeg", "oetoftegaardsvej_Taastrup", "Poul_Smedes_mose_Svendborg", "Poul_Smeds_Mose", "Raadvad_Dam_Moelleaaen", "Regnvandsbassinet", "Roededam_Gribskov",
#                    "Roermose_Alleroed", "Roermosen_Karlslunde", "Sankt_Joergens_Soe", "Schweizersoeen", "Sejlsbjerg_Mose", "Sjaelsoe_ved_skovhytten", "Skanderborg_Soe_Vestermoelle", "Smoerhullet_Kulsbjerg_Stensved", "Sneglehoej_soe", "Soe_i_Faelledparken", "Soe_vGreve_Gym", "Soe_vStenhus_gym_Busstoppested", "Soeen_v_Ringstedvej", 
#                    "Soendervang_Vandhul", "Soeren_Hvidehusvej_Alleroed", "Soroe_Soe_baadbro_ved_Soero_akedemi", "Store_Gribsoe", "Store_Hoej_Soeen", "Store_Kattinge_soe_naer_fugletaarn_ved_Boserupvej", "Store_vejle_aa", "Svanemoellen_Havn", "Tingvej_Soe", "Tranemosen", "Tranemosen_Frederiksvaerk", "Troldsoe", "Uglebrovej_6_Helsinge",
#                    "Valleroed_Gadekaer", "Valleroed_gadekaer", "Vandet_Soe", "Vandhul_v_Baunebovej_1_Haarlev", "Vandhul_v_Kikhanerende", "Vandhul_aasen_Koege", "Vejle_aa", "Vestre_Kirkegaardssoe_Valby", "Vordingborg_Voldgrav", "Zahrtmannsvej_Soe_Roenne_Bornholm", "Alleroed_Soepark", "Botanisk_have_dam", "Botanisk_have_Soe", "Bregninge_vandhul", "Nyhaandsbaek_ved_Busemarke_mose_og_soe", "Boesoere_strand_feriepark", "Hammersoeen_Bornholm", "Herthadalen", "Hoejsagersred_Boesoere", "Mikkels_foraeldres_havebassin_Klintholm_Moen", "Kongshoej_Moellesoe_Kongshoej_aa", "Lovns_soe", "Poelsekedlen/Borgesoeen", "Ringsoeen", "Brassoe", "Stauvrebjerg_Soe_Moen", "Soendergaards_Alle_Soe", "Groennelyng_Soeer_i_Nordskoven", "Tystrup_soe", "oerslev_Kloster_Soe", "aaremyre", "Uglebjerg_Langoe_Fyn", "Tvaersted_Soe", "Sofieholm_soe_Brorfelde", "Vandhul_ved_Observator_Gyldenkernes_Vej_Brorfelde", "Store_Hareskov", "Vesterled_Soe", "Boelling_Soe", "Salten_Langsoe", "Kalgaard_Soe", "oernsoe", "Soroe_Soe", "Kongskilde_Moellesoe/Skaelskoer_soe", "Tystrup_Soe", "Soetorup_Soe", "Ulse_Soe", "Ejlemade_Soe", "Sjaelsoe", "Lillesoevej_1", "Rude_Soe", "Furesoe_1", "Furesoe_2", "Bagsvaerd_Soe", "Lyngby_Soe", "Lillesoevej_2", "Paddesoeen_Maaloev_Naturpark", "Botanisk_Have_Soe", "Bastrup_soe", "Soender_soe", "Degnemosen", "Langedam", "Soendersoe_Maribosoeerne", "Skallemose_Soe_Maaloev", "Haraldsted_soe", "Kongeaa_Vamdrup", "Sumpomraade_v_Barup_soe_nordfalster", "Vandhul_ved_Taagensegaard__Lolland", "Gundsoemagle_soe", "Farum_soe", "Guldbjerg_Mose", "Buresoe", "Vandhul_Spang_Vade", "Myremosen_Nivaa", "Svingelsoeen_Nakskov", "Esrum_Soe", "Vejstrup_aa_Svendborg", "Vandhul_Helsinge", "Draenaa_Helsinge", "Tryggevaelde_aa", "Sandskredssoeen_Gribskov", "Tvorup_Hul", "Brede_aa", "Vaserne_oest", "Vaserne_vest", "Vaserne_rende", "Hejrede_Soe", "Frederiksborg_Slotssoe", "Fegen_soe_Sverige", "Anholt", "Langoe_Fyn", "Moellevej_Jyderup", "Halleby_aa_udloeb_i_Tissoe", "Hejresoeen_Amager_Faelled", "Nihoeje_soe_Sydamager_naturreservat", "Hoejbjerghus_Soeen", "Paradis_Soeen", "NA", "BM", "Militaersoe_Vordingborg_Kaserne", "Nuuk_fjord", "Arresoe_Kanal_Frederiksvaerk", "Sortedam_Soe_i_Hilleroed", "Soendersoe", "Peblingesoe_Soe_i_Koebenhavn_N", "Moellesoeen", "Praestbjerg_Soe_Fuglkaer_aa", "Karlstrup_Kalkgrav_Soe_i_Karlslunde", "Tissoe_Soe", "Frederiksvaerk_kanal/Arresoe_kanal", "Soe_ved_Rosborg_Gymnasium", "Vandhul_ved_Skovsgaard", "Vandhul_bag_tennisbanerne", "Sortedams_Soe_Soe_i_Koebenhavn_oe", "Brobaek_Mose", "Vandhul_i_Hoerret_skov", "Vandhul_ved_Klintholm", "Lundby_Dam", "Brobaek_Mose_Mose_i_Gentofte", "Nykoebing_Katedralskoles_Vandhul", "Kastrup_Fortet", "Borupgaard_Gymnasium_Soe", "Kulsbjerg_oevelsesplads", "Lustrup_Faellesjord", "Gurre_Soe_Soe_i_Tikoeb", "Pistolsoeen", "Kvaerkeby_Fuglereservat", "Gaekkaer_Bakke_vandhul", "Sejlbjerg_Mose", "oestre_Anlaeg_naturareal_/_Park", "Sundby_Soe", "Toggerup_Enghave_oevre_dam", "Toggerup_Enghave_Nedre_dam", "Kokkedal_moellesoe", "Sct_Joergens_soe", "Branddam", "Holmegaards_Mose_naturareal_/_Mose", "Boellemosen_Soe_i_Naerum", "Brede_dam_Hilleroed", "Herregaardsvej_vandhul", "Skuldelev_grusgrav", "Paradissoeerne_oest", "Ulvshale", "Roneklint_Stevs", "Skovfogedmosen_Brorfelde_Observatorium", "Trekroner_Soe_Soe_i_Roskilde", "Kloevergaard_Soe", "Hulsoe_Eskildstrup", "Store_Hoej_soe", "Ellemosen_Park_i_Charlottenlund", "Tronsoe_Soe_i_Grindsted", "Registerstien_Soe", "Kvottrup_Skov", "Kvottrup_skov", "Valby_parken_soe_v_Tudsemindevej", "Valby_Parken_soe_vTudsemindevej", "Regnvandsbassin", "Lille_soe_i_Store_Hareskov", "Soe_i_Hareskoven", "Utterslev_Mose_vest", "Utterslev_mose_vest", "Arresoe_Soe_i_Frederiksvaerk", "Dam_ved_Store_Taarn_Christiansoe", "Skanderborg_Soe_Soe_i_Skanderborg", "Koege_havn", "Porskaer_ved_Gudenaaen", "aarhus_Havn_oestmolen", "Helsingoer_havn", "Beddingen_Aalborg", "Koebenhavns_Havn", "Hirsthals_Havn", "Nordhavn_skudehavn", "Aarhus_Havn_bassin_3", "AQUAFerskvands_Akvariet_Silkeborg", "Lyngby_Soe_Soe_i_Kongens_Lyngby", "Moellekaer_Skov_i_Aabenraa", "Moesgaard_Museum_Museum_i_Hoejbjerg", "Blidsoe_Soe_i_Skanderborg", "Refsvindinge_by_i_oerbaek", "Danmark", "Sjoerup_by_i_Viborg", "aarhus_aa_aabyhoej", "EGSoeen", "EGsoeen", "Skanderborg_soe", "Remasoe", "Kolding_lystbaadhavn_syd", "Kolding_lystbaadehavn_syd", "Nordhavn_Koebenhavn", "Attup_havn", "Attrup_Havn_Lystbaadehavn_i_Brovst", "Gjoel_Havn", "Noerresundby_Havn", "Lemvig_Havn", "Struer_Havn", "Svendborg_Lystbaadehavn", "Aarhus_Havn", "Svendborg_Havn", "Soe_vTornby__Raevskaer_strand", "Grenaa_Industrihavn", "Grenaa_Lystbaadehavn", "Nibe_Havn", "Skudehavnen", "Aalborg_Havn_Krydstogtkajen", "Aabenraa_Lystbaadehavn", "Aabenraa_Industrihavn", "Aabenraa_Havn", "aarhus_havn_DOKK1_Bassin_1", "aarhus_havn_DOKK1__bassin_1", "Bryggen_Koebenhavn", "Marselisborg_havn_Aarhus", "Skive_havn", "Skive_Havn", "Islands_Brygge", "Dokk_1", "Kalundborg_havn")
# unmtch.harb04 <- c("NA", "NA", "NA", "NA", "NA", "NE_Sjaelland", "NA", "NA", "NE_Sjaelland", "NE_Sjaelland", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "Koebenhavn", "NE_Sjaelland", "NA", "Koege", "NA", "Skanderborg", "NA", "NE_Sjaelland", "NE_Sjaelland", "Koege", "NA", "NE_Sjaelland", "NE_Sjaelland", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "Koebenhavn", "NA", "NA", "NA", "NA", "NA", "NA", "NE_Sjaelland", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "Koege", "Koege", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "Koebenhavn", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "Fyn", "Fyn", "NA", "NA", "Koebenhavn", "Fyn", "Fyn", "NA", "NA", "NA", "NE_Sjaelland", "NA", "Koebenhavn", "NA", "NA", "NA", "Skanderborg", "NA", "NA", "Koebenhavn", "Koege", "NA", "NA", "NA", "NE_Sjaelland", "Soroe", "NA", "NA", "NA", "Vejle", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "Koege", "Vejle", "Koebenhavn", "Vordingborg", "Bornholm", "NE_Sjaelland", "Koebenhavn", "Koebenhavn", "NA", "NA", "NA", "NA", "NA", "NA", "Moen", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "Koebenhavn", "Koebenhavn", "NA", "NA", "NA", "NA", "NA", "Greenland", "NE_Sjaelland", "Hilleroed", "NA", "Koebenhavn", "NA", "NA", "Koege", "NA", "NA", "NA", "NA", "NA", "Koebenhavn", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NE_Sjaelland", "Koebenhavn", "NA", "NA", "NA", "Hilleroed", "NA", "NE_Sjaelland", "NA", "Moen", "NA", "Holbaek", "Roskilde", "Esbjerg", "Falster", "NA", "NE_Sjaelland", "NA", "NA", "Aarhus", "Aarhus", "Koebenhavn", "Koebenhavn", "NA", "NE_Sjaelland", "NE_Sjaelland", "Koebenhavn", "Koebenhavn", "NE_Sjaelland", "Bornholm", "Skanderborg", "Koege", "Vejle", "Aarhus", "Helsingoer", "Aalborg", "Koebenhavn", "Hirtshals", "Koebenhavn", "Aarhus", "Silkeborg", "NE_Sjaelland", "Aabenraa", "Aarhus", "Skanderborg", "Fyn", "NA", "Viborg", "Aarhus", "NA", "NA", "Skanderborg", "NA", "Kolding", "Kolding", "Koebenhavn", "Nibe", "Nibe", "Aalborg", "Aalborg", "Lemvig", "Struer", "Fyn", "Aarhus", "Fyn", "NA", "Grenaa", "Grenaa", "Aalborg", "NA", "Aalborg", "Aabenraa", "Aabenraa", "Aabenraa", "Aarhus", "Aarhus", "Koebenhavn", "Aarhus", "Skive", "Skive", "NE_Sjaelland", "NA", "NW_Sjaelland")
# 
# unmtch.harb05 <- t(data.frame(
#   unmtch.harb03,
#   unmtch.harb04
# ))
# unmtch.harb05 <- as.data.frame(t(unmtch.harb05))


#see the matched locations
hc3 <- hc[ which(!is.na(hc$Harbour2)), ]
#unique(hc3[,"Area_wt_coll_loc"])
#make another dataframe to use for unmatched regions
Harbour3 <- c("Aarhus_havn", "Gedser_havn", "Koebenhavn_havn", "Koege_havn", "Helsingoer_havn", "Aalborg_havn", "Frederikshavn_havn", "Hirtshals_havn", "Nyborg", "NykoebingF", "Bornholm", "Gentofte", "Roskilde", "Middelfart", "Hobro", "Bogense", "Aalborg", "Aarhus", "Billund", "Ballerup", "Espergaerde", "Hellerup", "Hilleroed", "Hundested", "Koebenhavn", "Frederiksvaerk", "Hvidesande", "Lyngby", "Koege", "Helsingoer", "Naestved", "Djursland", "Herning", "Soeen_bag_Folkeparken", "Vadehavet", "Esbjerg", "Aeroe_S_for_Fyn", "Frederikssund", "Vejle", "Vordingborg", "Ringsted", "NV_Sjaelland", "Svendborg", "Assens", "Slagelse", "Birkeroed", "Hirtshals")
rg.wtsmplloc <- c("Oe_Jylland", "Moen_Loll_Falst", "Sjaelland", "Sjaelland", "Sjaelland", "N_Jylland", "N_Jylland", "N_Jylland", "Fyn", "Moen_Loll_Falst", "Bornholm", "Sjaelland", "Sjaelland", "Fyn", "N_Jylland", "Fyn", "N_Jylland", "Oe_Jylland", "Midt_Jylland", "Sjaelland", "Sjaelland", "Sjaelland", "Sjaelland", "Sjaelland", "Sjaelland", "Sjaelland", "V_Jylland", "Sjaelland", "Sjaelland", "Sjaelland", "Sjaelland", "Oe_Jylland", "Midt_Jylland", "Sjaelland", "V_Jylland", "V_Jylland", "Fyn", "Sjaelland", "Oe_Jylland", "Sjaelland", "Sjaelland", "Sjaelland", "Fyn", "Fyn", "Sjaelland", "Sjaelland", "N_Jylland")
#merge in to a data frame
unmtch.harb06 <- t(data.frame(
  Harbour3,
  rg.wtsmplloc
))
unmtch.harb06 <- as.data.frame(t(unmtch.harb06))
#add an empty column with just NAs to fil with evaluations
hc[,"reg01"] <- NA
#match regions back to dataframe
hc$reg01 <- unmtch.harb06$rg.wtsmplloc[match(hc$Harbour2,unmtch.harb06$Harbour3)]
#View(hc)
#change decimal degrees to numeric values
d.lon <- as.numeric(as.character(hc$dec_lon))
d.lat <- as.numeric(as.character(hc$dec_lat))
hc$dec_lon <- d.lon
hc$dec_lat <- d.lat
#replace in the empty column, the order is important, as you otherwise will end up with the last evaluations
hc$reg01[   d.lon >= 14 
            & d.lon <  16
            & d.lat >= 54.5
            & d.lat <  55.8] <- "Bornholm" #0  

hc$reg01[   d.lon >= 11 
            & d.lon <  14
            & d.lat >= 54
            & d.lat <  55] <- "Moen_Loll_Falst" #0

hc$reg01[   d.lon >= 11 
            & d.lon <  14
            & d.lat >= 55
            & d.lat <  56.4] <- "Sjaelland" #0


hc$reg01[   d.lon >= 8 
            & d.lon <  12
            & d.lat >= 56.4
            & d.lat <  58] <- "N_Jylland" #0

hc$reg01[   d.lon >= 9 
            & d.lon <  12
            & d.lat >= 55
            & d.lat <  56] <- "Oe_Jylland" #0

hc$reg01[   d.lon >= 9 
            & d.lon <  10
            & d.lat >= 55.4
            & d.lat <  56.4] <- "Midt_Jylland" #0

hc$reg01[   d.lon >= 8 
            & d.lon <  9
            & d.lat >= 54
            & d.lat <  56.6] <- "V_Jylland" #0

hc$reg01[   d.lon >= 10 
            & d.lon <  11
            & d.lat >= 54
            & d.lat <  56.4] <- "Fyn" #0

#see the unmatched locations
hc5 <- hc[ which(is.na(hc$reg01)), ]
#unique(hc5[,"Area_wt_coll_loc"])

#make an extra data frame for regions
dec_lat_region <- c(55.25778245, 54.774563, 55.320289, 55.628791, 57.597536, 56.0233946, 55.758139, 55.904997)
dec_lon_region <- c(10.05453676, 11.876954, 15.18797, 12.0516207, 9.9772, 9.946757, 8.885876, 8.536297)
rg.wtsmplloc <- c("Fyn", "Moen_Loll_Falst", "Bornholm", "Sjaelland", "N_Jylland", "Oe_Jylland", "Midt_Jylland", "V_Jylland")
reg.df01 <- t(data.frame(
  dec_lat_region,
  dec_lon_region,
  rg.wtsmplloc
))
reg.df01 <- as.data.frame(t(reg.df01))
#make a new coumn based on a previous column
hc$rg.wtsmplloc <- hc$reg01
#match lat-lon positions for larger regions back on to data frame
hc$dec_lat_region <- reg.df01$dec_lat_region[match(hc$reg01,reg.df01$rg.wtsmplloc)]
hc$dec_lon_region <- reg.df01$dec_lon_region[match(hc$reg01,reg.df01$rg.wtsmplloc)]

harbours <- hc
# harbours <-read.csv("DL_padde_pos_water_samples03.csv",
#                                   header = TRUE, sep = ";", quote = "\"",
#                                   dec = ".", fill = TRUE, comment.char = "", stringsAsFactors = FALSE)

# split text - see: https://stevencarlislewalker.wordpress.com/2013/02/13/remove-or-replace-everything-before-or-after-a-specified-character-in-r-strings/
# and concatenate text - see: https://stackoverflow.com/questions/7201341/how-can-2-strings-be-concatenated 
# to get 6 letter abbr of latin speciesnames
ls.abbr.spcnm <-  paste(
  substr(sub('\\_.*', '', dkspecs_to_latspecs$Species_Latin), 1, 3),
  substr(sub('.*\\_', '', dkspecs_to_latspecs$Species_Latin), 1, 3),
  sep="."
)
#add back on to latin name dataframe
dkspecs_to_latspecs$abbr.nm <- ls.abbr.spcnm
# set working directory
#setwd ("/Users/steenknudsen/Documents/Documents/Post doc KU/DNA_og_liv_post_doc_KU_2017_2018/out01a_merged_csv_files_from_mxpro/")
setwd (wd00_wd07)
#getwd()

#read csv with all merged mxpro results
#outfile02_merged_csv_files_from_mxpro.csv
#smpls <- read.csv("outfile01_merged_csv_files_from_mxpro.csv", header = TRUE, sep = ";", quote = "\"",
#         dec = ".", fill = TRUE, comment.char = "", stringsAsFactors = FALSE)
smpls <- read.csv("outfile07_merged_csv_files_from_mxpro.csv", header = TRUE, sep = ";", quote = "\"",
                  dec = ".", fill = TRUE, comment.char = "", stringsAsFactors = FALSE)
#https://stackoverflow.com/questions/8854046/duplicate-row-names-are-not-allowed-error
#I was missing a column header- I added A column with the header 'txt' 
#smpls <- read.table("outfile02_merged_csv_files_from_mxpro.csv", header = TRUE, sep = ";", quote = "\"",
#                  dec = ".", fill = TRUE, comment.char = "", stringsAsFactors = FALSE)
#smpls <- read.csv("outfile02_merged_csv_files_from_mxpro.csv", header = TRUE,
#                  sep = ";", row.names=NULL)
#replace blank fields with 'koerselno1'
#see how to on this website : https://stackoverflow.com/questions/21243588/replace-blank-cells-with-character
smpls$koerselno <- sub("^$", "koerselno1", smpls$koerselno)
#paste a new column based on variables separated by point
smpls$spec.repl.rund.DLno.koerselno <- paste(smpls$specs,smpls$replno,smpls$qpcrrundate,smpls$DLsamplno,smpls$koerselno,  sep=".")
# set working directory
setwd (wd00)
#getwd()
#paste together directory paths
wd00_wd09 <- paste(wd00,wd09, sep="")
# set working directory
setwd (wd00_wd09)
#getwd()
# filter for unique combination of columns from a dataframe
spl1 <- unique(smpls[,c('specs','replno','qpcrrundate','DLsamplno','koerselno','spec.repl.rund.DLno.koerselno')])
#make a dataframe with gymn names
spl1_gymnnm <- unique(smpls[,c('qpcrrundate','DLsamplno','gymnasiumnm1')])
#reorder by species, then by rundate and then by replno
#although not necessary for the subsequent matching operation, but it makes it easier to check
#that all replicates are matched up correctly
spl2 <- spl1[ order(spl1$specs, spl1$qpcrrundate, spl1$replno, spl1$koerselno), ]
#see the column names
# names(spl2)
# names(smpls)
#make subsets of the smpls dataframe based on Welltype
ed_smplsNPC <- subset(smpls, WellType == "NPC", select = c("spec.repl.rund.DLno.koerselno","CtdRn"))
ed_smplsNTC <- subset(smpls, WellType == "NTC", select = c("spec.repl.rund.DLno.koerselno","CtdRn"))
ed_smplsunk <- subset(smpls, WellType == "Unknown", select = c("spec.repl.rund.DLno.koerselno","WellType", "CtdRn"))

#Add a variable showing the number of observations that have the same value recorded earlier
# see this website: https://stackoverflow.com/questions/11957205/how-can-i-derive-a-variable-in-r-showing-the-number-of-observations-that-have-th
#add a column for counting
ed_smplsunk$count <- 1
#count the numbers as described in this question:
ed_smplsunk <- plyr::ddply(ed_smplsunk, .(spec.repl.rund.DLno.koerselno), transform, count=cumsum(count))
# paste the counted number onto the welltype
ed_smplsunk$Welltype.no <- paste(ed_smplsunk$WellType,ed_smplsunk$count, sep="")
#subset by this new pasted number, and get individual data frames per unknown replicate
#i.e. make a new data frame for each replicate number
ed_smplsunk1s <- subset(ed_smplsunk, Welltype.no == "Unknown1", select = c("spec.repl.rund.DLno.koerselno","WellType", "CtdRn","Welltype.no"))
ed_smplsunk2s <- subset(ed_smplsunk, Welltype.no == "Unknown2", select = c("spec.repl.rund.DLno.koerselno","WellType", "CtdRn","Welltype.no"))
ed_smplsunk3s <- subset(ed_smplsunk, Welltype.no == "Unknown3", select = c("spec.repl.rund.DLno.koerselno","WellType", "CtdRn","Welltype.no"))
ed_smplsunk4s <- subset(ed_smplsunk, Welltype.no == "Unknown4", select = c("spec.repl.rund.DLno.koerselno","WellType", "CtdRn","Welltype.no"))
#match the spec.repl.rund.DLno in the subsetted dataframes
spl2$NPC.CtdRn <- ed_smplsNPC$CtdRn[match(spl2$spec.repl.rund.DLno.koerselno,ed_smplsNPC$spec.repl.rund.DLno.koerselno)]
spl2$NTC.CtdRn <- ed_smplsNTC$CtdRn[match(spl2$spec.repl.rund.DLno.koerselno,ed_smplsNTC$spec.repl.rund.DLno.koerselno)]
spl2$unkn1.CtdRn <- ed_smplsunk1s$CtdRn[match(spl2$spec.repl.rund.DLno.koerselno,ed_smplsunk1s$spec.repl.rund.DLno.koerselno)]
spl2$unkn2.CtdRn <- ed_smplsunk2s$CtdRn[match(spl2$spec.repl.rund.DLno.koerselno,ed_smplsunk2s$spec.repl.rund.DLno.koerselno)]
spl2$unkn3.CtdRn <- ed_smplsunk3s$CtdRn[match(spl2$spec.repl.rund.DLno.koerselno,ed_smplsunk3s$spec.repl.rund.DLno.koerselno)]
spl2$unkn4.CtdRn <- ed_smplsunk4s$CtdRn[match(spl2$spec.repl.rund.DLno.koerselno,ed_smplsunk4s$spec.repl.rund.DLno.koerselno)]
spl2[is.na(spl2)] <- 0
#spl2[spl2$specs=="KlokkeFroe",]

#exlude the rows where "NPC.CtdRn" column has NAs
#spl3 <- spl2[complete.cases(spl2[,"NPC.CtdRn"]),]
spl3 <- spl2

write.csv(spl3, file = "spl3.csv")
spl3[is.na(spl3)] <- 0
########
#transform to vectors
spl3$NPC.CtdRn <- as.numeric(as.character(spl3$NPC.CtdRn))
spl3$NTC.CtdRn <- as.numeric(as.character(spl3$NTC.CtdRn))
spl3$unkn1.CtdRn <- as.numeric(as.character(spl3$unkn1.CtdRn))
spl3$unkn2.CtdRn <- as.numeric(as.character(spl3$unkn2.CtdRn))
spl3$unkn3.CtdRn <- as.numeric(as.character(spl3$unkn3.CtdRn))
spl3$unkn4.CtdRn <- as.numeric(as.character(spl3$unkn4.CtdRn))
spl3[is.na(spl3)] <- "NoCt"

# substitute all records of "LatterFroe" with "GroenFroe" 
# as only  "GroenFroe"  occurs in Denmark
spl3$specs <- gsub("LatterFroe" , "GroenFroe" ,spl3$specs)
#match the latin species name w the Danish common name 
spl3$latspc <- dkspecs_to_latspecs$Species_Latin[match(spl3$specs,dkspecs_to_latspecs$Species_DK)]

#match the abbreviated latin name w the Danish name
spl3$abbr.nm <- dkspecs_to_latspecs$abbr.nm[match(spl3$specs,dkspecs_to_latspecs$Species_DK)]

#match the harbour w the DL_sampl no 
spl3$rg.wtsmplloc <- harbours$rg.wtsmplloc[match(spl3$DLsamplno,harbours$DL_No)]
#names(spl3)
#match the dec_lat and dec_lon w the DL_sampl no 
spl3$dec_lat_region <- harbours$dec_lat_region[match(spl3$DLsamplno,harbours$DL_No)]
spl3$dec_lon_region <- harbours$dec_lon_region[match(spl3$DLsamplno,harbours$DL_No)]
#match the "DNAconcinwtsmpl_ng_uL","elute_vol_uL","ddH2O_add_per_elute","tot_vol_elute"
#with DL_sampl no 
spl3$DNAconcinwtsmpl_ng_uL <- harbours$DNAconcinwtsmpl_ng_uL[match(spl3$DLsamplno,harbours$DL_No)]
spl3$elute_vol_uL <- harbours$elute_vol_uL[match(spl3$DLsamplno,harbours$DL_No)]
spl3$ddH2O_add_per_elute <- harbours$ddH2O_add_per_elute[match(spl3$DLsamplno,harbours$DL_No)]
spl3$tot_vol_elute <- harbours$tot_vol_elute[match(spl3$DLsamplno,harbours$DL_No)]

spl3$dec_lat <- harbours$dec_lat[match(spl3$DLsamplno,harbours$DL_No)]
spl3$dec_lon <- harbours$dec_lon[match(spl3$DLsamplno,harbours$DL_No)]
spl3$gymnasiumnm1 <- spl1_gymnnm$gymnasiumnm1[match(spl3$DLsamplno,spl1_gymnnm$DLsamplno)]
#identify unique species names in the spl3 dataframe
latspecnm <- unique(spl3$latspc)

list_of_amphians <- c("Ichthyosaurus_alpestris",
  "Rana_temporaria",
  "Bufo_viridis",
  "Bombina_bombina",
  "Rana_lessonae",
  "Pelophylax_ridibundus",
  "Pelophylax_esculentus",
  "Lissotriton_vulgaris",
  "Pelobates_fuscus",
  "Hyla_arborea",
  "Bufo_bufo",
  "Rana_arvalis",
  "Rana_dalmatina",
  "Triturus_cristatus",
  "Bufo_calamita")

latspecnm <- list_of_amphians
#set cut-off value for qPCR reactions
ct.cutoff=42
#ct.cutoff=41
#ct.cutoff=50
#ct.cutoff=37
# remove records that have NA for longitude and for latitude
spl3 <- spl3[!is.na(spl3$dec_lat),]
spl3 <- spl3[!is.na(spl3$dec_lon),]
spl3.kl.fr <- spl3[spl3$specs=="KlokkeFroe",]

#nrow(spl3.kl.fr)

#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# Plot single capture locations - start
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
#remove NAs from vector
latspecnm <- latspecnm[!is.na(latspecnm)]
#latspecnm <- "Bufo_bufo"

#delete selected species from list that holds no data
# latspecnm2 <- latspecnm[!latspecnm %in% "Perca_fluviatilis"]
# latspecnm2 <- latspecnm2[!latspecnm2 %in% "Homarus_americanus"]
# 
# loop over all species names in the unique list of species, and make plots. 
#Notice that the curly bracket ends after the pdf file is closed
for (spec.lat in latspecnm){
  print(spec.lat)
  #}
  
  #get the Danish commom name
  sbs.dk.nm <- dkspecs_to_latspecs$Species_DK[match(spec.lat, dkspecs_to_latspecs$Species_Latin)]
  #subset based on variable values, subset by species name
  sbs.spl3 <- spl3[ which(spl3$latspc==spec.lat), ]
  #count using the plyr-package - see: https://www.miskatonic.org/2012/09/24/counting-and-aggregating-r/
  sbs.tot_smpl <- plyr::count(sbs.spl3, c("DLsamplno","dec_lon", "dec_lat"))
  #subset based on variable values - see: https://stackoverflow.com/questions/4935479/how-to-combine-multiple-conditions-to-subset-a-data-frame-using-or
  # subset by when NTC is equal to NoCt and NPC is below ct.cut.off, and or NTC is equal to zero
  sbs.spl3.ntc_npc_approv <- sbs.spl3[ which(sbs.spl3$NTC.CtdRn=='NoCt' & sbs.spl3$NPC.CtdRn<=ct.cutoff
  ), ]
  #count using the plyr-package
  sbs.approvK_smpl <- plyr::count(sbs.spl3.ntc_npc_approv, c("DLsamplno"))
  #subset based on variable values
  # subset among the NPC and NTC approved replicate sets
  #subset by when repl1 is below ct.cut.off and/or  when repl2 is below ct.cut.off
  sbs.spl3.1or2pf <- sbs.spl3.ntc_npc_approv[ which(sbs.spl3.ntc_npc_approv$unkn1.CtdRn<=ct.cutoff 
                                                    | sbs.spl3.ntc_npc_approv$unkn2.CtdRn<=ct.cutoff
                                                    & !sbs.spl3.ntc_npc_approv$unkn1.CtdRn==0
                                                    & !sbs.spl3.ntc_npc_approv$unkn2.CtdRn==0), ]
  #count using the plyr-package
  sbs.1or2pos.smpl <- plyr::count(sbs.spl3.1or2pf, c("DLsamplno"))
  # subset among the NPC and NTC approved replicate sets with either 1 or 2 positive replicates
  #subset by when both repl1 is below ct.cut.off and when repl2 is below ct.cut.off
  sbs.spl3.2pf <- sbs.spl3.1or2pf[ which(sbs.spl3.1or2pf$unkn1.CtdRn<=ct.cutoff 
                                         & sbs.spl3.1or2pf$unkn2.CtdRn<=ct.cutoff), ]
  #count using the plyr-package
  sbs.2pos.smpl <- plyr::count(sbs.spl3.2pf, c("DLsamplno"))
  #Rename the frequency column
  sbs.tot_smpl$totsmpl <- sbs.tot_smpl$freq
  # Remove the redundant variable from the data frame, put the resulting data frame back in to the original object
  drops <- c("freq")
  sbs.tot_smpl <- sbs.tot_smpl[ , !(names(sbs.tot_smpl) %in% drops)]
  #match the harbour name between the data frame w all samples and the data frame w approved controls
  sbs.tot_smpl$approvK <- sbs.approvK_smpl$freq[match(sbs.tot_smpl$DLsamplno,sbs.approvK_smpl$DLsamplno)]
  sbs.tot_smpl$repl1or2 <- sbs.1or2pos.smpl$freq[match(sbs.tot_smpl$DLsamplno,sbs.1or2pos.smpl$DLsamplno)]
  sbs.tot_smpl$repl2pos <- sbs.2pos.smpl$freq[match(sbs.tot_smpl$DLsamplno,sbs.2pos.smpl$DLsamplno)]
  sbs.tot_smpl$gymnasiumnm1 <- spl3$gymnasiumnm1[match(sbs.tot_smpl$DLsamplno,spl3$DLsamplno)]
  #Replace NA with 0
  sbs.tot_smpl[is.na(sbs.tot_smpl)] <- 0
  sbs.tot_smpl$totsmpl <- as.numeric(as.character(sbs.tot_smpl$totsmpl))
  sbs.tot_smpl$approvK <- as.numeric(as.character(sbs.tot_smpl$approvK))
  sbs.tot_smpl$repl2pos <- as.numeric(as.character(sbs.tot_smpl$repl2pos))
  sbs.tot_smpl$repl1or2 <- as.numeric(as.character(sbs.tot_smpl$repl1or2))
  sbs.tot_smpl$dec_lon <- as.numeric(as.character(sbs.tot_smpl$dec_lon))
  sbs.tot_smpl$dec_lat <- as.numeric(as.character(sbs.tot_smpl$dec_lat))
  #see this website for more about jitter on scatter plot
  #https://thomasleeper.com/Rcourse/Tutorials/jitter.html
  sbs.tot_smpl$dec_lat.j <- jitter(sbs.tot_smpl$dec_lat, 40.4)
  # replace NAs with zero
  sbs.tot_smpl$approvK[is.na(sbs.tot_smpl$approvK)] <- 0
  #add column that sums up dis-approved control replicates
  sbs.tot_smpl$nonapprovK <- sbs.tot_smpl$totsmpl-sbs.tot_smpl$approvK
  #if subtraction returns a negative, then zero
  sbs.tot_smpl$nonapprovK <- ifelse(sbs.tot_smpl$nonapprovK < 0, 0, sbs.tot_smpl$nonapprovK)
  #add column that sums up true negative replicates 
  #- i.e. the replicates with absence of eDNA in filtered water samples, 
  #when posK is pos and negK is neg
  sbs.tot_smpl$truezerodetect <- sbs.tot_smpl$approvK-sbs.tot_smpl$repl1or2
  #add column that sums up true single replicate detections from filtered water samples
  #- i.e. the replicates with only one detection of eDNA in filtered water samples,
  #when posK is pos and negK is neg
  sbs.tot_smpl$repl1pos <- as.numeric(as.character(sbs.tot_smpl$repl1or2-sbs.tot_smpl$repl2pos))
  
  if (!empty(sbs.tot_smpl)){
    #add an empty column with just NAs to fil with evaluations
    sbs.tot_smpl[,"eval01"] <- NA
    sbs.tot_smpl$eval01[   sbs.tot_smpl$truezerodetect >= 1] <- "truezerodetect" #0  
    sbs.tot_smpl$eval01[   sbs.tot_smpl$nonapprovK >= 1] <- "nonapprovK" #0  
    sbs.tot_smpl$eval01[   sbs.tot_smpl$repl1or2 >= 1] <- "repl1or2" #0  
    sbs.tot_smpl$eval01[   sbs.tot_smpl$repl2pos >= 1] <- "repl2pos" #0  
    sbs.tot_smpl[,"eval02"] <- NA
    sbs.tot_smpl$eval02[   sbs.tot_smpl$truezerodetect >= 1] <- "blue" #0  
    sbs.tot_smpl$eval02[   sbs.tot_smpl$nonapprovK >= 1] <- "red" #0  
    sbs.tot_smpl$eval02[   sbs.tot_smpl$repl1or2 >= 1] <- "green" #0  
    sbs.tot_smpl$eval02[   sbs.tot_smpl$repl2pos >= 1] <- "darkgreen" #0
    #XXXXX______begin plot w pie charts on map ________XXXX
    #______________________________________________________________________________________
    # set to save plot as pdf file with dimensions 8.26 to 2.9
    # 8.26 inches and 2.9 inhes equals 210 mm and 74.25 mm
    # and 210 mm and 74.25 mm matches 1/4 of a A4 page
    # pdf(c(paste("plot_pies_edna_gymnasieundervisning.singl_pts_",spec.lat,"_wct",ct.cutoff,".pdf",  sep = ""))
    #     ,width=(1.6*8.2677),height=(1.6*2.9232*2))
    # 
    png(c(paste("plot_pies_edna_gymnasieundervisning.singl_pts_",spec.lat,"_wct",ct.cutoff,".png",
                sep = "")))
        #,width=(1.6*8.2677),height=(1.6*2.9232*2))
    
    #factors to multiply radius on each pie
    fct1 <- 1.000 
    fct2 <- 0.08
    #plot map #http://www.milanor.net/blog/maps-in-r-plotting-data-points-on-a-map/
    library(rworldmap)
    newmap <- getMap(resolution = "high")
    plot(newmap, xlim = c(8, 16), ylim = c(54, 58), 
    #      # use 'asp' to change the aspect ratio: https://statisticsglobe.com/asp-r-plot
         asp=1.6)
    #plot land on map
    maps::map('worldHires', add=TRUE, fill=TRUE, 
        xlim = c(8, 16), ylim = c(54, 58), 
        #col="#11263D",
        col="grey",
        bg=transp_col,
        las=1)
    #add points to map, color by variable
    points(sbs.tot_smpl$dec_lon, sbs.tot_smpl$dec_lat.j, pch=21, bg = c(alpha(c(sbs.tot_smpl$eval02),0.6)), cex = 1.8)
    #add text labels to points  
    text(sbs.tot_smpl$dec_lon, 
         sbs.tot_smpl$dec_lat.j, 
         #labels=c(paste(sbs.tot_smpl$gymnasiumnm1,", n=",sbs.tot_smpl$totsmpl,  sep = "")) #use paste and \n to get text-label on a new line, and use sep="", to get no spaces
         labels=c(paste("n=",sbs.tot_smpl$totsmpl,  sep = "")) #use paste and \n to get text-label on a new line, and use sep="", to get no spaces
         , cex= 1.0, pos=4) #Pos-Values of 1, 2, 3 and 4, respectively indicate positions below, to the left of, above and to the right of the specified (x,y) coordinates.
    
    title(main = paste("samplesets (2 unkn and 1NTC and 1NPC) per single location for \n",spec.lat," (",sbs.dk.nm,") with Ct<",ct.cutoff, sep = "")
          , cex=0.8)
    
    # add legend
    legend("topright", "(x,y)", 
           bg="white",
           c("nonapprovK", "truezerodetect", "repl1pos", "repl2pos"),
           ncol=1,
           pch = c(21, 21, 21, 21), pt.bg=c(alpha(c("red","blue", "green", "darkgreen"), 0.6)), 
           pt.lwd=c(1.2, 1.2, 1.2, 1.2),      
           cex=1.0,
           inset = 0.05)
    #XXXXX______ end plot w pie charts on map ________XXXX
    
    # end the pdf-file to save as
    # end the png-file to save as
    dev.off()
    # end if not empty
  }
  #below is the end of the loop initiated above
}

#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# Plot single capture locations - end
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
spl3.Ha <- spl3[grepl("Hyla",spl3$latspc),]
#nrow(spl3.Ha)
#count using the plyr-package - see: https://www.miskatonic.org/2012/09/24/counting-and-aggregating-r/
tot_smpl <- plyr::count(spl3, c("DLsamplno","dec_lon", "dec_lat","abbr.nm", "specs","latspc" ))#,
                          # "NPC.CtdRn", "NTC.CtdRn", "unkn1.CtdRn",
                          # "unkn2.CtdRn", "unkn3.CtdRn", "unkn4.CtdRn"))

tot_smpl.Ha <- tot_smpl[grepl("Hyla",tot_smpl$latspc),]
#nrow(tot_smpl.Ha)
sum(tot_smpl.Ha$freq)
#subset based on variable values - see: https://stackoverflow.com/questions/4935479/how-to-combine-multiple-conditions-to-subset-a-data-frame-using-or
# subset by when NTC is equal to NoCt and NPC is below ct.cut.off, and or NTC is equal to zero
spl3.ntc_npc_approv <- spl3[ which(spl3$NTC.CtdRn=='NoCt' & 
                        spl3$NPC.CtdRn<=ct.cutoff), ]
#count using the plyr-package
approvK_smpl <- plyr::count(spl3.ntc_npc_approv, c("DLsamplno","abbr.nm"))
#subset based on variable values
# subset among the NPC and NTC approved replicate sets
#subset by when repl1 is below ct.cut.off and/or  when repl2 is below ct.cut.off
spl3.1or2pf <- spl3.ntc_npc_approv[ which(spl3.ntc_npc_approv$unkn1.CtdRn<=ct.cutoff 
                                          | spl3.ntc_npc_approv$unkn2.CtdRn<=ct.cutoff
                                          & !spl3.ntc_npc_approv$unkn1.CtdRn==0
                                          & !spl3.ntc_npc_approv$unkn2.CtdRn==0), ]
#count using the plyr-package
r1orr2pos.smpl <- plyr::count(spl3.1or2pf, c("DLsamplno", "abbr.nm"))
# subset among the NPC and NTC approved replicate sets with either 1 or 2 positive replicates
#subset by when both repl1 is below ct.cut.off and when repl2 is below ct.cut.off
spl3.2pf <- spl3.1or2pf[ which(spl3.1or2pf$unkn1.CtdRn<=ct.cutoff 
                               & spl3.1or2pf$unkn2.CtdRn<=ct.cutoff), ]
#count using the plyr-package
r2pos.smpl <- plyr::count(spl3.2pf, c("DLsamplno", "abbr.nm"))

#Rename the frequency column
tot_smpl$totsmpl <- tot_smpl$freq
# Remove the redundant variable from the data frame, 
#put the resulting data frame back in to the original object
drops <- c("freq")
tot_smpl <- tot_smpl[ , !(names(tot_smpl) %in% drops)]
#paste together DL_smpl_name and abbr.nm
tot_smpl$DLsamplno.abbrnm <- paste(tot_smpl$DLsamplno,tot_smpl$abbr.nm,sep=".")
approvK_smpl$DLsamplno.abbrnm <- paste(approvK_smpl$DLsamplno,approvK_smpl$abbr.nm,sep=".")
r1orr2pos.smpl$DLsamplno.abbrnm <- paste(r1orr2pos.smpl$DLsamplno,r1orr2pos.smpl$abbr.nm,sep=".")
r2pos.smpl$DLsamplno.abbrnm <- paste(r2pos.smpl$DLsamplno,r2pos.smpl$abbr.nm,sep=".")
spl3$DLsamplno.abbrnm <- paste(spl3$DLsamplno,spl3$abbr.nm,sep=".")
#match the DL_smpl_name and abbr.nm between the data frame 
#w all samples and the data frame w approved controls
tot_smpl$approvK <- approvK_smpl$freq[match(tot_smpl$DLsamplno.abbrnm,approvK_smpl$DLsamplno.abbrnm)]
tot_smpl$repl1or2 <- r1orr2pos.smpl$freq[match(tot_smpl$DLsamplno.abbrnm,r1orr2pos.smpl$DLsamplno.abbrnm)]
tot_smpl$repl2pos <- r2pos.smpl$freq[match(tot_smpl$DLsamplno.abbrnm,r2pos.smpl$DLsamplno.abbrnm)]
tot_smpl$gymnasiumnm1 <- spl3$gymnasiumnm1[match(tot_smpl$DLsamplno.abbrnm,spl3$DLsamplno.abbrnm)]
#Replace NA with 0
tot_smpl[is.na(tot_smpl)] <- 0

tot_smpl$totsmpl <- as.numeric(as.character(tot_smpl$totsmpl))
tot_smpl$approvK <- as.numeric(as.character(tot_smpl$approvK))
tot_smpl$repl2pos <- as.numeric(as.character(tot_smpl$repl2pos))
tot_smpl$repl1or2 <- as.numeric(as.character(tot_smpl$repl1or2))

tot_smpl$dec_lon <- as.numeric(as.character(tot_smpl$dec_lon))
tot_smpl$dec_lat <- as.numeric(as.character(tot_smpl$dec_lat))

#see this website for more about jitter on scatter plot
#https://thomasleeper.com/Rcourse/Tutorials/jitter.html
tot_smpl$dec_lat.j <- jitter(tot_smpl$dec_lat, 40.4)

#add column that sums up dis-approved control replicates
tot_smpl$nonapprovK <- tot_smpl$totsmpl-tot_smpl$approvK
#if subtraction returns a negative, then zero
tot_smpl$nonapprovK <- ifelse(tot_smpl$nonapprovK < 0, 0, tot_smpl$nonapprovK)

#add column that sums up true negative replicates 
#- i.e. the replicates with absence of eDNA in filtered water samples, 
#when posK is pos and negK is neg
tot_smpl$truezerodetect <- tot_smpl$approvK-tot_smpl$repl1or2

#add column that sums up true single replicate detections from filtered water samples
#- i.e. the replicates with only one detection of eDNA in filtered water samples,
#when posK is pos and negK is neg
tot_smpl$repl1pos <- as.numeric(as.character(tot_smpl$repl1or2-tot_smpl$repl2pos))

#add an empty column with just NAs to fil with evaluations
tot_smpl[,"eval01"] <- NA
tot_smpl$eval01[   tot_smpl$truezerodetect >= 1] <- "truezerodetect" #0  
tot_smpl$eval01[   tot_smpl$nonapprovK >= 1] <- "nonapprovK" #0  
tot_smpl$eval01[   tot_smpl$repl1or2 >= 1] <- "repl1or2" #0  
tot_smpl$eval01[   tot_smpl$repl2pos >= 1] <- "repl2pos" #0  
tot_smpl$eval01[   tot_smpl$nonapprovK >= 1] <- "nonapprovK" #0  
tot_smpl[,"eval02"] <- NA
tot_smpl$eval02[   tot_smpl$truezerodetect >= 1] <- "blue" #0  
tot_smpl$eval02[   tot_smpl$nonapprovK >= 1] <- "red" #0  
tot_smpl$eval02[   tot_smpl$repl1or2 >= 1] <- "green" #0  
tot_smpl$eval02[   tot_smpl$repl2pos >= 1] <- "darkgreen" #0
tot_smpl$eval02[   tot_smpl$nonapprovK >= 1] <- "red" #0  
#subset data frame to match only approved K
tot_smpl02_df <- tot_smpl
abrNm <- unique(tot_smpl02_df$abbr.nm)
abrNm <- abrNm[order(abrNm)]
#subset to only include amphibian species
amph_smpl02_df <- subset(tot_smpl02_df, 
                         abbr.nm=="Bom.bom" |
                           abbr.nm=="Buf.buf" |
                           abbr.nm=="Buf.cal" |
                           abbr.nm=="Buf.vir" |
                           abbr.nm=="Hyl.arb" |
                           abbr.nm=="Ich.alp" |
                           abbr.nm=="Lis.vul" |
                           abbr.nm=="Pel.esc" |
                           abbr.nm=="Pel.fus" |
                           abbr.nm=="Pel.rid" |
                           abbr.nm=="Ran.arv" |
                           abbr.nm=="Ran.dal" |
                           abbr.nm=="Ran.les" |
                           abbr.nm=="Ran.tem" |
                           abbr.nm=="Tri.cri")


amph_smpl02_df.Ha <- amph_smpl02_df[grepl("Hyla",amph_smpl02_df$latspc),]
# nrow(amph_smpl02_df.Ha)
# head(amph_smpl02_df.Ha,12)
# sum(amph_smpl02_df.Ha$totsmpl)
#length(unique(amph_smpl02_df$DLsamplno))
#unique(smpls$specs)
#unique(spl3$specs)
spl3$abbr.nm <- dkspecs_to_latspecs$abbr.nm[match(spl3$specs,dkspecs_to_latspecs$Species_DK)]

# unique(tot_smpl$abbr.nm)
# unique(amph_smpl02_df$abbr.nm)
#length(unique(amph_smpl02_df$DLsamplno.abbrnm))
#head(amph_smpl02_df,4)
#nrow(amph_smpl02_df)
amph_smpl03_df <- amph_smpl02_df
#subset the data frame based on two criteria 
# and negate the criteria to exclude the
# detection of 'Bufo calamita' in sample DL2018009
# as this detection could not be reproduced in a second setup
# with 8 replicates of the "DL2018009" and 4 replicates of the standard 
# dilution series, as attempted in qPCR0903 and qPCR0904 
amph_smpl03_df <-  amph_smpl03_df[!(amph_smpl03_df$DLsamplno=="DL2018009" & amph_smpl03_df$latspc=="Bufo_calamita"),]

amph_smpl03_df <-  amph_smpl03_df[!(amph_smpl03_df$DLsamplno=="DL2018009" & amph_smpl03_df$latspc=="Bufo_calamita"),]
amph_smpl03_df <-  amph_smpl03_df[!(amph_smpl03_df$DLsamplno=="DL2019065" & amph_smpl03_df$latspc=="Bufo_calamita"),]
amph_smpl03_df <-  amph_smpl03_df[!(amph_smpl03_df$DLsamplno=="DL2019005" & amph_smpl03_df$latspc=="Pelobates_fuscus"),]
amph_smpl03_df <-  amph_smpl03_df[!(amph_smpl03_df$DLsamplno=="DL2019017" & amph_smpl03_df$latspc=="Rana_dalmatina"),]
amph_smpl03_df <-  amph_smpl03_df[!(amph_smpl03_df$DLsamplno=="DL2019050" & amph_smpl03_df$latspc=="Rana_dalmatina"),]

amph_smpl03_df.Ha <-  amph_smpl03_df[grepl("Hyla",amph_smpl03_df$latspc),]
# nrow(amph_smpl03_df.Ha)
# head(amph_smpl03_df.Ha,12)
# sum(amph_smpl03_df.Ha$totsmpl)
#amph_smpl02_df %>% dplyr::group_by(eval01)
library(dplyr)
# substitute the  "Pel.esc" name with 
amph_smpl03_df$abbr.nm <- gsub("Pel.esc","Pel.sp",amph_smpl03_df$abbr.nm)
amph_smpl03_df$abbr.nm <- gsub("Ran.les","Pel.sp",amph_smpl03_df$abbr.nm)

#use dplyr to group by name, and count per evaluation
tibl_as02 <- amph_smpl03_df %>% dplyr::group_by(abbr.nm) %>% dplyr::count(eval01)
tibl_as02.Ha <- tibl_as02[grepl("Hyl",tibl_as02$abbr.nm),]

#sum(tibl_as02.Ha$n)
spl3
#make the tibble a data frame
df_as03 <- as.data.frame(tibl_as02)
# rearrange from long to wide
df_as04 <- reshape(df_as03, direction = "wide",
                   idvar = "abbr.nm",
                   timevar = "eval01")
#replace NAs with zero
df_as04[is.na(df_as04)] <- 0
#df_as04$abbr.nm
df_as05 <- df_as04 %>% dplyr::mutate_if(is.character,as.numeric)
#add back species abbreaviation
df_as05$abbr.nm <- df_as04$abbr.nm
#replace abbreviated species name with full latin species names
df_as05$abbr.nm <- dkspecs_to_latspecs$Species_Latin[match(df_as05$abbr.nm,dkspecs_to_latspecs$abbr.nm)]
#sum two columns with positive detections
df_as05$nrepl.pos <- rowSums(df_as05[,4:5])

#remove the columns no longer needed
df_as05[ , c('n.repl1or2', 'n.repl2pos')] <- list(NULL)
#df_as05
#sum up for each column
clsu <- colSums(df_as05[,2:4])
# bind this as a row below
df_as05 <- rbind(df_as05,c("Total count",clsu))
df_as05 <- df_as05 %>% dplyr::mutate_if(is.character,as.numeric)
#add back species abbreaviation
df_as05$abbr.nm <- c(df_as04$abbr.nm,"Total count")
#replace abbreviated species name with full latin species names
df_as05$abbr.nm <- dkspecs_to_latspecs$Species_Latin[match(df_as05$abbr.nm,dkspecs_to_latspecs$abbr.nm)]

#sum up across all numeric columns and add this as a new column
# that has the total conut
df_as05$totalcnt<- rowSums(df_as05[,-1])

#calculate percentages
df_as05$n.nonapprovK.p <- paste0(round(df_as05$n.nonapprovK/df_as05$totalcnt*100,0),"%")
df_as05$n.truezerodetect.p <- paste0(round(df_as05$n.truezerodetect/df_as05$totalcnt*100,0),"%")
df_as05$nrepl.pos.p <- paste0(round(df_as05$nrepl.pos/df_as05$totalcnt*100,0),"%")
#reorder columns by index numbering
df_as05 <- df_as05[,c(1,2,6,3,7,4,8,5)]
#df_as05%>%dplyr::group_by(abbr.nm)%>%dplyr::mutate(Percentage=paste0(round(n.nonapprovK/sum(totalcnt)*100,2),"%"))
# finde number of rows
nrd5 <- nrow(df_as05)
# copy the data frame
df_as06 <- df_as05
#change column names
colnames(df_as05) <- c("Species",
                       "sets that are failed tests, Non-approved analyses",
                       "sets that are failed tests, percentage",
                       "Approved analyses sets, no eDNA detected",
                       "Approved analyses sets, no eDNA detected, percentage",
                       "Approved analyses sets, eDNA detected",
                       "Approved analyses sets, eDNA detected, percentage",
                       "Total number of attemped sets")

# amph_smpl02_df %>% dplyr::group_by(abbr.nm) %>% 
#   dplyr::count(approvK)
#getwd()
#write out the table
write.csv(df_as05,file="Table02_out09_lst_spc_detect_v01.csv")
#View(df_as05)
# Make a diagram from the proportions of failed and succesful 
# define the columns to keep
ckeep<- c("abbr.nm","n.nonapprovK","n.truezerodetect","nrepl.pos")
df_as06 <- df_as06[ckeep]
#_______________________________________________________________________________

#_______________________________________________________________________________
df_as06$abbr.nm2 <- NULL
df_as06$totcnt <- NULL
#load the tidyr package
library(tidyr)
# use gather in tidyr package to reshape from wide to long
df_as07 <- tidyr::gather(df_as06, key = "testres", value = "countresl",2:4)
# change the NAs to total category
df_as07$abbr.nm[is.na(df_as07$abbr.nm)] <- "Total"
# exclude total count
df_as07 <- df_as07[!df_as07$abbr.nm=="Total",]
#replace categories
df_as07$testres <- gsub("n.nonapprovK","failed tests",df_as07$testres)
df_as07$testres <- gsub("n.truezerodetect","no eDNA detected",df_as07$testres)
df_as07$testres <- gsub("nrepl.pos","eDNA detected",df_as07$testres)
# replace in names
df_as07$abbr.nm <- gsub("_"," ",df_as07$abbr.nm)
l_abbr.nm <- unique(df_as07$abbr.nm)
df_as07$abbr.nm <- factor(df_as07$abbr.nm, levels=c(l_abbr.nm))

# use dplyr to get the percentage
tibl_as07 <- df_as07 %>%
  dplyr::count(countresl,abbr.nm,testres) %>%       
  dplyr::group_by(abbr.nm) %>%
  dplyr::mutate(pct= prop.table(countresl) * 100)


df_as06$totcnt <- rowSums(df_as06[,-1])
tibl_as07$abbr.nm2 <- gsub(" ","_",tibl_as07$abbr.nm)
tibl_as07$abbr.nm2 <- as.character(tibl_as07$abbr.nm2)
tibl_as07$totcnt <- df_as06$totcnt[match(tibl_as07$abbr.nm2,df_as06$abbr.nm)]
#View(tibl_as07)
#load the ggplot2 package
library(ggplot2)

tibl_as07$abbr.nm2 <- tibl_as07$abbr.nm
#unique(tibl_as07$abbr.nm2)
# make a plot
plt06 <- ggplot(tibl_as07, aes(fill=testres, y=countresl, x=abbr.nm2)) + 
  geom_bar(position='stack', stat='identity', color="black")
# change  the fill colour  of the bars
#plt06 <- plt06 + scale_fill_manual(values=c("gray", "black", "white"))
#plt06 <- plt06 + scale_fill_manual(values=c("gray83", "gray48", "white"))
plt06 <- plt06 + scale_fill_manual(values=c("springgreen3","yellow",  "white"))
#plt06 <- plt06 + theme(axis.text.x = element_text(angle = 90, hjust = 1, face = "italic"))
plt06 <- plt06 + theme(axis.text.y = element_text(angle = 0, hjust = 1, face = "italic", size=12))
plt06 <- plt06 + theme(axis.text.x = element_text(angle = 0, size=14))
# reverse the order of categories on the discrete scale
# https://stackoverflow.com/questions/28391850/reverse-order-of-discrete-y-axis-in-ggplot2
# reverse the categories
plt06 <- plt06 + scale_x_discrete(limits=rev)
#change axis labels
plt06 <- plt06 + #xlab("species") +
  xlab("") +
  ylab("number of test sets")
# add labels on bars
plt06 <- plt06 +  geom_col(position = position_stack(), color = "black") +
  geom_text(aes(label =
                  #paste0(signif(pct, digits = 2),"%")), size=6, color="black",
                  paste0(round(pct, digits = 0),"%")), size=6, color="black",
            position = position_stack(vjust = .5))

plt06 <- plt06 + geom_text(data=tibl_as07, aes(x = abbr.nm2, y = -3.95, 
                                               label = paste0("n=",totcnt)), size=4,vjust=0, angle = 0)
plt06 <- plt06 + coord_flip()
#getting separate legends
plt06 <- plt06 + labs(fill='test sets with')
# see the plot
plt06
bSaveFigures <- T
figname02A <- paste0("Fig02_v03_barchart_failed_tests.png")
if(bSaveFigures==T){
  ggsave(plt06,file=figname02A,
         width=2*210,height=0.5*297,
         units="mm",dpi=300)
}
#order the species names the other way around
df_as08 <- df_as07[order(df_as07$abbr.nm, decreasing = F),]

# substitute the "Pelophylax ridibundus" name
df_as08$abbr.nm2 <- df_as08$abbr.nm
df_as08$abbr.nm2 <- gsub("Pelophylax ridibundus","Pelophylax kl esculentus",df_as08$abbr.nm2)
df_as08$abbr.nm2 <- gsub("Pelophylax kl esculentus","Pelophylax sp",df_as08$abbr.nm2)
df_as08$abbr.nm2 <- gsub("Pelophylax esculentus","Pelophylax sp",df_as08$abbr.nm2)
df_as08$abbr.nm2 <- gsub("Rana lessonae","Pelophylax sp",df_as08$abbr.nm2)

#unique(df_as08$abbr.nm2)
#https://stackoverflow.com/questions/14933242/how-to-label-percentage-values-inside-stacked-bar-plot-using-r-base
library(ggplot2)
plt07 <- ggplot(df_as08, aes(x=abbr.nm2, y=countresl)) +
  geom_point(aes(shape= testres, 
                 fill=testres),size=3.0) + 
  # reverse the order of categories on the discrete scale
  # https://stackoverflow.com/questions/28391850/reverse-order-of-discrete-y-axis-in-ggplot2
  scale_x_discrete(limits=rev) +
  # tranpose the diagram
  coord_flip() +
  
  labs(x="",y="number of test sets\n") #+
#ylim(0,100) +
#geom_hline(yintercept=50, linetype=2)
#getting separate legends
plt07 <- plt07 + theme(axis.text.y = element_text(angle = 0, hjust = 1, face = "italic", size=12))
#plt07 <- plt07 + scale_fill_manual(values=c("black","white","gray"))
plt07 <- plt07 + scale_fill_manual(values=c("springgreen4","yellow","white"))
plt07 <- plt07 + scale_shape_manual(values=c(21,22,23))
plt07 <- plt07 + labs(color='test sets with')
plt07 <- plt07 + labs(fill='test sets with')
plt07 <- plt07 + labs(shape='test sets with')
#plt07
#getwd()
bSaveFigures <- T
figname02A <- paste0("Fig02_v02_plot_failed_tests.png")
if(bSaveFigures==T){
  ggsave(plt07,file=figname02A,
         width=2*210,height=0.5*297,
         units="mm",dpi=300)
}


#_______________________________________________________________________________
#install packages needed
# if(!require(colorRamp)){
#   install.packages("colorRamp")
#   library(colorRamp)
# }
#add a column w numbers for pch symbols
amph_smpl02_df$pchsymb <- (amph_smpl02_df$eval01=="truezerodetect")*1
amph_smpl02_df$pchsymb <- (amph_smpl02_df$eval01=="repl2pos")*1*21
#https://stackoverflow.com/questions/13353213/gradient-of-n-colors-ranging-from-color-1-and-color-2
nspc <- length(unique(amph_smpl02_df$abbr.nm))
#make a color ramp funciton
colfunc <- grDevices::colorRampPalette(c( "purple","darkblue", 
                                          "darkgreen", "green",
                                          "yellow"))
#Check that the colours are as you want them them to be
#plot(rep(1,nspc),col=colfunc(nspc),pch=19,cex=3)
#make a data frame for colour
col_for_frog_df <- as.data.frame(cbind(unique(amph_smpl02_df$abbr.nm), colfunc(nspc)))
#change column names on th df with colours
colnames(col_for_frog_df) <- c("abbr.nm","hexcol")
#plot(rep(1,nspc),col=colfunc(nspc),pch=19,cex=3)
#match colur back to df
amph_smpl02_df$pchcol <- col_for_frog_df$hexcol[match(amph_smpl02_df$abbr.nm, col_for_frog_df$abbr.nm)]
# https://stackoverflow.com/questions/21537782/how-to-set-fixed-continuous-colour-values-in-ggplot2
# unfortunately this makes a continous color scale, not discrete steps
# I left the code here in case I needed it later on
#nspc <- 11
#mypal01 <- colorRamp::colorRampPalette(rev(brewer.pal(11, "Spectral")))
#colfunc 
#sc <- ggplot2::scale_colour_gradientn(colours = colfunc(100), limits=c(1, 11))
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::



#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# Plot on map -start
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
#if (!exists("world"))
#{  
world <- ne_countries(scale = 10, returnclass = "sf")
#}
# class(world)
# # example input data
# (sites <- data.frame(longitude = c(5.5, 6.7), 
#                      latitude = c(56.7,57.8)))
# # 
# # 
# # 
# # 
# ggplot(data = world) +
#   geom_sf() +
#   geom_point(data = sites, aes(x = longitude, y = latitude), size = 4,
#              shape = 23, fill = "darkred") +
#   #define limits of the plot
#   ggplot2::coord_sf(xlim = c(4, 17), ylim = c(54.0, 58.8), expand = FALSE)
# # # 
# # # 
# (sites <- st_as_sf(sites, coords = c("longitude", "latitude"),
#                    crs = 4326, agr = "constant"))
# # # 
# # ## Simple feature collection with 2 features and 0 fields
# # ## geometry type:  POINT
# # ## dimension:      XY
# # ## bbox:           xmin: -80.14401 ymin: 26.479 xmax: -80.109 ymax: 26.83
# # ## epsg (SRID):    4326
# # ## proj4string:    +proj=longlat +datum=WGS84 +no_defs
# # ##                     geometry
# # ## 1 POINT (-80.14401 26.47901)
# # ## 2      POINT (-80.109 26.83)
# # 
# A tryout plot to toy with
# ggplot(data = world) +
#   geom_sf() +
#   geom_sf(data = sites, size = 4, shape = 23, fill = "darkred") +
#   ggplot2::coord_sf(xlim = c(4, 17), ylim = c(54.0, 58.8), expand = FALSE)
#   # #   

#head(amph_smpl02_df,3)
#copy the data frame
amph_smpl03_df <- amph_smpl02_df
#subset the data frame based on two criteria 
# and negate the criteria to exclude the
# detection of 'Bufo calamita' in sample DL2018009
# as this detection could not be reproduced in a second setup
# with 8 replicates of the "DL2018009" and 4 replicates of the standard 
# dilution series, as attempted in qPCR0903 and qPCR0904 
amph_smpl03_df <-  amph_smpl03_df[!(amph_smpl03_df$DLsamplno=="DL2018009" & amph_smpl03_df$latspc=="Bufo_calamita"),]

amph_smpl03_df <-  amph_smpl03_df[!(amph_smpl03_df$DLsamplno=="DL2018009" & amph_smpl03_df$latspc=="Bufo_calamita"),]
amph_smpl03_df <-  amph_smpl03_df[!(amph_smpl03_df$DLsamplno=="DL2019065" & amph_smpl03_df$latspc=="Bufo_calamita"),]
amph_smpl03_df <-  amph_smpl03_df[!(amph_smpl03_df$DLsamplno=="DL2019005" & amph_smpl03_df$latspc=="Pelobates_fuscus"),]
amph_smpl03_df <-  amph_smpl03_df[!(amph_smpl03_df$DLsamplno=="DL2019017" & amph_smpl03_df$latspc=="Rana_dalmatina"),]
amph_smpl03_df <-  amph_smpl03_df[!(amph_smpl03_df$DLsamplno=="DL2019050" & amph_smpl03_df$latspc=="Rana_dalmatina"),]

#amph_smpl03_df <-  amph_smpl03_df[!(amph_smpl03_df$DLsamplno=="DL2019065" & amph_smpl03_df$abbr.nm=="Buf.cal"),]

#subset to exclude all NonApproved controls
amph_smpl04_df <- amph_smpl03_df[amph_smpl03_df$nonapprovK==0, ]
tot_smpl03_df <- tot_smpl[tot_smpl$nonapprovK==0, ]
#head(amph_smpl03_df,7)
#subset to only include positive detections
amph_smpl05_df <- amph_smpl04_df[amph_smpl04_df$repl1or2>0, ]
tot_smpl04_df <- tot_smpl03_df[tot_smpl03_df$repl1or2>0, ]


#tot_smpl04_df[tot_smpl04_df$abbr.nm=="Buf.cal",]
#amph_smpl05_df
#amph_smpl03_df <- subset(amph_smpl03_df, eval01=="repl2pos")
#make the column with numbers for symbols a factor column
amph_smpl05_df$pchsymb <- as.factor(amph_smpl05_df$pchsymb)
#tot_smpl04_df$pchsymb <- as.factor(tot_smpl04_df$pchsymb)
# set a value for jittering the points in the plots
jitlvl <- 0.07
jitlvl <- 0.18
jitlvl <- 0.10
jitlvl <- 0.05
#change color scheme:
# https://stackoverflow.com/questions/53750310/how-to-change-default-color-scheme-in-ggplot2
#https://data-se.netlify.app/2018/12/12/changing-the-default-color-scheme-in-ggplot2/
library(viridis)
opts <- options()  # save old options


#subset to get rid of data points with incorrect positions
amph_smpl05_df <- 
  amph_smpl05_df[ which( amph_smpl05_df$dec_lon > 8 | amph_smpl05_df$dec_lon < 16) , ]

amph_smpl05_df <- 
  amph_smpl05_df[ which( amph_smpl05_df$dec_lon > 8), ]
amph_smpl05_df <- 
  amph_smpl05_df[ which( amph_smpl05_df$dec_lon < 16), ]


#_______________________________________________________________________________

#_______________________________________________________________________________
#subset to get rid of data points with incorrect positions
tot_smpl04_df <- 
  tot_smpl04_df[ which( tot_smpl04_df$dec_lon > 8 | tot_smpl04_df$dec_lon < 16) , ]

tot_smpl04_df <- 
  tot_smpl04_df[ which( tot_smpl04_df$dec_lon > 8), ]
tot_smpl04_df <- 
  tot_smpl04_df[ which( tot_smpl04_df$dec_lon < 16), ]

# amph_smpl05_df <- 
#   amph_smpl05_df[ which( amph_smpl05_df$dec_lat > 50), ]

#options(ggplot2.continuous.colour="viridis")
#options(ggplot2.continuous.fill = "viridis")
#make character ranges with species names
ch_unspnm <- unique(amph_smpl05_df$abbr.nm)
ch_undknm <- unique(amph_smpl05_df$specs)

ch_unspnmt <- unique(tot_smpl04_df$abbr.nm)
ch_undknmt <- unique(tot_smpl04_df$specs)
#class(ch_unspnm)
# #variables for legend - not used
# cl <- c(colfunc(length(unique(amph_smpl05_df$abbr.nm))))
clt <- c(colfunc(length(unique(tot_smpl04_df$abbr.nm))))
#clt <- cl
# plot all DL samples with true zero detect and at least 
# 1 positive replicate on map
# also see : https://github.com/tidyverse/ggplot2/issues/2037
p01 <- ggplot(data = world) +
  geom_sf(color = "black", fill = "azure3") +
  #https://ggplot2.tidyverse.org/reference/position_jitter.html
  # use 'geom_jitter' instead of 'geom_point' 
  geom_jitter(data = amph_smpl05_df, 
              aes(x = dec_lon, y = dec_lat, #, 
                  #color=factor(abbr.nm),
                  fill=factor(abbr.nm)), #,shape=pchsymb),
              width = jitlvl, #0.07, jitter width 
              height = jitlvl, #0.07, # jitter height
              
              size = 2) +
  #scale_colour_viridis_d(breaks=11) +
  #scale_color_brewer(palette="Dark2") +
  #https://stackoverflow.com/questions/54078772/ggplot-scale-color-manual-with-breaks-does-not-match-expected-order
  # set alpha values for color intensity of fill color in point
  #https://ggplot2.tidyverse.org/reference/aes_colour_fill_alpha.html
  #define limits of the plot
  ggplot2::coord_sf(xlim = c(8, 15.4),
                    ylim = c(54.4, 58.0),
                    expand = FALSE)
# see the plot
p01

#count number of unique species names in the data frame
nspo <- length(unique(amph_smpl05_df$abbr.nm))


#head(amph_smpl05_df)
#http://www.cookbook-r.com/Graphs/Colors_(ggplot2)/
# The palette with black:
cbbPalette <- c("#000000", "#E69F00", "#56B4E9", 
                "#009E73", "#F0E442", "#0072B2", 
                #"#D55E00", 
                "#CC79A7")

cl <- cbbPalette
# #variables for legend - not used
cl <- c(colfunc(length(unique(amph_smpl05_df$abbr.nm))))
# Information on colour blind colours
#https://stackoverflow.com/questions/57153428/r-plot-color-combinations-that-are-colorblind-accessible
safe_colorblind_palette <- c("#88CCEE", "#CC6677", "#DDCC77", "#117733", "#332288", "#AA4499", 
                             "#44AA99", "#999933", "#882255", "#661100", "#6699CC", "#888888")
# using only 11 colours
safe_colorblind_palette <- c("#88CCEE", "#CC6677", "#DDCC77", "#117733", "#332288", "#AA4499",
                             "#44AA99", "#999933", "#882255", "#6699CC", "#888888")
# using only 11 colours
safe_colorblind_palette <- c("#88CCEE", "#CC6677", "#DDCC77", "#117733", "#332288", "#AA4499",
                             "#44AA99", "#999933", "#882255", "black", "#888888")
scbpl <- safe_colorblind_palette
scales::show_col(safe_colorblind_palette)
# see how to make a number of colurs along color range
# https://stackoverflow.com/questions/15282580/how-to-generate-a-number-of-most-distinctive-colors-in-r
cl2 <- colorRampPalette(c(scbpl))( nspo) 
#cl2 <- scbpl
cl <- cl2

#plot with abbreviated species names
p01 <- ggplot(data = world) +
  geom_sf(color = "black", fill = "azure3") +
  #https://ggplot2.tidyverse.org/reference/position_jitter.html
  # use 'geom_jitter' instead of 'geom_point' 
  geom_jitter(data = amph_smpl05_df, 
              aes(x = dec_lon, y = dec_lat,
                  #amph_smpl05_df$abbr.nm
                  shape=abbr.nm,
                  color=abbr.nm,
                  fill=abbr.nm),
              width = jitlvl, #0.07, jitter width 
              height = jitlvl, #0.07, # jitter height
              size = 3.0) +
  #manually set the pch shape of the points
  scale_shape_manual(values=c(rep(21,nrow(amph_smpl05_df)))) +
  #set the color of the points
  #here it is black, and repeated the number of times
  #matching the number of species listed
  scale_color_manual(values=c(rep("black",nspo))) +
  #set the color of the points
  #use alpha to scale the intensity of the color
  scale_fill_manual(values=alpha(
    c(cl),
    c(0.7)
  ))+
  #define limits of the plot
  ggplot2::coord_sf(xlim = c(8, 15.4),
                    ylim = c(54.4, 58.0), 
                    expand = FALSE)
#see the plot
#p01
#replace underscores with a space
amph_smpl05_df$latspc <- gsub("_"," ",amph_smpl05_df$latspc)
#
#unique(amph_smpl05_df$latspc)
#unique(gsub("Rana lessonae","Pelophylax kl. esculenta",amph_smpl05_df$latspc))
amph_smpl05_df$latspc2 <- gsub("Rana lessonae","Pelophylax kl. esculenta",amph_smpl05_df$latspc)
amph_smpl05_df$latspc2<- gsub("Pelophylax ridibundus","Pelophylax kl esculentus",amph_smpl05_df$latspc2)
amph_smpl05_df$latspc2<- gsub("esculenta","esculentus",amph_smpl05_df$latspc2)
amph_smpl05_df$latspc2 <- gsub("Pelophylax esculentus","Pelophylax kl. esculentus",amph_smpl05_df$latspc2)
amph_smpl05_df$latspc2 <- gsub("Pelophylax kl\\. esculentus","Pelophylax sp",amph_smpl05_df$latspc2)

ulsp <- unique(amph_smpl05_df$latspc2)[order(unique(amph_smpl05_df$latspc2))]

nspo2<- length(ulsp)
letsp <- LETTERS[1:nspo2]
df_Lsp <- as.data.frame(cbind(letsp,ulsp))
df_Lsp$Ls3 <- paste0(letsp,")   ",ulsp)
amph_smpl05_df$latspc3 <- df_Lsp$Ls3[match(amph_smpl05_df$latspc2,df_Lsp$ulsp )]
amph_smpl05_df$llatspc3 <- df_Lsp$letsp[match(amph_smpl05_df$latspc2,df_Lsp$ulsp )]
#identify the rows in the data frame with Bufo calamita
#amph_smpl05_df[with(amph_smpl05_df, latspc2 %in% "Bufo calamita"),]

# subsitute the "Pelophylax ridibundus" name
#DL2019065
#plot with long species names
p01 <- ggplot(data = world) +
  geom_sf(color = "black", fill = "azure3") +
  #https://ggplot2.tidyverse.org/reference/position_jitter.html
  # use 'geom_jitter' instead of 'geom_point' 
  geom_jitter(data = amph_smpl05_df, 
              aes(x = dec_lon, y = dec_lat,
                  #amph_smpl05_df$abbr.nm
                  shape=latspc2,
                  color=latspc2,
                  fill=latspc2),
              width = jitlvl, #0.07, jitter width 
              height = jitlvl, #0.07, # jitter height
              size = 3.0) +
  #manually set the pch shape of the points
  scale_shape_manual(values=c(rep(21,nrow(amph_smpl05_df)))) +
  #set the color of the points
  #here it is black, and repeated the number of times
  #matching the number of species listed
  scale_color_manual(values=c(rep("black",nspo))) +
  #set the color of the points
  #use alpha to scale the intensity of the color
  scale_fill_manual(values=alpha(
    c(cl),
    c(0.7)
  ))+
  #define limits of the plot
  ggplot2::coord_sf(xlim = c(8, 15.4),
                    ylim = c(54.4, 58.0), 
                    expand = FALSE)
#see the plot
p01
#  subset the data frame to try a new plot
#subset the data frame to only include 'approved control'
# i.e. subset by making sure the nonapproved controls 
#are zero
amph_smpl03_df <- subset(amph_smpl02_df, nonapprovK==0)
amph_smpl03_df$nonapprovK <- as.factor(amph_smpl03_df$nonapprovK)

#replace categories
amph_smpl03_df$eval01 <- gsub("nonapprovK","failed test",amph_smpl03_df$eval01)
amph_smpl03_df$eval01 <- gsub("truezerodetect","no eDNA detected",amph_smpl03_df$eval01)
amph_smpl03_df$eval01 <- gsub("repl1or2","eDNA detected in 1 of 2",amph_smpl03_df$eval01)
amph_smpl03_df$eval01 <- gsub("repl2pos","eDNA detected in 2 of 2",amph_smpl03_df$eval01)


#make a new set of colours for points
cl02 <- c("springgreen1","springgreen4","white")
#amph_smpl03_df$eval01
# plot all sampled sites where both controls 
# perform as expected - i.e. the true zero detect, and the 
# 1 pos repl, and 2 pos repl
p02 <- ggplot(data = world) +
  geom_sf(color = "black", fill = "azure3") +
  #https://ggplot2.tidyverse.org/reference/position_jitter.html
  # use 'geom_jitter' instead of 'geom_point' 
  geom_jitter(data = amph_smpl03_df, 
              aes(x = dec_lon, y = dec_lat,
                  color=eval01,
                  fill=eval01,
                  shape=eval01),
              width = jitlvl, #0.07, jitter width 
              height = jitlvl, #0.07, # jitter height
              size = 3) +
  #manually set the pch shape of the points
  scale_shape_manual(values=c(rep(21,length(unique(amph_smpl03_df$eval01))))) +
  #set the color of the points
  #here it is black, and repeated the number of times
  #matching the number of species listed
  scale_color_manual(values=c(rep("black",length(unique(amph_smpl03_df$eval01))))) +
  #set the color of the points
  #use alpha to scale the intensity of the color
  scale_fill_manual(values=alpha(
    c(cl02),
    c(0.7)
  ))+
  #define limits of the plot
  ggplot2::coord_sf(xlim = c(8, 15.4),
                    ylim = c(54.4, 58.0), 
                    expand = FALSE)
#see the plot
p02

#  try a new plot

#do not subset the data frame
# i.e. instead include nonapproved controls 
# and approved controls
amph_smpl03_df <- amph_smpl02_df
#make a new set of colours for points
cl03 <- c("springgreen1","springgreen4","yellow","white")
# plot all sampled sites where both controls 
# perform as expected - i.e. the true zero detect, and the 
# 1 pos repl, and 2 pos repl , but also plot the 
# failed attempts - i.e. the attempts where students failed 
# to get a positive for the positive control, and or failed
# to get a negative for the negative control
#replace categories
amph_smpl03_df$eval01 <- gsub("nonapprovK","failed test",amph_smpl03_df$eval01)
amph_smpl03_df$eval01 <- gsub("truezerodetect","no eDNA detected",amph_smpl03_df$eval01)
amph_smpl03_df$eval01 <- gsub("repl1or2","eDNA detected in 1 of 2",amph_smpl03_df$eval01)
amph_smpl03_df$eval01 <- gsub("repl2pos","eDNA detected in 2 of 2",amph_smpl03_df$eval01)

p03 <- ggplot(data = world) +
  geom_sf(color = "black", fill = "azure3") +
  #https://ggplot2.tidyverse.org/reference/position_jitter.html
  # use 'geom_jitter' instead of 'geom_point' 
  geom_jitter(data = amph_smpl03_df, 
              aes(x = dec_lon, y = dec_lat,
                  fill=eval01,
                  color=eval01,
                  shape=eval01),
              width = jitlvl, #0.07, jitter width 
              height = jitlvl, #0.07, # jitter height
              size = 3) +
  #manually set the pch shape of the points
  scale_shape_manual(values=c(rep(21,length(unique(amph_smpl03_df$eval01))))) +
  #set the color of the points
  #here it is black, and repeated the number of times
  #matching the number of species listed
  scale_color_manual(values=c(rep("black",length(unique(amph_smpl03_df$eval01))))) +
  #set the color of the points
  #use alpha to scale the intensity of the color
  scale_fill_manual(values=alpha(
    c(cl03),
    c(0.7)
  ))+
  #define limits of the plot
  ggplot2::coord_sf(xlim = c(8, 15.4),
                    ylim = c(54.4, 58.0), 
                    expand = FALSE)
#see the plot
p03

# Add titles
# see this example: https://www.datanovia.com/en/blog/ggplot-title-subtitle-and-caption/
# p01t <- p01 + labs(title = "Amphibians detected by eDNA",
#               subtitle = "approv controls and 1 or 2 pos repl")#,
#caption = "Data source: ToothGrowth")
p01t <- p01 + labs(title = "A")#,
#change axis labels
p01t <- p01t + xlab("longitude") + ylab("latitude")
#change the header for the legend on the side, 
#this must be done for both 'fill', 'color' and 'shape', to avoid 
#getting separate legends
p01t <- p01t + labs(color='species')
p01t <- p01t + labs(fill='species')
p01t <- p01t + labs(shape='species')
#get the number of species
noofspcsnms <- length(unique(amph_smpl05_df$latspc))
#unique(amph_smpl05_df$latspc)
# https://github.com/tidyverse/ggplot2/issues/3492
#repeat 'black' a specified number of times
filltxc = rep("black", noofspcsnms)
filltxc[10] <- "red"
# Label appearance ##http://www.cookbook-r.com/Graphs/Legends_(ggplot2)/
p01t <- p01t + theme(legend.text = element_text(colour=filltxc, size = 10, face = "italic"))
#


# Add titles
# p02t <- p02 + labs(title = "eDNA samples attempted",
#                    subtitle = "at least approv controls and 1 or 2 pos repl")#,
p02t <- p02 + labs(title = "B")#,
#change axis labels
p02t <- p02t + xlab("longitude") + ylab("latitude")

#change the header for the legend on the side, 
#this must be done for both 'fill', 'color' and 'shape', to avoid 
#getting separate legends
p02t <- p02t + labs(color='evaluation excl. failed tests')
p02t <- p02t + labs(fill='evaluation excl. failed tests')
p02t <- p02t + labs(shape='evaluation excl. failed tests')

# Add titles
# p03t <- p03 + labs(title = "eDNA samples attempted",
#                    subtitle = "both unapprov controls and approv contrl")#,
p03t <- p03 + labs(title = "C")#,
#change axis labels
p03t <- p03t + xlab("longitude") + ylab("latitude")
#change the header for the legend on the side, 
#this must be done for both 'fill', 'color' and 'shape', to avoid 
#getting separate legends
p03t <- p03t + labs(color='evaluation incl. failed tests')
p03t <- p03t + labs(fill='evaluation incl. failed tests')
p03t <- p03t + labs(shape='evaluation incl. failed tests')


#see the plot
# p01t
# p02t
# p03t

# ------------- plot Combined figure -------------
library(patchwork)
# set a variable to TRUE to determine whether to save figures
bSaveFigures <- T
#getwd()
#define a filename to save to
fnm02 <- "out09_01_map_with_eDNA_samples"
#see this website: https://www.rdocumentation.org/packages/patchwork/versions/1.0.0
# on how to arrange plots in patchwork
p <-  p01t +
  p02t +
  p03t +
  
  plot_layout(nrow=3,byrow=T) + #xlab(xlabel) +
  plot_layout(guides = "collect") +
  plot_annotation(caption=fnm02) #& theme(legend.position = "bottom")
#p
#make filename to save plot to
figname02 <- paste0(fnm02,"_w_Ct_cutoff_",ct.cutoff,".png")
figname05 <- paste0(fnm02,"_w_Ct_cutoff_",ct.cutoff,".pdf")
figname05A <- paste0("Fig01_v01",fnm02,"_w_Ct_cutoff_",ct.cutoff,".pdf")
figname05A <- paste0("Fig01_v01",fnm02,"_w_Ct_cutoff_",ct.cutoff,".png")
if(bSaveFigures==T){
  ggsave(p,file=figname02,width=210,height=297,
         units="mm",dpi=300)
}

if(bSaveFigures==T){
  ggsave(p,file=figname05A,width=210,height=297,
         units="mm",dpi=600)
}

p03t1 <- p03 + labs(title = "")#,
p03t1 <- p03t1 + xlab("longitude") + ylab("latitude")
#change the header for the legend on the side, 
#this must be done for both 'fill', 'color' and 'shape', to avoid 
#getting separate legends
p03t1 <- p03t1 + labs(color='evaluation incl. failed tests')
p03t1 <- p03t1 + labs(fill='evaluation incl. failed tests')
p03t1 <- p03t1 + labs(shape='evaluation incl. failed tests')



figname05A <- paste0("Fig01_v02",fnm02,"_w_Ct_cutoff_",ct.cutoff,".png")
if(bSaveFigures==T){
  ggsave(p03t1,file=figname05A,width=210,height=297,
         units="mm",dpi=600)
}


p01t1 <- p01 + labs(title = "A")#,
p01t1 <- p01t1 + xlab("longitude") + ylab("latitude")
#change the header for the legend on the side, 
#this must be done for both 'fill', 'color' and 'shape', to avoid 
#getting separate legends
p01t1 <- p01t1 + labs(color='species')
p01t1 <- p01t1 + labs(fill='species')
p01t1 <- p01t1 + labs(shape='species')
p02t1 <- p02 + labs(title = "B")#,
p02t1 <- p02t1 + xlab("longitude") + ylab("latitude")
p01t1 <- p01t1 + theme(legend.text = element_text(colour=filltxc, size = 10, face = "italic"))

#change the header for the legend on the side, 
#this must be done for both 'fill', 'color' and 'shape', to avoid 
#getting separate legends
p02t1 <- p02t1 + labs(color='evaluation excl. failed tests')
p02t1 <- p02t1 + labs(fill='evaluation excl. failed tests')
p02t1 <- p02t1 + labs(shape='evaluation excl. failed tests')

pS31 <-   p01t1 +
          p02t1 +
          plot_layout(nrow=2,byrow=T) + #xlab(xlabel) +
          plot_layout(guides = "collect") +
          plot_annotation(caption=fnm02) #& theme(legend.position = "bottom")

figname05A <- paste0("FigS31_v01",fnm02,"_w_Ct_cutoff_",ct.cutoff,".png")
if(bSaveFigures==T){
  ggsave(pS31,file=figname05A,width=210,height=297,
         units="mm",dpi=600)
}

#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# Plot on map -end
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# Grep for species names and substitute with "Pelophylax_sp" in the species names grepped
tot_smpl04_df$latspc[grepl("lessonae",tot_smpl04_df$latspc)] <- "Pelophylax_sp"
tot_smpl04_df$latspc[grepl("Pelophylax_esculentus",tot_smpl04_df$latspc)]  <- "Pelophylax_sp"
tot_smpl04_df$latspc[grepl("ridibundus",tot_smpl04_df$latspc)] <- "Pelophylax_sp"

#
p01 <- ggplot(data = world) +
  geom_sf(color = "black", fill = "azure3") +
  #https://ggplot2.tidyverse.org/reference/position_jitter.html
  # use 'geom_jitter' instead of 'geom_point' 
  geom_jitter(data = tot_smpl04_df, 
              aes(x = dec_lon, y = dec_lat, #, 
                  #color=factor(abbr.nm),
                  fill=factor(abbr.nm)), #,shape=pchsymb),
              width = jitlvl, #0.07, jitter width 
              height = jitlvl, #0.07, # jitter height
              
              size = 2) +
  #scale_colour_viridis_d(breaks=11) +
  #scale_color_brewer(palette="Dark2") +
  #https://stackoverflow.com/questions/54078772/ggplot-scale-color-manual-with-breaks-does-not-match-expected-order
  # set alpha values for color intensity of fill color in point
  #https://ggplot2.tidyverse.org/reference/aes_colour_fill_alpha.html
  #define limits of the plot
  ggplot2::coord_sf(xlim = c(8, 15.4),
                    ylim = c(54.4, 58.0),
                    expand = FALSE)
# see the plot
#p01


#head(amph_smpl05_df)
#http://www.cookbook-r.com/Graphs/Colors_(ggplot2)/
# The palette with black:
cbbPalette <- c("#000000", "#E69F00", "#56B4E9", 
                "#009E73", "#F0E442", "#0072B2", 
                #"#D55E00", 
                "#CC79A7")

#cl <- cbbPalette
# #variables for legend - not used
cl4 <- c(colfunc(length(unique(tot_smpl04_df$abbr.nm))))
ncl4 <- length(unique(tot_smpl04_df$abbr.nm))
#plot with abbreviated species names
p01 <- ggplot(data = world) +
  geom_sf(color = "black", fill = "azure3") +
  #https://ggplot2.tidyverse.org/reference/position_jitter.html
  # use 'geom_jitter' instead of 'geom_point' 
  geom_jitter(data = tot_smpl04_df, 
              aes(x = dec_lon, y = dec_lat,
                  #amph_smpl05_df$abbr.nm
                  shape=abbr.nm,
                  color=abbr.nm,
                  fill=abbr.nm),
              width = jitlvl, #0.07, jitter width 
              height = jitlvl, #0.07, # jitter height
              size = 3.0) +
  #manually set the pch shape of the points
  scale_shape_manual(values=c(rep(21,nrow(tot_smpl04_df)))) +
  #set the color of the points
  #here it is black, and repeated the number of times
  #matching the number of species listed
  scale_color_manual(values=c(rep("black",ncl4))) +
  #set the color of the points
  #use alpha to scale the intensity of the color
  scale_fill_manual(values=alpha(
    c(cl4),
    c(0.7)
  ))+
  #define limits of the plot
  ggplot2::coord_sf(xlim = c(8, 15.4),
                    ylim = c(54.4, 58.0), 
                    expand = FALSE)
#see the plot
p01

# Grep for species names and substitute with "Pelophylax_sp" in the species names grepped
tot_smpl03_df$latspc[grepl("lessonae",tot_smpl03_df$latspc)] <- "Pelophylax_sp"
tot_smpl03_df$latspc[grepl("Pelophylax_esculentus",tot_smpl03_df$latspc)]  <- "Pelophylax_sp"
tot_smpl03_df$latspc[grepl("ridibundus",tot_smpl03_df$latspc)] <- "Pelophylax_sp"

tot_smpl03_df <- tot_smpl[tot_smpl$nonapprovK==0, ]
#define input file
inpf03 <- "DL_dk_specs_to_latspecs06.csv"
#paste path and input file together
inpf04 <- paste(wd00,wd03,"/",inpf03,sep="")
#Read in input file with names
df_dk_to_latnms01 <- read.table(inpf04,sep = ",")
#replace column names
colnames(df_dk_to_latnms01)  <- c("DK_comm_nm","Lat_spc_mn")
#match between data frames
tot_smpl03_df$latspc <- df_dk_to_latnms01$Lat_spc_mn[match(tot_smpl03_df$specs,df_dk_to_latnms01$DK_comm_nm)]
#make a colour function
clt <- cl2
clt <- c(colfunc(length(unique(tot_smpl03_df$latspc))))
#count the number of species
noofspcsnms <- length(unique(tot_smpl03_df$latspc))
#subset the data frame
tot_smpl04_df <- tot_smpl03_df[(tot_smpl03_df$nonapprovK==0),]
#subset the data frame to exlude NAs
tot_smpl04_df <- tot_smpl04_df[!is.na(tot_smpl04_df$latspc),]

#plot with long species names
#https://statisticsglobe.com/create-legend-in-ggplot2-plot-in-r
#replace in latin species names
tot_smpl04_df$latspc2 <- gsub("_"," ",tot_smpl04_df$latspc)

#plot with long species names
p01 <- ggplot(data = world) +
  geom_sf(color = "black", fill = "azure3") +
  #https://ggplot2.tidyverse.org/reference/position_jitter.html
  # use 'geom_jitter' instead of 'geom_point' 
  geom_jitter(data = tot_smpl04_df, 
              aes(x = dec_lon, y = dec_lat, #,
                  shape=latspc2,
                  color=latspc2,
                  fill=latspc2),
              width = jitlvl, #0.07, jitter width 
              height = jitlvl, #0.07, # jitter height
              size = 3.0) +
  #define limits of the plot
  ggplot2::coord_sf(xlim = c(8, 15.4),
                    ylim = c(54.4, 58.0), 
                    expand = FALSE)
#change axis labels
p01b <- p01 + xlab("longitude") + ylab("latitude")
#change fill on points
p01b <- p01b + scale_fill_manual(values=alpha(c(clt),c(0.7)) )#,
#manually set the pch shape of the points
p01b <- p01b  + scale_shape_manual(values=c(rep(21,noofspcsnms)) )#,
#set the color of the points
#here it is black, and repeated the number of times
#matching the number of species listed
p01b <- p01b  + scale_color_manual(values=c(rep("black",noofspcsnms)) )
# you will have to change the legend for all legends
p01b <- p01b + labs(color='species')
p01b <- p01b + labs(fill='species')
p01b <- p01b + labs(shape='species')
# https://github.com/tidyverse/ggplot2/issues/3492
filltxc = rep("black", noofspcsnms)
filltxc[10] <- "red"
# Label appearance ##http://www.cookbook-r.com/Graphs/Legends_(ggplot2)/
p01b <- p01b + theme(legend.text = element_text(colour=filltxc, size = 10, face = "italic"))
#
p01 <- p01b
#dev.off()

#  subset the data frame to try a new plot
#subset the data frame to only include 'approved control'
# i.e. subset by making sure the nonapproved controls 
#are zero
tot_smpl03_df <- subset(tot_smpl03_df, nonapprovK==0)
tot_smpl03_df$nonapprovK <- as.factor(tot_smpl03_df$nonapprovK)
#make a new set of colours for points
cl02 <- c("springgreen1","springgreen4","white")
#amph_smpl03_df$eval01
# plot all sampled sites where both controls 
# perform as expected - i.e. the true zero detect, and the 
# 1 pos repl, and 2 pos repl
p02 <- ggplot(data = world) +
  geom_sf(color = "black", fill = "azure3") +
  #https://ggplot2.tidyverse.org/reference/position_jitter.html
  # use 'geom_jitter' instead of 'geom_point' 
  geom_jitter(data = tot_smpl04_df, 
              aes(x = dec_lon, y = dec_lat,
                  color=eval01,
                  fill=eval01,
                  shape=eval01),
              width = jitlvl, #0.07, jitter width 
              height = jitlvl, #0.07, # jitter height
              size = 3) +
  #manually set the pch shape of the points
  scale_shape_manual(values=c(rep(21,length(unique(tot_smpl04_df$eval01))))) +
  #set the color of the points
  #here it is black, and repeated the number of times
  #matching the number of species listed
  scale_color_manual(values=c(rep("black",length(unique(tot_smpl04_df$eval01))))) +
  #set the color of the points
  #use alpha to scale the intensity of the color
  scale_fill_manual(values=alpha(
    c(cl02),
    c(0.7)
  ))+
  #define limits of the plot
  ggplot2::coord_sf(xlim = c(8, 15.4),
                    ylim = c(54.4, 58.0), 
                    expand = FALSE)
#see the plot
#p02

#  try a new plot

#do not subset the data frame
# i.e. instead include nonapproved controls 
# and approved controls
#amph_smpl03_df <- amph_smpl02_df
#make a new set of colours for points
cl03 <- c("yellow","springgreen1","springgreen4","white")
cl03 <- c("springgreen1","springgreen4","white")
# plot all sampled sites where both controls 
# perform as expected - i.e. the true zero detect, and the 
# 1 pos repl, and 2 pos repl , but also plot the 
# failed attempts - i.e. the attempts where students failed 
# to get a positive for the positive control, and or failed
# to get a negative for the negative control
p03 <- ggplot(data = world) +
  geom_sf(color = "black", fill = "azure3") +
  #https://ggplot2.tidyverse.org/reference/position_jitter.html
  # use 'geom_jitter' instead of 'geom_point' 
  geom_jitter(data = tot_smpl04_df, 
              aes(x = dec_lon, y = dec_lat,
                  fill=eval01,
                  color=eval01,
                  shape=eval01),
              width = jitlvl, #0.07, jitter width 
              height = jitlvl, #0.07, # jitter height
              size = 3) +
  #manually set the pch shape of the points
  scale_shape_manual(values=c(rep(21,length(unique(tot_smpl04_df$eval01))))) +
  #set the color of the points
  #here it is black, and repeated the number of times
  #matching the number of species listed
  scale_color_manual(values=c(rep("black",length(unique(tot_smpl04_df$eval01))))) +
  #set the color of the points
  #use alpha to scale the intensity of the color
  scale_fill_manual(values=alpha(
    c(cl03),
    c(0.7)
  ))+
  #define limits of the plot
  ggplot2::coord_sf(xlim = c(8, 15.4),
                    ylim = c(54.4, 58.0), 
                    expand = FALSE)
#see the plot
#p03
# Add titles
# see this example: https://www.datanovia.com/en/blog/ggplot-title-subtitle-and-caption/
# p01t <- p01 + labs(title = "Amphibians detected by eDNA",
#               subtitle = "approv controls and 1 or 2 pos repl")#,
#caption = "Data source: ToothGrowth")
p01t <- p01 + labs(title = "A")#,
# Add titles
# p02t <- p02 + labs(title = "eDNA samples attempted",
#                    subtitle = "at least approv controls and 1 or 2 pos repl")#,
p02t <- p02 + labs(title = "B")#,
# Add titles
# p03t <- p03 + labs(title = "eDNA samples attempted",
#                    subtitle = "both unapprov controls and approv contrl")#,
p03t <- p03 + labs(title = "C")#,
#see the plot
# p01t
# p02t
# p03t
# ------------- plot Combined figure -------------
library(patchwork)
# set a variable to TRUE to determine whether to save figures
bSaveFigures <- T
#getwd()
#define a filename to save to
fnm03 <- "out09_02_map_with_eDNA_samples"
fnm04 <- "out09_03_map_with_eDNA_samples"
#see this website: https://www.rdocumentation.org/packages/patchwork/versions/1.0.0
# on how to arrange plots in patchwork
p <-  p01t +
  p02t +
  p03t +
  
  plot_layout(nrow=3,byrow=T) + #xlab(xlabel) +
  plot_layout(guides = "collect") +
  plot_annotation(caption=fnm03) #& theme(legend.position = "bottom")
#p
#make filename to save plot to
figname02 <- paste0(fnm03,"_w_Ct_cutoff_",ct.cutoff,".png")


if(bSaveFigures==T){
  ggsave(p,file=figname02,width=210,height=297,
         units="mm",dpi=300)
}
#modify the axis labels
p01b <- p01 + xlab("longitude") + ylab("latitude")
#
fnm04 <- "out09_03_map_with_eDNA_samples"
fnm05 <- "out09_04_map_with_eDNA_samples"
#see this website: https://www.rdocumentation.org/packages/patchwork/versions/1.0.0
# on how to arrange plots in patchwork
p <-  p01b +
  #
  
  plot_layout(nrow=3,byrow=T) + #xlab(xlabel) +
  plot_layout(guides = "collect") +
  plot_annotation(caption=fnm04) #& theme(legend.position = "bottom")
#p
#make filename to save plot to
figname04 <- paste0(fnm05,"_w_Ct_cutoff_",ct.cutoff,".pdf")
figname04 <- paste0(fnm05,"_w_Ct_cutoff_",ct.cutoff,".png")
figname03 <- paste0(fnm05,"_w_Ct_cutoff_",ct.cutoff,".png")


if(bSaveFigures==T){
  ggsave(p,file=figname03,width=210,height=297,
         units="mm",dpi=300)
}

if(bSaveFigures==T){
  ggsave(p01b,file=figname04,width=210,height=297,
         units="mm",dpi=300)
}

#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# Plot on map -end
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
#install.packages("rcartocolor")
# library(rcartocolor)
# display_carto_all(colorblind_friendly = TRUE)
# palette.colors(palette = "Okabe-Ito")
# Information on colour blind colours
#https://stackoverflow.com/questions/57153428/r-plot-color-combinations-that-are-colorblind-accessible
safe_colorblind_palette <- c("#88CCEE", "#CC6677", "#DDCC77", "#117733", "#332288", "#AA4499", 
                             "#44AA99", "#999933", "#882255", "#661100", "#6699CC", "#888888")

safe_colorblind_palette <- c("#88CCEE", "#CC6677", "#DDCC77", "#117733", "#332288", "#AA4499", 
                             "#44AA99", "#999933", "#882255", "#6699CC", "#888888")
scbpl <- safe_colorblind_palette
scales::show_col(safe_colorblind_palette)
# see how to make a number of colurs along color range
# https://stackoverflow.com/questions/15282580/how-to-generate-a-number-of-most-distinctive-colors-in-r
cl2 <- colorRampPalette(c(scbpl))( nspo) 
#cl2 <- scbpl
cl05 <- cl2
#length(cl2)
#_______________________________________________________________________________
# Make plot on map with facet wrap - start
#_______________________________________________________________________________
#plot with long species names
p04 <- ggplot(data = world) +
  geom_sf(color = "black", fill = "azure3") +
  #https://ggplot2.tidyverse.org/reference/position_jitter.html
  # use 'geom_jitter' instead of 'geom_point' 
  geom_jitter(data = amph_smpl05_df, 
              aes(x = dec_lon, y = dec_lat,
                  #amph_smpl05_df$abbr.nm
                  shape=latspc2,
                  color=latspc2,
                  fill=latspc2),
              width = jitlvl, #0.07, jitter width 
              height = jitlvl, #0.07, # jitter height
              size = 3.0) +
  #manually set the pch shape of the points
  scale_shape_manual(values=c(rep(21,nrow(amph_smpl05_df)))) +
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
  #Arrange in facets
  ggplot2::facet_wrap( ~ latspc2, 
                       ncol = 3,
                       labeller = label_bquote(col = italic(.(latspc2)))) +
  #define limits of the plot
  ggplot2::coord_sf(xlim = c(8, 15.4),
                    ylim = c(54.4, 58.0), 
                    expand = FALSE)
#see the plot
#p04
#change axis labels
p04t <- p04 + xlab("longitude") + ylab("latitude")
#change the header for the legend on the side, 
#this must be done for both 'fill', 'color' and 'shape', to avoid 
#getting separate legends
p04t <- p04t + labs(color='species')
p04t <- p04t + labs(fill='species')
p04t <- p04t + labs(shape='species')
#get the number of species
noofspcsnms <- length(unique(amph_smpl05_df$latspc))
# https://github.com/tidyverse/ggplot2/issues/3492
#repeat 'black' a specified number of times
filltxc = rep("black", noofspcsnms)
filltxc[10] <- "red"
# Label appearance ##http://www.cookbook-r.com/Graphs/Legends_(ggplot2)/
p04t <- p04t + theme(legend.text = element_text(colour=filltxc, size = 10, face = "italic"))
#adjust tick marks on axis
p04t <- p04t + scale_y_continuous(breaks=seq(54.5,58,1))
p04t <- p04t + scale_x_continuous(breaks=seq(8,16,2))
#alter stripes above facet plots
p04t <- p04t + theme(strip.background =element_rect(fill=c("black")))
p04t <- p04t + theme(strip.text = element_text(colour = 'white'))
# see the plot
#p04t
# #define file name to save plot to
# figname06A <- paste0("Fig02_",fnm02,"_w_Ct_cutoff_",ct.cutoff,".pdf")
# # save plot
# if(bSaveFigures==T){
#   ggsave(p04t,file=figname06A,width=210,height=297,
#          units="mm",dpi=600)
# }

#
#_______________________________________________________________________________
# Make plot on map with facet wrap - end
#_______________________________________________________________________________


#_______________________________________________________________________________
# Make plot on map with facet wrap - start
#_______________________________________________________________________________
#plot with long species names
p05 <- ggplot(data = world) +
  geom_sf(color = "black", fill = "azure3") +
  #https://ggplot2.tidyverse.org/reference/position_jitter.html
  # use 'geom_jitter' instead of 'geom_point' 
  geom_jitter(data = amph_smpl05_df, 
              aes(x = dec_lon, y = dec_lat,
                  #amph_smpl05_df$abbr.nm
                  shape=latspc2,
                  color=latspc2,
                  fill=latspc2),
              width = jitlvl, #0.07, jitter width 
              height = jitlvl, #0.07, # jitter height
              size = 3.0) +
  #manually set the pch shape of the points
  scale_shape_manual(values=c(rep(21,nrow(amph_smpl05_df)))) +
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
noofspcsnms <- length(unique(amph_smpl05_df$latspc))
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
#p05t
#define file name to save plot to
figname06A <- paste0("Fig02_v01",fnm02,"_w_Ct_cutoff_",ct.cutoff,"_02.pdf")
figname06A <- paste0("Fig02_v01",fnm02,"_w_Ct_cutoff_",ct.cutoff,"_02.png")
# save plot
if(bSaveFigures==T){
  ggsave(p05t,file=figname06A,width=210,height=297,
         units="mm",dpi=600)
}

figname06A <- paste0("FigS32_v01",fnm02,"_w_Ct_cutoff_",ct.cutoff,"_02.png")
# save plot
if(bSaveFigures==T){
  ggsave(p05t,file=figname06A,width=210,height=297,
         units="mm",dpi=600)
}


#
#_______________________________________________________________________________
# Make plot on map with facet wrap - end
#_______________________________________________________________________________



#Check following samples for presence of
# DL2018009 - Bufo calamita
# DL2019065 - Bufo calamita

#copy the data frame
df_as03 <- amph_smpl02_df
#subset the data frame based on two criteria 
# and negate the criteria to exclude the
# detection of 'Bufo calamita' in sample DL2018009
# as this detection could not be reproduced in a second setup
# with 8 replicates of the "DL2018009" and 4 replicates of the standard 
# dilution series, as attempted in qPCR0903 and qPCR0904 
# Remove all the positive detections that did not make any sens and which
# I could not reproduce when I tested out 8 technical replicates together
# with standard curves
df_as03 <-  df_as03[!(df_as03$DLsamplno=="DL2018009" & df_as03$latspc=="Bufo_calamita"),]
df_as03 <-  df_as03[!(df_as03$DLsamplno=="DL2019065" & df_as03$latspc=="Bufo_calamita"),]
df_as03 <-  df_as03[!(df_as03$DLsamplno=="DL2019005" & df_as03$latspc=="Pelobates_fuscus"),]
df_as03 <-  df_as03[!(df_as03$DLsamplno=="DL2019017" & df_as03$latspc=="Rana_dalmatina"),]
df_as03 <-  df_as03[!(df_as03$DLsamplno=="DL2019050" & df_as03$latspc=="Rana_dalmatina"),]
#subset to exclude all NonApproved controls
df_as04 <- df_as03[df_as03$nonapprovK==0, ]
#copy the data frame
df_as05 <- df_as04
#make the column with numbers for symbols a factor column
df_as05$pchsymb <- as.factor(df_as05$pchsymb)
#subset to get rid of data points with incorrect positions
df_as05 <- 
  df_as05[ which( df_as05$dec_lon > 8 | df_as05$dec_lon < 16) , ]
df_as05 <- 
  df_as05[ which( df_as05$dec_lon > 8), ]
df_as05 <- 
  df_as05[ which( df_as05$dec_lon < 16), ]
#count number of unique species names in the data frame
nspo <- length(unique(df_as05$abbr.nm))
#replace underscores with a space
df_as05$latspc <- gsub("_"," ",df_as05$latspc)
#
#unique(df_as05$latspc)
#unique(gsub("Rana lessonae","Pelophylax kl. esculenta",df_as05$latspc))
df_as05$latspc2 <- gsub("Rana lessonae","Pelophylax kl. esculenta",df_as05$latspc)
df_as05$latspc2 <- gsub("Pelophylax kl\\. esculenta","Pelophylax sp",df_as05$latspc)

ulsp <- unique(df_as05$latspc2)[order(unique(df_as05$latspc2))]
nspo2<- length(ulsp)
letsp <- LETTERS[1:nspo2]
df_Lsp <- as.data.frame(cbind(letsp,ulsp))
df_Lsp$Ls3 <- paste0(letsp,")   ",ulsp)
df_as05$latspc3 <- df_Lsp$Ls3[match(df_as05$latspc2,df_Lsp$ulsp )]
df_as05$llatspc3 <- df_Lsp$letsp[match(df_as05$latspc2,df_Lsp$ulsp )]
df_as05.Buf.cal <-  df_as05[df_as05$abbr.nm=="Buf.cal",]
df_as06 <- df_as05
# check for positive detections of Bufo calamita
#df_as05.Buf.cal[!df_as05.Buf.cal$repl1or2==0,]
# exclude records of Bufo calamita from  sample DL2019065
#df_as06 <- subset(df_as05, !DLsamplno=="DL2019065" | abbr.nm!="Buf.cal")

#define an output file
outfl1 = "out08_01b_DL_records_amphibia_Denmark.csv"
# paste together path and input flie
pthoutf01 <- paste0(wd00_wd09,"/",outfl1)
#make sure all columns are characters
#https://stackoverflow.com/questions/24829027/unimplemented-type-list-when-trying-to-write-table
df_as06 <- apply(df_as06,2,as.character)
# write a table
write.table(df_as06, file=pthoutf01, sep=",",
            row.names = F, # do not use row names
            col.names = T, #  use columns names
            quote = F) # do not use quotes
#_______________________________________________________________________________
# Make separate plot for Pelobates fuscus
#_______________________________________________________________________________
# subset to get records of Pelobates fuscus
df_Pf01 <- amph_smpl05_df[amph_smpl05_df$abbr.nm=="Pel.fus",]
#plot with long species names
p04 <- ggplot(data = world) +
  geom_sf(color = "black", fill = "azure3") +
  #https://ggplot2.tidyverse.org/reference/position_jitter.html
  # use 'geom_jitter' instead of 'geom_point' 
  geom_jitter(data = df_Pf01, 
              aes(x = dec_lon, y = dec_lat,
                  #amph_smpl05_df$abbr.nm
                  shape=latspc2,
                  color=latspc2,
                  fill=latspc2),
              width = jitlvl, #0.07, jitter width 
              height = jitlvl, #0.07, # jitter height
              size = 3.0) +
  
  geom_text(data= df_Pf01, 
            aes(x = dec_lon, y = dec_lat),
            label=c(df_Pf01$DLsamplno),
            size=2.4,
            colour="blue",
            nudge_x = 0.25, nudge_y = 0.10, 
            check_overlap = T
  ) +
  
  geom_text(data= df_Pf01, 
            aes(x = dec_lon, y = dec_lat),
            label=c(df_Pf01$gymnasiumnm1),
            size=2.4,
            colour="red",
            nudge_x = 0.25, nudge_y = -0.10, 
            check_overlap = T
  ) +
  #manually set the pch shape of the points
  # scale_shape_manual(values=c(rep(21,nrow(amph_smpl05_df)))) +
  #set the color of the points
  #here it is black, and repeated the number of times
  #matching the number of species listed
  # scale_color_manual(values=c(rep("black",nspo))) +
  #set the color of the points
  #use alpha to scale the intensity of the color
  # scale_fill_manual(values=alpha(
  #   c(cl05),
  #   c(0.7)
# ))+
# 
# #define limits of the plot
ggplot2::coord_sf(xlim = c(8, 15.4),
                  ylim = c(54.4, 58.0), 
                  expand = FALSE)
#see the plot
#p04
#
#change axis labels
p04t <- p04 + xlab("longitude") + ylab("latitude")
#change the header for the legend on the side, 
#this must be done for both 'fill', 'color' and 'shape', to avoid 
#getting separate legends
p04t <- p04t + labs(color='species')
p04t <- p04t + labs(fill='species')
p04t <- p04t + labs(shape='species')

#get the number of species
noofspcsnms <- length(unique(amph_smpl05_df$latspc))
# https://github.com/tidyverse/ggplot2/issues/3492
#repeat 'black' a specified number of times
filltxc = rep("black", noofspcsnms)
filltxc[10] <- "red"
# Label appearance ##http://www.cookbook-r.com/Graphs/Legends_(ggplot2)/
p04t <- p04t + theme(legend.text = element_text(colour=filltxc, size = 10, face = "italic"))
#adjust tick marks on axis
p04t <- p04t + scale_y_continuous(breaks=seq(54.5,58,1))
p04t <- p04t + scale_x_continuous(breaks=seq(8,16,2))
#alter stripes above facet plots
p04t <- p04t + theme(strip.background =element_rect(fill=c("black")))
p04t <- p04t + theme(strip.text = element_text(colour = 'white'))
# see the plot
#p04t
# get DL sampleNo for the odd sample
df_Pf01$DLsamplno[df_Pf01$gymnasiumnm1=="HelsingoerGym"]
spcNm <- unique(df_Pf01$specs)
bSaveFigures=T
#define file name to save plot to
figname06A <- paste0("FigS35_v01_",fnm02,"_w_Ct_cutoff_",ct.cutoff,"_",spcNm,"_smplHelsingoerGym.pdf")
figname06A <- paste0("FigS35_v01_",fnm02,"_w_Ct_cutoff_",ct.cutoff,"_",spcNm,"_smplHelsingoerGym.png")
# save plot
if(bSaveFigures==T){
  ggsave(p04t,file=figname06A,width=210,height=297,
         units="mm",dpi=600)
}
#subset to only comprise "Rana dalmatina"
df_Rd01 <- amph_smpl05_df[amph_smpl05_df$latspc=="Rana dalmatina",]
#subset to only comprise northern records above 56.1 N
df_Rd01 <- df_Rd01[df_Rd01$dec_lat>56.1,]
# get DL sample number for the records of Rana dalmatina that are off
DLsmpl_Rd_off <- unique(df_Rd01$DLsamplno)

# DL2018009 -  check for Bufo calamita - already tested in 16 replicates. Not possible to reproduce
# DL2019065 -  check for  Bufo calamita - check in qPCR0938  -not possible to find again
# DL2019005 -  check for Pelobates fuscus - fetched
# DL2019017 -  check for Rana dalmatina - check in qPCR0938 -not possible to find again
# DL2019050 -  check for Rana dalmatina
#_______________________________________________________________________________
# match to get sampling date
amph_smpl03_df$sampling_date  <- hc$sampling_date[match(amph_smpl03_df$DLsamplno,hc$DL_No)]
#head(amph_smpl03_df,12)
# make the sample dates a list
lst_smpl.dt <- amph_smpl03_df$sampling_date  
lst_smpl.dt[is.na(lst_smpl.dt)] <- c("00-00-0000")
# # split to get a list of vectors
lst_smpl.dt <- strsplit(lst_smpl.dt,"-")
#get sample day, month and year
smpDt.1 <- sapply(lst_smpl.dt, "[[", 1)
smpDt.2 <- sapply(lst_smpl.dt, "[[", 2)
smpDt.3 <- sapply(lst_smpl.dt, "[[", 3)
# copy the data frame
df_as09 <- amph_smpl03_df
# add back sampling year , month and day
df_as09$sampling_date.day  <- as.numeric(smpDt.1)
df_as09$sampling_date.mnt  <- as.numeric(smpDt.2)
df_as09$sampling_date.yer  <- as.numeric(smpDt.3)
# only retain samples where the sampling year is above 2000
df_as09 <- df_as09[df_as09$sampling_date.yer>2000,]
# paste together sample day, month and year
dt <- paste0(df_as09$sampling_date.day,"/",df_as09$sampling_date.mnt,"/",df_as09$sampling_date.yer)
# combine in a data frame with DL Sample numbers
df_dt <- as.data.frame(cbind(df_as09$DLsamplno,dt))
# change the column names
colnames(df_dt) <- c("DLsmplno","Date")
# use one of the examples here
#https://stackoverflow.com/questions/19564930/how-do-i-convert-date-to-number-of-days-in-r
# note that this use of functions returns the day number for each year
# the other suggestions on this website offers solutions to count across multiple years
# but the aim is here to know at what day in the year (across several years) the sample
# was collected
df_dt <- transform(df_dt, NumDays=as.numeric(strftime(as.Date(Date, format='%d/%m/%Y'), '%j'))-1)
# match back to the main data frame  
df_as09$NumDays <- df_dt$NumDays[match(df_as09$DLsamplno,df_dt$DLsmplno)]
df_as09$sampling_date2 <- df_dt$Date[match(df_as09$DLsamplno,df_dt$DLsmplno)]

#_______________________________________________________________________________
# make plot along day numbers for eDNA detections
#_______________________________________________________________________________
library(ggplot2)

#copy column with evaluations
df_as09$eval03  <- df_as09$eval01
# replace in the copied column if grepl is a match
df_as09$eval03[grepl("eDNA detected in",df_as09$eval01)] <- "eDNA detected"
# make a data frame for first days in the month, to use for vertical lines in
# the plots
refdates <- c("2022-05-01","2022-06-01","2022-07-01","2022-08-01","2022-09-01")
refdates <- as.Date(refdates)

df_as09$latspc <- gsub("Pelophylax_esculentus","Pelophylax_sp",df_as09$latspc)
df_as09$latspc <- gsub("Rana_lessonae","Pelophylax_sp",df_as09$latspc)


df_labels <- data.frame(date=refdates)  %>%
  mutate(dayno=lubridate::yday(date),
         datelabel=format(date, format = "%d-%b")) %>%
  mutate(x0=0.52) 
#Substitute in latin species name
df_as09$latspc2 <- gsub("_"," ",df_as09$latspc)
# copy the column with day number
df_as09$dayno <- df_as09$NumDays
# make a ggplot
plt09 <- ggplot(df_as09, aes(x=latspc2, y=dayno)) +
  # use points with fill based on evaluation, and jitter their position
  geom_point(aes(fill=eval03), size=3, shape=21,
             position=position_jitter(width=0.2, height=0.1)) +
  # set the colors to fill the points manually
  scale_fill_manual(values=alpha(c("springgreen3","yellow",  "white"),0.7)) +
  # add box plot for each category
  geom_boxplot(outlier.colour=NA, fill=NA)  +
  # make the species names along the axis italic
  theme(axis.text.y = element_text(angle = 0, hjust = 1, face = "italic", size=12)) +
  theme(axis.text.x = element_text(angle = 0, size=11)) +
  #change axis labels
  xlab("") + 
  #xlab("species") + 
  ylab("day number of the year") +
  #getting separate legends
  labs(fill='test sets with') +
  # reverse the order of categories on the discrete scale
  # https://stackoverflow.com/questions/28391850/reverse-order-of-discrete-y-axis-in-ggplot2
  # reverse the categories
  scale_x_discrete(limits=rev) +
  coord_flip() +
  # add lines for dates
  geom_hline(data=df_labels,
             aes(yintercept=dayno),
             colour="blue",linetype=2) + 
  # add labels for dates
  geom_text(data=df_labels,
            aes(x=x0+0.2,y=dayno+2,label=datelabel),
            hjust=0,vjust=1, size=3)
# see the plot
#plt09
figname09A <- paste0("Fig04_01_",fnm02,"_boxplot_sampling_time_.png")
# save plot
if(bSaveFigures==T){
  ggsave(plt09,file=figname09A,width=210,height=297*0.5,
         units="mm",dpi=300)
}
library(ggplot2)
# exclude to only comprise non-failed tests, and place in a new data frame
df_as10 <- df_as09[df_as09$eval03!="failed test",]
# substitute in Pelophylax name
df_as10$latspc2 <- gsub("Pelophylax esculentus","Pelophylax sp",df_as10$latspc2)
df_as10$latspc2 <- gsub("Rana lessonae","Pelophylax sp",df_as10$latspc2)

# make a ggplot
plt09 <- ggplot(df_as10, aes(x=latspc2, y=dayno)) +
  # use points with fill based on evaluation, and jitter their position
  geom_point(aes(fill=eval03), size=3, shape=21,
             position=position_jitter(width=0.2, height=0.1)) +
  # set the colors to fill the points manually
  scale_fill_manual(values=alpha(c("springgreen3",  "white"),0.7)) +
  # add box plot for each category
  geom_boxplot(outlier.colour=NA, fill=NA)  +
  # make the species names along the axis italic
  theme(axis.text.y = element_text(angle = 0, hjust = 1, face = "italic", size=12)) +
  theme(axis.text.x = element_text(angle = 0, size=11)) +
  #change axis labels
  xlab("") + 
  #xlab("species") + 
  ylab("day number of the year") +
  #getting separate legends
  labs(fill='test sets with') +
  # reverse the order of categories on the discrete scale
  # https://stackoverflow.com/questions/28391850/reverse-order-of-discrete-y-axis-in-ggplot2
  # reverse the categories
  scale_x_discrete(limits=rev) +
  coord_flip() +
  # add lines for dates
  geom_hline(data=df_labels,
             aes(yintercept=dayno),
             colour="blue",linetype=2) + 
  # add labels for dates
  geom_text(data=df_labels,
            aes(x=x0+0.2,y=dayno+2,label=datelabel),
            hjust=0,vjust=1, size=3)
#plt09
# pasTe together a file name
figname09A <- paste0("Fig04_02_",fnm02,"_boxplot_sampling_time_.png")
# save plot
if(bSaveFigures==T){
  ggsave(plt09,file=figname09A,width=210,height=297*0.5,
         units="mm",dpi=300)
}
library(ggplot2)
#subset data frame to only include matches with "eDNA detected"
df_as10 <- df_as09[df_as09$eval03=="eDNA detected",]
# make a ggplot
plt09 <- ggplot(df_as10, aes(x=latspc2, y=dayno)) +
  # use points with fill based on evaluation, and jitter their position
  geom_point(aes(fill=eval03), size=3, shape=21,
             position=position_jitter(width=0.2, height=0.1)) +
  # set the colors to fill the points manually
  scale_fill_manual(values=alpha(c("springgreen3"),0.7)) +
  # add box plot for each category
  geom_boxplot(outlier.colour=NA, fill=NA)  +
  # make the species names along the axis italic
  theme(axis.text.y = element_text(angle = 0, hjust = 1, face = "italic", size=12)) +
  theme(axis.text.x = element_text(angle = 0, size=11)) +
  #change axis labels
  xlab("") + 
  #xlab("species") + 
  ylab("day number of the year") +
  #getting separate legends
  labs(fill='test sets with') +
  # reverse the order of categories on the discrete scale
  # https://stackoverflow.com/questions/28391850/reverse-order-of-discrete-y-axis-in-ggplot2
  # reverse the categories
  scale_x_discrete(limits=rev) +
  coord_flip() +
  # add lines for dates
  geom_hline(data=df_labels,
             aes(yintercept=dayno),
             colour="blue",linetype=2) + 
  # add labels for dates
  geom_text(data=df_labels,
            aes(x=x0+0.2,y=dayno+2,label=datelabel),
            hjust=0,vjust=1, size=3)
# see the plot
#plt09
# paste together to get a file name to use for saving the file
figname09A <- paste0("Fig04_03_",fnm02,"_boxplot_sampling_time_.png")
# save plot
if(bSaveFigures==T){
  ggsave(plt09,file=figname09A,width=210,height=297*0.5,
         units="mm",dpi=300)
}

#match to get area covered by water body collected
df_as09$Areal_m2 <- hc$Areal_m2[match(df_as09$DLsamplno,hc$DL_No)]
# make the area value numeric
df_as09$Areal_m2 <- as.numeric(df_as09$Areal_m2)
# exclude sampling that do not have an area for the water body collected
df_as10 <- df_as09[!is.na(df_as09$Areal_m2),]
# take the log10 to the areas
df_as10$l10.Areal_m2 <- log10(df_as10$Areal_m2)
# replace the underscore to have space in between genus and species name
df_as10$latspc2 <-  gsub("_"," ",df_as10$latspc)
# make a scattered box plot for species
plt10 <- ggplot(df_as10, aes(x=latspc2, y=Areal_m2)) +
  geom_point(aes(fill=eval03), size=4, shape=21, colour="grey20",
             position=position_jitter(width=0.2, height=0.1)) +
  
  geom_boxplot(outlier.colour=NA, fill=NA, colour="grey20") +
  labs(title="B")
# reverse the order of categories on the discrete scale
# https://stackoverflow.com/questions/28391850/reverse-order-of-discrete-y-axis-in-ggplot2
# reverse the categories
plt10 <- plt10 + scale_x_discrete(limits=rev)
# set the fill color manually
plt10 <- plt10 + scale_fill_manual(values=alpha(c("springgreen3","yellow",  "white"),0.7))
# make the species names along the axis italic
plt10 <- plt10 + theme(axis.text.y = element_text(angle = 0, hjust = 1, face = "italic", size=12))
plt10 <- plt10 + theme(axis.text.x = element_text(angle = 0, size=14))
plt10 <- plt10 + scale_y_log10(breaks = trans_breaks("log10", function(y) 10^y),
                               labels = trans_format("log10", math_format(10^.x)))
#labels = trans_format("log10"))
#change axis labels
plt10 <- plt10 + 
  #xlab("species") + 
  xlab("") + 
  #https://community.rstudio.com/t/use-bquote-in-ggplot2-for-subscript-text/40882
  ylab(bquote(area ~ of ~ water ~ body ~ sampled ~ ( m^2))) 
#getting separate legends
plt10 <- plt10 + labs(fill='test sets with')
plt10 <- plt10 + coord_flip()
#plt10
figname10A <- paste0("Fig05_01_",fnm02,"_boxplot_lake_area_size.png")
# save plot
if(bSaveFigures==T){
  ggsave(plt10,file=figname10A,width=210,height=297*0.5,
         units="mm",dpi=300)
}
library(ggplot2)
# exclude the failed tests
df_as12 <- df_as10[df_as10$eval03!="failed test",]
# make a scattered box plot for species
plt12 <- ggplot(df_as12, aes(x=latspc2, y=Areal_m2)) +
  geom_point(aes(fill=eval03), size=4, shape=21, colour="grey20",
             position=position_jitter(width=0.2, height=0.1)) +
  
  geom_boxplot(outlier.colour=NA, fill=NA, colour="grey20") +
  labs(title="B")
# reverse the order of categories on the discrete scale
# https://stackoverflow.com/questions/28391850/reverse-order-of-discrete-y-axis-in-ggplot2
# reverse the categories
plt12 <- plt12 + scale_x_discrete(limits=rev)
# set the fill color manually
plt12 <- plt12 + scale_fill_manual(values=alpha(c("springgreen3","white"),0.7))
# make the species names along the axis italic
plt12 <- plt12 + theme(axis.text.y = element_text(angle = 0, hjust = 1, face = "italic", size=12))
plt12 <- plt12 + theme(axis.text.x = element_text(angle = 0, size=14))


plt12 <- plt12 + scale_y_log10(breaks = trans_breaks("log10", function(y) 10^y),
                               labels = trans_format("log10", math_format(10^.x)))
#labels = trans_format("log10"))
#change axis labels
plt12 <- plt12 +  #xlab("species") + 
  xlab("") + 
  #https://community.rstudio.com/t/use-bquote-in-ggplot2-for-subscript-text/40882
  ylab(bquote(area ~ of ~ water ~ body ~ sampled ~ ( m^2))) 
#getting separate legends
plt12 <- plt12 + labs(fill='test sets with')
plt12 <- plt12 + coord_flip()
#plt12
figname10A <- paste0("Fig05_02_",fnm02,"_boxplot_lake_area_size.png")
# save plot
if(bSaveFigures==T){
  ggsave(plt12,file=figname10A,width=210,height=297*0.5,
         units="mm",dpi=300)
}
library(ggplot2)
# exclude the failed tests
df_as12 <- df_as09[df_as09$eval03=="eDNA detected",]
# make a scattered box plot for species
plt12 <- ggplot(df_as12, aes(x=latspc2, y=Areal_m2)) +
  geom_point(aes(fill=eval03), size=4, shape=21, colour="grey20",
             position=position_jitter(width=0.2, height=0.1)) +
  
  geom_boxplot(outlier.colour=NA, fill=NA, colour="grey20") +
  #labs(title="B")
  labs(title="")
# reverse the order of categories on the discrete scale
# https://stackoverflow.com/questions/28391850/reverse-order-of-discrete-y-axis-in-ggplot2
# reverse the categories
plt12 <- plt12 + scale_x_discrete(limits=rev)
# set the fill color manually
plt12 <- plt12 + scale_fill_manual(values=alpha(c("springgreen3"),0.7))
# make the species names along the axis italic
plt12 <- plt12 + theme(axis.text.y = element_text(angle = 0, hjust = 1, face = "italic", size=12))
plt12 <- plt12 + theme(axis.text.x = element_text(angle = 0, size=14))
plt12 <- plt12 + scale_y_log10(breaks = trans_breaks("log10", function(y) 10^y),
                               labels = trans_format("log10", math_format(10^.x)))
#labels = trans_format("log10"))
#change axis labels
plt12 <- plt12 +  #xlab("species") +
  xlab("") +
  #ylab("area of water body sampled (m2)")
  #https://community.rstudio.com/t/use-bquote-in-ggplot2-for-subscript-text/40882
  ylab(bquote(area ~ of ~ water ~ body ~ sampled ~ ( m^2))) 
#getting separate legends
plt12 <- plt12 + labs(fill='test sets with')
plt12 <- plt12 + coord_flip()
#plt12
figname10A <- paste0("Fig05_03_",fnm02,"_boxplot_lake_area_size.png")
# save plot
if(bSaveFigures==T){
  ggsave(plt12,file=figname10A,width=210,height=297*0.5,
         units="mm",dpi=300)
}
#_______________________________________________________________________________



library(lubridate)
library(tidyverse)
library(scales)

#paste path and file together for table with aquatic periods for the amphibians
wd00_wd03_inpf04 <- paste(wd00_wd03,"/aquatic_periods_for_DK_amphibians_v01.xls",sep="")
# read in the excel file
df_aqp <- as.data.frame(read_excel(wd00_wd03_inpf04))
# Proceed by transforming this data frame in order to 
# get day number of the year for adult period start (aps) and end (ape)
# and for juvenile period start (jps) and end (jpe)
df_aqp$aps.dn <- lubridate::yday( as.Date(df_aqp$adultperiodstart,tryFormats=c("%d-%m-%y")))
df_aqp$ape.dn <- lubridate::yday( as.Date(df_aqp$adultperiodend,tryFormats=c("%d-%m-%y")))
df_aqp$jps.dn <- lubridate::yday( as.Date(df_aqp$juvenileperiodstart,tryFormats=c("%d-%m-%y")))
df_aqp$jpe.dn <- lubridate::yday( as.Date(df_aqp$juvenileperiodend,tryFormats=c("%d-%m-%y")))
# get the mean dayNumber per period by using the adult period start day no and the
# adult period end day no 
df_aqp$ap.m.dn <- rowMeans(df_aqp[,c('aps.dn', 'ape.dn')], na.rm=TRUE)
# get the mean dayNumber per period by using the juvenile period start day no and the
# juvenile period end day no 
df_aqp$jp.m.dn <- rowMeans(df_aqp[,c('jps.dn', 'jpe.dn')], na.rm=TRUE)
# also get the standard deviation around the meand day numbers
df_aqp$ap.sd.dn <- df_aqp$ap.m.dn-df_aqp$aps.dn
df_aqp$jp.sd.dn <- df_aqp$jp.m.dn-df_aqp$jps.dn
# use tidyr to rearrange from wide to long
df_aqp2 <- df_aqp %>% 
  pivot_longer(
    cols = starts_with(c("jp.","ap.")), 
    names_to = "periodName", 
    values_to = "dayNumb",
    values_drop_na = TRUE
  )
# define columns to keep
colkeep <- c("latspc","periodName","dayNumb")
# only keep specified columns
df_aqp2 <- df_aqp2[colkeep]
# exclude match with species
df_aqp2 <- df_aqp2[!grepl("lessonae",df_aqp2$latspc),]
df_aqp2 <- df_aqp2[!grepl("ridibundus",df_aqp2$latspc),]
df_aqp2 <- df_aqp2[!grepl("esculent",df_aqp2$latspc),]

# get the second element, which denotes the 'sd' or the 'mean'
df_aqp2$perEval <- gsub("^(.*)\\.(.*)\\.(.*)","\\2",df_aqp2$periodName)
# subsitute to get the first element - which is the abbreviation for the mating
# hactching period
df_aqp2$periodName <- gsub("^(.*)\\.(.*)\\.(.*)","\\1",df_aqp2$periodName)
# make the tibble wide
df_aqp3 <- df_aqp2 %>% 
  pivot_wider(names_from = perEval, values_from = dayNumb)
# substitute to get long period name categories
df_aqp3$periodName <- gsub("jp","juvenile aquatic",df_aqp3$periodName)
df_aqp3$periodName <- gsub("ap","adult aquatic",df_aqp3$periodName)
# a sequence of all day nos used to make tile data
daynos_norm <- data.frame(dayno=seq(floor(min(df_aqp$aps.dn,na.rm=T)),
                                    ceiling(max(df_aqp$jpe.dn,na.rm=T)),1))
# cutoff nvalues below a threshold
cutoff = 0.2
# cartesian join of daynos and the group / period combinations
# for each group (species) and aquatic period we will create a normally distributed 
# variable and calculate the probability distribution function at each day in the dayno sequence
df_tile3 <- df_aqp3 %>% 
  merge(daynos_norm,all=T) %>%
  mutate(n=dnorm(dayno,m,sd)/dnorm(m,m,sd)) %>%
  mutate(n=n^2) %>% # denne kvadratfunktion tydeliggør de høje værdier - prøv uden for at se hvad jeg mener
  filter(n>=cutoff) 
#replace column name to make the 'group' name match with the 'df' data frame
colnames(df_tile3)[1] <- c("latspc2")
# substitute in name
df_tile3$latspc2 <- gsub("_"," ",df_tile3$latspc2)
# subset data frame
df_as11 <- df_as09[df_as09$eval03=="eDNA detected",]
df_as11 <- df_as09[!df_as09$eval03=="failed test",]
#unique(df_as11$eval03)
# -------- make data for date labels  ------- 

refdates <- c("2022-03-01","2022-05-01","2022-07-01","2022-09-01","2022-10-01")
refdates <- as_date(refdates)

df_labels <- data.frame(date=refdates)  %>%
  mutate(dayno=yday(date),
         datelabel=format(date, format = "%d-%b")) %>%
  mutate(x0=0.52) 

# -------- plot  1 ------- 

# different colours for each period
pal_period <- c("#fcb900", "#827717") 
# set day interval for geom_tile
dayinterval = 1 
# replace the matches with 'lessonae'
df_as11$latspc2[grepl("lessonae",df_as11$latspc2)] <- "Pelophylax sp"
#unique(df_as11$latspc2)
# Get evaluation categories
eval03.1 <- df_as11$eval03
# make it a factor
eval03.1 <- as.factor(eval03.1) 
# get unique categories
eval03.cat <- unique(eval03.1)
# set colors for categories of eDNA evaluations
colsfeval <- c("white","springgreen3")
#bind together as columns in a data frame
df_colsfeval<- cbind.data.frame(eval03.cat,colsfeval)
# use this data frame to look up the colors for the eDNA evaluations
eval03.col<- df_colsfeval$colsfeval[match(eval03.1,df_colsfeval$eval03.cat)]
# get unique period names
perNm2 <- as.factor(unique(df_tile3$periodName))
# start the ggplot
plt13 <- ggplot(df_as11, aes(x=latspc2, y=dayno)) +
  # alpha indicates the tiled values from normal distributions
  # add the faded color tiles underneath for the periods
  geom_tile(data=df_tile3,aes(width=0.85,height=dayinterval,fill=periodName,alpha=n), 
            position=position_nudge(x=-0.05), show.legend=F) +
  # add points, fill them by the factor defined above
  geom_point(data=df_as11,aes(fill=eval03),position=position_jitter(width=0.2, height=0.1),
             #size=3, shape=21,fill=NA,colour="#000000",alpha=0.9) +
             size=5, shape=21,colour="#000000",alpha=0.6) +
  # add boxplot
  #geom_boxplot(outlier.colour=NA, fill=NA, width=0.65)  +
  
  scale_alpha_continuous(range=c(0,0.9)) +
  # set the color range manually -  comprised from two vectors
  # one vector for the periods and one for the points
  scale_fill_manual("test sets with", 
                    breaks = c(as.character( c(perNm2,eval03.cat))),
                    values=c(pal_period,colsfeval)) +
  # transpose the coordinate system -i.e. make the x-axis the y-axis
  coord_flip() +
  # use 'theme_classic()' to get a plain white nbackground on the plot
  # notice that using 'theme_classic()' nullifies setting 'fac'face = "italic"'
  # under 'theme' -  which is why it is placed here above 'theme'
  theme_classic() +
  # make the species names along the axis italic
  theme(axis.text.y = element_text(angle = 0, hjust = 1, face = "italic", size=12)) +
  theme(axis.text.x = element_text(angle = 0, size=12)) +
  # reverse the order of categories on the discrete scale
  # https://stackoverflow.com/questions/28391850/reverse-order-of-discrete-y-axis-in-ggplot2
  # reverse the categories
  scale_x_discrete(limits=rev) +
  scale_y_continuous(limits=c(60,280)) +
  #change axis labels
  xlab("") + 
  #xlab("species") + 
  ylab("day number of the year") +
  #getting separate legends
  labs(fill='test sets with') +
  labs(shape='period names') +
  # labs(color='test sets with') +
  # add stipled vertical line for dates 
  geom_hline(data=df_labels,
             aes(yintercept=dayno),
             colour="#795548",linetype=2) + 
  # add labels for dates
  geom_text(data=df_labels,
            aes(x=x0+0.2,y=dayno+2,label=datelabel),
            hjust=0,vjust=1, size=4)
#see the plot
plt13
#

figname13A <- paste0("Fig04_04_",fnm02,"_time_period_aquatic.png")
# save plot
if(bSaveFigures==T){
  ggsave(plt13,file=figname13A,width=210*1.6,height=297*0.8,
         units="mm",dpi=300)
}
#_______________________________________________________________________________
# make another plot but only including 'eDNA detected'
#_______________________________________________________________________________

# subset data frame
df_as11 <- df_as09[df_as09$eval03=="eDNA detected",]
#df_as11 <- df_as09[!df_as09$eval03=="failed test",]
# replace the matches with 'lessonae'
df_as11$latspc2[grepl("lessonae",df_as11$latspc2)] <- "Pelophylax sp"

#unique(df_as11$eval03)
# -------- make data for date labels  ------- 

refdates <- c("2022-03-01","2022-05-01","2022-07-01","2022-09-01","2022-10-01")
refdates <- as_date(refdates)

df_labels <- data.frame(date=refdates)  %>%
  mutate(dayno=yday(date),
         datelabel=format(date, format = "%d-%b")) %>%
  mutate(x0=0.52) 

# -------- plot  1 ------- 

# different colours for each period
pal_period <- c("#fcb900", "#827717") 
# set day interval for geom_tile
dayinterval = 1 

# Get evaluation categories
eval03.1 <- df_as11$eval03
# make it a factor
eval03.1 <- as.factor(eval03.1) 
# get unique categories
eval03.cat <- unique(eval03.1)
# set colors for categories of eDNA evaluations
colsfeval <- c("white","springgreen3")
colsfeval <- c("springgreen3")
#bind together as columns in a data frame
df_colsfeval<- cbind.data.frame(eval03.cat,colsfeval)
# use this data frame to look up the colors for the eDNA evaluations
eval03.col<- df_colsfeval$colsfeval[match(eval03.1,df_colsfeval$eval03.cat)]
# get unique period names
perNm2 <- as.factor(unique(df_tile3$periodName))
# start the ggplot
plt13 <- ggplot(df_as11, aes(x=latspc2, y=dayno)) +
  # alpha indicates the tiled values from normal distributions
  # add the faded color tiles underneath for the periods
  geom_tile(data=df_tile3,aes(width=0.85,height=dayinterval,fill=periodName,alpha=n), 
            position=position_nudge(x=-0.05), show.legend=F) +
  # add points, fill them by the factor defined above
  geom_point(data=df_as11,aes(fill=eval03),position=position_jitter(width=0.2, height=0.1),
             #size=3, shape=21,fill=NA,colour="#000000",alpha=0.9) +
             size=5, shape=21,colour="#000000",alpha=0.6) +
  # add boxplot
  geom_boxplot(outlier.colour=NA, fill=NA, width=0.65)  +
  
  scale_alpha_continuous(range=c(0,0.9)) +
  # set the color range manually -  comprised from two vectors
  # one vector for the periods and one for the points
  scale_fill_manual("test sets with", 
                    breaks = c(as.character( c(perNm2,eval03.cat))),
                    values=c(pal_period,colsfeval)) +
  # transpose the coordinate system -i.e. make the x-axis the y-axis
  coord_flip() +
  # use 'theme_classic()' to get a plain white nbackground on the plot
  # notice that using 'theme_classic()' nullifies setting 'fac'face = "italic"'
  # under 'theme' -  which is why it is placed here above 'theme'
  theme_classic() +
  # make the species names along the axis italic
  theme(axis.text.y = element_text(angle = 0, hjust = 1, face = "italic", size=12)) +
  theme(axis.text.x = element_text(angle = 0, size=12)) +
  # reverse the order of categories on the discrete scale
  # https://stackoverflow.com/questions/28391850/reverse-order-of-discrete-y-axis-in-ggplot2
  # reverse the categories
  scale_x_discrete(limits=rev) +
  scale_y_continuous(limits=c(60,280)) +
  #change axis labels
  xlab("") + 
  #xlab("species") + 
  ylab("day number of the year") +
  #getting separate legends
  labs(fill='test sets with') +
  labs(shape='period names') +
  # labs(color='test sets with') +
  # add stipled vertical line for dates 
  geom_hline(data=df_labels,
             aes(yintercept=dayno),
             colour="#795548",linetype=2) + 
  # add labels for dates
  geom_text(data=df_labels,
            aes(x=x0+0.2,y=dayno+2,label=datelabel),
            hjust=0,vjust=1, size=4)
#see the plot
plt13
#

figname13A <- paste0("Fig04_05_",fnm02,"_time_period_aquatic.png")
# save plot
if(bSaveFigures==T){
  ggsave(plt13,file=figname13A,width=210*1.6,height=297*0.8,
         units="mm",dpi=300)
}
#_______________________________________________________________________________
# start is the lake area sampled normally distributed ?
#_______________________________________________________________________________
# log transform area of the water bodies sampled
l10_lA <- log10(df_as11$Areal_m2)
hist(l10_lA)
# get inspiration here: http://www.sthda.com/english/wiki/normality-test-in-r
library(ggpubr)
ggqqplot(l10_lA)
shapiro.test(l10_lA)
SWt_lake <- shapiro.test(l10_lA)
ifelse(SWt_lake$p.value  > 0.05,"we can assume the normality","do not assume the normality")

#From the output, the p-value > 0.05 implying that the distribution of 
#the data are not significantly different from normal distribution. 
#In other words, we can assume the normality.
#_______________________________________________________________________________
# end is the lake area sampled normally distributed ?
#_______________________________________________________________________________

#_______________________________________________________________________________
# start is the day number sampled normally distributed ?
#_______________________________________________________________________________

hist(df_as11$dayno)
ggqqplot(df_as11$dayno)
SWt_day <- shapiro.test(df_as11$dayno)
ifelse(SWt_day$p.value  > 0.05,"we can assume the normality","do not assume the normality")
# 
#_______________________________________________________________________________
# end is the day number sampled normally distributed ?
#_______________________________________________________________________________
