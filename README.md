This README file was generated on 2023-Sep-08 by Steen Wilhelm Knudsen.

GENERAL INFORMATION

1. Title of Dataset: Data and code for: Detection of environmental DNA from amphibians in Northern Europe applied in citizen science. With data from 2017-2019

2. Author Information
	 Principal Investigator Contact Information
  	 Name: Steen Wilhelm Knudsen
  	 Institution: NIVA Denmark
  	 Address: Njalsgade 76, 2300 Copenhagen, Denmark
  	 Email: steen.knudsen@niva-dk.dk

3. Date of data collection (single date, range, approximate date): 2017-2019

4. Geographic location of data collection: Freshwater areas in Denmark

5. Information about funding sources that supported the collection of the data: Innovationsfonden, Award number: J.nr. 104-2012-1; and Lundbeck Foundation; and Miljøstyrelsen

SHARING/ACCESS INFORMATION

1. Licenses/restrictions placed on the data: CC0 1.0 Universal (CC0 1.0) Public Domain

2. Links to publications that cite or use the data:

Knudsen, S. W., Hesselsøe, M., Rytter, M., Lillemark, M. R., Tøttrup, A. P., Rahbek, C., Sheard, J. K., Thomsen, P. F., Agersnap, S., Mortensen, P. B., Møller, P. R. (2023). Detection of environmental DNA from amphibians in Northern Europe applied in citizen science. Environmental DNA 00,1-20. DOI: 10.1002/edn3.462 https://doi.org/10.1002/edn3.462

3. Links to other publicly accessible locations of the data: https://github.com/monis4567/amphibia_eDNA_in_Denmark.git

4. Links/relationships to ancillary data sets: None

5. Was data derived from another source? Yes
	A. If yes, list source(s): https://www.gbif.org/, https://arter.dk/, https://www.inaturalist.org/

6. Recommended citation for this dataset: 

Knudsen, S. W., Hesselsøe, M., Rytter, M., Lillemark, M. R., Tøttrup, A. P., Rahbek, C., Sheard, J. K., Thomsen, P. F., Agersnap, S., Mortensen, P. B., Møller, P. R. (2023). Data and code for: Detection of environmental DNA from amphibians in Northern Europe applied in citizen science. With data from 2017-2019. Dryad Digital Repository. https://doi.org/10.5061/dryad.w9ghx3fvc

DATA & FILE OVERVIEW

1. File List:
The compressed file holds 10 directories with input file and code, numbered 'supma01' to 'supma10'. The contents of each of these directories is listed below.
    supma01_inp_raw_qcpr_csv
    supma02_Rcodes_for_rawqpcr_and_resultingplots
    supma03_inp_files_for_R
    supma04_qpcr_data_from_students_tests
    supma05_qpcr_csv_data_from_students_tests
    supma06_bashcode
    supma07_qpcr_merged_csvs
    supma08_Rcode
    supma09_plots_from_R_analysis
    supma10_plots_from_R_analysis_for_fishes

2. Relationship between files, if important: The directory 'supma01_inp_raw_qcpr_csv' holds directories that are required for the R code in the directory named 'supma02_Rcodes_for_rawqpcr_and_resultingplots'. The directory named 'supma03_inp_files_for_R' holds input files required for the R code in the directory 'supma08_Rcode'. The directories named 'supma04_qpcr_data_from_students_tests', and 'supma05_qpcr_csv_data_from_students_tests' holds the files required for the bash code in the directory named: 'supma06_bashcode'. The directory named : 'supma07_qpcr_merged_csvs' holds the resulting files produced from the bash code in 'supma06_bashcode'. The directory named: 'supma08_Rcode' holds the R code that is used to anlayse the data files in the directories named: 'supma03_inp_files_for_R' and 'supma07_qpcr_merged_csvs'. The files that results from running the R code in 'supma08_Rcode' will be placed in the directory named: 'supma09_plots_from_R_analysis' and 'supma10_plots_from_R_analysis_for_fishes'.

Methods
This dataset was obtained with the aid of high school students in Denmark collecting filtered water samples that later on was extracted and analysed by qPCR using species specific primers and probes. A full description of the methods can be found in this publication: Knudsen, S. W., Hesselsøe, M., Rytter, M., Lillemark, M. R., Tøttrup, A. P., Rahbek, C., Sheard, J. K., Thomsen, P. F., Agersnap, S., Mortensen, P. B., Møller, P. R. (2023). Detection of environmental DNA from amphibians in Northern Europe applied in citizen science. Environmental DNA 00,1-20. DOI: 10.1002/edn3.462 https://doi.org/10.1002/edn3.462
There is additional information in the supporting material also provided together with this publication.
The data obtained from the qPCR analysis were all exported as '.txt'files from the MxPro software associated with the MxPr3005 qPCR machine. These raw '.txt' files can be found in the directory named 'supma04_qpcr_data_from_students_tests'.

Usage notes
The entire compressed file can be downloaded, placed locally and uncompressed. The R codes are all dependent on having the path to the working directory specified. Before any of the R codes can be used they need to have the path for the working directory specified. The other sub-directories are then used in R codes when they executed.
All the R code have the path to the working directory specified in the first part of the code, together with the packages required.

The codes in the directory named 'supma02_Rcodes_for_rawqpcr_and_resultingplots' uses the files in the directory named 'supma01_inp_raw_qcpr_csv'. These R codes in 'supma02_Rcodes_for_rawqpcr_and_resultingplots' can be used to recreate the plots provided in the supporting material provided with the paper published in 'Environmental DNA' (https://doi.org/10.1002/edn3.462). The directory named 'supma03_inp_files_for_R' holds input files obtained from www.arter.dk and from GBIF (see derived dataset from GBIF.org, 8 September 2023), and records obtained from iNaturalist.

Start out by running the codes in the directory named 'supma02_Rcodes_for_rawqpcr_and_resultingplots' to get the plots the shows the specificity in the assays. Then run the bashcode in the directory named 'supma06_bashcode'. This bashcode will make use of all the students qPCR runs, and first transform these raw '.txt' files in the directory named 'supma04_qpcr_data_from_students_tests' into comma seprated value ('.csv') files. The bashcode in 'supma06_bashcode' should ensure these '.csv' files are placed in the directory 'supma05_qpcr_csv_data_from_students_tests'.
The bashcode in the directory named 'supma06_bashcode' also merges all the '.csv' files in the directory 'supma05_qpcr_csv_data_from_students_tests', and then places the final merged '.csv' file in the directory named 'supma07_qpcr_merged_csvs'.

Once the merged '.csv' file is placed in the directory named 'supma07_qpcr_merged_csvs' all the R code in the directory named : 'supma08_Rcode' can be used.The R code in  the directory named  'supma08_Rcode' makes use of both the input files in the directory named 'supma07_qpcr_merged_csvs' and the input files in the directory named 'supma03_inp_files_for_R'. The individual pieces of R code in the directory named 'supma07_qpcr_merged_csvs' all needs to have the path to the working directory corrected. This needs to be a path to a local directory, as it is currently set up to run an a different computer. Once the path to the working directory has been correct the first R code in the directory named  'supma08_Rcode' to use is the code named 'Rcode08_01_plot_Amphibians_on_map03.R'. Executing the code 'Rcode08_01_plot_Amphibians_on_map03.R' will remove the previous version of the directory named 'supma09_plots_from_R_analysis', and will then start to write plots and diagrams to the directory named 'supma09_plots_from_R_analysis'.

Once the code named 'Rcode08_01_plot_Amphibians_on_map03.R' has been executed, the code named 'Rcode08_02_table_w_distr.R' can be used to prepare a table of distributions. The output from this code is also written to the  directory named 'supma09_plots_from_R_analysis'.
The the R code named 'Rcode08_03_try_inaturalist_v02.R' can be used to get records from iNaturalist and place the obtained records on a map. The resulting plots and diagrams are written to the directory named 'supma09_plots_from_R_analysis'.

The R code named 'Rcode08_04_map_inaturalist_and_eDNA_monitoring_v01.R' can be used to plot both the eDNA postive and validated results together with the records obtained from iNaturalist. The plots and diagrams are again written to the directory named 'supma09_plots_from_R_analysis'.
The R code named 'Rcode08_05_tryout_ecospat_v01.R' can be used to try the 'ecospat' package in R. 

The R code named 'Rcode08_06_tryout_getrecords_from_gbif_v01.R' can be used to obtain records from GBIF. Which results in this dataset:
Derived dataset from GBIF.org, 8 September 2023
Title: 'Data from gbif for : Detection of environmental DNA from amphibians in Northern Europe applied in citizen science'
  Description: 'A csv file with occurence data for amphibians in Denmark used in the study:  Knudsen, S. W., Hesselsøe, M., Rytter, M., Lillemark, M. R., Tøttrup, A. P., Rahbek, C., Sheard, J. K., Thomsen, P. F., Agersnap, S., Mortensen, P. B., & Møller, P. R. (2023). Detection of environmental DNA from amphibians in Northern Europe applied in citizen science. Environmental DNA, 00, 1–20. https://doi.org/10.1002/edn3.462 '
  Source URL: https://github.com/monis4567/amphibia_eDNA_in_Denmark/blob/main/supma03_inp_files_for_R/out08_06b_gbif_records_amphibia_Denmark.csv
  Citation: Derived dataset GBIF.org (8 September 2023) Filtered export of GBIF occurrence data https://doi.org/10.15468/dd.yqhtz7
  Derived Dataset DOI: 10.15468/dd.yqhtz7

The R code named 'Rcode08_07_map_gbif_and_eDNA_monitoring_v01.R' can be used to plot both the eDNA postive and validated results together with the records obtained from GBIF. The plots and diagrams are again written to the directory named 'supma09_plots_from_R_analysis'.

The R code named 'Rcode08_08_map_records_arter.dk_and_eDNA_monitoring_v01' can be used to plot both the eDNA postive and validated results together with the records obtained from www.arter.dk. The plots and diagrams are again written to the directory named 'supma09_plots_from_R_analysis'.

The directory named 'supma09_plots_from_R_analysis' only holds files that are produced by R code in the directory named 'supma08_Rcode'.

Funding
This study was supported by the Innovation Fund Denmark (Grant J.nr. 104-2012-1), and by the Danish Environmental Agency [Miljøstyrelsen] and by the Lundbeck foundation. 