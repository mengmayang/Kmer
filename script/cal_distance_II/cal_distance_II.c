#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <malloc.h>
#include <math.h>
#include <time.h>
#include <cblas.h>
 main(int argc,char *argv[]){

  char heredoc[]="Usage";
  if(argc<=2){
    printf("%s\n",heredoc);
  }else{
    FILE *fp;
    FILE *fp1;
    FILE *fp2=fopen("Distance.txt", "w");
    time_t timep;
    int nrows=5242;
    int ncols=4097;
    int nrows1=20000;
    int i,j;
    float *countM;
    float *countmeta;
    //printf("input nrows:");
    //scanf("%d",&nrows);
    //printf("input ncols:");
    //scanf("%d",&ncols);
    //printf("%d-%d!\n",nrows,ncols);
    countM=(float*)malloc((nrows-1)*(ncols-1)*sizeof(float));
    countmeta=(float*)malloc((nrows1)*(ncols-1)*sizeof(float));

    if((fp=fopen(argv[1],"r"))==NULL){
      printf("file1 cannot be opened\n");
    }else if((fp1=fopen(argv[2],"r"))==NULL){
      printf("file2 cannot be opened\n");
    }else{
      //For matrix-kmers
      printf("For matrix-kmers:\t");
      time (&timep);
      printf("%s\n",asctime(gmtime(&timep)));
      char strarray[200];
      for(i=0;i<nrows;i++){
        for(j=0;j<ncols;j++){
          fscanf(fp,"%s",strarray);
          if(i>0 && j>0){
            int n=atoi(strarray);
            countM[(i-1)*(ncols-1)+(j-1)]=n;
        }
       }
      }
      fclose(fp);
      
      //For meta-reads
      printf("For meta-reads:\t");
      time (&timep);
      printf("%s\n",asctime(gmtime(&timep)));
      for(i=0;i<nrows1;i++){
        for(j=0;j<ncols;j++){
          fscanf(fp1,"%s",strarray);
          if(j>0){
            float n=atoi(strarray);
            countmeta[i*(ncols-1)+(j-1)]=n;
          }
        }
      }
      fclose(fp1);
    }
    //free(countM);
    //free(countmeta);
    
    //For Distance calculate
    printf("For Distance calculate:\t");
    time (&timep);
    printf("%s\n",asctime(gmtime(&timep)));
    const enum CBLAS_ORDER Oder=CblasRowMajor;
    const enum CBLAS_TRANSPOSE TransA=CblasNoTrans;
    const enum CBLAS_TRANSPOSE TransB=CblasTrans;
    const int M=nrows1;//C row
    const int N=nrows-1;//C col
    const int K=ncols-1;//A col,B col
    
    const float alpha=1;
    const float beta=0;
    const int lda=K;//4096
    const int ldb=K;//5241
    const int ldc=N;
    /*
    float *A;
    float *B;
    
    A=(float*)malloc(M*K*sizeof(float));
    B=(float*)malloc(N*K*sizeof(float));
    
    for(i=0;i<M;i++){
      for(j=0;j<K;j++){
        A[i*K+j]=(float)countmeta[i*K+j];
        printf("A:%d,%.2f\n",i*K+j,A[i*K+j]);
      }
    }
    for(i=0;i<N;i++){
      for(j=0;j<K;j++){
        A[i*K+j]=(float)countmeta[i*K+j];
        printf("B:%d,%.2f\n",i*K+j,B[i*K+j]);
      }
    }
    free(countmeta);
    free(countM);
    */
    //memcpy(A,countmeta,sizeof(countmeta));
    //memcpy(B,countM,sizeof(countM));
    
    float *C;
    C=(float*)malloc(M*N*sizeof(float));
    printf("cblas_sgemm:\t");
    time (&timep);
    printf("%s\n",asctime(gmtime(&timep)));
    cblas_sgemm(Oder,TransA,TransB,M,N,K,alpha,countmeta,lda,countM,ldb,beta,C,ldc);
    //C = alpha*op( A )*op( B )' + beta*C
    
    //Calculate Distance 
    printf("Calculate Distance:\t");
    time (&timep);
    printf("%s\n",asctime(gmtime(&timep)));
    double Dis[M*N];
    double on;
    float under1[K];
    float under2[K];
    float U1[1];
    float U2[1];
    int p,q;
    for(i=0;i<M;i++){
      for(p=0;p<K;p++){
        under1[p]=(float)countmeta[i*K+p];
      }
      cblas_sgemm(Oder,TransA,TransB,1,1,K,alpha,under1,K,under1,1,beta,U1,1);
      for(j=0;j<N;j++){
        for(q=0;q<K;q++){
          under2[q]=(float)countM[j*K+q];
        }
        cblas_sgemm(Oder,TransA,TransB,1,1,K,alpha,under2,K,under2,1,beta,U2,1);
        on=C[i*N+j];
        Dis[i*N+j]=on/(sqrt(U1[0])*sqrt(U2[0]));
        printf("%d,%d,%d",i,j,Dis[i*N+j]);
      }
    }

    //Write Distance matrix
    printf("Write Distance matrix:\t");
    time (&timep);
    printf("%s\n",asctime(gmtime(&timep)));
    for(i=0;i<M;i++){
      for(j=0;j<N;j++){
        fprintf(fp2,"%.2f\t",Dis[i*N+j]);
      }
      fprintf(fp2,"\n");
    }
    free(countmeta);
    free(countM);
    free(C);
    free(Dis);
  }
  
}
