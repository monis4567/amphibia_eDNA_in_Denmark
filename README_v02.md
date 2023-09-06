This README file was generated on 2023-Aug-30 by Steen Wilhelm Knudsen.

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


#########################################################################

DATA-SPECIFIC INFORMATION FOR THE DIRECTORY: 'supma01_inp_raw_qcpr_csv'

'supma01_inp_raw_qcpr_csv' Holds six directories named: 
1.    inp01_speci_ampl_plots_amphibia) 
        This directory holds xls files obtained from qPCR on the MX3005P with genomic DNA extracted from tissue samples from target and non-target species. These xls files serve as input for the R code in the directory 'supma02_Rcodes_for_rawqpcr_and_resultingplots'.
2.    inp02_primer_opt_xls_amphibia)
        This directory holds xls files obtained from qPCR on the MX3005P with genomic DNA extracted from tissue samples from target species, with different concentrations of primers added to infer optimal final concentration of the primers in each assay. These xls files serve as input for the R code in the directory 'supma02_Rcodes_for_rawqpcr_and_resultingplots'. 
3.    inp03_probe_opt_xls_amphibia
        This directory holds xls files obtained from qPCR on the MX3005P with genomic DNA extracted from tissue samples from target species, with different concentrations of probs added to infer optimal final concentration of the primers in each assay. These xls files serve as input for the R code in the directory 'supma02_Rcodes_for_rawqpcr_and_resultingplots'.
4.    inp04_std_crvs
        This directory holds xls files obtained from qPCR on the MX3005P with standard dilution series of purified amplicons. These xls files serve as input for the R code in the directory 'supma02_Rcodes_for_rawqpcr_and_resultingplots'.
5.    inp05_inpfiles
        This directory holds files obtained using obitools (https://git.metabarcoding.org/obitools/) for inferring the species specifity . These files serve as input for the R code in the directory 'supma02_Rcodes_for_rawqpcr_and_resultingplots'.
6.    inp07_distrib_lsts
         This directory holds csv files with list of areas and countries for where the amphibians occur.

#########################################################################

DATA-SPECIFIC INFORMATION FOR THE DIRECTORY: 'supma02_Rcodes_for_rawqpcr_and_resultingplots'

'supma02_Rcodes_for_rawqpcr_and_resultingplots' Holds 12 files named: 

    Rcode02_primer_mismatch_plots01.R
    Rcode03b_qPCR842.R
    Rcode03c_qPCR888.R
    Rcode03c_qPCR889.R
    Rcode03c_qPCR890.R
    Rcode03c_qPCR891.R
    Rcode03_qpcr_specificity_ampl_plots01.R
    Rcode04_qpcr_primer_opt_heatmaps01.R
    Rcode05_qpcr_probe_opt_plots01.R
    Rcode06_std_curves_01.R
    Rcode07_table_w_distr01.R
    Rcode08_LoDcalculator_adopted_from_Klymus_etal_2019_v01.R

and also holds directories named:
    plotout02_amphibia_specificity
    plotout03_amphibia_primer_opt
    plotout04_amphibia_probe_optimal_conc
    plotout05_std_crv
    plotout07_table_distr_area
    plotout08_LoD_calculations_as_by_Klymus_etal_2019


The files in the directory supma02_Rcodes_for_rawqpcr_and_resultingplots' are:
1.    'Rcode02_primer_mismatch_plots01.R'
        This is an R code that is used to make mismatch plots for the primer sets
2.    'Rcode03b_qPCR842.R'
        This is an R code for analysing the results from qPCR run 842.
3.    'Rcode03c_qPCR888.R'
        This is an R code for analysing the results from qPCR run 888.
4.    'Rcode03c_qPCR889.R'
        This is an R code for analysing the results from qPCR run 889.
5.    'Rcode03c_qPCR890.R'
        This is an R code for analysing the results from qPCR run 890.
6.    'Rcode03c_qPCR891.R'
        This is an R code for analysing the results from qPCR run 891.
7.    'Rcode03_qpcr_specificity_ampl_plots01.R'
        This is an R code for making plots of primer specificity.
8.    'Rcode04_qpcr_primer_opt_heatmaps01.R'
        This is an R code for making heat maps that reflects the optimal final concentration of primers.
9.    'Rcode05_qpcr_probe_opt_plots01.R'
        This is an R code for making plotting the optimal final concentration of the probe.
10.    'Rcode06_std_curves_01.R'
        This is an R code for plotting the standard dilution curves for each species specific assay.
11.    'Rcode07_table_w_distr01.R'
        This is an R code for making a table that lists the distribution of the species of amphibians monitored in this study.
12.    'Rcode08_LoDcalculator_adopted_from_Klymus_etal_2019_v01.R'
        This is an R code for making inferring the limit of detection (LOD) and the limit of quantification (LOQ) for the species specific assays, but this code is based on the R code to infer LOD and LOQ as presented in the study by Klymus et al. (2019) ().

The directories named:
1.    plotout02_amphibia_specificity
        Contains the plots from the qPCR analysis with the specificity of the primer and probe whee tested in vitro in genomic DNA extracted from tissue from congeners 
2.    plotout03_amphibia_primer_opt
        Contains the plots from the qPCR analysis optimal final concentration of primers 
3.    plotout04_amphibia_probe_optimal_conc
        Contains the plots from the qPCR analysis optimal final concentration of the probe 
4.    plotout05_std_crv
        Contains the plots from the qPCR analysis with the standard dilution series 
5.    plotout07_table_distr_area
        Contains the table listing the known distribution of the species monitored  
6.    plotout08_LoD_calculations_as_by_Klymus_etal_2019
        Contains the table with the LOD and LOQ as inferred using the R code provided by Klymus et al., 2019. 

#########################################################################

DATA-SPECIFIC INFORMATION FOR THE DIRECTORY: 'supma03_inp_files_for_R'

'supma03_inp_files_for_R' holds 24 files named: 

    aquatic_periods_for_DK_amphibians_v01.xls
    DL_dk_specs_to_latspecs06.csv
    DL_padde_pos_water_samples03.csv
    DNAogLiv_Proever_14-3-2022.xls
    Ferskvand_2018_2019_20200513_DLtests_only_amphibians.xlsx
    Ferskvand_2018_2019_20200513_DLtests.xlsx
    Ferskvand_2018_2019_20200513.xlsm
    fund_arter.dk_Bombina_bombina_records_fb5b0a2f-43ca-49a0-9020-b232c828b5d7.xlsx
    fund_arter.dk_Bufo_bufo_records_58f248a0-c334-4cc2-bae3-79301c47302c.xlsx
    fund_arter.dk_Bufo_calamita_records_44492982-862e-4496-9977-55118afcfafe.xlsx
    fund_arter.dk_Bufo_viridis_records_0ea2de2c-c2cb-40b8-a3e1-201b0e922fdd.xlsx
    fund_arter.dk_Hyla_arborea_records_312187c6-645e-48aa-9d81-fd613c016fa7.xlsx
    fund_arter.dk_Ichthyosaura_alpestris_records_309f6c87-09a2-4e84-81f4-28230f51098f.xlsx
    fund_arter.dk_Lissotriton_vulgaris_records_cf7a979a-9f52-46f3-8405-7444afa5af0a.xlsx
    fund_arter.dk_Pelobates_fuscus_records_43afc906-4e9b-40f0-bd15-0a48dbb9f1a2.xlsx
    fund_arter.dk_Pelobates_fuscus_records_68cb6c45-a462-4625-9184-e033148d14ba.xlsx
    fund_arter.dk_Rana_arvalis_records_8724d7f2-8805-4439-bfa7-86ae08e19db0.xlsx
    fund_arter.dk_Rana_dalmatina_records_bc2f5d0b-b1a6-4d33-8110-6582e6067da2.xlsx
    fund_arter.dk_Rana_lessonae_records_40c4d570-a5f9-41a5-b77c-1de4bf07b4a4.xlsx
    fund_arter.dk_Rana_temporaria_records_be426561-4ce6-4b6a-aa16-80b338d4cf1f.xlsx
    fund_arter.dk_Triturus_cristatus_records_107f965c-dddc-4678-b0cd-8a28e424164e.xlsx
    list_latin_spc_nms_and_common_names.tsv
    lu3205wja.tmp
    table_w_eng_common_names_and_Latin_spc_names.xlsx

These files are used as input files for the R code in the other directories.
The files in the directory 'supma03_inp_files_for_R' are:
1. aquatic_periods_for_DK_amphibians_v01.xls
    This is an excel file that lists the periods over the year when the amphibians are in contact with their aquatic habitat
2. DL_dk_specs_to_latspecs06.csv
    This is an comma separated value (csv) file that lists the Latins species names and the Danish common names
3. DL_padde_pos_water_samples03.csv
    This is an comma separated value (csv) file that sums up the positive detections of environmental DNA in the water samples
4. DNAogLiv_Proever_14-3-2022.xls
    This is an excel file that lists all the samples collected by the high school students
5. Ferskvand_2018_2019_20200513_DLtests_only_amphibians.xlsx
    This is an excel file that lists all the qPCR tests performed by the high school students, but only the amphibians
6. Ferskvand_2018_2019_20200513_DLtests.xlsx
    This is an excel file that lists all the qPCR tests performed by the high school students
7. Ferskvand_2018_2019_20200513.xlsm
    This is an excel file that was an early attempt at adding up the results from the course
8. fund_arter.dk_Bombina_bombina_records_fb5b0a2f-43ca-49a0-9020-b232c828b5d7.xlsx
    This is an excel file obtained from the website 'www.arter.dk', and lists occurences of Bombina bombina in Denmark
9. fund_arter.dk_Bufo_bufo_records_58f248a0-c334-4cc2-bae3-79301c47302c.xlsx
    This is an excel file obtained from the website 'www.arter.dk', and lists occurences of Bufo bufo in Denmark
10. fund_arter.dk_Bufo_calamita_records_44492982-862e-4496-9977-55118afcfafe.xlsx
    This is an excel file obtained from the website 'www.arter.dk', and lists occurences of Bufo calamita in Denmark
11. fund_arter.dk_Bufo_viridis_records_0ea2de2c-c2cb-40b8-a3e1-201b0e922fdd.xlsx
12. fund_arter.dk_Hyla_arborea_records_312187c6-645e-48aa-9d81-fd613c016fa7.xlsx
13. fund_arter.dk_Ichthyosaura_alpestris_records_309f6c87-09a2-4e84-81f4-28230f51098f.xlsx
14. fund_arter.dk_Lissotriton_vulgaris_records_cf7a979a-9f52-46f3-8405-7444afa5af0a.xlsx
15. fund_arter.dk_Pelobates_fuscus_records_43afc906-4e9b-40f0-bd15-0a48dbb9f1a2.xlsx
16. fund_arter.dk_Pelobates_fuscus_records_68cb6c45-a462-4625-9184-e033148d14ba.xlsx
17. fund_arter.dk_Rana_arvalis_records_8724d7f2-8805-4439-bfa7-86ae08e19db0.xlsx
18. fund_arter.dk_Rana_dalmatina_records_bc2f5d0b-b1a6-4d33-8110-6582e6067da2.xlsx
19. fund_arter.dk_Rana_lessonae_records_40c4d570-a5f9-41a5-b77c-1de4bf07b4a4.xlsx
20. fund_arter.dk_Rana_temporaria_records_be426561-4ce6-4b6a-aa16-80b338d4cf1f.xlsx
21. fund_arter.dk_Triturus_cristatus_records_107f965c-dddc-4678-b0cd-8a28e424164e.xlsx
22. list_latin_spc_nms_and_common_names.tsv
23. lu3205wja.tmp
24. table_w_eng_common_names_and_Latin_spc_names.xlsx


#########################################################################

DATA-SPECIFIC INFORMATION FOR THE DIRECTORY: 'supma04_qpcr_data_from_students_tests'


#########################################################################

DATA-SPECIFIC INFORMATION FOR THE DIRECTORY: 'supma05_qpcr_csv_data_from_students_tests'


#########################################################################

DATA-SPECIFIC INFORMATION FOR THE DIRECTORY: 'supma06_bashcode'


#########################################################################

DATA-SPECIFIC INFORMATION FOR THE DIRECTORY: 'supma07_qpcr_merged_csvs'


#########################################################################

DATA-SPECIFIC INFORMATION FOR THE DIRECTORY: 'supma08_Rcode'



#########################################################################

DATA-SPECIFIC INFORMATION FOR THE DIRECTORY: 'supma09_plots_from_R_analysis'

#########################################################################


