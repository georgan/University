#include <errno.h>
#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <signal.h>

#include <assert.h>
#include <string.h>
#include <sys/wait.h>
#include <sys/types.h>

#include "proc-common.h"
#include "request.h"

/* Compile-time parameters. */
#define SCHED_TQ_SEC 2                /* time quantum */
#define TASK_NAME_SZ 60               /* maximum size for a task's name */


typedef struct node{
	int id;
	pid_t pid;
	char name[TASK_NAME_SZ];
	struct node *next;
}pcb;

pcb *global_curr;
/* SIGALRM handler: Gets called whenever an alarm goes off.
 * The time quantum of the currently executing process has expired,
 * so send it a SIGSTOP. The SIGCHLD handler will take care of
 * activating the next in line.
 */
static void
sigalrm_handler(int signum)
{
	kill(global_curr->pid,SIGSTOP);
}

/* SIGCHLD handler: Gets called whenever a process is stopped,
 * terminated due to a signal, or exits gracefully.
 *
 * If the currently executing task has been stopped,
 * it means its time quantum has expired and a new one has
 * to be activated.
 */
static void
sigchld_handler(int signum)
{
	pcb *proso;
	pid_t p;
	int status,id;
	do {
		p = waitpid(-1, &status, WUNTRACED | WNOHANG);
		if (p < 0) {
			perror("waitpid");
			exit(1);
		}
		if(p != 0){ 
			explain_wait_status(p, status);
			if (WIFEXITED(status) || WIFSIGNALED(status)){ 
				printf("child with id %d  has died \n",global_curr->id);
				id = global_curr->id;
				while(global_curr->next->id != id) global_curr = global_curr->next; 
				proso = global_curr->next;
				global_curr->next = global_curr->next->next;
				proso->next = NULL;
				global_curr = global_curr->next;
			}
			if (WIFSTOPPED(status)){
				printf("child with id %d  has been stopped\n",global_curr->id);
				global_curr = global_curr->next;
			}
		}
	} while (p > 0);
	alarm(SCHED_TQ_SEC);
	kill(global_curr->pid,SIGCONT);
}

/* Install two signal handlers.
 * One for SIGCHLD, one for SIGALRM.
 * Make sure both signals are masked when one of them is running.
 */
static void
install_signal_handlers(void)
{
	sigset_t sigset;
	struct sigaction sa;

	sa.sa_handler = sigchld_handler;
	sa.sa_flags = SA_RESTART;
	sigemptyset(&sigset);
	sigaddset(&sigset, SIGCHLD);
	sigaddset(&sigset, SIGALRM);
	sa.sa_mask = sigset;
	if (sigaction(SIGCHLD, &sa, NULL) < 0) {
		perror("sigaction: sigchld");
		exit(1);
	}

	sa.sa_handler = sigalrm_handler;
	if (sigaction(SIGALRM, &sa, NULL) < 0) {
		perror("sigaction: sigalrm");
		exit(1);
	}

	/*
	 * Ignore SIGPIPE, so that write()s to pipes
	 * with no reader do not result in us being killed,
	 * and write() returns EPIPE instead.
	 */
	if (signal(SIGPIPE, SIG_IGN) < 0) {
		perror("signal: sigpipe");
		exit(1);
	}
}

int main(int argc, char *argv[])
{
	char executable[TASK_NAME_SZ];
	char *newargv[] = {executable,NULL};
	char *newenviron[] = { NULL };
	int nproc,i;
	pid_t p;
	/*
	 * For each of argv[1] to argv[argc - 1],
	 * create a new child process, add it to the process list.
	 */

	nproc = argc-1; /* number of proccesses goes here */
	pcb *curr,*head; 	head = NULL;
	curr = (pcb*)malloc(sizeof(pcb)); 	for(i=0;i<nproc;i++){
		p = fork();
		if(p < 0){
			perror("fork");
			exit(1);
		}
		if(p == 0){
			raise(SIGSTOP);
			printf("I am child PID = %ld\n",(long)getpid());
			strcpy(executable,argv[i+1]);
        		printf("About to replace myself with the executable %s...\n",executable);
        		execve(executable, newargv, newenviron);
        		/* execve() only returns on error */
        		perror("execve");		
			exit(1);	
		}
		curr = (pcb *)malloc(sizeof(pcb));
		curr->id = nproc-i;
		curr->pid = p;
		curr->next = head;
		strcpy(curr->name,argv[i+1]);
		head = curr;
	}
	if(nproc){
	int b=1;
	while(b){ _
		if(curr->next) 
		curr = curr->next;
		else{
		curr->next = head; 
		b = 0;
		} 
	}
	curr = curr->next
	global_curr = curr;
	/* Wait for all children to raise SIGSTOP before exec()ing. */
	wait_for_ready_children(nproc);
	/* Install SIGALRM and SIGCHLD handlers. */
	install_signal_handlers();
		alarm(SCHED_TQ_SEC);
		kill(global_curr->pid,SIGCONT);
	}
	else if (nproc == 0) {
		fprintf(stderr, "Scheduler: No tasks. Exiting...\n");
		exit(1);
	}
	while(pause());

	/* loop forever  until we exit from inside a signal handler. */


	/* Unreachable */
	fprintf(stderr, "Internal error: Reached unreachable point\n");
	return 1;
}

