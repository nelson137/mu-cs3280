**************************************************
* Homework 5 Question 3
* Nelson Earle
* 2020-11-18
*
* The main program will put $FF, $00, $FF, $00, ...
*   on PortC indefinitely.
* The interrupt routine will increment the global
*   counter variable RESULT.
**************************************************


	ORG	$D000
RESULT	RMB	2
PORTC	EQU	$1003
DDRC	EQU	$1007


**************************************************
* MAIN
**************************************************


	ORG	$C000
MAIN
* initialize stack
	LDS	#$01FF

* enable interrupts
	CLI

* setup PORTC
	CLR	PORTC
	LDAA	#%11111111
	STAA	DDRC

* initialize RESULT counter
	LDD	#$0000
	STD	RESULT

* initialize PORTC output data
	LDD	#$00FF

* infinite loop
* uses NOP to mostly even out the length of time
* that $00 and $FF are on PortC
* ($00 is on for 1 less clock cycle than $FF)
LOOP	STAA	PORTC	* 4 clock cycles
	NOP		* 2 clock cycles
	STAB	PORTC	* 4 clock cycles
	BRA	LOOP	* 3 clock cycles


**************************************************
* ISR
**************************************************


	ORG	$B000
ISR
* increment RESULT
	LDD	RESULT
	ADDB	#$01
	ADCA	#$00
	STD	RESULT
	RTI

* store ISR addr in the interrupt vector
	ORG	$FFF2
	FDB	ISR