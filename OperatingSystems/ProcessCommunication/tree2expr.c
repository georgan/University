#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <string.h>

#include "proc-common.h"
#include "tree.h"


/*
 * Calculate an expression
 * from a process tree
 * 
 */
 
typedef struct tree_node treeptr ;
 
void fork_procs(treeptr *root, int father_pfd)
{

	pid_t pid ;
	int status ;
	int i ;
	int my_pfd[2];
	int value1, value2;
	pid_t *pds;
	
	
	printf("%s: Starting...\n", root->name) ;

	change_pname(root->name);
	if (root->nr_children == 0) {
		raise(SIGSTOP);
		/* is awake */
		/* make integer from char */
		value1 = atoi(root->name) ;
		if (write(father_pfd, &value1, sizeof(value1)) != sizeof(value1)) {
			perror("write to pipe") ;
			exit(1) ;
		}

	printf("%s: Exiting...\n", root->name);
	exit(1) ;
	}


	if (pipe(my_pfd) < 0) {
		perror("create pipe") ;
		exit(1) ;
	}

	pds = malloc(root->nr_children*sizeof(pid_t));
	if (pds < 0) {
		perror("malloc");
		exit(1);
	}

	for(i = 0; i < root->nr_children; i++) {
		pid = fork() ;
		if (pid < 0) {
			perror("fork") ;
			exit(1) ;
		}
		if (pid == 0) {
			/* Child */
			fork_procs(root->children + i, my_pfd[1]) ;
			exit(1) ;
		}
		*(pds+i) = pid ;
	}

	/* Father */
	wait_for_ready_children(root->nr_children) ;

	/*
	 * Suspend Self
	 */
	raise(SIGSTOP) ;

	/* printf("Process %s waits children to terminate\n", root->name); */

	for(i = 0; i < root->nr_children; i++) {
		pid = kill(*(pds+i), SIGCONT) ;
		if (pid < 0) {
			perror("kill") ;
			exit(1) ;
		}

		pid = wait(&status) ;
		explain_wait_status(pid, status) ;
	}


	/* read the values from the pipe */
	if (read(my_pfd[0], &value1, sizeof(value1)) != sizeof(value1)) {
		perror("first read from pipe") ;
		exit(1) ;
	}

	if (read(my_pfd[0], &value2, sizeof(value2)) != sizeof(value2)) {
		perror("second read from pipe") ;
		exit(1) ;
	}

	/* calculate the value of your node */
	if (strcmp(root->name, "+") == 0)
		value1 += value2 ;
	else if (strcmp(root->name, "*") == 0)
		value1 *= value2 ;
	else {
		perror("invalid operation") ;
		exit(1) ;
	}

	/* write the value to your father's pipe */
	if (write(father_pfd, &value1, sizeof(value1)) != sizeof(value1)) {
		perror("write to pipe") ;
		exit(1) ;
	}

	free(pds);
	printf("%s: Exiting...\n", root->name);
	exit(16);
}

/*
 * The initial process forks the root of the process tree,
 * waits for the process tree to be completely created,
 * then takes a photo of it using show_pstree().
 *
 * How to wait for the process tree to be ready?
 *      use wait_for_ready_children() to wait until
 *      the first process raises SIGSTOP.
 */
int main(int argc, const char **argv)
{
	pid_t pid;
	int status;
	struct tree_node *root;
	int fdp[2];
	int value = 10;

	if (argc < 2){
		fprintf(stderr, "Usage: %s <tree_file>\n", argv[0]);
		exit(1);
	}


	if (pipe(fdp) < 0) {
		perror("create pipe") ;
		exit(1) ;
	}

	/* Fork root of process tree */
	pid = fork();
	if (pid < 0) {
		perror("main: fork");
		exit(1);
	}
	if (pid == 0) {
		/* Child */
		root = get_tree_from_file(argv[1]) ;
		fork_procs(root, fdp[1]);
		exit(1);
	}

	/*
	 * Father
	 */
	wait_for_ready_children(1);


	/* Print the process tree root at pid */
	show_pstree(pid);

	/* wake Child */
	kill(pid, SIGCONT);

	/* Wait for the root of the process tree to terminate */
	pid = wait(&status);
	explain_wait_status(pid, status);

	if (read(fdp[0], &value, sizeof(value)) != sizeof(value)) {
		perror("read from pipe") ;
		exit(1) ;
	}

	printf("The value of the expression tree is: %d\n", value) ;

	return 0;
}

