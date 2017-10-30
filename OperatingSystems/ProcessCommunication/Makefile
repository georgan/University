all: fork_procs proctree signals tree2expr

proc-common.o: proc-common.c
	gcc -Wall -c proc-common.c

fork_procs.o: fork_procs.c
	gcc -Wall -c fork_procs.c

fork_procs: fork_procs.o proc-common.o
	gcc proc-common.o fork_procs.o -o fork_procs

tree.o: tree.c
	gcc -Wall -c tree.c

proctree.o: proctree.c
	gcc -Wall -c proctree.c

proctree: proctree.o proc-common.o tree.o
	gcc proc-common.o tree.o proctree.o -o proctree

signals.o: signals.c
	gcc -Wall -c signals.c

signals: signals.o proc-common.o tree.o
	gcc proc-common.o tree.o signals.o -o signals

tree2expr.o: tree2expr.c
	gcc -Wall -c tree2expr.c

tree2expr: tree2expr.o proc-common.o tree.o
	gcc proc-common.o tree.o tree2expr.o -o tree2expr

clean:
	rm -f *.o
