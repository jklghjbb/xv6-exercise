//
// Created by hongjie on 18/03/24.
//
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fs.h"
#include "kernel/fcntl.h"

char* fmtname(char *path){
  static char buf[DIRSIZ+1];
  char *p;

  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
    ;
  p++;

  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
    return p;
  memmove(buf, p, strlen(p));
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  return buf;
}

void find(char *path, char *target){
    char buf[512], *p;
    int fd;
    struct dirent de;
    struct stat st;

    if((fd = open(path, O_RDONLY)) < 0){
        fprintf(2, "find: cannot open %s\n", path);
        return;
    }
    if(fstat(fd, &st) < 0){
        fprintf(2, "find: cannot stat %s\n", path);
        close(fd);
        return;
    }
    switch(st.type){
        case T_DIR:
            if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
                printf("find: path too long\n");
                break;
            }
            strcpy(buf, path);
            p = buf+strlen(buf);
            *p++ = '/';
            while(read(fd, &de, sizeof(de)) == sizeof(de)){
				if(de.inum == 0 || strcmp(de.name, ".")==0 || strcmp(de.name, "..")==0){
					continue;
				}
				memmove(p, de.name, DIRSIZ);
      			if(stat(buf, &st) < 0){
        			printf("find: cannot stat %s\n", buf);
        			continue;
      			}
				switch(st.type){
					case T_DIR:
						find(buf, target);
						break;
				}
				if(strcmp(target, de.name)==0){
					printf("%s\n", buf);
				}
            }
            break;
        default:
            fprintf(2, "find: %s is not a valid directory\n", path);
    }
}

int main(int argc, char *argv[]){
    if(argc < 3){
       printf("Insufficient arguments");
    }
    find(argv[1], argv[2]);
	exit(0);
}
