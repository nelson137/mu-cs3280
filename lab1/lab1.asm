**************************************************
*
*  This program will add data1 and data3 and subtract data2
*  Nelson Earle (nwewnh)
*  2020/9/18
*
*    Step  |  PC     |  Register A  |  Mem $B003  |  NZVC
*  --------------------------------------------------------
*    1     |  $C000  |  $0A         |  $0000      |  0000
*    2     |  $C000  |  $FB         |  $0000      |  1001
*    3     |  $C000  |  $15         |  $0000      |  0001
*    4     |  $C000  |  $0A         |  $000F      |  0001
*
**************************************************

* data location starts at $B000
			ORG	$B000
DATA1		FCB	10		$B000 : declare 1-byte variable DATA1 with value 10
DATA2		FCB	15		$B001 : declare 1-byte variable DATA2 with value 15
DATA3		FCB	$1A		$B002 : declare 1-byte variable DATA3 with value $1A
RESULT	RMB	1		$B003 : declare 1-byte variable RESULT

* main program starts at $C000
	ORG	$C000
	LDAA	DATA1		1) regA = DATA1
	SUBA	DATA2		2) regA -= DATA2
	ADDA	DATA3		3) regA += DATA3
	STAA	RESULT	4) RESULT = regA
DONE	BRA	DONE		infinite loop
	END
