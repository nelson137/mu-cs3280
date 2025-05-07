#define DEBUG

#ifndef N
#define N 40
#endif

#ifdef DEBUG
#include <stdio.h>
#endif


int main() {
    long unsigned X;
    long unsigned CURR;
    long unsigned LAST;
    long unsigned RESULT;

    X = 2;
    CURR = 1;
    LAST = 1;
    RESULT = 1;

    while (X < N) {
        RESULT = LAST + CURR;
        LAST = CURR;
        CURR = RESULT;
        X++;
    }

#ifdef DEBUG
    printf("%lu\n", RESULT);
#endif
}
