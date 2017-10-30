all: pipesem-test mandel procs-shm

proc-common.o: proc-common.c
	gcc -Wall -c proc-common.c

pipesem.o: pipesem.c
	gcc -Wall -c pipesem.c

pipesem-test.o: pipesem-test.c
	gcc -Wall -c pipesem-test.c

pipesem-test: proc-common.o pipesem.o pipesem-test.o
	gcc proc-common.o pipesem.o pipesem-test.o -o pipesem-test

mandel-lib.o: mandel-lib.c
	gcc -Wall -c mandel-lib.c

mandel.o: mandel.c
	gcc -Wall -c mandel.c

mandel: mandel.o mandel-lib.o pipesem.o
	gcc mandel-lib.o pipesem.o mandel.o -lm -o mandel

procs-shm.o: procs-shm.c
	gcc -Wall -c procs-shm.c

procs-shm: procs-shm.o pipesem.o proc-common.o
	gcc proc-common.o pipesem.o procs-shm.o -o procs-shm

clean:
	rm -f *.o
