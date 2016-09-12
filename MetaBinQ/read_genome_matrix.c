#include <stdio.h>
#include <stdlib.h>
//#include <math.h>
#include <string.h>
#include <sys/types.h>
#include <dirent.h>
#include <unistd.h>
//#define TEST
#define FORMAL

#ifdef FORMAL
char **classify_name;
float *counts;
char **fqnames;
int fqnum;
#endif

void get_fq(char fqdir[50]);
void read_genome_matrix(char matrix_file[30],int k,int m);
void char2num(char *charseq,char *numseq);
int mi(int a,int m);

#ifdef TEST
char **classify_name;
float *counts;
char **fqnames;
int fqnum;
main(int argc,char *argv[]){
  int k=5;
  int m=2608;
  read_genome_matrix(argv[1],k,m);
  free(classify_name);
  free(counts);

  /////////////////////////////////////
  char str[1000]="ATCC";
  char numseq[1000];
  char2num(str,numseq);
  /////////////////////////////////////
  get_fq(argv[2]);
  free(fqnames);
  ////////////////////////////////////
}
#endif


void get_fq(char fqdir[50]){
  DIR *dir;
  struct dirent *ptr;
  int i;
  int filelen;
  i=0;
  fqnames=(char **)malloc(20*50*sizeof(char));
  dir=opendir(fqdir);
  while((ptr=readdir(dir))!=NULL){
    filelen=strlen(ptr->d_name);
    if(ptr->d_name[filelen-3]=='.' && ptr->d_name[filelen-2]=='f' && ptr->d_name[filelen-1]=='q'){
      fqnames[i]=ptr->d_name;
      i++;
    }
  }
  closedir(dir);
  fqnum=i;
}

void read_genome_matrix(char matrix_file[30],int k,int m){
  char strarray[500];
  float c;
  int count=0;
  int z=mi(4,k);
  int name_num=0;
  int counts_num=0;
  FILE *fp;
  classify_name=(char **)malloc((m+1)*1000*sizeof(char*));
  counts=(float *)malloc((m+1)*(z+2)*sizeof(float));
  
  fp=fopen(matrix_file,"r");
  if(fp==NULL){
    fprintf(stderr,"matrix_file cannot be opened!\n");
  }else{
     while(!feof(fp)){
       count=count+1;
 
       if(count==name_num*(z+1)+1 && name_num<m){
         classify_name[name_num]=(char *)malloc(1000*sizeof(char));
         fscanf(fp,"%s",classify_name[name_num]);
#ifdef TEST
         printf("now:%s\n",classify_name[name_num]);
         if(name_num>1){
           printf("last:%d,%s\n",name_num,classify_name[0]);
         }
#endif
         name_num++;
       }
       
       else{
         fscanf(fp,"%s",strarray);
         c=atof(strarray);
         counts[counts_num]=c;
         //printf("%d--%.4f\n",counts_num,counts[counts_num]);
         counts_num++;
       }
       
     }
     fclose(fp);
#ifdef TEST
     printf("%s\n",classify_name[0]);
     printf("%s\n",classify_name[1]);
     printf("%s\n",classify_name[2]);
     printf("%.4f\n",counts[0]);
     printf("%.4f\n",counts[1]);
     printf("%.4f\n",counts[2]);
#endif
  }
}

void char2num(char *charseq,char *numseq){
  int len=strlen(charseq);
  int i;
  for(i=0;i<len;i++){
    char c=charseq[i];
    char ns;
    if(c=='A'){
      ns='0';
    }else if(c=='T'){
      ns='1';
    }else if(c=='C'){
      ns='2';
    }else if(c=='G'){
      ns='3';
    }else{
      ns='4';
    }
    numseq[i]=ns;
  }
  numseq[len]='\0';
}

int mi(int a,int m){
  int j;
  int z=1;
  for(j=0;j<m;j++){
    z=z*a;
  }
  return z;
}












