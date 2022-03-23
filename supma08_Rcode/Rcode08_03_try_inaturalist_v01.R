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



rpath = "."
wd00 <- "/home/hal9000/Documents/Documents/MS_amphibian_eDNA_assays/amphibia_eDNA_in_Denmark"
#wd00 <- rpath
setwd (wd00)
getwd()
#define an output directory
wd09 <- "/supma09_plots_from_R_analysis"
#paste together path
wd00_wd09 <- paste(wd00,wd09,sep="")


#https://www.r-bloggers.com/2014/03/accessing-inaturalist-data/

#https://www.eleanor-jackson.com/post/searching-for-spring/

options(stringsAsFactors = F)

#get spocc package
if(!require(spocc)){
  install.packages("spocc")
  library(spocc)
  }  

#get rinat package
if(!require(rinat)){
  install.packages("rinat")
}  
 
# iNaturalist is an online community where people can record and share observations. 
#We have been using iNaturalist in our group for student projects. It’s proved a great 
#way to teach how to collect and analyse data while the lab and field have
#been off-limits. To find a way to make data collection easier, 
#I have been playing around with iNaturalist’s API.
# 
# It has been a long, dark winter for those of us under lockdown in
#the UK and to give myself something to look forward to, I decided to look into when 
#we might expect to see the first Spring bulbs emerging.

# iNaturalist does have a bulk download facility, but you can’t pull the data directly 
#into R, and I want to filter the data by term_id, which is not an option when using
#the export facility.
# 
# I’m going to use functions from {httr} to query the API, and {jsonlite} 
#to deal with the ugly json file that the API will return 

library("tidyverse")
library("httr")
library("jsonlite")

library("dplyr") 
# to avoid : https://stackoverflow.com/questions/30248583/error-could-not-find-function

#The API will only give us 200 records at a time, this is the max number of records per
#page, so I’m writing a function that I can use to repeatedly hit the server.
# The call I’m using includes filters to pull out the data I want to look at. 
#Briefly, I’m filtering for observations of plants iconic_taxa=Plantae, in the 
#UK place_id=6857, which have the annotations Plant Phenology term_id=12, and
# Flowering term_value_id=13. Annotations are 
#a little different to Observation Fields in iNaturalist.
#Observation Fields can be created and added by anyone, whereas 
#Annotations are maintained by iNaturalist administrators.
#This means I will probably pull fewer observations, but they might be more reliable.


# see this website : https://www.inaturalist.org/pages/search+urls
#Usually you’d use the page parameter to cycle through each page and retreive 
#all the results, however, if there are more than 10k results, iNaturalist 
#recommends you sort by ascending ID order_by=id&order=asc, and use the 
#id_above parameter set to the ID of the record in the last batch.

get_obs <- function(max_id){
  
  # an API call that has "id_above =" at the end
  call <- paste("https://api.inaturalist.org/v1/observations?",
                #"iconic_taxa=Plantae&",
                "iconic_taxa=Gadus&",
                #"term_id=12&", # 1=Life Stage, 9=Sex, 12=Plant Phenology, 17=Alive or Dead
                "term_id=17&",
                #"term_value_id=13&", #Plant Phenology: 13=Flowering, 14=Fruiting, 15=Flower Budding, 21=No Evidence of Flowering
                "term_value_id=18&", #"Alive or Dead: 18=Alive, 19=Dead, 20=Cannot Be Determined"
                "place_id=6857&",
                "d1=2017-01-01&",
                "per_page=200&",
                "order_by=id&",
                "order=asc&",
                "id_above=",
                max_id, sep="")
  
  # making the API call, parsing it to JSON and then flatten
  GET(url = call) %>%
    content(as = "text", encoding = "UTF-8") %>%
    fromJSON(flatten = TRUE) -> get_call_json
  
  # this grabs just the data we want and makes it a data frame
  as.data.frame(get_call_json$results)
  
}

# try with a comb jelly  URL for Europe
get_obs <- function(max_id){
  
  # an API call that has "id_above =" at the end
  call <- paste(
    #remeber to replace the 'www' with 'api'
    # and replace 'inaturalist.org/observations'
    # with
    # inaturalist.org/v1/observations
    #"https://www.inaturalist.org/observations?nelat=63.2000710201517&nelng=89.02951503499085&place_id=any&subview=map&swlat=32.038085308818296&swlng=-38.58767246500915&taxon_id=171725",
    #"https://www.inaturalist.org/observations?nelat=58.90022964297149&nelng=28.956272847490848&place_id=any&subview=map&swlat=52.07425112941103&swlng=-2.9480240275091507&taxon_id=63743",
      "https://api.inaturalist.org/v1/observations?nelat=62.24410751082821&nelng=85.06445707306858&place_id=any&subview=map&swlat=30.25283706916566&swlng=-42.552730426931404&taxon_id=63741",  
    #  "https://api.inaturalist.org/v1/observations?nelat=62.24410751082821&nelng=85.06445707306858&place_id=any&subview=map&swlat=30.25283706916566&swlng=-42.552730426931404&taxon_id=63743",
    # "https://api.inaturalist.org/v1/observations?nelat=63.2000710201517&nelng=89.02951503499085&place_id=any&subview=map&swlat=32.038085308818296&swlng=-38.58767246500915&taxon_id=171725",
                "&",
                #"per_page=200&",
                "order_by=id&",
                "order=asc&",
                "id_above=",max_id, sep="")
  
  # making the API call, parsing it to JSON and then flatten
  GET(url = call) %>%
    content(as = "text", encoding = "UTF-8") %>%
    fromJSON(flatten = TRUE) -> get_call_json
  
  # this grabs just the data we want and makes it a data frame
  as.data.frame(get_call_json$results)
  
}
#try with a http for a request of kyphosus on a specific bounding box with 
#boundaries for latitude and longitude
httpptah <- "https://www.inaturalist.org/observations?nelat=3.460786451252345&nelng=-143.08291869620442&place_id=any&subview=map&swlat=-40.88693807184049&swlng=89.29989380379561&taxon_id=49688"
# or try with a search without a bounding box
#httpptah <- "https://www.inaturalist.org/observations?place_id=any&subview=map&taxon_id=49688"
#substitute 'www' with 'api' - to make get_obs function search the correct webpage
httpptah <- gsub("//www\\.","//api.",httpptah)
#substitute afer 'org' and insert 'v1' - to make get_obs function search the correct webpage
httpptah <- gsub("\\.org/observations",".org/v1/observations",httpptah)

# nelng cuts on the eastern boundary
# nelat cut on the northern border
  #                             |
  #                       nelng |
  #             N         nelat___    |
  #             |                     | y-axis is lat
  #             |                     |
  #             |                     |
  #   W____________________E          |
  #             |                     |
  #             |                     |
  #             |                     |
  # ___  swlat  S                     |
  #     |swlng
  #     |
  #_____________________________
  #             x-axis is lon
# swlng cuts on the western boundary
# swlat cut on the southern border

#try defining your own bounding box
set_nelat= 58
set_nelng= 15.4
set_swlat= 54.4
set_swlng= 8


#try defining your own bounding box
set_nelat= 59.5
set_nelng= 17
set_swlat= 53
set_swlng= 7


#replace in the nelat and nlng boundary
httpptah <- gsub("nelat=.[0-9]{+}\\.[0-9]{+}&",paste0("nelat=",set_nelat,"&"),httpptah)
httpptah <- gsub("nelng=.[0-9]{+}\\.[0-9]{+}&",paste0("nelng=",set_nelng,"&"),httpptah)
#replace in the swlat and swng boundary
httpptah <- gsub("swlat=.[0-9]{+}\\.[0-9]{+}&",paste0("swlat=",set_swlat,"&"),httpptah)
httpptah <- gsub("swlng=.[0-9]{+}\\.[0-9]{+}&",paste0("swlng=",set_swlng,"&"),httpptah)
#

txnmb <- 171725 # Mnemiopsis
#make a list of taxon numbers in inaturalist
txnmbs <- c(
  171725, # Mnemiopsis
#  180788, # Mnemiopsis leidyi
# 208527, # Cordylophora caspia
 #182985, # Bonnemaisonia hamifera
# 549872, # Pseudochattonella verruculosa
# 58612, # Carassius auratus
 #53911, # Cyprinus carpio
 #129737, # Colpomenia peregrine
 106743, # Neogobius melanostomus
 #47516, # Oncorhynchus mykiss
 605992, # Magallana gigas
 #107570, # Oncorhynchus gorbuscha
 81634, # Mya arenaria
 81612, # Rhithropanopeus harrisii
63038 # Eriocheir sinensis
)

#Bufo bufo
#https://www.inaturalist.org/observations?nelat=63.2000710201517&nelng=89.02951503499085&place_id=any&subview=map&swlat=32.038085308818296&swlng=-38.58767246500915&taxon_id=326296
#Bufo viridis
#https://www.inaturalist.org/observations?nelat=63.2000710201517&nelng=89.02951503499085&place_id=any&subview=map&swlat=32.038085308818296&swlng=-38.58767246500915&taxon_id=135064
# Rana dalmatina
#https://www.inaturalist.org/observations?nelat=63.2000710201517&nelng=89.02951503499085&place_id=any&subview=map&swlat=32.038085308818296&swlng=-38.58767246500915&taxon_id=25669
# Rana arvalis
#https://www.inaturalist.org/observations?nelat=63.2000710201517&nelng=89.02951503499085&place_id=any&subview=map&swlat=32.038085308818296&swlng=-38.58767246500915&taxon_id=25488
# Hyla arborea
#https://www.inaturalist.org/observations?nelat=63.2000710201517&nelng=89.02951503499085&place_id=any&subview=map&swlat=32.038085308818296&swlng=-38.58767246500915&taxon_id=424147
#Lissotriton vulgaris
#https://www.inaturalist.org/observations?nelat=63.2000710201517&nelng=89.02951503499085&place_id=any&subview=map&swlat=32.038085308818296&swlng=-38.58767246500915&taxon_id=556656
# Pelobates fuscus  
#https://www.inaturalist.org/observations?nelat=63.2000710201517&nelng=89.02951503499085&place_id=any&subview=map&swlat=32.038085308818296&swlng=-38.58767246500915&taxon_id=25312
# Pelophylax esculentus
#https://www.inaturalist.org/observations?nelat=63.2000710201517&nelng=89.02951503499085&place_id=any&subview=map&swlat=32.038085308818296&swlng=-38.58767246500915&taxon_id=66322
# Pelophylax ridibundus
#https://www.inaturalist.org/observations?nelat=63.2000710201517&nelng=89.02951503499085&place_id=any&subview=map&swlat=32.038085308818296&swlng=-38.58767246500915&taxon_id=1319807
# Rana temporaria
#https://www.inaturalist.org/observations?nelat=63.2000710201517&nelng=89.02951503499085&place_id=any&subview=map&swlat=32.038085308818296&swlng=-38.58767246500915&taxon_id=25591
# Triturus cristatus
#https://www.inaturalist.org/observations?nelat=63.2000710201517&nelng=89.02951503499085&place_id=any&subview=map&swlat=32.038085308818296&swlng=-38.58767246500915&taxon_id=27718
#make a list of taxon numbers in inaturalist
txnmbs <- c(
  25669, # Rana dalmatina
  25488, # Rana arvalis
  424147, # Hyla arborea  
  556656, # Lissotriton vulgaris
  326296, # Bufo bufo
  135064, # Bufo viridis
  25312, # Pelobates fuscus  
  66322, # Pelophylax esculentus
  1319807, # Pelophylax ridibundus
  25591, # Rana temporaria
  27718 # Triturus cristatus
  )

#txnmbs <- c(27718)
#txnmbs<- txnmbs[1]
#make an empty list to use for collecting data frame
lst_tx_gobs <- list()
#start a growing number
i <- 1
for (tx in txnmbs)
{
  #print(tx)}
#replace the taxon_ID
httpptah <- gsub("taxon_id=.[0-9]+",paste0("taxon_id=",tx),httpptah)

#httpptah

  get_obs <- function(max_id){
  # an API call that has "id_above =" at the end
  call <- paste(httpptah,
    #remeber to replace the 'www' with 'api'
    # and replace 'inaturalist.org/observations'
    # with
    # inaturalist.org/v1/observations
    "&",
    "per_page=200&",
    "order_by=id&",
    "order=asc&",
    "id_above=",max_id, sep="")
  
  # making the API call, parsing it to JSON and then flatten
  GET(url = call) %>%
    content(as = "text", encoding = "UTF-8") %>%
    fromJSON(flatten = TRUE) -> get_call_json
  # this grabs just the data we want and makes it a data frame
  as.data.frame(get_call_json$results)
  
}

# Now that we have our function, I’m going to use it to pull the 
#first page of results by setting max_id to zero.
#Once we’ve got that, we can create a list with our first page of 
#results as the first item. I can then use a while loop to continually 
#hit the API and append each new page to the list. The loop will run while 
#the number of rows in a page is equal to 200. 
#The last page of results will have less than 200 rows, 
#and the loop will stop running. 
#I’ve also told it to print the page number so I can see how 
#it’s progressing, although I won’t print all that output in this post.

# get the first page
obs <- get_obs(max_id = 3)

max_id <- max(obs[["id"]])
thisisalist <- list(page_1 = obs)
page <- 1

while (nrow(obs) == 200) {
  Sys.sleep(0.5)
  page <- page + 1
  page_count <- paste("page", page, sep = "_")
  obs <- get_obs(max_id = max_id)
  thisisalist[[page_count]] <- obs
  max_id <- max(obs[["id"]])
  print(page_count)
  print(max_id)
}

# We can now bind all the elements of the list into one big dataframe and explore.

thisisnotalist <- bind_rows(thisisalist)
dim(thisisnotalist)

## [1] 21836   160

# There are a lot of different variables! I’m interested in observed_on.
#Let’s convert it to date format and do some quick overview plots.

thisisnotalist %>%
  mutate(observed_on_date = as.Date(observed_on, "%Y-%m-%d"),
         day_of_year = as.numeric(strftime(observed_on_date,
                                           format = "%j")) ) -> df_g01obs

#nrow(df_g01obs)

lst_tx_gobs[[i]] <- df_g01obs
i<- i+1

}
df_g03bs <- bind_rows(lst_tx_gobs, .id = "spc_no")
df_g01obs <- df_g03bs

# set_nelat= 59.5
# set_nelng= 17
# set_swlat= 53
# set_swlng= 7
#limit data frame
# df_g01obs <- df_g01obs[(df_g01obs$dec_lon >= (set_swlng-2)),]
# df_g01obs <- df_g01obs[(df_g01obs$dec_lon <= (set_nelng+2)),]
# df_g01obs <- df_g01obs[(df_g01obs$dec_lat <= (set_nelat+2)),]
# df_g01obs <- df_g01obs[(df_g01obs$dec_lat >= (set_swlat-2)),]

#lst_tx_gobs
# df_g01obs %>%
#   ggplot(aes(x = observed_on_date)) +
#   geom_bar(color = "#264653") +
#   scale_x_date(date_breaks = "1 year", date_labels = "%Y") +
#   labs(x = "Day observed")

# The number of observations recorded has increased each year, probably 
#due to iNaturalist gaining popularity. There are 
#also many more observations in the summer months than in the winter. 
#We can get a better look at this pattern plotting by month.

# df_g01obs %>%
#   filter(observed_on_details.year < 2021) %>% # we don't have the full data for this yr
#   ggplot(aes(x= as.factor(observed_on_details.month))) +
#   geom_bar(fill = "grey90", color = "#264653") +
#   labs(x= "Month observed")

# There’s a peak in April with observations slowly dropping throughout the year. I didn’t quite expect that. I would have assumed that observations of flowering plants would be relatively flat from April to August as different plants come into flower at different points throughout the spring and summer. Perhaps this is due to some kind of sampling bias in how people are recording observations. Let’s have a look at which plants are the first to flower.

# df_g01obs %>%
#   group_by(taxon.name, taxon.preferred_common_name) %>%
#   summarise(median_day = median(day_of_year), n_obs = n()) %>%
#   ungroup() %>%
#   # filter to sp with more than 20 observations
#   # to make sure we get a representitive sample size
#   filter(n_obs > 20) %>%
#   slice_min(order_by = median_day, n = 15) %>%
#   knitr::kable()

# taxon.name	taxon.preferred_common_name	median_day	n_obs
# 
# I always think of Crocus coming up first, along with Snowdrops, 
# so it’s reassuring to see them high up on this list. 
#I think it would be nice to get a visualisation of the
#emergence of different flowers with the changing seasons. 
#I’m going to choose a few which I know emerge fairly sequentially: 
#Snowdrops (genus = Galanthus), Crocus, Daffodils (Narcissus), 
#Hyacinths (Hyacinthoides), Iris, and finally Cyclamen, which 
#flowers through the winter.
# 
# I have to do some fiddling around here with dates to get the x axis labels how I want them. I’m going to change the year for every observation to be 2020, so that data from different years can be grouped together. I also use floor_date from {lubridate} to round dates to the week they were observed. e.g. Tuesday 6th and Thursday 8th would both be rounded down to Sunday 4th. This allows me to plot by week and label by month.

library("lubridate")
# 
# df_g01obs %>%
#   filter(str_detect(taxon.name, "bigibbus") |
#            str_detect(taxon.name, "sydneyanus") |
#            str_detect(taxon.name, "vaigiensis")|
#            str_detect(taxon.name, "sectatrix")|
#            str_detect(taxon.name, "gladius")|
#            str_detect(taxon.name, "cinerascens")) %>%
#   separate(taxon.name, into = c("genus", "sp"), sep = " ") %>%
#   mutate(date = as.Date(paste(2020, strftime(observed_on, format = "%m-%d"),
#                               sep="-")) ) %>%
#   mutate(week = floor_date(date, "week")) %>%
#   #ggplot(aes(x= week, fill = genus)) +
#   ggplot(aes(x= week, fill = sp)) +
#   geom_bar(position = "fill") +
#   scale_x_date(date_breaks = "1 month",  expand = c(0,0),
#                date_labels = "%B", limits = as.Date(c("2020-01-01", "2020-12-31"))) +
#   coord_polar() +
#   scale_fill_manual(
#     values = c("#264653", "#2A9D8F", "#8AB17D",
#                "#E9C46A", "#F4A261", "#E76F51")) +
#   theme_void(base_size = 9)

# I feel like this is a really nice one to use coord_polar() for. You can see how the months blend into each other, without a break at Dec/Jan. Narcissus flowering phenology is well represented here, you can see how it steadily increases to a peak and then dips down again.
# 
# But ok, what about if you live in Edinburgh, are you going to see Daffs on the same day as people in London? Maybe we can see how geography affects flowering observations.
# 
# We want {sf} to work with spatial features, {rnaturalearthdata} to get a map of the UK, {rnaturalearth} for functions to work with that data and, for fun, {gganimate}.



#_______________________________________________________________________________
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
  install.packages("rnaturalearthhires", repos = "http://packages.ropensci.org", 
                   type = "source")
  # if the download fails via Rstudio. Then try swithcing to a terminal, 
  #and download from here
  # http://packages.ropensci.org/src/contrib/rnaturalearthhires_0.2.0.tar.gz
  # and then install the package from this local zip file
  # Like this: https://stackoverflow.com/questions/39410148/timeout-r-package-installation-from-github#39410332
  #  zipfile <- "/home/hal9000/Documents/shrfldubuntu18/inaturalist_in_R/rnaturalearthhires_0.2.0.tar.gz"
  #  install.packages(zipfile, repos = NULL, type="source")
  
  
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
#______________________________________________________________________________

#split the column in genus and species name
df_loc <- data.frame(do.call('rbind', strsplit(as.character(df_g01obs$location),',',fixed=TRUE)))
# ass back to original data frame with mock species and colors
df_g01obs$dec_lat <- as.numeric(df_loc$X1) #latitude - north south position
df_g01obs$dec_lon <- as.numeric(df_loc$X2) # longitude - east- west position

# Replace species names to make species names from iNaturalist match species 
# names in 'DNA og Liv' Amphibian study that follows
# the taxonomy and nomenclature of Spreybock et al. (2010) and Dubois and Bour (2020).
# Speybroeck, J., Beukema, W, Crochet, P.-A., 2010. A tentative species list of the European herpetofauna (Amphibia and Reptilia) — an update. Zootaxa 2492, 1–27
# Dubois, A., Bour, R., 2010. The nomenclatural status of the nomina of amphibians and reptiles created by Garsault (1764), with a parsimonious solution to an old nomenclatural problem regarding the genus Bufo (Amphibia, Anura), comments on the taxonomy of this genus, and comments on some nomina created by Laurenti (1768). Zootaxa 2447, 1–52
df_g01obs$taxon.name <- gsub("Lissotriton vulgaris vulgaris","Lissotriton vulgaris",df_g01obs$taxon.name)
df_g01obs$taxon.name <- gsub("Bufotes viridis","Bufo viridis",df_g01obs$taxon.name)
df_g01obs$taxon.name <- gsub("Pelophylax kurtmuelleri","Pelophylax ridibundus",df_g01obs$taxon.name)
df_iNDL02$taxon.name <- gsub("Pelophylax kl.","Pelophylax kl. esculenta",df_iNDL02$taxon.name)
df_g01obs$taxon.name <- gsub("Pelophylax esculentus","Pelophylax kl. esculenta",df_g01obs$taxon.name)
#change species names

#also split column with tax names
df_spc <- data.frame(do.call('rbind', strsplit(as.character(df_g01obs$taxon.name),' ',fixed=TRUE)))
# ass back to original data frame with mock species and colors
df_g01obs$tax.genus <- df_spc$X1 #add back genus
df_g01obs$tax.species <- df_spc$X2 #add back species
#unique(df_g01obs$tax.species)
#unique(df_g01obs$tax.genus)
# add a level of jitter for points
jitlvl <- 0.017


df_g01obs <- df_g01obs[(df_g01obs$dec_lon >= (set_swlng-2)),]
df_g01obs <- df_g01obs[(df_g01obs$dec_lon <= (set_nelng+2)),]
df_g01obs <- df_g01obs[(df_g01obs$dec_lat <= (set_nelat+2)),]
df_g01obs <- df_g01obs[(df_g01obs$dec_lat >= (set_swlat-2)),]

#copy the data frame
df_g02obs <- df_g01obs
#df_g02obs$tax.species <- gsub("Mnemiopsis","leidyi" ,df_g02obs$tax.species )
#unique(df_g02obs$tax.species)
df_g02obs$taxon.name <- paste(df_g02obs$tax.genus,df_g02obs$tax.species, sep=" ")
#df_g02obs$taxon.name <- gsub("Mnemiopsis","Mnemiopsis leidyi" ,df_g02obs$taxon.name )
#unique(df_g02obs$taxon.name)
# or use this line to subset the data frame
#df_g02obs <- df_g01obs[(df_g01obs$tax.genus=="Kyphosus"),]
#but subset again to exclude rows where the species identity was determined as
# the same genus
#df_g02obs <- df_g02obs[(!df_g02obs$tax.species=="Kyphosus"),]
#check you removed all occurences of the genus name in the species name column
#unique(df_g02obs$tax.species)
#make a colr ramp function over a set of colors
colfunc <- colorRampPalette(c("yellow","green","blue","purple", "black"))
# count the number of unique genera
nbg <- length(unique(df_g02obs$tax.genus))
# count the number of unique species
nbg <- length(unique(df_g02obs$taxon.name))
#apply the color ramp function on the number of elements to
# produce a set of colours equal to the length of the vector, but with
# a colour ramp over the colors defined in the colorRampPalette 
cl_nbg <- colfunc(nbg)


milo <- min(df_g02obs$dec_lon)
mila <- min(df_g02obs$dec_lat)
mxlo <- max(df_g02obs$dec_lon)
mxla <- max(df_g02obs$dec_lat)



#try defining your own bounding box
set_nelat= 58
set_nelng= 15.4
set_swlat= 54.4
set_swlng= 8
# use a defined box to prepare the map
mxla <- set_nelat
mxlo <- set_nelng
mila <- set_swlat
milo <- set_swlng


#______________________<________________________________________________________
p03 <- 
  ggplot(data = world) +
  #ggplot(sf_transform(data = world, 4326)) +
  geom_sf(color = "black", fill = "azure3", lwd =  0.14) +
  #https://ggplot2.tidyverse.org/reference/position_jitter.html
  # use 'geom_jitter' instead of 'geom_point' 
  geom_jitter(data = df_g02obs, 
              aes(x = dec_lon, y = dec_lat,
                  fill=taxon.name,
                  color=taxon.name,
                  shape=taxon.name,
                  lwd =  0.5),
              
              width = jitlvl, #0.07, jitter width 
              height = jitlvl, #0.07, # jitter height
              size = 3) +
  #manually set the pch shape of the points
  scale_shape_manual(values=c(rep(21,length(unique(df_g02obs$taxon.name))))) +
  #set the color of the points
  #here it is black, and repeated the number of times
  #matching the number of species listed
  scale_color_manual(values=c(rep("black",
          length(unique(df_g02obs$taxon.name))))) +
  #set the color of the points
  #use alpha to scale the intensity of the color
  scale_fill_manual(values=alpha(
    c(cl_nbg),
    c(0.7)
  ))+
  # # use the boundaries used for getting the data from inaturalist
  # to set the limits of the plot area
  ## nelat=62.24410751082821&
  ## nelng=85.06445707306858&
  ## swlat=30.25283706916566&
  ## swlng=-42.552730426931404&
  ## define limits of the plot
  ggplot2::coord_sf(xlim = c((milo-1), (mxlo+1)),
                    ylim = c((mila-1), (mxla+1)), 
                    expand = FALSE)
#see the plot
#wd00 <- "/home/hal9000/Documents/shrfldubuntu18/inaturalist_in_R"
#wd00_wd09
#getwd()
setwd(wd00_wd09)
p03

p01 <- p03
#
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
noofspcsnms <- length(unique(df_g01obs$tax.species))
# https://github.com/tidyverse/ggplot2/issues/3492
#repeat 'black' a specified number of times
filltxc = rep("black", noofspcsnms)
#filltxc[10] <- "red"
# Label appearance ##http://www.cookbook-r.com/Graphs/Legends_(ggplot2)/
p01t <- p01t + theme(legend.text = element_text(colour=filltxc, size = 10, face = "italic"))
p01t
# ------------- plot Combined figure -------------
library(patchwork)
# set a variable to TRUE to determine whether to save figures
bSaveFigures <- T
#getwd()
#define a filename to save to
fnm02 <- "out08_03a_map_inaturalist_records"
#see this website: https://www.rdocumentation.org/packages/patchwork/versions/1.0.0
# on how to arrange plots in patchwork
p <-  p01t +
  #p02t +
  #p03t +
  
  plot_layout(nrow=1,byrow=T) + #xlab(xlabel) +
  plot_layout(guides = "collect") +
  plot_annotation(caption=fnm02) #& theme(legend.position = "bottom")
#p
#make filename to save plot to
figname02 <- paste0(fnm02,".pdf")

if(bSaveFigures==T){
  ggsave(p,file=figname02,
         #width=210,height=297,
         width=297,height=210,
         units="mm",dpi=300)
}

if(bSaveFigures==T){
  ggsave(p,file=figname02,
         #width=210,height=297,
         width=297,height=210,
         units="mm",dpi=600)
}
#define output flie name
outfl1 = "out08_03b_inaturalist_records_amphibia_Denmark.csv"
# paste together path and input flie
pthoutf01 <- paste0(wd00_wd09,"/",outfl1)
#make sure all columns are characters
#https://stackoverflow.com/questions/24829027/unimplemented-type-list-when-trying-to-write-table
df_g03obs <- apply(df_g02obs,2,as.character)
#make the matrix a data frame
df_g03obs <- as.data.frame(df_g03obs)
#define columns to keep
keep <- c("dec_lat",
          "dec_lon",
          "tax.genus",
          "tax.species",
          "taxon.name",
          "taxon.endemic",
          "observed_on_details.date",
          "user.activity_count",
          "user.species_count",
          "user.universal_search_rank",
          "user.spam" ,
          "user.suspended",
          "quality_grade",
          "identifications_most_agree",
          "identifications_most_disagree",
          "identifications_some_agree",
          "reviewed_by",
          "num_identification_agreements",
          "num_identification_disagreements",
          "owners_identification_from_vision",
          "identifications_count",
          "obscured",
          "project_ids_with_curator_id",
          "project_ids_without_curator_id"
          )
#only keep columns selected above
df_g04obs <- df_g03obs[keep]
# use tab as separator
write.table(df_g04obs, file=pthoutf01, sep=";",
            row.names = F) # do not use row names

#______________________________________________________________________________

#