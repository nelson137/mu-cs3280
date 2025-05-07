#define DEBUG

#ifdef DEBUG
#include <stdio.h>
#endif


__uint32_t FIB(__uint8_t N) {
    __uint32_t X;
    __uint32_t CURR;
    __uint32_t LAST;
    __uint32_t RES;

    X = 2;
    CURR = 1;
    LAST = 1;
    RES = 1;

    while (X < N) {
        RES = LAST + CURR;
        LAST = CURR;
        CURR = RES;
        X++;
    }

    return RES;
}


int main() {
    __uint8_t NARR[] = {1, 2, 5, 10, 20, 128, 254, 255, 0};
    __uint32_t RESARR[8];

    __uint8_t *N_PTR;
    __uint32_t *R_PTR;
    __uint8_t N;
    __uint32_t RES;

    N_PTR = &NARR[0];
    R_PTR = &RESARR[0];

    while (*N_PTR != 0) {
        N = *N_PTR;
        RES = FIB(N);
        *R_PTR = RES;
        N_PTR++;
        R_PTR++;
    }

#ifdef DEBUG
    for (int i=0; i<8; i++)
        printf("%3d: $%04X (%u)\n", NARR[i], RESARR[i], RESARR[i]);
#endif
}
