TITLE Prog01(DY_Prog01.asm)

;Author: David Yan
;Course/Project ID : CS_271_400_S2016	Prog #1
;Date: 4/6/16
;Description: This program prompts the user for two integers. Using the
; two integers, it will calculate and displate the sum difference product and
; quotient with remainder to the user.

INCLUDE Irvine32.inc


.data

firstNum	DWORD ?
secondNum	DWORD ?

intro_1		BYTE	"Title: Prog01	by David Yan", 0
intro_2		BYTE	"Enter 2 numbers, and I'll show you the sum, difference, product, quotient, and remainder.", 0
prompt_1	BYTE	"First number: ", 0
prompt_2	BYTE	"Second number: ", 0

calc_prompt_1	BYTE	" + ", 0
calc_prompt_2	BYTE	" - ", 0
calc_prompt_3	BYTE	" x ", 0
calc_prompt_4	BYTE	" / ", 0
calc_equal	BYTE	" = ", 0
calc_remain	BYTE	" remainder ", 0

goodbye 	BYTE	"Impressed?	Bye! ", 0

numS	DWORD ? ; sum
numD	DWORD ? ; difference
numP	DWORD ? ; product
numQ	DWORD ? ; quotient
numR	DWORD ? ; remainder


.code
main PROC
; print title

mov		edx, OFFSET intro_1
call	WriteString
call	CrLF

; print intro

mov		edx, OFFSET intro_2
call	WriteString
call	CrLF
call	CrLF

; get first number

mov		edx, OFFSET prompt_1
call	WriteString
call	ReadInt
mov		firstNum, eax


; get second number

mov		edx, OFFSET prompt_2
call	WriteString
call	ReadInt
mov		secondNum, eax
call	CrLF

; add numbers

	mov		eax, firstNum
	add		eax, secondNum

	mov		numS, eax

;display the sum

	mov		eax, firstNum
	call	WriteDec
	mov		edx, OFFSET calc_prompt_1
	call	WriteString
	mov		eax, secondNum
	call	WriteDec
	mov		edx, OFFSET calc_equal
	call	WriteString
	mov		eax, numS
	call	WriteDec	

	call	CrLF


; sub numbers

	mov		eax, firstNum
	sub		eax, secondNum

	mov		numD, eax

; display the difference

	mov		eax, firstNum
	call	WriteDec
	mov		edx, OFFSET calc_prompt_2
	call	WriteString
	mov		eax, secondNum
	call	WriteDec
	mov		edx, OFFSET calc_equal
	call	WriteString
	mov		eax, numD
	call	WriteDec

	call	CrLF


; mul numbers

	mov		eax, firstNum
	mov		ebx, secondNum
	mul		ebx

	mov		numP, eax

; display the product

	mov		eax, firstNum
	call	WriteDec
	mov		edx, OFFSET calc_prompt_3
	call	WriteString
	mov		eax, secondNum
	call	WriteDec
	mov		edx, OFFSET calc_equal
	call	WriteString
	mov		eax, numP
	call	WriteDec

	call	CrLF

; div numbers


	mov		eax, firstNum
	mov		ebx, secondNum
	sub		edx, edx
	div		ebx

	
	mov		numQ, eax
	mov		numR, edx

; display the quotient

	mov		eax, firstNum
	call	WriteDec
	mov		edx, OFFSET calc_prompt_4
	call	WriteString
	mov		eax, secondNum
	call	WriteDec

	mov		edx, OFFSET calc_equal
	call	WriteString
	mov		eax, numQ
	call	WriteDec


	mov		edx, OFFSET calc_remain
	call	WriteString

; display  the remainder

	mov		eax, numR
	call	WriteDec

	call	CrLF


; good bye

	mov		edx, OFFSET goodbye
	call	WriteString
	call	CrLF


exit				
main ENDP

END main