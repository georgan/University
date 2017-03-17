#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define M 100
#define min(a,b) (a<b) ? a : b


typedef struct coords{
	int x;
	int y;
	int z;
} COOrds;

typedef struct coords *mycoords;


typedef struct treenode {
	char *key;
	struct treenode *right;
	struct treenode *left;
} Treenode;

typedef Treenode *Treeptr;


void helpfcn(int *a, int *b);
void (*funptr)(int *,int *);

void main(int argc, char **argv) {
	FILE *fid;
	int i, j;
	char *inp;
	Treeptr root;

	for (i=1; i<argc; i++) {
		printf("%s\n", *(argv+i));
	}

	root = malloc(sizeof(Treenode));

	root->key = "Hello World";
	root->right = NULL;
	root->left = NULL;
	
	root->right = malloc(5*sizeof(Treenode));
	(root->right+3)->key = "Bye, Bye...";

	(*((*root).right+3)).key = "Bye...";
	root = root->right;
	

	//(argc>1) ? (fid = fopen(argv[1], "r")) : return;
	/*scanf("%s", inp);
	if (argc>1) {
		fid = fopen(*(argv+1),"r");
		if (fid==NULL) {
			printf("File %s not found!\n", argv[1]);
			return;
		}
	}
	else
		return;

	i = 0;
	while (fscanf(fid, "%s", inp) != EOF) {
	printf("%s\n", inp);
	}

	i = fclose(fid); */
	//printf("Done %d\n",min(2,3));

	i = 1; j = 2;
	helpfcn(&i,&j);
	printf("%d", i);
	
	funptr = &helpfcn;
	(*funptr)(&i,&j);
	printf("%d", i);

}

void helpfcn(int *a, int *b) {
	*a += *b;

}
