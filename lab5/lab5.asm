**************************************************
*
* Name: Nelson Earle
* ID: 12550087
* Date: 2020/11/11
* Lab5
*
* Program description:
*   Calculate the N'th fibonacci number for each N in a given array. The
*   calculation is done in a transparent subroutine using call by value in a
*   register.
*
* Pseudocode of Main Program:
*
* int main() {
*     __uint8_t NARR[] = {1, 2, 5, 10, 20, 128, 254, 255, 0};
*     __uint32_t RESARR[8];
*
*     __uint8_t N;
*     __uint32_t RES;
*
*     __uint8_t *N_PTR;
*     __uint32_t *R_PTR;
*
*     N_PTR = &NARR[0];
*     R_PTR = &RESARR[0];
*
*     while (*N_PTR != 0) {
*         N = *N_PTR;
*         RES = FIB(N);
*         *R_PTR = RES;
*         N_PTR++;
*         R_PTR++;
*     }
* }
*
*-------------------------------------------------
*
* Pseudocode of Subroutine:
*
* __uint32_t FIB(unsigned char N) {
*     __uint32_t X;
*     __uint32_t CURR;
*     __uint32_t LAST;
*     __uint32_t RES;
*
*     X = 2;
*     CURR = 1;
*     LAST = 1;
*     RES = 1;
*
*     while (X < N) {
*         RES = LAST + CURR;
*         LAST = CURR;
*         CURR = RES;
*         X++;
*     }
*
*     return RES;
* }
*
**************************************************


* data section
	ORG $B000
NARR	FCB	1, 2, 5, 10, 20, 128, 254, 255, $00
SENTIN	EQU	$00

	ORG $B010
RESARR	RMB	32


**************************************************
*
* MAIN
*
**************************************************


* variables for main
	ORG	$BFF0

* main program
	ORG	$C000
	LDS	#$01FF	* initialize stack pointer

	LDX	#NARR	* N_PTR = &NARR[0]
	LDY	#RESARR	* R_PTR = &RESARR[0]

* while (*N_PTR != 0)
WHILE1	LDAA	0,X
	CMPA	#SENTIN
	BEQ	DONE1

* call fib with call-by-value in register: FIB(N)
	JSR	FIB	* N = A reg

* store FIB return value in RESARR: *R_PTR = RES
	PULA		* pull result's 2 high bytes off stack
	PULB
	STD	0,Y	* store result's 2 high bytes in RESARR
	PULA		* pull result's 2 low bytes off stack
	PULB
	STD	2,Y	* store result's 2 low bytes in RESARR

	INX		* N_PTR++
	INY		* R_PTR++
	INY
	INY
	INY

	BRA	WHILE1
DONE1
* end while

END	BRA	END


**************************************************
*
* SUBROUTINE
*
**************************************************


	ORG	$D000
FIB
* open hole for return value
	DES	* 23,X
	DES	* (return addr will be shifted up after registers are cached)
	DES
	DES

* return addr at 21,X

* cache register values for transparency
	PSHY	* 19,X
	PSHX	* 17,X
	PSHB	* 16,X
	PSHA	* 15,X
	TPA
	PSHA	* 14,X * CC

* get current top of stack
	TSX

* shift return addr to its correct spot above the return value hole
	LDD	11,X
	STD	7,X
* clear old return addr for sanity
	CLR	11,X
	CLR	12,X

* open holes for local variables
	DES	* LAST * 10,X * 4 bytes
	DES
	DES
	DES
	DES	* CUR * 6,X * 4 bytes
	DES
	DES
	DES
	DES	* RES * 2,X * 4 bytes
	DES
	DES
	DES
	DES	* X * 1,X * 1 byte
	DES	* N * 0,X * 1 byte

* get current top of stack
	TSX

* copy parameter from cached reg A to N
	LDAA	15,X	* reg A cache
	STAA	0,X	* N

* initialize local variables
	LDD	#0
	STD	2,X	* RES
	STD	6,X	* CUR
	STD	10,X	* LAST
	LDD	#1
	STD	4,X	* RES+2
	STD	8,X	* CUR+2
	STD	12,X	* LAST+2
	LDAA	#2
	STA	1,X	* X

* while (X < N)
WHILE2	LDA	1,X	* X
	CMPA	0,X	* N
	BHS	DONE2

* RESULT = LAST + CUR
* calculate the lower half (2 bytes) of the next fib number
	LDD	12,X	* LAST+2
	ADDB	9,X	* CUR+3 * CUR byte 0 (least significant byte)
	ADCA	8,X	* CUR+2 * CUR byte 1
	STD	4,X	* RES+2

* RESULT = LAST + CUR
* calculate the upper half (2 bytes) of the next fib number
	LDD	10,X	* LAST
	ADCB	7,X	* CUR+1 * CUR byte 2
	ADCA	6,X	* CUR * CUR byte 3 (most significant byte)
	STD	2,X	* RES

* LAST = CUR
* save the calculated fib number to LAST (4 bytes)
	LDD	8,X	* CUR+2
	STD	12,X	* LAST+2
	LDD	6,X	* CUR
	STD	10,X	* LAST

* CUR = RES
* save the current fib number to CUR (4 bytes)
	LDD	4,X	* RES+2
	STD	8,X	* CUR+2
	LDD	2,X	* RES
	STD	6,X	* CUR

* increment the fib index counter
	INC	1,X	* X

	BRA	WHILE2
DONE2
* end while

* return RES
* copy RES into the return value hole
	LDD	2,X	* RES
	STD	23,X	* RET_VAL
	LDD	4,X	* RES+2
	STD	25,X	* RET_VAL+2

* delete local vars
	INS
	INS
	INS
	INS
	INS
	INS
	INS
	INS
	INS
	INS
	INS
	INS
	INS
	INS

* restore cached register values
	PULA
	TAP
	PULA
	PULB
	PULX
	PULY

* return
	RTS
