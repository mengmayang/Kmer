#!/bin/Rscript
####################################
#usage:                            #
#     Rscript generate_kmer.R k    #
####################################
argv <- commandArgs(TRUE)
k<-as.numeric(argv[1])
e<-c('A','T','C','G')
M<-matrix(c(rep(' ',4^k*k)),ncol=k)
setwd("/export/home/yyqiao/QYY/Project/K-mer/script")
file=paste("k-mer_",k,sep='')

i=0
while(k>0){
  temp<-c(rep(e[1],4^i),rep(e[2],4^i),rep(e[3],4^i),rep(e[4],4^i))
  M[,k]<-c(rep(temp,4^(k-1)))
  i=i+1
  k=k-1
}
N<-c(rep('',nrow(M)))
for(i in 1:nrow(M)){
  for(j in 1:ncol(M)){
    N[i]<-paste(N[i],M[i,j],sep = '')
  }
}

write(N,file=file)

