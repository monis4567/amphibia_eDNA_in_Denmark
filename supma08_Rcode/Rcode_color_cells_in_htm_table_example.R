library(htmlTable)
library(tidyr)
library(dplyr )
# make ex ddf
  le <- c(letters[1:4])
  r1 <- round(rnorm(1:4,2),1)
  r2 <- seq(1,8,2)
  r3 <- round(rnorm(1:4,0.2),1)
  r4 <- round(rnorm(1:4,0.01),1)
  d1 <- as.data.frame(cbind(r1,r2,r3,r4))
  rownames(d1) <- le
  colnames(d1) <- le
  # re arrange
  d2 <- d1 %>%
    tibble::rownames_to_column() %>%
    tidyr::gather(colname, value, -rowname)
  # make heat map
  ggplot(d2, aes(x = rowname,
                 y = colname,
                 fill = value)) +
    geom_tile()
#https://cran.r-project.org/web/packages/htmlTable/vignettes/general.html
mdlo <- as.matrix(d1)
mdlo %>%
    addHtmlTableStyle(align = "r") %>%
    htmlTable

library(htmlTable)

mdlo <- as.matrix(d1)

nr <- nrow(mdlo)
nc <- ncol(mdlo)

# normalize values to a scale from 0 to 1
minval <- min(mdlo)
maxval <- max(mdlo)
valuesnorm <- mapply(function(x) (x-minval)/(maxval-minval), t(mdlo))

# set up colour scale using default ggplot palette
colscale<-scale_fill_continuous()

# alternative palettes
# note that we only need to define colscale once - comment out the ones you don't want
library(scico)
library(paletteer)
colscale <- scale_fill_paletteer_c(palette="scico::tokyo", direction = 1)
#colscale <- scale_fill_paletteer_c(palette="pals::kovesi.linear_kryw_5_100_c64", direction = 1)

# get colour values corresponding to normalized values in matrix
colourhtmlvalues <- colscale$palette(valuesnorm)
# add necessary html around each colour value
colourhtmlvalues <- paste0("background-color:",colourhtmlvalues ,";")
# convert back to matrix
colourhtmlvalues <- t(matrix(data=colourhtmlvalues,nrow=nr,ncol=nc))
# we now have colour codes for the cells containing values
# make a matrix the size of the table including headers and row names
ncells <- (nc+1)*(nr+1)
colourhtml <- rep("background-color:transparent;",ncells)
# or use for example: "background-color:#FFFFFF;"
colourhtml <- t(matrix(data=colourhtml,nrow=nr+1,ncol=nc+1))
# replace the values part of the table with the html for the colours
colourhtml[2:(nr+1),2:(nc+1)]<-colourhtmlvalues
# show the table
mdlo %>%
  
  addHtmlTableStyle(align = "r") %>%
  
  addHtmlTableStyle(css.cell = colourhtml) %>%
  htmlTable
  