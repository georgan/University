#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <signal.h>
#include <sys/types.h>
#include <sys/wait.h>

#include "tree.h"
#include "proc-common.h"

void fork_procs(struct tree_node *root)
{
	/*
	 * Start
	 */
	int i;
	int status;
	pid_t pid;
	pid_t *pds;

	printf("PID = %ld, name %s, starting...\n",
			(long)getpid(), root->name);
	change_pname(root->name);

	/*if (root->nr_children == 0) {
		printf("%s: Raising...\n", root->name);
		raise(SIGSTOP);
		printf("PID = %ld, name = %s is awake\n",
			(long)getpid(), root->name);

		exit(1) ;
	}*/


	pds = malloc(root->nr_children*sizeof(pid_t));
	if (pds < 0) {
		perror("malloc");
		exit(1);
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
		/* store pid */
		*(pds+i) = pid ;
	}


	wait_for_ready_children(root->nr_children) ;

	/*
	 * Suspend Self
	 */
	printf("%s: Raising...\n", root->name);
	raise(SIGSTOP);
	printf("PID = %ld, name = %s is awake\n",
		(long)getpid(), root->name);


	/* wake children */
	for(i = 0; i < root->nr_children; i++) {
		pid = kill(*(pds+i) , SIGCONT) ;
		if (pid < 0) {
			perror("kill") ;
			exit(1) ;
		}
		pid = wait(&status) ;
		explain_wait_status(pid, status) ;
	}


	free(pds);
	/*
	 * Exit
	 */
	printf("%s: Exiting...\n", root->name);
	exit(0);
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

int main(int argc, char *argv[])
{
	pid_t pid;
	int status;
	struct tree_node *root;

	if (argc < 2){
		fprintf(stderr, "Usage: %s <tree_file>\n", argv[0]);
		exit(1);
	}

	/* Read tree into memory */
	root = get_tree_from_file(argv[1]);

	/* Fork root of process tree */
	pid = fork();
	if (pid < 0) {
		perror("main: fork");
		exit(1);
	}
	if (pid == 0) {
		/* Child */
		fork_procs(root);
		exit(1);
	}

	/*
	 * Father
	 */
	wait_for_ready_children(1);


	/* Print the process tree root at pid */
	show_pstree(pid);

	/* wake child */
	kill(pid, SIGCONT);

	/* Wait for the root of the process tree to terminate */
	wait(&status);
	explain_wait_status(pid, status);

	return 0;
}

