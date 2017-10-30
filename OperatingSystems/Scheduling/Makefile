all: scheduler scheduler-shell scheduler-shell2 shell prog execve-example strace-test

proc-common.o: proc-common.c
	gcc -Wall -c proc-common.c

scheduler.o: scheduler.c
	gcc -Wall -c scheduler.c

scheduler: scheduler.o proc-common.o
	gcc proc-common.o scheduler.o -o scheduler

scheduler-shell.o: scheduler-shell.c
	gcc -Wall -c scheduler-shell.c

scheduler-shell: scheduler-shell.o proc-common.o
	gcc proc-common.o scheduler-shell.o -o scheduler-shell

scheduler-shell2.o: scheduler-shell2.c
	gcc -Wall -c scheduler-shell2.c

scheduler-shell2: scheduler-shell2.o proc-common.o
	gcc proc-common.o scheduler-shell2.o -o scheduler-shell2

shell.o: shell.c
	gcc -Wall -c shell.c

shell: shell.o proc-common.o
	gcc proc-common.o shell.o -o shell

prog.o: prog.c
	gcc -Wall -c prog.c

prog: prog.o proc-common.o
	gcc proc-common.o prog.o -o prog

execve-example.o: execve-example.c
	gcc -Wall -o execve-example.o -c execve-example.c

execve-example: execve-example.o 
	gcc execve-example.o -o execve-example

strace-test.o: strace-test.c
	gcc -Wall -o strace-test.o -c strace-test.c

strace-test: strace-test.o 
	gcc strace-test.o -o strace-test

clean:
	rm -f *.o
