#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>

void doWrite(int fd, const char *buff, int len)
{

   int index = 0 ;
   ssize_t ret ;

   do
   {
      ret = write(fd, buff + index, len - index) ;
      if (ret < 0) {
         perror("write") ;
         exit(1) ;
      }
      index += ret ;
   }
   while (index < len) ;


   return ;
}

