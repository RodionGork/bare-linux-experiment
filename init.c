#include <stdio.h>
#include <string.h>

int main() {
  printf("I'm mini-shell, type in your commands:\n");
  while (1) {
    char ur[1024];
    fgets(ur, sizeof(ur), stdin);
    if (ur[0] < ' ') break;
    printf("%ld - not supported\n", strlen(ur));
  }
  return 0;
}

