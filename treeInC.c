#include <stdio.h>
#include<stdlib.h>

#define SIZE1 20                        /* array's size */
#define SIZE2 100
#define N 200


struct treeNode {                     
       int info;
       int rank;
       struct treeNode *left;
       struct treeNode *right;
       };
       

typedef struct treeNode *Treeptr;


Treeptr createPosTree(int n, int m, int *array, int i);          /* create tree */
void printPosTree(Treeptr tree);                                  /* print tree using inorder diashisi */
Treeptr searchPosition(Treeptr tree, int k, int i, int j);       /* searching a node */     
void insertPosition(Treeptr tree, int k);                         /* insert a new node */
void deletePosition(Treeptr tree, int k);                         /* delete a node */
void simSearch(int *array);                                     /* apodosi domis */



int main()
  {
  Treeptr ptr1;
  int ar1[SIZE1], ar2[SIZE2];
  FILE *fpin;
  int i, pos;
  
  
  fpin=fopen("input.txt", "r");                                  /* open file for reading */
  for(i=0; i<SIZE1; i++)                                         /* initialize fisrt array */
    fscanf(fpin,"%d", &ar1[i]); 
    
    /* create tree */
  printf("Let's create position tree that has %d nodes\n", SIZE1);
  ptr1=createPosTree(0, SIZE1-1, &ar1[0], 0); 
   
  /* insert, search and delete  a node */
  printf("Now we will make  3 times insertion and deletion\n");
  for(i=0; i<3; i++)  {
    printf("Give position for insertion\n");
    scanf("%d", &pos);
    insertPosition(ptr1, pos);
    
    system("pause");
    printf("Give position for deletion\n");
    scanf("%d", &pos);
    deletePosition(ptr1, pos);
   
  }
  
  
  for(i=0; i<SIZE2; i++)
    fscanf(fpin,"%d", &ar2[i]);                             /* initialize second array */
  
 
  simSearch(&ar2[0]);
  
  fclose(fpin);
  system("pause");
  return 0;
  
} 
  
  
    /* create tree function */
  Treeptr createPosTree(int n, int m, int *array, int i)               /*  n: first position, m: last position, i: rank control */ 
    {
    Treeptr t=NULL;
  
    if (n<=m)  {
      t=(Treeptr)malloc(sizeof(struct treeNode));
      t->info=*(array+(m+n)/2);
      t->rank=(m+n)/2 -i +1;  
      t->left=createPosTree(n, (m+n)/2-1, array, i); 
      t->right=createPosTree((m+n)/2+1, m, array, t->rank+i);
    }

    return t;

    }

  
           
  /* print function */          
  void printPosTree(Treeptr ptr)         
    {             
           
     if (ptr!=NULL)  {      
       printPosTree(ptr->left);
       printf("  %d  ",ptr->info);
       printPosTree(ptr->right);    
     }      
           
   }      
           
           
   /* search function */        
   Treeptr searchPosition(Treeptr tree, int k, int i, int *compare)      /*  tree:pointer to first node, k: positin for seaching */         
     {                                                                   /*  i:rank processing, compare: comparisons counting */      
     int j;
     
     if (tree==NULL)
       return NULL;
      
          
     printf("Let's search for %dth element\n", k);     
      
     j=k;   
     (*compare)++;                             /* counts while comparison */
     while(tree!=NULL && j!= tree->rank)  {          
       if (j<tree->rank)  {
         (*compare)++;              
         tree->rank+=i;                        /* rank adjustment for inserting and deleting a node */
         tree=tree->left;  
       }
       else  {    
         (*compare)++;  
         j-=tree->rank; 
         tree=tree->right;
       }  
       
       (*compare)++;                       /* counts while comparison */
     }
     
     printf("Element at position %d found.It is %d\n", k, tree->info);      
           
     return tree;      
  }  
     
     
       /* insert function */        
   void insertPosition(Treeptr tree, int k)        
     {
     Treeptr t, ptr;      
     int num,i; 
     
     if(k<=0 || k>SIZE1) {
       printf("The position that was given is mistaken\n");
       return;
     }
     
     t=searchPosition(tree, k, 1, &i);                /* 1 for rank increasement */
     if (t==NULL) return;   
     
     printf("Give integer for insertion\n");
     scanf("%d", &num);           
    
     ptr=(Treeptr)malloc(sizeof(struct treeNode));
     ptr->info=num;
     
     ptr->rank = t->rank;     
     t->rank++;      
     ptr->left = t->left;            
     ptr->right=NULL;      
     t->left=ptr;
     
               
     system("pause"); 
     printf("Let's print the tree after inserting the node\n\n");
     printPosTree(tree);
     printf("\n");
     
           
}        
     
  
     
           
   /* delete function */
   void deletePosition(Treeptr tree, int k)
     {
     Treeptr t,ptr,help_ptr;
     int temp,i,j,n;
     
      if(k<=0 || k>SIZE1) {
       printf("The position that was given is mistaken\n");
       return;
     }
     
     t=searchPosition(tree, k, 0, &i);
     if (t==NULL) return;
     
     printf("\n");
     printf("Here starts deleting procedure\n\n");
     
     j=0;
     while (t->left!=NULL || t->right!=NULL)  {
       j++;
       ptr=searchPosition(tree, k+j, 0, &i);              /* finds k+j-th elment */
                                                          
       temp=ptr->info;                                    /* swaps k-th element with k+j-th element */
       ptr->info=t->info;                                 /* k-th elment have to become leave for deletion */
       t->info=temp;
       
       t=ptr;
     }
     
     
     n=k+j;
     ptr=tree; 
     
     while(ptr->right!=t && ptr->left!=t)  {
       if (ptr->rank > n)                                  /* finds the nearest element of k */
         ptr=ptr->left;
       else     {
         n-=ptr->rank;
         ptr=ptr->right;
       }
     } 
     
     help_ptr=searchPosition(tree, k+j, -1, &i);           /* -1 for rank decreasement */
     free(t);
     if (ptr->right==t)  
       ptr->right=NULL;
     else if (ptr->left==t)  
       ptr->left=NULL;
     
     printf("\n");
     printf("Here finishes deleting procedure\n\n");
     printf("Let's print the tree after deleting the node\n");
     system("pause");
     printPosTree(tree);
     printf("\n");
     
   }
    
    /* simSearch function */ 
   void simSearch(int *array) 
     {
     Treeptr ptr,t;
     int comp=0,i,k;
     float average;
     
     
     printf("Let's create position tree that has %d nodes\n", SIZE2);
     ptr=createPosTree(0, SIZE2-1, array, 0);
     system("pause");
     printf("\n");
     printf("Now we'll estimate the efficiency of our structure making %d searches\n", N);
     system("pause");
     for(i=0; i<N; i++)  {
        k=rand()%100+1;     
        t=searchPosition(ptr, k, 0, &comp);
     }
     
     average=(float) comp/N;
     printf("\n");
     printf("On average are demanded %f comparisons for finding an element\n", average);
     
}     

          
