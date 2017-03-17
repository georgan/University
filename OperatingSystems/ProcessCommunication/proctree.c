#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <sys/types.h>
#include <sys/wait.h>

#include "proc-common.h"
#include "tree.h"

#define SLEEP_PROC_SEC  10
#define SLEEP_TREE_SEC  3

/*
 * Create a process tree
 * given from a file
 */
 
typedef struct tree_node treeptr ;
 
void fork_procs(treeptr *root)
{

	pid_t pid ;
	int status ;
	int i ;
	/*
	 * initial process is A.
	 */

	change_pname(root->name);
	if (root->nr_children == 0) {
		printf("%s: Sleeping...\n", root->name);
		sleep(SLEEP_PROC_SEC);
		exit(1) ;
	}


	for(i = 0; i < root->nr_children; i++) {
	/* Father */
		pid = fork() ;
		if (pid < 0) {
			perror("fork") ;
			exit(1) ;
		}
		if (pid == 0) {
		/* Child */
			fork_procs(root->children + i) ;
			exit(1) ;
		}
	}

	printf("Process %s waits children to terminate\n", root->name) ;
	for(i = 0; i < root->nr_children; i++) {
		pid = wait(&status) ;
		explain_wait_status(pid, status) ;
	}


	printf("%s: Exiting...\n", root->name);
	exit(16);
}

/*
 * The initial process forks the root of the process tree,
 * waits for the process tree to be completely created,
 * then takes a photo of it using show_pstree().
 *
 * How to wait for the process tree to be ready?
 *      wait for a few seconds, hope for the best.
 */
int main(int argc, const char **argv)
{
	pid_t pid;
	int status;
	struct tree_node *root;

	if (argc < 2){
		fprintf(stderr, "Usage: %s <tree_file>\n", argv[0]);
		exit(1);
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
		fork_procs(root);
		exit(1);
	}

	/*
	 * Father
	 */

	/* wait until all processes sleep */
	sleep(SLEEP_TREE_SEC);

	/* Print the process tree root at pid */
	show_pstree(pid);


	/* Wait for the root of the process tree to terminate */
	pid = wait(&status);
	explain_wait_status(pid, status);

	return 0;
}

