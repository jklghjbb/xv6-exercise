//
// Created by hongjie on 16/03/24.
//
#include "kernel/types.h"
#include "user/user.h"

int main(int argc, char *argv[]) {
    int pPtoC[2];
    int pCtoP[2];
    pipe(pPtoC);
    pipe(pCtoP);

    int pid = fork();
    if(pid == 0) {
       char writeBuff[12] = "nihaoparent";
       char readBuff[11];
       read(pCtoP[0], readBuff, 11);
       printf("%d: child received message\n", getpid());
       write(pPtoC[1], writeBuff, 12);
       exit(0);
    }
    // Parent sends bytes to the child
    char writeBuff[11] = "nihaochild";
    char readBuff[12];
    write(pCtoP[1], writeBuff, 11);
    read(pPtoC[0], readBuff, 12);
    printf("%d: parent received message\n", getpid());
    exit(0);
}