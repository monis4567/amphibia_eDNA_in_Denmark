library(dplyr)
# copy a data frame
mtcars2 <- mtcars
set.seed(34)
# add an empty column to add evaluations to
mtcars2$eval <- NA
# copy columns to serve as positive control (pk) and negative control (nk)
# this name change is only to help me out using this example afterwards
mtcars2$pk <- mtcars2$vs
mtcars2$nk <- mtcars2$am
# # in my own dataset these can go from 0 to 50, with a large proportion being 0
mtcars2$pk <- mtcars2$pk*runif(nrow(mtcars2),0,50)
mtcars2$nk <- mtcars2$nk*runif(nrow(mtcars2),0,50)
# make evaluations 
# evaluate for pk and for nk
# if 'pk' is equal to zero or 'nk' is above zero the evaluation  is a 'Non Approved Control' i.e. 'napK'
mtcars2$eval[which(mtcars2$pk==0 | mtcars2$nk>0)] <- "napK"
# if 'pk' is above zero and 'nk' is equal to zero the evaluation  is a 'true zero detection' i.e. 'tzd'
mtcars2$eval[which(mtcars2$pk>0 & mtcars2$nk==0)] <- "tzd"
# make some sample columns, 
# in my own dataset these can go from 0 to 50, with a large proportion being 0
mtcars2$smpl01 <- round(runif(nrow(mtcars2),0,1),digits=0)*runif(nrow(mtcars2),0,50)
mtcars2$smpl02 <- round(runif(nrow(mtcars2),0,1),digits=0)*runif(nrow(mtcars2),0,50)
mtcars2$smpl03 <- round(runif(nrow(mtcars2),0,1),digits=0)*runif(nrow(mtcars2),0,50)
mtcars2$smpl04 <- round(runif(nrow(mtcars2),0,1),digits=0)*runif(nrow(mtcars2),0,50)

# for each row, n = count of the number of values from smpl01-04 which are >0
# we do this by applying the Boolean function x>0 to each column and then taking the sum
# then determine New_eval based on eval and n
mtcars3 <- mtcars2 %>%
  mutate(n=rowSums(across(c(smpl01,smpl02,smpl03,smpl04), function(x) x>0))) %>%
  mutate(New_eval=ifelse(eval=="tzd",ifelse(n>1,"repl2p",ifelse(n>0,"repl1p",eval)),eval))


# using this example
# https://www.r-bloggers.com/2020/05/r-how-to-assign-values-based-on-multiple-conditions-of-different-columns/
mtcars3 <- mtcars2 %>% dplyr::mutate(New_eval = case_when(
  eval=='tzd' & smpl01>=1 ~ "repl2p",
  eval=='tzd' & smpl02>=1 ~ "repl2p",
  eval=='tzd' & smpl03>=1 ~ "repl2p",
  eval=='tzd' & smpl04>=1 ~ "repl2p",
  TRUE~eval
))



# only retain a couple of columns defined by the column name
mtcars4 <- mtcars3 %>% dplyr::select('eval','pk','nk','smpl01','smpl02','smpl03','smpl04','New_eval')

mtcars4[mtcars4$New_eval=="repl2p",]

#'Merc 280C'  should be "repl1p" instead
#'
mtcars4