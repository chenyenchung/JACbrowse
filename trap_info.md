## TRAP-seq

TRAP stands for **t**ranslating **r**ibosome **a**ffinity **p**urification, which is based on pulling down epitope-tagged version of ribosomal protein and profile its associated mRNAs. This dataset comes from a 2017 paper from Yoo Lab, and the raw data could be downloaded [here](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE93412) at GEO Dataset.

Briefly, they used _SNAP25_ promoter (for all neuronals) or _ChAT_ promoter to drive EGFP-tagged Rpl10a (Tg(Chat- EGFP/Rpl10a)DW167Htz), and the result should reflect the actively translated mRNAs in p21 spinal cord sections.

The output here is presented in two ways, first is raw CPM value for each dataset, and an traslation enrichment score ( a ratio of TRAPseq/PreIPseq).

> Abernathy, D. G. et al. [MicroRNAs Induce a Permissive Chromatin Environment that Enables Neuronal Subtype-Specific Reprogramming of Adult Human Fibroblasts](http://linkinghub.elsevier.com/retrieve/pii/S193459091730320X). Cell Stem Cell 21, 332–348.e9 (2017).
