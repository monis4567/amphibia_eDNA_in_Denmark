#!/bin/bash
# -*- coding: utf-8 -*-

##get the present directory
WD=$(pwd)
# get base directory
WD00="/home/hal9000/MS_amphibia_eDNA/"
#WD00="/Users/steenknudsen/Documents/Documents/MS_DNA_og_Liv_citizen_science/"
#get dir with the present bash code inside
WD06="supma06_bashcode"
#define output directory
WD07="supma07_qpcr_merged_csvs"
#define input dirs
WD04="supma04_qpcr_data_from_students_tests"
WD05="supma05_qpcr_csv_data_from_students_tests"
# in Finder on Macintosh connect to
# https://webfile.science.ku.dk/webdav

#make strings with new dirs
WD00_WD07=$(echo "$WD00""$WD07")
WD00_WD06=$(echo "$WD00""$WD06")
WD00_WD05=$(echo "$WD00""$WD05")
WD00_WD04=$(echo "$WD00""$WD04")
#echo "$WD00_WD06"
#echo "$WD00_WD04"

# in Finder on Macintosh connect to
# https://webfile.science.ku.dk/webdav
#
#Locate MxPro files in:
#I:\SCIENCE-SNM-ZMDISK\5. FORMIDLINGSAFDELING\DNA & LIV\Data\qPCR resultater\MxPro_tekstfiler

#copy to your own computer

# and place them in INDIR1="mxpro_fra_dnaogliv_2019apr"

#then you should be able to run the code here below
#
#define dir with input files
#INDIR1="mxpro_fra_dnaogliv_2020jun"
# INDIR1 is where the raw text reports from the MxPro machine are stored
INDIR1="${WD00_WD04}"
# INDIR2 is where the csv modified text reports from the MxPro machine are to be placed
INDIR2="${WD00_WD05}"

#OUTDIR1="out02a_merged_csv_files_from_mxpro"
# OUTDIR1 is the dir where the final merged csv file is to be stored
OUTDIR1="${WD00_WD07}"
OUTFILE1="outfile07_merged_csv_files_from_mxpro.csv"

#remove the old versions of the in- and output directory
rm -rf "${OUTDIR1}"
rm -rf "${INDIR2}"
#make new versions of the in- and output directory
mkdir "${OUTDIR1}"
mkdir "${INDIR2}"

#change directory to the directory w raw input files
cd "${INDIR1}"
#copy these files to the new directory
cp *.txt "${INDIR2}"/.
#change directory to new directory w copied input files
cd "${INDIR2}"/

pwd

for FILENAME in *.txt
do
	NEWFILENAME=$(echo "${FILENAME}" | sed 's/ /_/g' | sed 's/_-_Text_Report_Data//g' | sed 's/\#/no/g')
	mv "${FILENAME}" "${NEWFILENAME}"
done


#TXT_FILEs=$(ls *.txt | sed s/.txt//g)
for FILE in *.txt
do
	FILENM=$(echo ${FILE} | \
	LC_ALL=C sed -E 's/\.txt//g' | \
	LC_ALL=C sed -E 's/RoskildeHTX_BorupgaardGym/RoskildeHTXBorupgaardGym/g' | \
	LC_ALL=C sed -E 's/GentofteHF_AkademiskStudenterkursus/GentofteHFAkademiskStudenterkursus/g' | \
	LC_ALL=C sed -E 's/GladsaxeGym_SvendborgGym/GladsaxeGymSvendborgGym/g' | \
	LC_ALL=C sed -E 's/FrederiksvaerkGym_BorupgaardGym/FrederiksvaerkGymBorupgaardGym/g' | \
	LC_ALL=C sed -E 's/Frederiksborg_Ordrup/FrederiksborgOrdrup/g' | \
	LC_ALL=C sed -E 's/Frederiksborg_SktAnnaeGym/FrederiksborgSktAnnaeGym/g' | \
	LC_ALL=C sed -E 's/Frederiksvaerk_SktAnnaeGym/FrederiksvaerkSktAnnaeGym/g' | \
	LC_ALL=C sed -E 's/Aurehoej_SktAnnaeGym/AurehoejSktAnnaeGym/g'| \
	LC_ALL=C sed -E 's/GladsaxeGymSvendborgGym_FrederiksvaerkGym/GladsaxeGymSvendborgGymFrederiksvaerkGym/g' | \
	LC_ALL=C sed -E 's/RoskildeGym_text/RoskildeGym_koersel1_text/g' | \
	LC_ALL=C sed -E 's/AurehoejGym_text/AurehoejGym_koersel1_text/g' | \
	LC_ALL=C sed -E 's/ErhvervsskolenNordsjaelland_text/ErhvervsskolenNordsjaelland_koersel1_text/g' |\
	LC_ALL=C sed -E 's/HoejeTaastrupGym_text/HoejeTaastrupGym_koersel1_text/g' | \
	LC_ALL=C sed -E 's/OerstadGym_text/OerstadGym_koersel1_text/g' | \
	LC_ALL=C sed -E 's/HTXHilleroed/HTXHilleroed_koersel1/g' | \
	LC_ALL=C sed -E 's/GentofteHF$/GentofteHF_koersel1/g' | \
	LC_ALL=C sed -E 's/NordfynsGym_text/NordfynsGym_koersel1_text/g' | \
	LC_ALL=C sed -E 's/DNG_sktAnnae/DNGsktAnnae/g' | \
	LC_ALL=C sed -E 's/Hoeje_TaastrupGym/HoejeTaastrupGym/g' | \
	LC_ALL=C sed -E 's/korsel/koersel/g' | \
	LC_ALL=C sed -E 's/DetFrieGym.*ChristianshavnsGym/DetFrieGymChristianshavnsGym/g' | \
	LC_ALL=C sed -E 's/GrindstedGym.*EGG/GrindstedGymEGG/g' | \
	LC_ALL=C sed -E 's/RoskildeGym.*FrederiksbergVUC/RoskildeGymFrederiksbergVUC/g' | \
	LC_ALL=C sed -E 's/StenhusGym.*FrederiksbergVUC/StenhusGymFrederiksbergVUC/g' | \
	LC_ALL=C sed -E 's/KoegeGym.*GentofteHF/KoegeGymGentofteHF/g' | \
	LC_ALL=C sed -E 's/TaarnbyGym.*OrdrupGym/TaarnbyGymOrdrupGym/g' | \
	LC_ALL=C sed -E 's/NZahlesGymSkole.*RoedovreGym/NZahlesGymSkoleRoedovreGym/g' | \
	LC_ALL=C sed -E 's/VibenshusGym.*OrdrupGym/VibenshusGymOrdrupGym/g' | \
	LC_ALL=C sed -E 's/VibenshusGym.*OrdrupGym/VibenshusGymOrdrupGym/g' | \
	LC_ALL=C sed -E 's/SilkeborgGym.*ZahlesGym/SilkeborgGymZahlesGym/g' | \
	LC_ALL=C sed -E 's/GrindstedGym.*NordsjVUC/GrindstedGymNordsjVUC/g' | \
	LC_ALL=C sed -E 's/RoedovreGym.*Zahles/RoedovreGymZahles/g' | \
	LC_ALL=C sed -E 's/R.*dovreGym/RoedovreGym/g' | \
		#fejl herunder
	LC_ALL=C sed -E 's/_DL([0-9]{6}).*restadGym/_DL\1_OerestadGym/g' | \
	LC_ALL=C sed -E 's/HelsingoerGym.*HoejeTaastrupGym/HelsingoerGymHoejeTaastrupGym/g')
#		sed 's/Frederiksborg_Ordrup/FrederiksborgOrdrup/g'|\
#		sed 's/GladsaxeGym_SvendborgGym_FrederiksvaerkGym/GladsaxeGymSvendborgGymFrederiksvaerkGym/g')
	#echo ${FILENM}
	cat ${FILE} | \
	LC_ALL=C sed -E 's/_\+K_/_PosK/g' | \
	LC_ALL=C sed -E 's/_-K_/_NegK/g' | \
	LC_ALL=C sed -E 's/_eDNA_/_eDNA/g' | \
	LC_ALL=C sed -E 's/_PosK_/_PosK/g' | \
	LC_ALL=C sed -E 's/_NegK_/_NegK/g' | \
	LC_ALL=C sed -E 's/e\+K/e_PosK/g' | \
	LC_ALL=C sed -E 's/e-K/e_NegK/g' | \
	LC_ALL=C sed -E 's/eeDNA/e_eDNA/g' | \
	LC_ALL=C sed -E 's/leDNA/l_eDNA/g' | \
	LC_ALL=C sed -E 's/deDNA/d_eDNA/g' | \
	LC_ALL=C sed -E 's/keDNA/k_eDNA/g' | \
	LC_ALL=C sed -E 's/eDNADL/eDNA_DL/g' | \
	LC_ALL=C sed -E 's/\+K/PosK/g' | \
	LC_ALL=C sed -E 's/-K/NegK/g' | \
	LC_ALL=C sed -E 's/negK/NegK/g' | \
	LC_ALL=C sed -E 's/posK/PosK/g' | \

	LC_ALL=C sed -E 's/FAM Positive Control/NPC/g' | \
	LC_ALL=C sed -E 's/_nyeprimere//g' | \
	LC_ALL=C sed -E 's/gamleprimere//g' | \
	LC_ALL=C sed -E 's/nye*.primere//g' | \
	LC_ALL=C sed -E 's/gamle*.primere//g' | \
	LC_ALL=C sed -E 's/(posK).*[0-9+]:[0-9+]/\1/g' | \
	LC_ALL=C sed -E 's/eDNA.*nye*.primere/eDNA/g' | \
	LC_ALL=C sed -E 's/PosK.*'$'\t''Unknown/PosK'$'\t''Unknown/g' | \
		# replace in lines NOT macthing
#https://stackoverflow.com/questions/4953738/how-to-globally-replace-strings-in-lines-not-starting-with-a-certain-pattern
	LC_ALL=C sed -E '/PosK.*'$'\t''FAM'$'\t''/! s/PosK.*'$'\t''NPC'$'\t''/PosK'$'\t''NPC'$'\t''/g' | \
	LC_ALL=C sed -E '/NegK.*'$'\t''FAM'$'\t''/! s/NegK.*'$'\t''NTC'$'\t''/NegK'$'\t''NTC'$'\t''/g' | \


	LC_ALL=C sed -E 's/Ny.*PosK/PosK/g' | \
	LC_ALL=C sed -E 's/NegK.*Unknown/NegK'$'\t''Unknown/g' | \
	LC_ALL=C sed -E 's/StorVandsalamander.*Unknown/StorVandsalamander_eDNA'$'\t''Unknown/g' | \
	# see this weblink for how to ignore foreign characters:	#https://stackoverflow.com/questions/19242275/re-error-illegal-byte-sequence-on-mac-os-x/19770395#19770395
#	LC_ALL=C sed '/multiplex/d' | \ # delete lines with multiplex occuring
	LC_ALL=C sed -E 's/R.*dsp.*tte/Roedspaette/g' | \
	LC_ALL=C sed -E 's/r.*dsp.*tte/Roedspaette/g' | \
	LC_ALL=C sed -E 's/Europ.*isk.*l/EuropaeiskAal/g' | \
	LC_ALL=C sed -E 's/KinesiskUldh.*ndskrabbe/KinesiskUldhaandskrabbe/g' | \
	LC_ALL=C sed -E 's/Stillehavs.*sters/Stillehavsoesters/g' | \
	LC_ALL=C sed -E 's/Nordamerikansk.*mudderkrabbe/NordamerikanskMudderkrabbe/g' | \
	LC_ALL=C sed -E 's/Nordamerikansk.*Mudderkrabbe/NordamerikanskMudderkrabbe/g' | \
	LC_ALL=C sed -E 's/Latterfr.*_eDN/Latterfroe_eDN/g' | \
	LC_ALL=C sed -E 's/Latterfr.*_Pos/Latterfroe_Pos/g' | \
	LC_ALL=C sed -E 's/Latterfr.*_Neg/Latterfroe_Neg/g' | \

	LC_ALL=C sed -E 's/BudsnudetFroe/ButsnudetFroe/g' | \
	LC_ALL=C sed -E 's/Spidssnudetfroe/SpidssnudetFroe/g' | \
	LC_ALL=C sed -E 's/Solvkarusse/Soelvkarusse/g' | \
	LC_ALL=C sed -E 's/S.*lvkarusse/Soelvkarusse/g' | \
	LC_ALL=C sed -E 's/AmerikanskRibbegople/AmerikanskRibbegoble/g' | \
	LC_ALL=C sed -E 's/AtlantiskSild/Sild/g' | \
	LC_ALL=C sed -E 's/AlmindeligMakrel/Makrel/g' | \

	LC_ALL=C sed -E 's/L.*gfr.*_/Loegfroe_/g' | \
	LC_ALL=C sed -E 's/L.*vfr.*_/Loevfroe_/g' | \

	LC_ALL=C sed -E 's/Klokkefr.*_/Klokkefroe_/g' | \

	LC_ALL=C sed -E 's/brasen/Brasen/g' | \
	LC_ALL=C sed -E 's/bredVandkalv/BredVandkalv/g' | \
	LC_ALL=C sed -E 's/karpe/Karpe/g' | \
	LC_ALL=C sed -E 's/fr.*_/Froe_/g' | \
	LC_ALL=C sed -E 's/Fr.*_/Froe_/g' | \
	LC_ALL=C sed -E 's/K.*rguldsmed/Kaerguldsmed/g' | \
	LC_ALL=C sed -E 's/Gr.*nbroget/Groenbroget/g' | \

	LC_ALL=C sed -E 's/Tudse/tudse/g' | \
	LC_ALL=C sed -E 's/strandtudse/Strandtudse/g' | \
	LC_ALL=C sed -E 's/storVandsalamander/storvandsalamander/g' | \
	LC_ALL=C sed -E 's/StorVandsalamanderNegK/StorVandsalamander_NegK/g' | \
	LC_ALL=C sed -E 's/LilleVandsalamandereDNA/LilleVandsalamander_eDNA/g' | \
		
	LC_ALL=C sed -E 's/StorVandsalamanderPosK/StorVandsalamander_PosK/g' | \
	LC_ALL=C sed -E 's/StorVandsalamandereDNA/StorVandsalamander_eDNA/g' | \
	LC_ALL=C sed -E 's/vandsalamander/Vandsalamander/g' | \
	LC_ALL=C sed -E 's/stor/Stor/g' | \
		
	LC_ALL=C sed -E 's/Threshold.*\(dRn\)/;ThresholddRn;/g' | \
	LC_ALL=C sed -E 's/Ct.*\(dRn\)/;CtdRn;/g' | \

	LC_ALL=C sed -E 's/Threshold.*\(dR\)/;ThresholddRn;/g' | \
	LC_ALL=C sed -E 's/ThresholddRn.*/ThresholddRn;CtdRn/' | \

	#see how to remove tabs here: https://stackoverflow.com/questions/5398395/how-can-i-insert-a-tab-character-with-sed-on-os-x?noredirect=1&lq=1
	LC_ALL=C sed -E $'s/\t/;/g' | \
	LC_ALL=C sed -E 's/ //g' > ${FILENM}.csv
#	echo ${FILE}.csv
#	cat ${FILE}.txt | grep multi 

done


#Manipulate double DL files
for FILE in *_DL*_DL*.csv
do
	echo $FILE
	#delete them for now - I have not yet worked out what to do with them
	rm $FILE
done

#delete the files with odd columns -  - I have not yet worked out what to do with them
#they contain data from MONIS3-5 species -  not relevant for Amphibians
rm 20180412_DL2017082_GlHellerupGym* 
rm 20180419_DL2017068_VUCAarhus*

rm 20190114_Standardkurve_koersel1*
rm 20190115_Standardkurve_koersel*

# remove the 20190319_DL2018170_EgedalGym* file as it has this line
# ' ---	Unknown	0.1	27.82	20190319	DL2018170	EgedalGym'
# which is no good for later when the files are to be assembled
#rm 20190319_DL2018170_EgedalGym*
# or alternatively, manipulate the Egedal file that has this problem

#Manipulate the 20190319_DL2018170_EgedalGym file
for FILE in 20190319_DL2018170_EgedalGym*koersel1.csv
do
	#echo the problematic file to screen, to check no additional files are manipulated
	echo ""
	echo "this is the Egedal file"
	TMPF=$(echo "${FILE}" | sed 's/koersel1\.csv/koersel1corrected.csv/g')
	#see the tmp file name
	echo "$TMPF"
	#edit the problematic line
	LC_ALL=C sed -E 's/D1;---;Unknown;0.1000;27.82;/D1;01_NA_NegK;Unknown;0.1000;27.82;/g' "${FILE}" > $TMPF
	# remove the original file
	rm "$FILE"
	# move the tmp file name to the old file name
	mv "$TMPF" "$FILE"
	echo ""
done
#'s/D1;---;Unknown;0.1000;27.82;/D1;NA;--;Unknown;0.1000;27.82;/g'

#remove this file as it is difficult to align with all the other files
# it might be possible to include if a substitution scheme can be developed
#rm *DL2018106*
#remove this file as the lat-lon coordinates for sampling location are completely wrong. Might be possible to include if correct coordinates are included
#rm *DL2018136*


# get only the first part of the filename
#CSV_FILENAMES=$(ls *.csv | sed s/.csv//g)

for FILE in *.csv
do
	CSV_FILENAME=$(echo ${FILE} | sed -E 's/\.csv//g')
# for how to convert line endings in DOS-file
#see this website: https://stackoverflow.com/questions/2613800/how-to-convert-dos-windows-newline-crlf-to-unix-newline-lf-in-a-bash-script
	#echo "inputfile format is:"
	#file ${CSV_FILENAME}.csv #check the file format of the input file 
	LC_ALL=C tr -d '\015' <${CSV_FILENAME}.csv >${CSV_FILENAME}01.csv # replace DOS CRLF-end-of-lines
	#echo "outputfile format is:"
	#file ${CSV_FILENAME}01.csv #check the file format of the output file
# use sed command on every line except the first line, but instead add ";qpcrrundate_DLsamplno_gymnasiumnm1_gymnasiumnm2" to first line
	LC_ALL=C sed -E '1 s,$,;qpcrrundate_DLsamplno_gymnasiumnm1_koerselno_txt,; 1! s,$,'';'${CSV_FILENAME}',' ${CSV_FILENAME}01.csv > "${CSV_FILENAME}"02.csv
	
	#use sed to remove spaces in values
	LC_ALL=C sed -E 's/ //g' "${CSV_FILENAME}"02.csv > "${CSV_FILENAME}"03.csv
	#only print the last column in the file
#	awk -F ";" '{print $NF}' ${CSV_FILENAME}03.csv
	#replace in a specified column, see: https://stackoverflow.com/questions/42004482/shell-script-replace-a-specified-column-with-sed
	# for some reason this replaces semicolons w spaces in the other columns - I do not know why
	awk -F";" '{gsub("_",";",$NF)}1' ${CSV_FILENAME}03.csv | \
	#but with sed the spaces can be replaced back to semicolons
	LC_ALL=C sed -E 's/ /;/g' | \
	#and the remaining underscores can be replaced
	LC_ALL=C sed -E 's/_/;/g' | \
	#and the ;WellName; can be split into new column names and added semicolons
	#correct format is: Well;replno;specs;smpltp;WellType;ThresholddRn;CtdRn;qpcrrundate;DLsamplno;gymnasiumnm1;koerselno
	LC_ALL=C sed -E 's/;WellName;/;replno;specs;smpltp;/g' | \
	#use backslash to allow sed to replace parentheses
	LC_ALL=C sed -E 's/\(//g' | \
	LC_ALL=C sed -E 's/\)//g' | \
	#use hard brackets to allow sed to replace parentheses
	LC_ALL=C sed -E 's/[(]//g' | \
	LC_ALL=C sed -E 's/[)]//g' | \

	#the csv-file had decimal numbers with commas instead of points, replace commas w points
	LC_ALL=C sed -E 's/,/./g' | \
	#use sed to replace eDNa with eDNA
	LC_ALL=C sed -E 's/eDNa/eDNA/g' | \

		#use sed to replace double separators with single separators
	LC_ALL=C sed -E 's/;;/;/g' | \
	#delete line with 'multiplex'
	awk '!/multiplex/' | \
	#delete line with 'NotinUse'
	awk '!/NotinUse/' | \
	#delete line with '---;---;Unknown;0.1'
	awk '!/---;---;Unknown;0.1/' | \
	#delete line with 'Reference'
	awk '!/Reference/' > ${CSV_FILENAME}04.csv 
done	

#check incorrect headers
#for FILE in *04.csv
#do
#	echo $FILE
	#delete them for now - I have not yet worked out what to do with them
#	head -1 $FILE
	
	#done

#in a loop check if the input .csv-files have the word 'Dye' included
CSV04_FILENAMES=$(ls *04.csv | sed s/04.csv//g)

for ENDING in ${CSV04_FILENAMES}
do
	## check if the input file has the word 'Dye' included
if grep -Fq Dye ${ENDING}04.csv; then
	while IFS= read -r line
	do
		## Assuming the fifth column always holds the 'Dye' column
		## With cut fields 1 to 4 and from 6 an onwards are retained : see this website https://www.cyberciti.biz/faq/unix-linux-bsd-appleosx-skip-fields-command/
	     cut -d ';' -f1-4,6- <<<"$line"
	    ### same stuff with awk ###
	    ### awk '{print substr($0, index($0,$3))}' <<< "$line" ###
	done < "${ENDING}"04.csv > ${ENDING}05.csv
else NEWFILENAME=$(echo "${ENDING}05.csv")
	cp "${ENDING}"04.csv "${NEWFILENAME}"
fi
done

CSV05_FILENAMES=$(ls *05.csv | sed s/05.csv//g)
#in a loop check if the input .csv-files have the word 'Replicate' included
for ENDING in ${CSV05_FILENAMES}
do
	## check if the input file has the word 'Replicate' included
if grep -Fq Replicate ${ENDING}05.csv; then
	while IFS= read -r line
	do
		## Assuming the sixth column always holds the 'Replicate' column
		## With cut fields 1 to 5 and from 7 an onwards are retained : see this website https://www.cyberciti.biz/faq/unix-linux-bsd-appleosx-skip-fields-command/
	     cut -d ';' -f1-5,7- <<<"$line"
	    ### same stuff with awk ###
	    ### awk '{print substr($0, index($0,$3))}' <<< "$line" ###
	done < "${ENDING}"05.csv > ${ENDING}06.csv
else NEWFILENAME=$(echo "${ENDING}06.csv")
	cp "${ENDING}"05.csv "${NEWFILENAME}"
fi
done

#see note about quotes around variables: https://stackoverflow.com/questions/2462385/getting-an-ambiguous-redirect-error
# especially for writing to a file in a path that incl. spaces
for FILE in *06.csv
do
	#write the first line of every csv-file into a temporary file
	head -1 ${FILE} >> "${OUTDIR1}"/tmp01.txt
done

#get the unique lines from the tmp01.txt file, 
#if all csv-files are set up in the same way, this should return only a single line
#this line can put into the outputfile and serve as a header with column names
cat "${OUTDIR1}"/tmp01.txt | \
	LC_ALL=C uniq > "${OUTDIR1}"/"${OUTFILE1}"

#see this website on how to use sed to get all lines apart from the first line: https://unix.stackexchange.com/questions/55755/print-file-content-without-the-first-and-last-lines/55757
for FILE in *06.csv
do
	LC_ALL=C sed -E '1d' ${FILE} >> "${OUTDIR1}"/"${OUTFILE1}"
done

#head -10 "${WD}"/"${OUTDIR1}"/"${OUTFILE1}"
#tail -10 "${WD}"/"${OUTDIR1}"/"${OUTFILE1}"

# see this website about : Echo newline in Bash prints literal \n
# https://stackoverflow.com/questions/8467424/echo-newline-in-bash-prints-literal-n
# -e flag did it for me, which "enables interpretation of backslash escapes"

echo -e " \n make sure there only is one unique line for headers \n"
#see the content of the tmp01.txt file, to check all input files have the same header
#using the uniq command in the end , will make sure it only returns the unique lines 
cat "${OUTDIR1}"/tmp01.txt | \
	LC_ALL=C uniq

echo -e " \n make sure there only is one unique species name per species \n"
#Print the third column
# and sort the output, and get only uniq values
awk -F";" '{print $3}' "${OUTDIR1}"/"${OUTFILE1}" | \
	LC_ALL=C sort | \
	LC_ALL=C uniq

echo -e " \n make sure there only is one unique sample type name per sample type \n"
#Print the fourth column
# and sort the output, and get only uniq values
awk -F";" '{print $4}' "${OUTDIR1}"/"${OUTFILE1}" | \
	LC_ALL=C sort | \
	LC_ALL=C uniq

#printf "${OUTDIR1}"/"${OUTFILE1}"

#delete all the temporary files
rm *01.csv
rm *02.csv
rm *03.csv
rm *04.csv
rm *05.csv
rm *06.csv
rm "${OUTDIR1}"/tmp01.txt
#
#grep PosK "${OUTDIR1}"/"${OUTFILE1}" | head -120

#grep 20190306 "${OUTDIR1}"/"${OUTFILE1}"
#grep OerestadGym "${OUTDIR1}"/"${OUTFILE1}" | grep ';DL2;' | head -120
#grep DL2018170 "${OUTDIR1}"/"${OUTFILE1}" | grep mundet
grep SortmundetKutling "${OUTDIR1}"/"${OUTFILE1}" | grep ';eDNA;Unknown;' |\
	#invert the match to match non-matching lines
	#to identify the sample locations where there has been amplification
	grep -v ';NoCt;'
