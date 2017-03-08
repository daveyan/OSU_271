TITLE Prog02(DY_Prog02.asm)

; Author: David Yan
; Course / Project ID : CS_271_400_S2016	Prog #2
; Date: 4 / 12 / 16
; Description: A program that calculates the values found in a fibonacci sequence.
; User input for the number of sequences is validated and must be in a given range as set by the programmer.

INCLUDE Irvine32.inc

.data

intro_1				BYTE	"Fibonacci Numnbers ", 0
intro_2				BYTE	"Programmed by David Yan ", 0

prompt_name			BYTE	"What's your name? ", 0
prompt_greetings	BYTE	"Hello ", 0

prompt_fib_1		BYTE	"Enter the number of Fibonacci terms to be displayed ", 0
prompt_fib_2		BYTE	"Give the number as an integer in the range [1 .. 46]. ", 0
prompt_fib_3		BYTE	"How many Fibonacci terms do you want? ", 0

prompt_fib_err		BYTE	"Out of range. Enter a number in [1 ... 46] ", 0


prompt_farewell_1	BYTE	"Results certified by David Yan ", 0
prompt_farewell_2	BYTE	"Goodbye ", 0

user_Name			BYTE	256 DUP(0)

user_Fib			DWORD ? ; number of terms the user wants to see
fib_Max				DWORD	46
fib_Min				DWORD	1

num_prev			DWORD ?
num_curr			DWORD ?
num_next			DWORD ?

.code
main PROC

; introductions - programmers name and title

mov		edx, OFFSET intro_1
call	WriteString
call	CrLF

mov		edx, OFFSET intro_2
call	WriteString
call	CrLF

; prompt user for their name

mov		edx, OFFSET prompt_name
call	WriteString

mov		edx, OFFSET user_Name
mov		ecx, 255; maxChar is 256 last is 0
call	ReadString

; greet user

mov		edx, OFFSET prompt_greetings
call	WriteString

mov		edx, OFFSET user_Name
call	WriteString
call	CrLF

; prompt user for number of fib terms to be displayed

mov		edx, OFFSET prompt_fib_1
call	WriteString
call	CrLF
mov		edx, OFFSET prompt_fib_2
call	WriteString
call	CrLF

mov		edx, OFFSET prompt_fib_3
call	WriteString
call	ReadInt

mov		user_Fib, eax

; data validation

DATAVAL:
mov		eax, user_Fib

cmp		eax, fib_Max	; check to see if user val is greater than max
jg		ERROR

cmp		eax, fib_Min	; check to see if user val is less than min
jl		ERROR


jmp		NEXT		;if there is no error it should jump to the NEXT section

ERROR:
	mov		edx, OFFSET prompt_fib_err
	call	WriteString
	call	CrLF

	call	ReadInt
	mov		user_Fib, eax

	jmp		DATAVAL

; fib calculations

NEXT :

mov		ecx, user_Fib	

mov		num_prev, 0
mov		num_curr, 1
mov		num_next, 0

CALC:

;printing the fib number
	mov		eax, num_curr
	call	WriteDec
	call	CrLF
	
	mov		eax, num_prev
	add		eax, num_curr

	mov		num_next, eax		

	mov		eax, num_curr
	mov		num_prev, eax

	mov		eax, num_next
	mov		num_curr, eax

	loop CALC



; farewells

mov		edx, OFFSET prompt_farewell_1
call	WriteString
call	CrLF

mov		edx, OFFSET prompt_farewell_2
call	WriteString
mov		edx, OFFSET user_Name
call	WriteString
call	CrLF

exit
main ENDP

END main