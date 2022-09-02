
library(lubridate)
library(tidyverse)
library(scales)

# ----------------get some data -----------------------------------------------

set.seed(49)
nobs = 100
ngroups = 6

# normally distributed day numbers
daynos <- rnorm(nobs,mean=160,sd=40)
# uniformly distributed years
years <- as.integer(runif(nobs, min=2010,2022))
# dates from years and day numbers
dates <- as.Date(lubridate::ymd(paste0(years,"-01-01"))) + daynos
# groups
groups = (rep_len(1:ngroups,length.out=nobs))
groups = factor(paste0("Grp",groups))
# create data frame
df <- data.frame(group=groups,dayno=daynos,date=dates)


# ------------  plot using day no ---------------------------------------------   
ggplot(df, aes(x=group, y=dayno)) +
  geom_point(position=position_jitter(width=0.2, height=0.1)) +
  geom_boxplot(outlier.colour=NA, fill=NA)  +
  coord_flip()

# ------------ plot using "fake" date - convert all dates to the same year ----
fixyear <- as.character(year(max(df$date,na.rm=T)))
df <- df %>%
  mutate(date2 = as_date(str_replace(as.character(date),"^\\d{4}",fixyear)))

ggplot(df, aes(x=group, y=date2)) +
  geom_point(position=position_jitter(width=0.2, height=0.1)) +
  geom_boxplot(outlier.colour=NA, fill=NA)  +
  coord_flip() +
  scale_y_date(labels = date_format("%d-%b"))

# ------------  plot using day no + add reference lines for dates ------------ 

refdates <- c("2022-05-01","2022-07-01","2022-09-01")
refdates <- as_date(refdates)

df_labels <- data.frame(date=refdates)  %>%
  mutate(dayno=yday(date),
         datelabel=format(date, format = "%d-%b")) %>%
  mutate(x0=0.0,x1=0.3) 

ggplot(df, aes(x=group, y=dayno)) +
  geom_point(position=position_jitter(width=0.2, height=0.1)) +
  geom_boxplot(outlier.colour=NA, fill=NA)  +
  coord_flip() +
  geom_segment(data=df_labels,
               aes(x=x0,xend=x1,y=dayno,yend=dayno),
               colour="#FF0000",linetype=2) + 
  geom_text(data=df_labels,
            aes(x=x1,y=dayno+2,label=datelabel),
            hjust=0,vjust=1, size=3)


# -------- plot using day no + add reference lines for dates ALTERNATIVE ------- 

refdates <- c("2022-05-01","2022-07-01","2022-09-01")
refdates <- as_date(refdates)

df_labels <- data.frame(date=refdates)  %>%
  mutate(dayno=yday(date),
         datelabel=format(date, format = "%d-%b")) %>%
  mutate(x0=0.52) 

ggplot(df, aes(x=group, y=dayno)) +
  geom_point(position=position_jitter(width=0.2, height=0.1)) +
  geom_boxplot(outlier.colour=NA, fill=NA)  +
  coord_flip() +
  geom_hline(data=df_labels,
               aes(yintercept=dayno),
               colour="#FF0000",linetype=2) + 
  geom_text(data=df_labels,
            aes(x=x0,y=dayno+2,label=datelabel),
            hjust=0,vjust=1, size=3)

# --------- language for month names ---------------------------
# change locale from danish to english to control how month names are shown

# get current locale for date/time
currentlocale <- Sys.getlocale("LC_TIME") # "Danish_Denmark.1252"

# set locale for date/time to English 
Sys.setlocale("LC_TIME", "English")

# change locale for date/time back to original
Sys.setlocale("LC_TIME", currentlocale)




