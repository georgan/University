/*
 * procs-shm.c
 *
 * A program to create three processes,
 * working with a shared memory area.
 *
 * Operating Systems
 *
 */

#include <stdio.h>
#include <unistd.h>
#include <assert.h>
#include <string.h>
#include <math.h>
#include <stdlib.h>

#include <sys/types.h>
#include <sys/wait.h>

#include "proc-common.h"
#include "pipesem.h"


/*
 * This is a pointer to a shared memory area.
 * It holds an integer value, that is manipulated
 * concurrently by all children processes.
 */
int *shared_memory;
struct pipesem sema, semb, semc;

/* Proc A: n = n + 1 */
void proc_A(void)
{
	volatile int *n = &shared_memory[0];

	for (;;) {
		pipesem_wait(&sema);
		*n = *n + 1;
		pipesem_signal(&semb);
	}

	exit(0);
}

/* Proc B: n = n - 2 */
void proc_B(void)
{
	volatile int *n = &shared_memory[0];

	for (;;) {
		pipesem_wait(&semb);
		pipesem_wait(&semb);
		*n = *n - 2;
		pipesem_signal(&semc);
	}

	exit(0);
}

/* Proc C: print n */
void proc_C(void)
{
	int val;

	volatile int *n = &shared_memory[0];

	for (;;) {
		pipesem_wait(&semc);
		val = *n;
		printf("Proc C: n = %d\n", val);
		if (val != 1) {
			printf("     ...Aaaaaargh!\n");
		}
		pipesem_signal(&sema);
		pipesem_signal(&sema);
	}
	exit(0);
}

/*
 * Use a NULL-terminated array of pointers to functions.
 * Each child process gets to call a different pointer.
 */
typedef void proc_fn_t(void);
static proc_fn_t *proc_funcs[] = {proc_A, proc_B, proc_C, NULL};

int main(void)
{
	int i;
	int status;
	pid_t p;
	proc_fn_t *proc_fn;
	pipesem_init(&sema, 2);
	pipesem_init(&semb, 0);
	pipesem_init(&semc, 0);


	/* Create a shared memory area */
	shared_memory = create_shared_memory_area(sizeof(int));
	*shared_memory = 1;

	for(i = 0; (proc_fn = proc_funcs[i]) != NULL; i++) {
		printf("%lu fork()\n", (unsigned long)getpid());
		p = fork();
		if (p < 0) {
			perror("parent: fork");
			exit(1);
		}
		if (p != 0) {
			/* Father */
			continue;
		}
		/* Child */
		proc_fn();
		assert(0);
	}

	/* Parent waits for all children to terminate */
	for (; i >0; i--)
		wait(&status);

	return 0;
}

