args <- commandArgs(trailingOnly = TRUE)
input_dir <- args[1]
output_dir <- args[2]

source("https://raw.githubusercontent.com/BHKLAB-Pachyderm/ICB_Common/main/code/Get_Response.R")

clin = read.csv( file.path(input_dir, "CLIN.txt"), stringsAsFactors=FALSE , sep="\t" )
clin = cbind( clin[ , c( "PATIENT_ID","HISTOLOGY","AGE","SEX","PFS_MONTHS","EVENT_TYPE","TREATMENT_BEST_RESPONSE" ) ] , "Lung", "PD-1/PD-L1", NA , NA , NA , NA , NA , NA , NA )
colnames(clin) = c( "patient" , "histo" , "age" , "sex"  ,"t.pfs" , "pfs" ,"recist" , "primary", "drug_type" , "os" , "t.os" , "stage" , "dna" , "rna" , "response.other.info" , "response")

clin$recist[ clin$recist %in% "POD" ] = "PD" 
clin$pfs = ifelse(clin$pfs %in% "Progression-free Survival" , 1 , 0)
clin$response = Get_Response( data=clin )

clin$sex = ifelse(clin$sex %in% "Female" , "F" , "M")

case = read.csv( file.path(output_dir, "cased_sequenced.csv"), stringsAsFactors=FALSE , sep=";" )
clin$dna[ clin$patient %in% case[ case$snv %in% 1 , ]$patient ] = "wes"

clin = clin[ , c("patient" , "sex" , "age" , "primary" , "histo" , "stage" , "response.other.info" , "recist" , "response" , "drug_type" , "dna" , "rna" , "t.pfs" , "pfs" , "t.os" , "os" ) ]

write.table( clin , file=file.path(output_dir, "CLIN.csv") , quote=FALSE , sep=";" , col.names=TRUE , row.names=FALSE )

