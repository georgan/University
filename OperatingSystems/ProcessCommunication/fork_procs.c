#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <sys/types.h>
#include <sys/wait.h>

#include "proc-common.h"

#define SLEEP_PROC_SEC  10
#define SLEEP_TREE_SEC  3

/*
 * Create this process tree:
 * A-+-B---D
 *   `-C
 */
void fork_procs(void)
{

	int status ;
	pid_t p;
	/*
	 * initial process is A.
	 */

	printf("A: Begins\n") ;
	change_pname("A");

	/*
	 * process A creates B
	 */
	p = fork() ;
	if (p < 0) {
		perror("A:fork") ;
		exit(16) ;
	}
	if (p == 0) {
		/*
		 *  process B
		 */
		printf("B: Begins\n") ;
		change_pname("B") ;

		/*
		 * process B creates D
		 */
		p = fork() ;
			if (p < 0) {
				perror("B:fork") ;
				exit(19) ;
			}
			if (p == 0) {
				/*
				 * process D
				 */
				printf("D: Begins\n") ;
				change_pname("D") ;

				printf("D: Sleeping\n") ;
				sleep(SLEEP_PROC_SEC) ;
				printf("D: Exiting...\n") ;
				exit(13) ;
			}


			printf("Process B waits D to terminate...\n") ;
			p = wait(&status) ;
			explain_wait_status(p, status) ;
			printf("B: Exiting...\n") ;

			exit(19) ;
	}
								
	/*
	 * process A creates C
	 */	
	p = fork() ;
	if (p < 0) {
		perror("A:fork") ;
		exit(16) ;
	}
	if (p == 0) {
		/*
		 * process C
		 */
		printf("C: Begins\n") ;
		change_pname("C") ;
		printf("C: Sleeping\n") ;
		sleep(SLEEP_PROC_SEC) ;

		printf("C: Exiting...\n") ;
		exit(17) ;
	}


	printf("Process A waits children to terminate...\n") ;
	p = wait(&status) ;
	explain_wait_status(p, status) ;
	
	printf("Process A waits children to terminate...\n") ;
	p = wait(&status) ;
	explain_wait_status(p, status) ;
	
	printf("A: Exiting...\n");
	exit(16);
}

/*
 * The initial process forks the root of the process tree,
 * waits for the process tree to be completely created,
 * then takes a photo of it using show_pstree().
 *
 * How to wait for the process tree to be ready?
 *      wait for a few seconds, hope for the best.
 * In ask2-signals:
 */
int main(void)
{
	pid_t pid;
	int status;

	/* Fork root of process tree */
	pid = fork();
	if (pid < 0) {
		perror("main: fork");
		exit(1);
	}
	if (pid == 0) {
		/* Child */
		fork_procs();
		exit(1);
	}

	/*
	 * Father
	 */

	sleep(SLEEP_TREE_SEC);

	/* Print the process tree root at pid */
	show_pstree(pid);


	/* Wait for the root of the process tree to terminate */
	pid = wait(&status);
	explain_wait_status(pid, status);

	return 0;
}

