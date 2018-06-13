# Pre-processing
trapseq <- read.csv("GSE93412_gene_counts.csv", header = TRUE, stringsAsFactors = FALSE)
# Normalize to input
normalized <- trapseq[, c(5:10)]/trapseq[, c(11:16)]

# Find the rows that are not a number
row_nan <- apply(normalized, 1, function(x) {
  individual <- sapply(x, function(y) is.nan(y))
  composite <- Reduce(`|`, individual)
  return(composite)
})

row_inf <- apply(normalized, 1, function(x) {
  individual <- sapply(x, function(y) is.infinite(y))
  composite <- Reduce(`|`, individual)
  return(composite)
})

row_rm <- row_nan | row_inf

# Remove the NaN/Inf rows
gene_name <- trapseq$external_gene_name[!row_rm]
normalized <- normalized[!row_rm,]
count <- trapseq[!row_rm,] %>% dplyr::select(., external_gene_name, contains("ip")) %>%
  gather(key = "sample", value = "count", -external_gene_name)
count$ab <- "SNAP25"
count$ab[grep("_21c", count$sample)] <- "ChAT"
count$assay <- "PreIP"
count$assay[grep("postip", count$sample)] <- "TRAP"

# Bind the df for MN (ChAT+) and neuron (SNAP25+)
MN <- normalized[, c(1:3)]
Neuron <- normalized[, c(4:6)]
MN$type <- "MN"
Neuron$type <- "Neuron"
MN$gene <- gene_name
Neuron$gene <- gene_name
colnames(MN) <- c("rep1", "rep2", "rep3", "type", "gene")
colnames(Neuron) <- c("rep1", "rep2", "rep3", "type", "gene")

trap_disp <- rbind(MN, Neuron)
trap_disp <- gather(trap_disp, key = "rep", value = "score", c("rep1", "rep2", "rep3"))
