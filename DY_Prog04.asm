TITLE Prog04					(DY_Prog04.asm)

; Author: David Yan
; Course / Project ID : CS_271_400_S2016	Prog #4
; Date: 5 / 7 / 16
; Description: A program that prints out all composite number up and including the
; nth composite as given by the user 
;
; note_1: the userNum is validated between 1 and 400 (uLimit and lLimit)
;
; note_2: there are two sub procedures that are not called directly in the main
; procedure.both "validate" and "isComposite" is called from getUserData and showComposite respectively


INCLUDE Irvine32.inc

.data

; intro variables
intro_greet	BYTE	"Composite Numbers			Programmed by David", 0
intro_1		BYTE	"Enter the number of composite numbers you would like to see.", 0
intro_2		BYTE	"I'll accept orders for up to 400 composites.", 0

; getData variables
getData_1	BYTE	"Enter the number of composites to display [1 ... 400] ", 0
userNum		DWORD ?

; validatas variables
uLimit		DWORD 400
lLimit		DWORD 1
outOfRange	BYTE	"Out of Range. Try again. ", 0
numInRow	DWORD 10; the number of values in a row

; showComposite variables
totalNumD	DWORD 0; total amount of numbers displayed to be compared to userNum
testNum		DWORD 4; number to be tested incremented : starts at the value 4 (which is the first composite number)
spacer		BYTE "   ", 0; 3 spaces

; isComposite variables
; n / a

; farewell variables
farewell_1	BYTE	"Results certified by David. Goodbye.", 0

.code
main PROC

call intro
call getUserData
call showComposite
call farewell

exit
main ENDP

intro PROC

mov		edx, OFFSET intro_greet
call	WriteString
call	CrLF
call	CrLF

mov		edx, OFFSET intro_1
call	WriteString
call	CrLF

mov		edx, OFFSET intro_2
call	WriteString
call	CrLF
call	CrLF

ret
intro ENDP


getUserData PROC

mov		edx, OFFSET getData_1
call	WriteString
call	ReadInt
mov		userNum, eax

call	validate; always moves to validate

ret
getUserData ENDP

validate PROC

; if the useNum is greater than upper limit
mov eax, userNum
cmp	eax, uLimit
jg	ERR

; if the userNum is lower than lower limit
cmp eax, lLimit
jl	ERR

; number is valid and will jump to continue
jmp CONTINUE

ERR : ;Error Out of range

mov		edx, OFFSET outOfRange
call	WriteString
call	CrLF

call	getUserData			;loops around to get user data again

CONTINUE:


mov ecx, numInRow

ret
validate ENDP

showComposite PROC

; INITIAL VALS
; testNum = 4
; totalNumD = 0

mov		eax, testNum
call	WriteDec

mov		edx, OFFSET spacer
call	WriteString
dec		ecx


cmp		ecx, 0
jz		NEWLINE

CONT:
	inc		totalNumD
	call	isComposite

	;if isComposite doesn't do anything, it will jump to the end of the procedure
	jmp		RETURN

;prints out 10 values before making a new line

NEWLINE:

	call	CrLF
	mov ecx, numInRow

	jmp	CONT


RETURN:

	ret
		showComposite ENDP

isComposite PROC

;if totalNumD is equal to the userNum then we are done (jump to RETURN)

mov eax, totalNumD
mov ebx, userNum
cmp	eax, ebx
je RETURN

;increments the test number and resets the divisor to 2
NEWNUM:

	inc testNum
	mov ebx, 2

COMPTEST:

	;if the divisor is equal to the dividend, it is a prime number (looped from 2 to testNum)
	cmp ebx, testNum
	je NEWNUM

	mov eax, testNum
	sub edx,edx
	div ebx

	;a remainder of 0 would indicate a clean quotient and therefore a composite number
	cmp edx, 0

	je COMPOSITE

	;if it isn't 0 then increment the divisor
	inc ebx
	jmp COMPTEST

COMPOSITE:

	call showComposite


RETURN:
ret
isComposite ENDP

farewell PROC

call	CrLF
mov		edx, OFFSET farewell_1
call	WriteString
call	CrLF

ret
farewell ENDP

END main