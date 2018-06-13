library(dplyr)
library(reshape2)
library(ggplot2)
library(cowplot)
library(magrittr)
library(tidyr)

# Set comment.char because the header of the raw data strats with #
# (Default comment char)
hmc_raw <- read.table(file = "./GSE79561_RNAseq_FPKM_ES_to_MN.txt", header = T,
                  stringsAsFactors = F, comment.char = "")
colnames(hmc_raw)[1] <- "id"
hmc_raw$symid <- paste0(hmc_raw$symbol, " (", hmc_raw$id, ")")

hmc_rawl <- melt(hmc_raw, id.vars = c(1,2,7))

# Normalize with z transformation
hmc_raw_z <- apply(hmc_raw[ , -c(1:2,7)], 1, function(x) {
  # Finding the genes that z-score is all NaN and replace with 0
  if(sum(x) == 0) {return(c(0,0,0,0))}
  
  z <- (x - mean(x))/sd(x)
  return(z)
})
hmc_raw_z <- as.data.frame(t(hmc_raw_z))
names(hmc_raw_z) <- c("Day0", "Day4", "Day5", "Day6")
hmc_raw_z$symbol <- hmc_raw$symbol
hmc_raw_z$id <- hmc_raw$id
hmc_raw_z$symid <- paste0(hmc_raw_z$symbol, " (", hmc_raw_z$id, ")")

hmc_zl <- gather(hmc_raw_z, key = "variable", value = "value", Day0, Day4, Day5, Day6)
