**************************************
*
* Name: Nelson Earle
* ID: 12550087
* Date: 2020/09/29
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
N	FCB	1

	ORG	$B010
RESULT	RMB	2

* define any other variables that you might need here
	ORG	$B020
X	FCB	2

	ORG	$B030
CURR  FDB	1
LAST	FDB	1

** program section

	ORG	$C000
	LDD	#1
	STD	RESULT

* while (X < N)
WHILE	LDA	X
	CMPA	N
	BHS	END

* RESULT = LAST + CURR
* calculate the next fib num
	LDD	LAST
	ADDD	CURR
	STD	RESULT

* LAST = CURR
* save the last calculated fib number to LAST
	LDD	CURR
	STD	LAST

* CURR = RESULT
* save the current fib num to CURR
	LDD	RESULT
	STD	CURR

* increment the fib index counter
	INC	X

* jump to top of loop body
	BRA	WHILE

* infinite loop
END	BRA	END