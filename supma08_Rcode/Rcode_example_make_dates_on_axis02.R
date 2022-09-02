#remove everything in the working environment, without a warning!!
#rm(list=ls())

library(lubridate)
library(tidyverse)
library(scales)

# ----------------get some data -----------------------------------------------

set.seed(49)
nobs = 600
ngroups = 6

# normally distributed day numbers
daynos <- rnorm(nobs,mean=160,sd=40)

# uniformly distributed years
years <- as.integer(runif(nobs, min=2010,2022))

# dates from years and day numbers
dates <- as.Date(ymd(paste0(years,"-01-01"))) + daynos

# groups
groups = (rep_len(1:ngroups,length.out=nobs))
groups = factor(paste0("Grp",groups))

# create data frame
df <- data.frame(group=groups,dayno=daynos,date=dates)


# -------- make data for date labels  ------- 

refdates <- c("2022-05-01","2022-07-01","2022-09-01")
refdates <- as_date(refdates)

df_labels <- data.frame(date=refdates)  %>%
  mutate(dayno=yday(date),
         datelabel=format(date, format = "%d-%b")) %>%
  mutate(x0=0.52) 

# -------- make data for tiles (coloured bars)  ------- 

# cutoff day for two periods 

day_cutoff <- 195

# assign period according to dayno
df_tile <- df %>% 
  mutate(period=ifelse(dayno<day_cutoff,"Hatching","Mating"))

# find the average dayno for each group / "aquatic period" combination 
df_stat <- df_tile %>%
  group_by(group,period) %>%
  summarise(avg=mean(dayno,na.rm=T),sd=sd(dayno,na.rm=T),.groups="drop")

# convert period to a factor
df_stat$period <- factor(df_stat$period,levels=c("Hatching","Mating"))

# a sequence of all day nos used to make tile data
daynos_norm <- data.frame(dayno=seq(floor(min(df$dayno,na.rm=T)),ceiling(max(df$dayno,na.rm=T)),1))


# cutoff nvalues below a threshold
cutoff = 0.2

# cartesian join of daynos and the group / period combinations
# for each group (species) and aquatic period we will create a normally distributed 
# variable and calculate the probability distribution function at each day in the dayno sequence
df_tile <- df_stat %>% 
  merge(daynos_norm,all=T) %>%
  mutate(n=dnorm(dayno,avg,sd)/dnorm(avg,avg,sd)) %>%
  mutate(n=n^2) %>% # denne kvadratfunktion tydeliggør de høje værdier - prøv uden for at se hvad jeg mener
  filter(n>=cutoff) 

# this cutoff is artificially high to ensure that this
# test shows a gap between the two periods

#_______________________________________________________________________________
# Make dummy period data by SWK -  start
#_______________________________________________________________________________
# -------- make period data for hatching and mating  ------- 
# get group names
grpNm <- unique(df$group)
# get number of groups
nGr <- length(grpNm)
# get years for the groups -  for this data frame the exact year is unimportant
years_p <- years[1:nGr]
# normally distributed day numbers for 
# hatch start date, hatch end date
# mating start date, mating end date
dayn.hs <- rnorm(nGr,mean=60,sd=20)
dayn.he <- rnorm(nGr,mean=140,sd=10)
dayn.ms <- rnorm(nGr,mean=200,sd=10)
dayn.me <- rnorm(nGr,mean=280,sd=10)
# make dates from years and day numbers
dates.hs <- as.Date(ymd(paste0(years_p,"-01-01"))) + dayn.hs
dates.he <- as.Date(ymd(paste0(years_p,"-01-01"))) + dayn.he
dates.ms <- as.Date(ymd(paste0(years_p,"-01-01"))) + dayn.ms
dates.me <- as.Date(ymd(paste0(years_p,"-01-01"))) + dayn.me
# use 'cbind.data.frame' instead of 'cbind'
# https://stackoverflow.com/questions/8944525/cbind-is-changing-date-formatting
# to get data frame with aquatic periods 
df_aqp <- cbind.data.frame(grpNm,
  dates.hs,
  dates.he,
  dates.ms,
  dates.me)
# Now 'df_aqp' resembles an input data file example, i.e. a data frame
# that comes from a file read, that has been read  in to R
# Proceed by transforming this data frame in order to 
# get day number of the year for hatching period start (hps) and end (hpe)
# and for mating period start (mps) and end (mpe)
df_aqp$hps.dn <- lubridate::yday( as.Date(df_aqp$dates.hs,tryFormats=c("%d-%m-%y")))
df_aqp$hpe.dn <- lubridate::yday( as.Date(df_aqp$dates.he,tryFormats=c("%d-%m-%y")))
df_aqp$mps.dn <- lubridate::yday( as.Date(df_aqp$dates.ms,tryFormats=c("%d-%m-%y")))
df_aqp$mpe.dn <- lubridate::yday( as.Date(df_aqp$dates.me,tryFormats=c("%d-%m-%y")))
# get the mean dayNumber per period by using the hatching period start day no amd the
# hatching period end day no 
df_aqp$hp.m.dn <- rowMeans(df_aqp[,c('hps.dn', 'hpe.dn')], na.rm=TRUE)
# get the mean dayNumber per period by using the mating period start day no amd the
# mating period end day no 
df_aqp$mp.m.dn <- rowMeans(df_aqp[,c('mps.dn', 'mpe.dn')], na.rm=TRUE)
# also get the standard deviation around the meand day numbers
df_aqp$hp.sd.dn <- df_aqp$hp.m.dn-df_aqp$hps.dn
df_aqp$mp.sd.dn <- df_aqp$mp.m.dn-df_aqp$mps.dn
# use tidyr to rearrange from wide to long
df_aqp2 <- df_aqp %>% 
  pivot_longer(
    cols = starts_with(c("mp.","hp.")), 
    names_to = "periodName", 
    values_to = "dayNumb",
    values_drop_na = TRUE
  )
# define columns to keep
colkeep <- c("grpNm","periodName","dayNumb")
# only keep specified columns
df_aqp2 <- df_aqp2[colkeep]
# get the second element, which denotes the 'sd' or the 'mean'
df_aqp2$perEval <- gsub("^(.*)\\.(.*)\\.(.*)","\\2",df_aqp2$periodName)
# subsitute to get the first element - which is the abbreviation for the mating
# hactching period
df_aqp2$periodName <- gsub("^(.*)\\.(.*)\\.(.*)","\\1",df_aqp2$periodName)
# make the tibble wide
df_aqp3 <- df_aqp2 %>% 
  pivot_wider(names_from = perEval, values_from = dayNumb)
# substitute to get long period name categories
df_aqp3$periodName <- gsub("mp","mating",df_aqp3$periodName)
df_aqp3$periodName <- gsub("hp","hatching",df_aqp3$periodName)
# cartesian join of daynos and the group / period combinations
# for each group (species) and aquatic period we will create a normally distributed 
# variable and calculate the probability distribution function at each day in the dayno sequence
df_tile3 <- df_aqp3 %>% 
  merge(daynos_norm,all=T) %>%
  mutate(n=dnorm(dayno,m,sd)/dnorm(m,m,sd)) %>%
  mutate(n=n^2) %>% # denne kvadratfunktion tydeliggør de høje værdier - prøv uden for at se hvad jeg mener
  filter(n>=cutoff) 
#replace column name to make the 'group' name match with the 'df' data frame
colnames(df_tile3)[1] <- c("group")



# a sequence of all day nos used to make tile data
daynos_norm <- data.frame(dayno=seq(floor(min(df_aqp$hps.dn,na.rm=T)),
                                    ceiling(max(df_aqp$mpe.dn,na.rm=T)),1))
# add evaluation of sample in df
# first count number of rows
cobs <- nrow(df) 
set.seed(1) # random number will generate from 1
# generate random evaluation
df$eval <- ceiling(runif(cobs, min=0, max=2))
# substitute in  evaluation
df$eval[df$eval==1] <- "eDNA_absent"
df$eval[df$eval==2] <- "eDNA_present"
#Get evaluation categories
ev03.1 <- df$eval
ev03.1 <- as.factor(ev03.1) 
# get unique categories
eval03.cat <- unique(ev03.1)
# set colors for categories of eDNA evaluations
colsfeval <- c("white","green")
#bind together as columns in a data frame
df_colsfeval<- cbind.data.frame(eval03.cat,colsfeval)
# use this data frame to look up the colors for the eDNA evaluations
eval03.col<- df_colsfeval$colsfeval[match(ev03.1,df_colsfeval$eval03.cat)]
#_______________________________________________________________________________
# Make dummy period data by SWK -  end
#_______________________________________________________________________________

# -------- plot  1 ------- 

# different colours for each period
pal_period <- c("#CC6666", "#66CC99") 
# set day interval for geom_tile
dayinterval = 1 
# alpha indicates the tiled values from normal distributions
ggplot(df, aes(x=group, y=dayno)) +
  geom_point(position=position_jitter(width=0.2, height=0.1),
             size=3, shape=21,fill=NA,colour="#000000",alpha=0.3) +
  geom_boxplot(outlier.colour=NA, fill=NA, width=0.35)  +
  geom_tile(data=df_tile,aes(width=0.15,height=dayinterval,fill=period,alpha=n), 
            position=position_nudge(x=-0.35), show.legend=F) +
  scale_fill_manual(values=pal_period) +
  scale_alpha_continuous(range=c(0,0.6)) +
  coord_flip() +
  geom_hline(data=df_labels,
               aes(yintercept=dayno),
               colour="#FF0000",linetype=2) + 
  geom_text(data=df_labels,
            aes(x=x0,y=dayno+2,label=datelabel),
            hjust=0,vjust=1, size=3) +
  theme_classic()

# -------- plot  2 ------- 
# The column called 'group' in the 'df'
# data frame  has to be present and named likewise in the 'df_tile3'
# data frame

# different colours for each period
pal_period <- c("#fcb900", "#827717") 
#pal_period <- c("#CC6666", "#66CC99") 
# set day interval for geom_tile
dayinterval = 1 
# alpha indicates the tiled values from normal distributions
plt13 <- ggplot(df, aes(x=group, y=dayno)) +
  geom_tile(data=df_tile3,aes(width=0.85,height=dayinterval,fill=periodName,alpha=n), 
            position=position_nudge(x=-0.05), show.legend=F) +
  geom_point(aes(fill=eval),position=position_jitter(width=0.2, height=0.1),
             size=3, shape=21,colour="#000000",alpha=0.6) +
  geom_boxplot(outlier.colour=NA, fill=NA, width=0.35)  +
  # manual fill scale applies to colored hatch-mate period 
  scale_fill_manual(values=c(colsfeval,pal_period)) +
  scale_alpha_continuous(range=c(0,0.6)) +
  coord_flip() +
  # reverse the order of categories on the discrete scale
  # https://stackoverflow.com/questions/28391850/reverse-order-of-discrete-y-axis-in-ggplot2
  # reverse the categories
  scale_x_discrete(limits=rev) +
  # make the species names along the axis italic
  theme(axis.text.y = element_text(angle = 0, hjust = 1, face = "italic", size=12)) +
  theme(axis.text.x = element_text(angle = 0, size=14)) +
  geom_hline(data=df_labels,
             aes(yintercept=dayno),
             colour="#FF0000",linetype=2) + 
  geom_text(data=df_labels,
            aes(x=x0,y=dayno+2,label=datelabel),
            hjust=0,vjust=1, size=3)# +
  #theme_classic()
#see the plot
plt13





