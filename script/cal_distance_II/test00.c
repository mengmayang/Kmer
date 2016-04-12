#include <stdio.h>
#include <cblas.h>
//#include <iostream>
//using namespace std;
int main(void){
  const enum CBLAS_ORDER Order=CblasRowMajor;
  const enum CBLAS_TRANSPOSE TransA=CblasNoTrans;
  const enum CBLAS_TRANSPOSE TransB=CblasNoTrans;
  const int M=4; //A row,C row
  const int N=2; //B col,C col
  const int K=3; //A col,B row
  const float alpha=1;
  const float beta=0;
  const int lda=K;
  const int ldb=N;
  const int ldc=N;
  //const float A[K*M]={1,2,3,4,5,6,7,8,9,8,7,6};
  const float A[12]={1,2,3,4,5,6,7,8,9,8,7,6};
  //const float B[K*N]={5,4,3,2,1,0};
  const float B[6]={5,4,3,2,1,0};
  float C[8];

  cblas_sgemm(Order,TransA,TransB,M,N,K,alpha,A,lda,B,ldb,beta,C,ldc);
  //C = alpha*op( A )*op( B ) + beta*C

  // printf("%.2f,%.2f,%.2f\n",A[0],A[1],A[2]);
 int i;
 
 for(i=0;i<M;i++)
 {
   int j;
   for(j=0;j<N;j++)
   {
      printf("%.2f,",C[i*N+j]);
   }
   printf("\n");
 }
  
}
