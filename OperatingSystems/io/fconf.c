#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <string.h>

void write_file(int fd, const char *buff) ;

int main(int argc, char **argv)
{

   int oflags=O_CREAT | O_WRONLY | O_TRUNC; 
   int mode=S_IRUSR |S_IWUSR;
   char *outfile  = "fconc.out" ;

   if ((argc != 3) && (argc != 4))
   {
      printf("Usage: ./fconc infile1 infile2 [outfile (default:fconc.out)]\n");
      exit(1);
   }
   if (argc == 4)
      outfile = argv[3] ;

   if ((strcmp(outfile, argv[1]) == 0) || (strcmp(outfile, argv[2]) == 0)) {
      printf( "Input and output files must be different\n") ;
      exit(1) ;
   }

   int fd;
   fd = open(outfile, oflags, mode) ;
   if (fd < 0)
   {
      perror("open");
      exit(1) ;
   }

   write_file(fd, argv[1]) ;
   write_file(fd, argv[2]) ;


   if (close(fd) < 0) {
      perror("close") ;
      exit(1) ;
   }

   return 0;

}

