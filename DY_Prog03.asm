TITLE Prog03(DY_Prog03.asm)

; Author: David Yan
; Course / Project ID : CS_271_400_S2016	Prog #3
; Date: 4 / 26 / 16
; Description: A program that calculates the sum and average of
; a series of negative numbers between - 100 to - 1 until the
; user enters a positive number.
; 
; 
; Note: If the user enters 0 valid values, it will jump to the end of the program
; numbers are validated between the upper and lower vals (ulimit and llimit respectively)
;


INCLUDE Irvine32.inc

.data

promptTitle		BYTE	"Welcome to the Integer Accumulator by David Yan", 0

promptName		BYTE	"What is your name? ", 0
promptGreet		BYTE	"Hello, ", 0

prompt1		BYTE	"Please enter a number in [-100, -1].", 0
prompt2		BYTE	"Enter a non-negative number when you are finished to see results", 0
prompt3		BYTE	"Enter a number: ", 0
prompt4		BYTE	"You entered ", 0
prompt5		BYTE	" valid numbers", 0
prompt6		BYTE	"The sum of your valid numbers is ", 0
prompt7		BYTE	"The rounded average is ", 0
prompt8		BYTE	"Thank you for playing Integer Accumulator! It's been a pleasure meeting you, ", 0

prompt_err1	BYTE	"The number you have entered is less than -100. Please try again",0
prompt_err2	BYTE	"Looks like you don't have any negative numbers to add up", 0

userName	BYTE	256 DUP(0)
userNum		SDWORD	?

totalNum	DWORD	? ; total amount of numbers entered
totalSum	SDWORD	? ; accumulator
average		SDWORD	?
remainder	SDWORD	?

lLimit		SDWORD - 100	; lower limit
uLimit		SDWORD - 1		; upper limit



.code
main PROC


; greet the user

mov		edx, OFFSET promptTitle
call	WriteString
call	CrLF

; gather the user name

mov		edx, OFFSET promptName
call	WriteString

mov		edx, OFFSET userName
mov		ecx, 255
call	ReadString

; zero out initial values


mov		eax, 0
mov		totalNum, eax

mov		eax, 0
mov		totalSum, eax

mov		eax, 0
mov		average, eax

; greet the user

mov		edx, OFFSET promptGreet
call	WriteString

mov		edx, OFFSET userName
call	WriteString

call	CrLF
call	CrLF

; instruct the user on the direction

mov		edx, OFFSET prompt1
call	WriteString
call	CrLF

mov		edx, OFFSET prompt2
call	WriteString
call	CrLF


NEWNUM:

; prompt the user for a number


mov		edx, OFFSET prompt3
call	WriteString

call	ReadInt
	
mov		userNum, eax

; calculations

POSITIVE:

	; check to see if positive


		mov		eax, userNum
		cmp		eax, uLimit
		jg		PRINTRESULTS

		cmp		eax, lLimit
		jl		ERROR

		;if not positive or less than -100, update the totalNum, add to the totalSum

		mov		eax, totalNUM
		add		eax, 1
		mov		totalNum, eax

		neg		userNum
		mov		eax, totalSum
		sub		eax, userNum
		mov		totalSum, eax
		jmp		NEWNUM

ERROR:
;value is less than -100 will prompt the user to reenter a new number - not added to accumulator.


mov		edx, OFFSET prompt_err1
call	WriteString
call	CrLF
jmp		NEWNUM


PRINTRESULTS :

; display the totalNum entered

mov		edx, OFFSET prompt4
call	WriteString

mov		eax, totalNum
call	WriteDec

mov		edx, OFFSET prompt5
call	WriteString

call	CrLF

; if the user enetered 0 valid numbers, it will jump to the  goodbye
mov		eax, totalNum
cmp		eax, 0
jz		NOVALID

; display the totalSum calculated

mov		edx, OFFSET prompt6
call	WriteString



mov		eax, totalSum
call	WriteInt

call	CrLF

; display the average calculated

mov		edx, OFFSET prompt7
call	WriteString


; calculate average

mov		edx,0



mov		eax, totalSum
cdq
mov		ebx, totalNum
idiv	ebx
mov		average, eax
mov		remainder, edx


;rounding the average to the nearest integer

mov eax, average
mov ecx, totalNum

cdq	
shr ecx, 1

mov edx, remainder
neg edx
cmp ecx,edx

jge	DISPLAYAVG

PLUSONE:
dec eax
mov average, eax
jmp		DISPLAYAVG

NOVALID :

mov		edx, OFFSET prompt_err2
call	WriteString
call	CrLF
jmp		GOODBYE

DISPLAYAVG:

mov		eax, average
call	WriteInt


call	CrLF

; goodbyes

GOODBYE:

mov		edx, OFFSET prompt8
call	WriteString

mov		edx, OFFSET userName
call	WriteString

call	CrLF


	exit
main ENDP

END main
