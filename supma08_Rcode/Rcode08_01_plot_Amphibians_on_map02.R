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
#
#This code is able to run in:
# #
# platform       x86_64-pc-linux-gnu         
# arch           x86_64                      
# os             linux-gnu                   
# system         x86_64, linux-gnu           
# status                                     
# major          4                           
# minor          0.2                         
# year           2020                        
# month          06                          
# day            22                          
# svn rev        78730                       
# language       R                           
# version.string R version 4.0.2 (2020-06-22)
# nickname       Taking Off Again

#____________________________________________________________________________#

#____________________________________________________________________________#
# in Finder on Macintosh connect to
# https://webfile.science.ku.dk/webdav
#
#Locate MxPro files in:
#I:\SCIENCE-SNM-ZMDISK\5. FORMIDLINGSAFDELING\DNA & LIV\Data\qPCR resultater\MxPro_tekstfiler

#copy to your own computer
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

#remove everything in the working environment, without a warning!!
#rm(list=ls())

# set working directory
#wd00 <- "/home/hal9000/MS_amphibia_eDNA"
wd00 <- "/home/hal9000/Documents/Documents/MS_amphibian_eDNA_assays/MS_suppm_amphibia_eDNA"
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
names(dkspecs_to_latspecs)
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


#paste path and file together
wd00_wd03_inpf03 <- paste(wd00_wd03,"/DNAogLiv_Proever_1-9-2020.xls",sep="")
# read in the excel file
ha <- as.data.frame(read_excel(wd00_wd03_inpf03))
#change column names
colnames(ha) <- ha[1,]
hb <- (ha[-1,])
head(hb,4)
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
  Area_wt_coll_loc
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
unmtch.harb03 <- c("Solbjerg/Stilling_Soe", "Boelle_Soe", "Pouls_Smeds_Mose", "Vejby_Overdrev_vandhul", "Krobaek_Tappernoeje", "Gentofte_Soe", "Tubaek_Praestoe", "Lille_privat_soe_oelsted", "Gymnasiesoeen_Alleroed", "Alleroed_Soe", "Hyrdehoej_Skov_soe", "Boendernes_Egehoved", "Horsekaer_Tisvilde_Hegn", "Beiths_Vaenge_Hjoerring", "Kong_oeres_Grav", "Arresoe_Kanal", "Kildevaeld_naer_Mordal_Mariager_Fjord", "Utterslev_Mose", "Farum_Overdrev_soe", "Soroe", "Skensved_aa", "Moellesoe_Gjorslev", "Lillesoe_Skanderborg", "?", "Alleroed_gymnasie_regnvandsbassin", "Alleroed/lilleroed", "aasenKoege", "Avnsoe", "Birkeroed", "Birkeroed_Soe", "Boellemosen_Skodsborg", "Boellesoe_Saerloese_overdrev_Hvalsoe", "Borupgaard_Gymnasium_lille_soe", "Boestrup_aa", "Bringe_Mose_Flyvestation_Vaerloese", "Bruunshaab_Moelleaa", "Dam_v_Helsingoer_Elforsyning", "Davinde_soe", "Digterparken_Ballerup", "Dumpedalen_vandhul", "Dumpedalen_Birkeroed", "Dybesoe", "Egebaeksvang", "Egebaeksvang_Soe", "Ejby_Mose", "Ellesoeen", "Ellesoeen_GlKoege_Gaard", "Emdrup_Soe", "Frederiksberg_Have", "Frederiksvaerk", "Fuglesangssoe", "Furesoe", "Furesoe_Soe", "Furesoeen", "Furesoeen_Frederiksdal_Fribad", "Gentofte_Soe_ved_badebro", "Grevinge_Soe", "Grindsted_aadal", "Grindsted_Engsoe", "Grindsted_Langsoe", "Gurre_Soe_Nordsjaelland", "Hakkemosen", "Hampen_soe", "Harrestrup_aa_v_Vigerslev_Allé", "Himmelev_Baek_opdaemmet_soe_ved_RUC", "Himmelev_Grusgrav", "Holtug_Kridtbrud", "Hornbaek_soe", "Hvidehusvej_Alleroed", "Ishoej_Soepark", "Karlstrup_Kalkgrav_Solroed", "Kastrupfortet", "Kobberdammen_Hellebaek", "Koege_aa", "Koege_aas", "Kragemosen_Samsoe_nord", "Kvaerkeby_Mose_karpesoe", "Kvaerkeby_Mose_store_soe", "Lille_Fuglsoe_oesteraadal", "Lustrup_faellesjord_1", "Lustrup_faellesjord_2", "Lustrup_faellesjord_3", "Lyngby_soe", "Maglesoe", "Maaloev", "Marielundssoeen_Kolding", "Mlm_Hakkemosemosevej_og_Lervangen", "Moelholm_Soe_Norholmsvej_55_Aalborg", "Moelleaaen_ved_Frederiksdal_Friluftsbad", "Moelleaaen_v_Sorgenfri_Slotspark", "Moellesoe_v_Virket", "Odense_aa", "Odense_aa_ved_Stryget_Munke_Mose", "oestermosen_Femoe", "oestre_Anlaeg", "oetoftegaardsvej_Taastrup", "Poul_Smedes_mose_Svendborg", "Poul_Smeds_Mose", "Raadvad_Dam_Moelleaaen", "Regnvandsbassinet", "Roededam_Gribskov", "Roermose_Alleroed", "Roermosen_Karlslunde", "Sankt_Joergens_Soe", "Schweizersoeen", "Sejlsbjerg_Mose", "Sjaelsoe_ved_skovhytten", "Skanderborg_Soe_Vestermoelle", "Smoerhullet_Kulsbjerg_Stensved", "Sneglehoej_soe", "Soe_i_Faelledparken", "Soe_vGreve_Gym", "Soe_vStenhus_gym_Busstoppested", "Soeen_v_Ringstedvej", "Soendervang_Vandhul", "Soeren_Hvidehusvej_Alleroed", "Soroe_Soe_baadbro_ved_Soero_akedemi", "Store_Gribsoe", "Store_Hoej_Soeen", "Store_Kattinge_soe_naer_fugletaarn_ved_Boserupvej", "Store_vejle_aa", "Svanemoellen_Havn", "Tingvej_Soe", "Tranemosen", "Tranemosen_Frederiksvaerk", "Troldsoe", "Uglebrovej_6_Helsinge", "Valleroed_Gadekaer", "Valleroed_gadekaer", "Vandet_Soe", "Vandhul_v_Baunebovej_1_Haarlev", "Vandhul_v_Kikhanerende", "Vandhul_aasen_Koege", "Vejle_aa", "Vestre_Kirkegaardssoe_Valby", "Vordingborg_Voldgrav", "Zahrtmannsvej_Soe_Roenne_Bornholm", "Alleroed_Soepark", "Botanisk_have_dam", "Botanisk_have_Soe", "Bregninge_vandhul", "Nyhaandsbaek_ved_Busemarke_mose_og_soe", "Boesoere_strand_feriepark", "Hammersoeen_Bornholm", "Herthadalen", "Hoejsagersred_Boesoere", "Mikkels_foraeldres_havebassin_Klintholm_Moen", "Kongshoej_Moellesoe_Kongshoej_aa", "Lovns_soe", "Poelsekedlen/Borgesoeen", "Ringsoeen", "Brassoe", "Stauvrebjerg_Soe_Moen", "Soendergaards_Alle_Soe", "Groennelyng_Soeer_i_Nordskoven", "Tystrup_soe", "oerslev_Kloster_Soe", "aaremyre", "Uglebjerg_Langoe_Fyn", "Tvaersted_Soe", "Sofieholm_soe_Brorfelde", "Vandhul_ved_Observator_Gyldenkernes_Vej_Brorfelde", "Store_Hareskov", "Vesterled_Soe", "Boelling_Soe", "Salten_Langsoe", "Kalgaard_Soe", "oernsoe", "Soroe_Soe", "Kongskilde_Moellesoe/Skaelskoer_soe", "Tystrup_Soe", "Soetorup_Soe", "Ulse_Soe", "Ejlemade_Soe", "Sjaelsoe", "Lillesoevej_1", "Rude_Soe", "Furesoe_1", "Furesoe_2", "Bagsvaerd_Soe", "Lyngby_Soe", "Lillesoevej_2", "Paddesoeen_Maaloev_Naturpark", "Botanisk_Have_Soe", "Bastrup_soe", "Soender_soe", "Degnemosen", "Langedam", "Soendersoe_Maribosoeerne", "Skallemose_Soe_Maaloev", "Haraldsted_soe", "Kongeaa_Vamdrup", "Sumpomraade_v_Barup_soe_nordfalster", "Vandhul_ved_Taagensegaard__Lolland", "Gundsoemagle_soe", "Farum_soe", "Guldbjerg_Mose", "Buresoe", "Vandhul_Spang_Vade", "Myremosen_Nivaa", "Svingelsoeen_Nakskov", "Esrum_Soe", "Vejstrup_aa_Svendborg", "Vandhul_Helsinge", "Draenaa_Helsinge", "Tryggevaelde_aa", "Sandskredssoeen_Gribskov", "Tvorup_Hul", "Brede_aa", "Vaserne_oest", "Vaserne_vest", "Vaserne_rende", "Hejrede_Soe", "Frederiksborg_Slotssoe", "Fegen_soe_Sverige", "Anholt", "Langoe_Fyn", "Moellevej_Jyderup", "Halleby_aa_udloeb_i_Tissoe", "Hejresoeen_Amager_Faelled", "Nihoeje_soe_Sydamager_naturreservat", "Hoejbjerghus_Soeen", "Paradis_Soeen", "NA", "BM", "Militaersoe_Vordingborg_Kaserne", "Nuuk_fjord", "Arresoe_Kanal_Frederiksvaerk", "Sortedam_Soe_i_Hilleroed", "Soendersoe", "Peblingesoe_Soe_i_Koebenhavn_N", "Moellesoeen", "Praestbjerg_Soe_Fuglkaer_aa", "Karlstrup_Kalkgrav_Soe_i_Karlslunde", "Tissoe_Soe", "Frederiksvaerk_kanal/Arresoe_kanal", "Soe_ved_Rosborg_Gymnasium", "Vandhul_ved_Skovsgaard", "Vandhul_bag_tennisbanerne", "Sortedams_Soe_Soe_i_Koebenhavn_oe", "Brobaek_Mose", "Vandhul_i_Hoerret_skov", "Vandhul_ved_Klintholm", "Lundby_Dam", "Brobaek_Mose_Mose_i_Gentofte", "Nykoebing_Katedralskoles_Vandhul", "Kastrup_Fortet", "Borupgaard_Gymnasium_Soe", "Kulsbjerg_oevelsesplads", "Lustrup_Faellesjord", "Gurre_Soe_Soe_i_Tikoeb", "Pistolsoeen", "Kvaerkeby_Fuglereservat", "Gaekkaer_Bakke_vandhul", "Sejlbjerg_Mose", "oestre_Anlaeg_naturareal_/_Park", "Sundby_Soe", "Toggerup_Enghave_oevre_dam", "Toggerup_Enghave_Nedre_dam", "Kokkedal_moellesoe", "Sct_Joergens_soe", "Branddam", "Holmegaards_Mose_naturareal_/_Mose", "Boellemosen_Soe_i_Naerum", "Brede_dam_Hilleroed", "Herregaardsvej_vandhul", "Skuldelev_grusgrav", "Paradissoeerne_oest", "Ulvshale", "Roneklint_Stevs", "Skovfogedmosen_Brorfelde_Observatorium", "Trekroner_Soe_Soe_i_Roskilde", "Kloevergaard_Soe", "Hulsoe_Eskildstrup", "Store_Hoej_soe", "Ellemosen_Park_i_Charlottenlund", "Tronsoe_Soe_i_Grindsted", "Registerstien_Soe", "Kvottrup_Skov", "Kvottrup_skov", "Valby_parken_soe_v_Tudsemindevej", "Valby_Parken_soe_vTudsemindevej", "Regnvandsbassin", "Lille_soe_i_Store_Hareskov", "Soe_i_Hareskoven", "Utterslev_Mose_vest", "Utterslev_mose_vest", "Arresoe_Soe_i_Frederiksvaerk", "Dam_ved_Store_Taarn_Christiansoe", "Skanderborg_Soe_Soe_i_Skanderborg", "Koege_havn", "Porskaer_ved_Gudenaaen", "aarhus_Havn_oestmolen", "Helsingoer_havn", "Beddingen_Aalborg", "Koebenhavns_Havn", "Hirsthals_Havn", "Nordhavn_skudehavn", "Aarhus_Havn_bassin_3", "AQUAFerskvands_Akvariet_Silkeborg", "Lyngby_Soe_Soe_i_Kongens_Lyngby", "Moellekaer_Skov_i_Aabenraa", "Moesgaard_Museum_Museum_i_Hoejbjerg", "Blidsoe_Soe_i_Skanderborg", "Refsvindinge_by_i_oerbaek", "Danmark", "Sjoerup_by_i_Viborg", "aarhus_aa_aabyhoej", "EGSoeen", "EGsoeen", "Skanderborg_soe", "Remasoe", "Kolding_lystbaadhavn_syd", "Kolding_lystbaadehavn_syd", "Nordhavn_Koebenhavn", "Attup_havn", "Attrup_Havn_Lystbaadehavn_i_Brovst", "Gjoel_Havn", "Noerresundby_Havn", "Lemvig_Havn", "Struer_Havn", "Svendborg_Lystbaadehavn", "Aarhus_Havn", "Svendborg_Havn", "Soe_vTornby__Raevskaer_strand", "Grenaa_Industrihavn", "Grenaa_Lystbaadehavn", "Nibe_Havn", "Skudehavnen", "Aalborg_Havn_Krydstogtkajen", "Aabenraa_Lystbaadehavn", "Aabenraa_Industrihavn", "Aabenraa_Havn", "aarhus_havn_DOKK1_Bassin_1", "aarhus_havn_DOKK1__bassin_1", "Bryggen_Koebenhavn", "Marselisborg_havn_Aarhus", "Skive_havn", "Skive_Havn", "Islands_Brygge", "Dokk_1", "Kalundborg_Havn")
unmtch.harb04 <- c("NA", "NA", "NA", "NA", "NA", "NE_Sjaelland", "NA", "NA", "NE_Sjaelland", "NE_Sjaelland", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "Koebenhavn", "NE_Sjaelland", "NA", "Koege", "NA", "Skanderborg", "NA", "NE_Sjaelland", "NE_Sjaelland", "Koege", "NA", "NE_Sjaelland", "NE_Sjaelland", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "Koebenhavn", "NA", "NA", "NA", "NA", "NA", "NA", "NE_Sjaelland", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "Koege", "Koege", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "Koebenhavn", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "Fyn", "Fyn", "NA", "NA", "Koebenhavn", "Fyn", "Fyn", "NA", "NA", "NA", "NE_Sjaelland", "NA", "Koebenhavn", "NA", "NA", "NA", "Skanderborg", "NA", "NA", "Koebenhavn", "Koege", "NA", "NA", "NA", "NE_Sjaelland", "Soroe", "NA", "NA", "NA", "Vejle", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "Koege", "Vejle", "Koebenhavn", "Vordingborg", "Bornholm", "NE_Sjaelland", "Koebenhavn", "Koebenhavn", "NA", "NA", "NA", "NA", "NA", "NA", "Moen", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "Koebenhavn", "Koebenhavn", "NA", "NA", "NA", "NA", "NA", "Greenland", "NE_Sjaelland", "Hilleroed", "NA", "Koebenhavn", "NA", "NA", "Koege", "NA", "NA", "NA", "NA", "NA", "Koebenhavn", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NE_Sjaelland", "Koebenhavn", "NA", "NA", "NA", "Hilleroed", "NA", "NE_Sjaelland", "NA", "Moen", "NA", "Holbaek", "Roskilde", "Esbjerg", "Falster", "NA", "NE_Sjaelland", "NA", "NA", "Aarhus", "Aarhus", "Koebenhavn", "Koebenhavn", "NA", "NE_Sjaelland", "NE_Sjaelland", "Koebenhavn", "Koebenhavn", "NE_Sjaelland", "Bornholm", "Skanderborg", "Koege", "Vejle", "Aarhus", "Helsingoer", "Aalborg", "Koebenhavn", "Hirtshals", "Koebenhavn", "Aarhus", "Silkeborg", "NE_Sjaelland", "Aabenraa", "Aarhus", "Skanderborg", "Fyn", "NA", "Viborg", "Aarhus", "NA", "NA", "Skanderborg", "NA", "Kolding", "Kolding", "Koebenhavn", "Nibe", "Nibe", "Aalborg", "Aalborg", "Lemvig", "Struer", "Fyn", "Aarhus", "Fyn", "NA", "Grenaa", "Grenaa", "Aalborg", "NA", "Aalborg", "Aabenraa", "Aabenraa", "Aabenraa", "Aarhus", "Aarhus", "Koebenhavn", "Aarhus", "Skive", "Skive", "NE_Sjaelland", "NA", "NW_Sjaelland")

unmtch.harb05 <- t(data.frame(
  unmtch.harb03,
  unmtch.harb04
))
unmtch.harb05 <- as.data.frame(t(unmtch.harb05))


#see the matched locations
hc3 <- hc[ which(!is.na(hc$Harbour2)), ]
unique(hc3[,"Area_wt_coll_loc"])

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
unique(hc5[,"Area_wt_coll_loc"])

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
getwd()

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

#z <- colnames(smpls)

#z[1]

#length (colnames(smpls))
head (smpls)
#replace blank fields with 'koerselno1'
#see how to on this website : https://stackoverflow.com/questions/21243588/replace-blank-cells-with-character
smpls$koerselno <- sub("^$", "koerselno1", smpls$koerselno)
#paste a new column based on variables separated by point
smpls$spec.repl.rund.DLno.koerselno <- paste(smpls$specs,smpls$replno,smpls$qpcrrundate,smpls$DLsamplno,smpls$koerselno,  sep=".")



# set working directory
setwd (wd00)
getwd()

#paste together directory paths
wd00_wd09 <- paste(wd00,wd09, sep="")
# set working directory
setwd (wd00_wd09)
getwd()

# filter for unique combination of columns from a dataframe
spl1 <- unique(smpls[,c('specs','replno','qpcrrundate','DLsamplno','koerselno','spec.repl.rund.DLno.koerselno')])
#make a dataframe with gymn names
spl1_gymnnm <- unique(smpls[,c('qpcrrundate','DLsamplno','gymnasiumnm1')])
#reorder by species, then by rundate and then by replno
#although not necessary for the subsequent matching operation, but it makes it easier to check
#that all replicates are matched up correctly
spl2 <- spl1[ order(spl1$specs, spl1$qpcrrundate, spl1$replno, spl1$koerselno), ]

#see the column names
names(spl2)
names(smpls)

#make subsets of the smpls dataframe based on Welltype
ed_smplsNPC <- subset(smpls, WellType == "NPC", select = c("spec.repl.rund.DLno.koerselno","CtdRn"))
ed_smplsNTC <- subset(smpls, WellType == "NTC", select = c("spec.repl.rund.DLno.koerselno","CtdRn"))
ed_smplsunk <- subset(smpls, WellType == "Unknown", select = c("spec.repl.rund.DLno.koerselno","WellType", "CtdRn"))

#Add a variable showing the number of observations that have the same value recorded earlier
# see this website: https://stackoverflow.com/questions/11957205/how-can-i-derive-a-variable-in-r-showing-the-number-of-observations-that-have-th
#add a column for counting
ed_smplsunk$count <- 1
#count the numbers as described in this question:
ed_smplsunk <- ddply(ed_smplsunk, .(spec.repl.rund.DLno.koerselno), transform, count=cumsum(count))
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

#match the latin species name w the Danish common name 
spl3$latspc <- dkspecs_to_latspecs$Species_Latin[match(spl3$specs,dkspecs_to_latspecs$Species_DK)]
#match the abbreviated latin name w the Danish name
spl3$abbr.nm <- dkspecs_to_latspecs$abbr.nm[match(spl3$specs,dkspecs_to_latspecs$Species_DK)]
#match the harbour w the DL_sampl no 
spl3$rg.wtsmplloc <- harbours$rg.wtsmplloc[match(spl3$DLsamplno,harbours$DL_No)]
names(spl3)
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
ct.cutoff=41
#ct.cutoff=50
#ct.cutoff=37

#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# Plot single capture locations - start
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
#remove NAs from vector
latspecnm <- latspecnm[!is.na(latspecnm)]

#latspecnm <- "Gadus_morhua"
#latspecnm <- "Anguilla_anguilla"
#latspecnm <- "Scomber_scombrus"
#latspecnm <- "Clupea_harengus"
#latspecnm <- "Eriocheir_sinensis"
#latspecnm <- "Eriocheir_sinensis"
#latspecnm <- "Mya_arenaria"
#latspecnm <- "Bufo_bufo"
#latspecnm <- "Ichthyosaurus_alpestris"

#delete selected species from list that holds no data
# latspecnm2 <- latspecnm[!latspecnm %in% "Perca_fluviatilis"]
# latspecnm2 <- latspecnm2[!latspecnm2 %in% "Homarus_americanus"]
# latspecnm2 <- latspecnm2[!latspecnm2 %in% "Anguilla_anguilla"]
# latspecnm2 <- latspecnm2[!latspecnm2 %in% "Paralithodes_camtschaticus"]
# latspecnm2 <- latspecnm2[!latspecnm2 %in% "Eriocheir_sinensis"]
# latspecnm2 <- latspecnm2[!latspecnm2 %in% "Scomber_scombrus"]
# latspecnm2 <- latspecnm2[!latspecnm2 %in% "Rhithropanopeus_harrisii"]
# latspecnm2 <- latspecnm2[!latspecnm2 %in% "Oncorhynchus_gorbuscha"]
# latspecnm2 <- latspecnm2[!latspecnm2 %in% "Pleuronectes_platessa"]
# latspecnm2 <- latspecnm2[!latspecnm2 %in% "Mya_arenaria"]
# latspecnm2 <- latspecnm2[!latspecnm2 %in% "Clupea_harengus"]
# latspecnm2 <- latspecnm2[!latspecnm2 %in% "Platichthys_flesus"]
# latspecnm2 <- latspecnm2[!latspecnm2 %in% "Crassostrea_gigas"]
# latspecnm2 <- latspecnm2[!latspecnm2 %in% "Gadus_morhua"]
# 
# latspecnm <- latspecnm2

#latspecnm <- "Clupea_harengus"

# loop over all species names in the unique list of species, and make plots. 
#Notice that the curly bracket ends after the pdf file is closed
for (spec.lat in latspecnm){
  #print(spec.lat)
  #}
  
  #get the Danish commom name
  sbs.dk.nm <- dkspecs_to_latspecs$Species_DK[match(spec.lat, dkspecs_to_latspecs$Species_Latin)]
  #subset based on variable values, subset by species name
  sbs.spl3 <- spl3[ which(spl3$latspc==spec.lat), ]
  
  #count using the plyr-package - see: https://www.miskatonic.org/2012/09/24/counting-and-aggregating-r/
  sbs.tot_smpl <- count(sbs.spl3, c("DLsamplno","dec_lon", "dec_lat"))
  
  #subset based on variable values - see: https://stackoverflow.com/questions/4935479/how-to-combine-multiple-conditions-to-subset-a-data-frame-using-or
  # subset by when NTC is equal to NoCt and NPC is below ct.cut.off, and or NTC is equal to zero
  sbs.spl3.ntc_npc_approv <- sbs.spl3[ which(sbs.spl3$NTC.CtdRn=='NoCt' & sbs.spl3$NPC.CtdRn<=ct.cutoff
  ), ]
  #count using the plyr-package
  sbs.approvK_smpl <- count(sbs.spl3.ntc_npc_approv, c("DLsamplno"))
  
  #subset based on variable values
  # subset among the NPC and NTC approved replicate sets
  #subset by when repl1 is below ct.cut.off and/or  when repl2 is below ct.cut.off
  sbs.spl3.1or2pf <- sbs.spl3.ntc_npc_approv[ which(sbs.spl3.ntc_npc_approv$unkn1.CtdRn<=ct.cutoff 
                                                    | sbs.spl3.ntc_npc_approv$unkn2.CtdRn<=ct.cutoff
                                                    & !sbs.spl3.ntc_npc_approv$unkn1.CtdRn==0
                                                    & !sbs.spl3.ntc_npc_approv$unkn2.CtdRn==0), ]
  #count using the plyr-package
  sbs.1or2pos.smpl <- count(sbs.spl3.1or2pf, c("DLsamplno"))
  
  # subset among the NPC and NTC approved replicate sets with either 1 or 2 positive replicates
  #subset by when both repl1 is below ct.cut.off and when repl2 is below ct.cut.off
  sbs.spl3.2pf <- sbs.spl3.1or2pf[ which(sbs.spl3.1or2pf$unkn1.CtdRn<=ct.cutoff 
                                         & sbs.spl3.1or2pf$unkn2.CtdRn<=ct.cutoff), ]
  #count using the plyr-package
  sbs.2pos.smpl <- count(sbs.spl3.2pf, c("DLsamplno"))
  
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
  pdf(c(paste("plot_pies_edna_gymnasieundervisning.singl_pts_",spec.lat,"_wct",ct.cutoff,".pdf",  sep = ""))
      ,width=(1.6*8.2677),height=(1.6*2.9232*2))
  
  
  #factors to multiply radius on each pie
  fct1 <- 1.000 
  fct2 <- 0.08
  
  #plot map #http://www.milanor.net/blog/maps-in-r-plotting-data-points-on-a-map/
  library(rworldmap)
  newmap <- getMap(resolution = "high")
  plot(newmap, xlim = c(8, 16), ylim = c(54, 58), asp = 1)
  
  #plot land on map
  map('worldHires', add=TRUE, fill=TRUE, 
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
  dev.off()
  #below is the end of the loop initiated above
}


#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# Plot single capture locations - end
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

#count using the plyr-package - see: https://www.miskatonic.org/2012/09/24/counting-and-aggregating-r/
tot_smpl <- count(spl3, c("DLsamplno","dec_lon", "dec_lat","abbr.nm", "specs","latspc" ))#,
                          # "NPC.CtdRn", "NTC.CtdRn", "unkn1.CtdRn",
                          # "unkn2.CtdRn", "unkn3.CtdRn", "unkn4.CtdRn"))

#subset based on variable values - see: https://stackoverflow.com/questions/4935479/how-to-combine-multiple-conditions-to-subset-a-data-frame-using-or
# subset by when NTC is equal to NoCt and NPC is below ct.cut.off, and or NTC is equal to zero
spl3.ntc_npc_approv <- spl3[ which(spl3$NTC.CtdRn=='NoCt' & 
                        spl3$NPC.CtdRn<=ct.cutoff
), ]
#count using the plyr-package
approvK_smpl <- count(spl3.ntc_npc_approv, c("DLsamplno","abbr.nm"))


#subset based on variable values
# subset among the NPC and NTC approved replicate sets
#subset by when repl1 is below ct.cut.off and/or  when repl2 is below ct.cut.off
spl3.1or2pf <- spl3.ntc_npc_approv[ which(spl3.ntc_npc_approv$unkn1.CtdRn<=ct.cutoff 
                                          | spl3.ntc_npc_approv$unkn2.CtdRn<=ct.cutoff
                                          & !spl3.ntc_npc_approv$unkn1.CtdRn==0
                                          & !spl3.ntc_npc_approv$unkn2.CtdRn==0), ]


#count using the plyr-package
r1orr2pos.smpl <- count(spl3.1or2pf, c("DLsamplno", "abbr.nm"))
# subset among the NPC and NTC approved replicate sets with either 1 or 2 positive replicates
#subset by when both repl1 is below ct.cut.off and when repl2 is below ct.cut.off
spl3.2pf <- spl3.1or2pf[ which(spl3.1or2pf$unkn1.CtdRn<=ct.cutoff 
                               & spl3.1or2pf$unkn2.CtdRn<=ct.cutoff), ]
#count using the plyr-package
r2pos.smpl <- count(spl3.2pf, c("DLsamplno", "abbr.nm"))

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
head(approvK_smpl,4)
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
tot_smpl[,"eval02"] <- NA
tot_smpl$eval02[   tot_smpl$truezerodetect >= 1] <- "blue" #0  
tot_smpl$eval02[   tot_smpl$nonapprovK >= 1] <- "red" #0  
tot_smpl$eval02[   tot_smpl$repl1or2 >= 1] <- "green" #0  
tot_smpl$eval02[   tot_smpl$repl2pos >= 1] <- "darkgreen" #0

#subset data frame to match only approved K
#tot_smpl02_df<- subset(tot_smpl, nonapprovK==0)
tot_smpl02_df <- tot_smpl

#subset to only include amphibian species
amph_smpl02_df <- subset(tot_smpl02_df, 
                         abbr.nm=="Bom.bom" |
                           abbr.nm=="Buf.buf" |
                           abbr.nm=="Buf.cal" |
                           abbr.nm=="Buf.vir" |
                           abbr.nm=="Hyl.arb" |
                           abbr.nm=="Ich.alp" |
                           abbr.nm=="Lis.vul" |
                           abbr.nm=="Pel.fus" |
                           abbr.nm=="Pel.rid" |
                           abbr.nm=="Ran.arv" |
                           abbr.nm=="Ran.dal" |
                           abbr.nm=="Ran.les" |
                           abbr.nm=="Ran.tem" |
                           abbr.nm=="Tri.cri")


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
world <- ne_countries(scale = 10, returnclass = "sf")
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
#subset to exclude all NonApproved controls
amph_smpl04_df <- amph_smpl03_df[amph_smpl03_df$nonapprovK==0, ]
tot_smpl03_df <- tot_smpl[tot_smpl$nonapprovK==0, ]
#head(amph_smpl03_df,7)
#subset to only include positive detections
amph_smpl05_df <- amph_smpl04_df[amph_smpl04_df$repl1or2>0, ]
tot_smpl04_df <- tot_smpl03_df[tot_smpl03_df$repl1or2>0, ]
#amph_smpl05_df
#amph_smpl03_df <- subset(amph_smpl03_df, eval01=="repl2pos")
#make the column with numbers for symbols a factor column
amph_smpl05_df$pchsymb <- as.factor(amph_smpl05_df$pchsymb)
tot_smpl04_df$pchsymb <- as.factor(tot_smpl04_df$pchsymb)
# set a value for jittering the points in the plots
jitlvl <- 0.07
jitlvl <- 0.18
jitlvl <- 0.10
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
class(ch_unspnm)
# #variables for legend - not used
cl <- c(colfunc(length(unique(amph_smpl05_df$abbr.nm))))
clt <- c(colfunc(length(unique(tot_smpl04_df$abbr.nm))))

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


#head(amph_smpl05_df)
#http://www.cookbook-r.com/Graphs/Colors_(ggplot2)/
# The palette with black:
cbbPalette <- c("#000000", "#E69F00", "#56B4E9", 
                "#009E73", "#F0E442", "#0072B2", 
                #"#D55E00", 
                "#CC79A7")

cl <- cbbPalette
# #variables for legend - not used
#cl <- c(colfunc(length(unique(amph_smpl05_df$abbr.nm))))
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
  scale_color_manual(values=c(rep("black",7))) +
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

#replace underscores with a space
amph_smpl05_df$latspc <- gsub("_"," ",amph_smpl05_df$latspc)
#
#unique(amph_smpl05_df$latspc)
#unique(gsub("Rana lessonae","Pelophylax kl. esculenta",amph_smpl05_df$latspc))
amph_smpl05_df$latspc2 <- gsub("Rana lessonae","Pelophylax kl. esculenta",amph_smpl05_df$latspc)
#identify the rows in the data frame with Bufo calamita
amph_smpl05_df[with(amph_smpl05_df, latspc2 %in% "Bufo calamita"),]

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
  scale_color_manual(values=c(rep("black",7))) +
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

if(bSaveFigures==T){
  ggsave(p,file=figname02,width=210,height=297,
         units="mm",dpi=300)
}

if(bSaveFigures==T){
  ggsave(p,file=figname05,width=210,height=297,
         units="mm",dpi=600)
}

#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# Plot on map -end
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

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
p01


#head(amph_smpl05_df)
#http://www.cookbook-r.com/Graphs/Colors_(ggplot2)/
# The palette with black:
cbbPalette <- c("#000000", "#E69F00", "#56B4E9", 
                "#009E73", "#F0E442", "#0072B2", 
                #"#D55E00", 
                "#CC79A7")

cl <- cbbPalette
# #variables for legend - not used
#cl <- c(colfunc(length(unique(amph_smpl05_df$abbr.nm))))
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
  scale_color_manual(values=c(rep("black",7))) +
  #set the color of the points
  #use alpha to scale the intensity of the color
  scale_fill_manual(values=alpha(
    c(clt),
    c(0.7)
  ))+
  #define limits of the plot
  ggplot2::coord_sf(xlim = c(8, 15.4),
                    ylim = c(54.4, 58.0), 
                    expand = FALSE)
#see the plot
p01

#define input file
inpf03 <- "DL_dk_specs_to_latspecs07.csv"
#paste path and input file together
inpf04 <- paste(wd00,"/",wd03,"/",inpf03,sep="")
#Read in input file with names
df_dk_to_latnms01 <- read.table(inpf04,sep = "\t")
#replace column names
colnames(df_dk_to_latnms01)  <- c("DK_comm_nm","Lat_spc_mn","aq_hab")
#match between data frames
tot_smpl03_df$latspc <- df_dk_to_latnms01$Lat_spc_mn[match(tot_smpl03_df$specs,df_dk_to_latnms01$DK_comm_nm)]
tot_smpl03_df$aq_hab <- df_dk_to_latnms01$aq_hab[match(tot_smpl03_df$specs,df_dk_to_latnms01$DK_comm_nm)]
#subest to only include marine species
tot_smpl03_df <- tot_smpl03_df[(tot_smpl03_df$aq_hab=="marine"),]
#make a colour function
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
p02

#  try a new plot

#do not subset the data frame
# i.e. instead include nonapproved controls 
# and approved controls
#amph_smpl03_df <- amph_smpl02_df
#make a new set of colours for points
cl03 <- c("yellow","springgreen1","springgreen4","white")
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
p03

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
figname03 <- paste0(fnm04,"_w_Ct_cutoff_",ct.cutoff,".png")
figname04 <- paste0(fnm05,"_w_Ct_cutoff_",ct.cutoff,".pdf")


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




