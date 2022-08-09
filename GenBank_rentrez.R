#/usr/bin/env Rscript
# Author: JLinares/08/2022
#       Usage: Getting SARS-CoV-2 fasta sequences from NCBI/GenBank/nuccore for a specific time window excluding samples from the UPHL
#       Parameters: time-window. ie: Rscript /. . . ./GenBank_Rentrez.R 220705 220708
library("easypackages");libraries("ape","rbin","rentrez","lubridate")
options(timeout = 10000, "width"=300)
args = commandArgs(trailingOnly=T);date1<-ymd(substr(args[1], 1, 6));date2<-ymd(substr(args[2], 1, 6))
days<-seq(ymd(date1), ymd(date2), by="days"); days
cat(" Number of days in analysis ",length(days)," days  ","\n")
base<-"HUMAN AND UT AND(UT-CDC OR INTERMOUNTAIN) AND (COLLECTION_DATE="
ids<-vector(); Records<-0;
cat(" Please wait, searching the NCBI/nuccore DB","\n")
# searching NCBI/nuccore DB 
for (i in 1:length(days)){
  r_search <- entrez_search(db="nuccore", term= paste(base,days[i],sep = ""))
  Records<-c(Records, r_search$ids)
  }
Records<-Records[2:length(Records)]
cat(" Number of samples retrived excluding UHPL samples ", length(Records),"\n")
Records<-as.character(Records);Records
cat("Please wait, downloading/storing ", length(Records), "fasta sequences","\n")
# downloading/storing fasta sequences
seqq<-read.GenBank(Records, seq.names = Records, species.names = T,as.character = T, chunk.size = 200, quiet = TRUE)
write.dna(seqq, paste("GenBank_fasta_",ymd_hms(Sys.time()),".fasta",sep = ""), format = "fasta")
cat(paste("Sequences stored at:",getwd(),paste("GenBank_fasta_",ymd_hms(Sys.time()),".fasta",sep = ""),sep=" "),"\n")
