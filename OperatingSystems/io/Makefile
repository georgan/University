all: fconf

doWrite.o: doWrite.c
	gcc -Wall -c doWrite.c

write_file.o: write_file.c
	gcc -Wall -c write_file.c

fconf.o: fconf.c
	gcc -Wall -c fconf.c

fconf: doWrite.o write_file.o fconf.o
	gcc doWrite.o write_file.o fconf.o -o fconf

clean:
	rm -f *.o
