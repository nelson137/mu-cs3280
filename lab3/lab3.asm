**************************************
*
* Name: Nelson Earle
* ID: 12550087
* Date: 2020/10/12
* Lab2
*
* Program description: Calculate the N'th Fibonacci number
*
* Pseudocode:
*
* int main() {
*     long unsigned X;
*     long unsigned CURR;
*     long unsigned LAST;
*     long unsigned RESULT;
*
*     X = 2;
*     CURR = 1;
*     LAST = 1;
*     RESULT = 1;
*
*     while (X < N) {
*         RESULT = LAST + CURR;
*         LAST = CURR;
*         CURR = RESULT;
*         X++;
*     }
* }
*
**************************************

** data section

	ORG	$B000
N	FCB	40
	ORG	$B010
RESULT	RMB	4

* define any other variables that you might need here
	ORG	$B020
X	FCB	2

	ORG	$B030
CURR	RMB	4
LAST	RMB	4

** program section

	ORG	$C000
	LDD	#1
	STD	RESULT
	STD	CURR+2
	STD	LAST+2
	LDD	#0
	STD	CURR
	STD	LAST

* while (X < N)
WHILE	LDA	X
	CMPA	N
	BHS	END

* RESULT = LAST + CURR
* calculate the lower half (2 bytes) of the next fib num
	LDD	LAST+2
	ADDB	CURR+3	* lower byte of the lower half
	ADCA	CURR+2	* upper byte of the lower half
	STD	RESULT+2

* RESULT = LAST + CURR
* calculate the upper half (2 bytes) of the next fib num
	LDD	LAST
	ADCB	CURR+1	* lower byte of the upper half
	ADCA	CURR	* upper byte of the upper half
	STD	RESULT

* LAST = CURR
* save the last calculated fib number to LAST (4 bytes)
	LDD	CURR+2
	STD	LAST+2
	LDD	CURR
	STD	LAST

* CURR = RESULT
* save the current fib num to CURR (4 bytes)
	LDD	RESULT+2
	STD	CURR+2
	LDD	RESULT
	STD	CURR

* increment the fib index counter
	INC	X

* jump to top of loop body
	BRA	WHILE

* infinite loop
END	BRA	END
