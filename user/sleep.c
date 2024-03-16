//
// Created by hongjie on 15/03/24.
//
#include "kernel/types.h"
#include "user/user.h"


int main(int argc, char *argv[]) {
    if (argc <= 1) {
        fprintf(2, "sleep: please input the time\n");
        exit(1);
    }
    int seconds = atoi(argv[1]);
    sleep(seconds);
    exit(0);
}
