library(biomaRt)
raw <- read.table("GSE54409_mean_replicate_count_matrix.txt", header = TRUE,
                  stringsAsFactors = FALSE)

ensembl <- useMart("ensembl",dataset="hsapiens_gene_ensembl")
symbol <- getBM(attributes = c('ensembl_gene_id', "hgnc_symbol"), 
              filters = 'ensembl_gene_id', 
              values = raw$ensembl_id, 
              mart = ensembl)
names(symbol)[1] <- names(raw)[1]

output <- merge(raw, symbol, by = names(raw)[1])
write.csv(output, "GSE54409_mean_replicate_count_matrix_with_name.csv",
          row.names = FALSE)
