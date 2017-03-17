#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/stat.h>
#include <sys/types.h>


void doWrite(int fd, const char *buff, int len) ;

void write_file(int fd, const char *buff) {
 
   ssize_t ret ;
   char name[10] ;

   int fdread = open(buff, O_RDONLY) ;
   if (fdread < 0)
   {
      perror(buff) ;
      exit(1) ;
   }

   ret = read(fdread, name, 10) ;
   while (ret > 0) {

      doWrite(fd, name, ret) ;
      ret = read(fdread, name, 10) ;
   }

   if (ret < 0) {
      perror("read") ;
      if (close(fdread) < 0)
         perror("close") ;
      exit(1) ;
   }

   if (close(fdread) < 0) {
      perror("close") ;
      exit(1) ;
   }

   return ;
}

