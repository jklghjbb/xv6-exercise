//
// Created by hongjie on 16/03/24.
//
#include "kernel/types.h"
#include "user/user.h"

int element(int pipeline_read){
   int first = 0;
   int received_number;
   int next_pipe[2];
   int forked = 0;

   while(read(pipeline_read, &received_number, sizeof(int))>0){
      // printf("receive: %d\n", received_number);
      if(first==0) {
         first=received_number;
         printf("prime: %d\n", first);
      } else {
         // send the number to the right end of the new pile
         if(received_number%first!=0){
         // if it is the first number to send
            if(forked == 0){
               pipe(next_pipe);
               // parent doesn't need the read end of the pipe
               int child = fork();
               forked = 1;
               if (child == 0){
                  // child doesn't need the write end of the old pipe
                  close(next_pipe[1]);
                  element(next_pipe[0]);
               }
            }

         // write the element
         write(next_pipe[1], &received_number, sizeof(int));
         }
      }
   }
   // all elements are writen, no need the write pipeline end
   close(next_pipe[1]);
   wait(0);
   exit(0);
}

// main process is to feed the number to the pipeline
int main(int argc, char* argv[]){
   int i;
   int p_primary[2];
   pipe(p_primary);
   for(i=2; i<=35; i++){
      write(p_primary[1], &i, sizeof(int));
   }

   close(p_primary[1]);
   int pid = fork();
   if(pid == 0){ // these are intermediate proecesses in the pipeline
      element(p_primary[0]);
   }
   wait(0);
   exit(0);
}