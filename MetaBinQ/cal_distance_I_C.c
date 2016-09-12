#include <stdio.h>
#include <math.h>
#include <time.h>
#include "read_genome_matrix.c"
//#define PRINTD
extern char **classify_name;
extern float *counts;
extern char **fqnames;
extern int fqnum;
time_t timep;
main(int argc,char *argv[]){
  char usage[]="Usage:\n./cal_distance_I fq_dir k genome_matrix classify_file";
  if(argc!=5){
    printf("%s\n",usage);
  }else{
    int k=atoi(argv[2]);
    int m=2607;//counts_num
    if(k<4||k>8){
      fprintf(stderr,"Please select k between 4 and 8!\n");
    }else{
      time(&timep);
      FILE *log;
      log=fopen("running.log","w");
      fprintf(log,"%s\nstart:%s\n",argv[0],asctime(gmtime(&timep)));

      //1.get classify_name and counts.
      read_genome_matrix(argv[3],k,m);
      //2.open classify_file for output.
      
      FILE *class;
      class=fopen(argv[4],"w");
      if(class==NULL){
        fprintf(stderr,"classify_file cannot be opened!\n");
      }else{
        fprintf(class,"RESULT:\n");
      }
      fclose(class);
      class=fopen(argv[4],"a");
      //3.declare the array

      //4.open fqdir for reading the reads.
      get_fq(argv[1]);
      FILE *ffq;
      char *fq=argv[1];
      char **fqfile;
      fqfile=(char **)malloc(sizeof(char*)*(fqnum+1)*100);

      if(fqnum==0){
        printf("The dir you have chosen has no read.fq files!\n");
      }else{
        int i;
        for(i=0;i<fqnum;i++){
          fqfile[i]=(char *)malloc(100*sizeof(char));
          memset(fqfile[i],'\0',sizeof(fqfile[i]));
          if(fq[strlen(fq)-1]=='/'){ 
            strcat(fqfile[i],fq);
            strcat(fqfile[i],fqnames[i]);
          }else{
            strcat(fqfile[i],fq);
            strcat(fqfile[i],"/");
            strcat(fqfile[i],fqnames[i]);
          }
         
          ffq=fopen(fqfile[i],"r");

          char StrLine[2000];
          char StrNum[2000];
          int count=0;
          if(ffq==NULL){
            fprintf(stderr,"ffq cannot be opened!\n");
          }
          
          else{
            int i1;
            int j1;
            int seq_len=strlen(StrNum);
            int index;
            int c_num;
            char c_str;
            int *kmer_num;
            int kmer_num_len=mi(4,k);
            float *C;
            int j;
            float d;
            int index_class;
            int i;
            int read_index=0;
            int b;
            int g;

            kmer_num=(int *)malloc(kmer_num_len*sizeof(int));

            while(!feof(ffq)){
              memset(StrLine,'\0',sizeof(StrLine));
              fgets(StrLine,2000,ffq);
              count++;
              if(count%4==2){
                C=(float *)malloc((m+1)*sizeof(float));
                for(b=0;b<m;b++){
                  C[b]=0;
                }
                for(g=0;g<kmer_num_len;g++){
                  kmer_num[g]=0;
                }
                char2num(StrLine,StrNum);
                seq_len=strlen(StrNum)-k;
                for(i1=0;i1<seq_len;i1++){
                  index=0;
                  for(j1=i1;j1<i1+k;j1++){
                    c_str=StrNum[j1];
                    c_num=c_str-'0';
                    index=index*4+c_num;
                  }
                  kmer_num[index]++;
                  
                  for(j=0;j<m;j++){
                    C[j]=C[j]+counts[j*kmer_num_len+index];
                  }
                }
                d=0;
                index_class=0;
#ifdef PRINTD
    printf("%d",read_index);
#endif
                for(i=0;i<m;i++){
#ifdef PRINTD
    printf("\t%.6f",C[i]);
#endif
                  if(C[i]>d){
                    d=C[i];
                    index_class=i;
                  }
                }
#ifdef PRINTD
    printf("\n");
    printf("read:%d-d:%.6f-index:%d\n",read_index,d,index_class);
#endif
                fprintf(class,"%d\t%s\n",read_index,classify_name[index_class]);
                read_index++;
                free(C);
              }//else count%4
            }//while
          }//else can open ffq
          fclose(ffq);
        }//i from fqnames
        free(fqfile);
      }//fqnum!=0

      //end
      fclose(class);
      free(classify_name);
      free(counts);
      free(fqnames);
      time(&timep);
      fprintf(log,"end:%s\n",asctime(gmtime(&timep)));
      fclose(log);
    }
  }
}//main


