**************************************************
*
* Name: Nelson Earle
* ID: 12550087
* Date: 2020/10/28
* Lab4
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


* register caches
	ORG	$CFE0
RADDR	RMB	2
REG_B	RMB	1
REG_X	RMB	2
REG_Y	RMB	2

* variables for subroutine
	ORG	$CFF0
N	RMB	1
X	RMB	1
RES	RMB	4
CUR	RMB	4
LAST	RMB	4


* subroutine
	ORG	$D000
FIB
* cache register values
	STAA	N	* save parameter (fib num index) to variable N
	STAB	REG_B
	STX	REG_X
	STY	REG_Y

	PULX		* save return addr
	DES		* open hole for return value
	DES
	DES
	DES
	PSHX		* restore return addr

* initialize local variables
	LDD	#0
	STD	RES
	STD	CUR
	STD	LAST
	LDD	#1
	STD	RES+2
	STD	CUR+2
	STD	LAST+2
	LDAA	#2
	STA	X

* while (X < N)
WHILE2	LDA	X
	CMPA	N
	BHS	DONE2

* RESULT = LAST + CUR
* calculate the lower half (2 bytes) of the next fib number
	LDD	LAST+2
	ADDB	CUR+3	* lower byte of the lower half
	ADCA	CUR+2	* upper byte of the lower half
	STD	RES+2

* RESULT = LAST + CUR
* calculate the upper half (2 bytes) of the next fib number
	LDD	LAST
	ADCB	CUR+1	* lower byte of the upper half
	ADCA	CUR	* lower byte of the upper half
	STD	RES

* LAST = CUR
* save the calculated fib number to LAST (4 bytes)
	LDD	CUR+2
	STD	LAST+2
	LDD	CUR
	STD	LAST

* CUR = RES
* save the current fib number to CUR (4 bytes)
	LDD	RES+2
	STD	CUR+2
	LDD	RES
	STD	CUR

* increment the fib index counter
	INC	X

	BRA	WHILE2
DONE2
* end while

* return RES
* put RES in the return value hole on the stack
	TSX
	LDD	RES
	STD	2,X
	LDD	RES+2
	STD	4,X

* restore register values
	LDAB	REG_B
	LDX	REG_X
	LDY	REG_Y

	RTS
