/*
 * pipesem.c
 */

#include <assert.h>
#include <stdlib.h>
#include <unistd.h>
#include <stdio.h>


#include "pipesem.h"

void pipesem_init(struct pipesem *sem, int val)
{
	int fd[2];
	int i;

	if(pipe(fd) < 0) {
		perror("pipe");
		exit(1);
	}

	sem->rfd = fd[0];
	sem->wfd = fd[1];

	for(i = 0; i < val; i++)
		pipesem_signal(sem);

	return;
}

void pipesem_wait(struct pipesem *sem)
{
	int value;

	if (read(sem->rfd, &value, sizeof(value)) != sizeof(value)) {
		perror("read from pipe");
		exit(1);
	}

	return;
}

void pipesem_signal(struct pipesem *sem)
{
	int value = 1;

	if (write(sem->wfd, &value, sizeof(value)) != sizeof(value)) {
		perror("write to pipe");
		exit(1);
	}

	return;
}

void pipesem_destroy(struct pipesem *sem)
{
	close(sem->wfd);
	close(sem->rfd);

	return;
}

