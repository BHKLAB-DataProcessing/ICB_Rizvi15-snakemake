# wget -O /Users/minorunakano/Documents/ICBCuration/data_source/Rizvi15/luad_mskcc_2015.tar.gz https://cbioportal-datahub.s3.amazonaws.com/luad_mskcc_2015.tar.gz
library(R.utils)

args <- commandArgs(trailingOnly = TRUE)
work_dir <- args[1]

untar(file.path(work_dir, 'luad_mskcc_2015.tar.gz'), exdir = work_dir)

# CLIN.txt
clin <- read.csv( file.path(work_dir, "luad_mskcc_2015", 'data_clinical_patient.txt'), stringsAsFactors=FALSE , sep="\t" )
colnames(clin) <- clin[4, ]
clin <- clin[-c(1:4), ]
clin <- clin[!is.na(clin$HISTOLOGY), ]
rownames(clin) <- c(1:nrow(clin))
write.table( clin , file=file.path(work_dir, 'CLIN.txt') , quote=FALSE , sep="\t" , col.names=TRUE , row.names=FALSE )

# CLIN_sample.txt
clin_sample <- read.csv( file.path(work_dir, "luad_mskcc_2015", 'data_clinical_sample.txt'), stringsAsFactors=FALSE , sep="\t" )
colnames(clin_sample) <- clin_sample[4, ]
clin_sample <- clin_sample[-c(1:4), ]
clin_sample <- clin_sample[clin_sample$PATIENT_ID != 'R7495_2', ]
write.table( clin_sample , file=file.path(work_dir, 'CLIN_sample.txt') , quote=FALSE , sep="\t" , col.names=TRUE , row.names=FALSE )

# SNV.txt.gz
snv <- read.csv(file.path(work_dir, "luad_mskcc_2015", 'data_mutations.txt'), stringsAsFactors=FALSE , sep="\t")
gz <- gzfile(file.path(work_dir, 'SNV.txt.gz'), "w")
write.table( snv , file=gz , quote=FALSE , sep="\t" , col.names=TRUE , row.names=FALSE )
close(gz)

# To DO
# Download and process CNA data gistic file

file.remove(file.path(work_dir, 'luad_mskcc_2015.tar.gz'))
unlink(file.path(work_dir, "luad_mskcc_2015"), recursive = TRUE)