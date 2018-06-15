library(tidyr)
library(magrittr)

# Load raw data
a4v_table <- read.csv("./dataset/GSE54409_mean_replicate_count_matrix_with_name.csv",
                      header = TRUE, stringsAsFactors = FALSE)
names(a4v_table)[c(2,3)] <- c("SOD1-A4V", "SOD1-WT")
a4v_l <- gather(a4v_table, key = "sample", value = "count", -ensembl_id, -hgnc_symbol)
