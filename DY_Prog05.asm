TITLE Prog05(DY_Prog05.asm)

; Author: David Yan
; Course / Project ID : CS_271_400_S2016	Prog #5
; Date: 5 / 17 / 16
; Description: a program that fills an array with randomly generated numbers.
; the user is prompted for an array size between 10 to 200
; generated numbers fall between 100 and 999
;
; variables are passed between procedures via the stack


INCLUDE Irvine32.inc

MAX_SIZE = 200

.data

; introduction variables
introduction_1	BYTE	"Sorting Random Integers			Programmed by David Yan", 0
introduction_2	BYTE	"This program generates random numbers in the range [100... 999],", 0
introduction_3	BYTE	"displays the original list, sorts the list, and calucluates the", 0
introduction_4	BYTE	"median value. Finally, it displaus the list sorted in descending order", 0

; getData variables
getData_1	BYTE	"How many numbers should be generated? [10 .. 200] : ", 0
getData_2	BYTE	"Invalid input", 0
userCount	DWORD ?
max			DWORD	200
min			DWORD	10

; fillArray variables
randomArr	DWORD	MAX_SIZE	DUP(? )
count		DWORD	0
hi			DWORD	999
lo			DWORD	100

; displayList variables
perLine		DWORD	0
dList_u		BYTE	"The unsorted random numbers: ", 0
dList_s		BYTE	"The sorted list: ", 0
spacer		BYTE	"   ", 0

; sortList variables
outerUserCount		DWORD ?
isSorted	DWORD	0; acts as a bool for whether or not the list has been sorted

; displayMedian variables
dMedian		BYTE	"The median is ", 0


.code
main PROC

; generates random numbers
call	randomize

; introduction prompts
call	introduction

; collect user data
push	userCount
call	getData

; filling array with random numbers
push	OFFSET	randomArr
push	userCount
call	fillArray

; display the unsorted list of array that was randomly generated
push	OFFSET randomArr
push	userCount
push	perLine
push	isSorted
call	displayList

; sorts the list - nothing is displayed to the user
push	OFFSET	randomArr
push	userCount
push	isSorted
call	sortList

; displays the calculated median to the user
push	OFFSET	randomArr
push	userCount
call	displayMedian

; displays the sorted list to the user
push	OFFSET randomArr
push	userCount
push	perLine
push	isSorted
call	displayList

exit
main ENDP

introduction PROC
; Description: displays the introduction to the user

mov		edx, OFFSET introduction_1
call	WriteString
call	CrLF

mov		edx, OFFSET introduction_2
call	WriteString
call	CrLF

mov		edx, OFFSET introduction_3
call	WriteString
call	CrLF

mov		edx, OFFSET introduction_4
call	WriteString
call	CrLF

ret
introduction ENDP

getData PROC
; Description: gathers the information from the user to be used

push	ebp
mov		ebp, esp

call	CrLF

COLLECTDATA :

mov		edx, OFFSET getData_1
call	WriteString
call	ReadInt
mov		[ebp + 8], eax; copies the information back onto the stack

;data validation
cmp		eax, max
jg		err

cmp		eax, min
jl		err

mov		userCount, eax

jmp		return

err:

mov		edx, OFFSET getData_2
call	WriteString
call	CrLF
; invalid value - repeat the data collection
jmp		COLLECTDATA


return:
call	CrLF

pop ebp
ret 4

getData ENDP

fillArray PROC
; Description: fills the pushed array with randomly generated numbers

push	ebp
mov		ebp, esp

mov		ecx, [ebp + 8]; the userCount
mov		edi, [ebp + 12]; the address of randomArr



genNum:
mov		eax, 900
call	RandomRange
add		eax, lo
mov[edi], eax
add		edi, 4

loop	genNum; loops for a usercount amount of times

pop		ebp
ret		8

fillArray ENDP

sortList PROC
; Description: Sorts the values found within the array.
; boolean isSorted is incremented from 0
push	ebp
mov		ebp, esp
mov		ebx, [ebp + 8]; isSorted
mov		ecx, [ebp + 12]; userCount
dec		ecx; outer loop =  n-1 times

outLoop:
	mov		edi,[ebp+16]
	mov		outerUserCount,ecx

inLoop:
	mov		eax, [edi]
	cmp		eax, [edi + 4]; compare "array[a]" and "array[a+1]"

	jl		nextNum

	xchg	eax, [edi + 4]; swap numbers
	mov		[edi],eax


nextNum:
	add		edi, 4
	loop	inLoop

	mov		ecx, outerUserCount
	loop	outLoop

	;increases the isSorted for validation purposes
	mov		eax,1
	mov		isSorted,eax

	pop		ebp
	ret		12

sortList ENDP

displayMedian PROC
; Description: calculates the median value in the array
push	ebp
mov		ebp, esp
mov		ecx, [ebp +8]
mov		edi, [ebp + 12]

mov		eax,ecx
mov		ebx, 2
sub		edx,edx
idiv	ebx;dividing to usercount by 2 to find the middle value

cmp		edx, 0
jnz		oddCount

jmp		evenCount

oddCount:
	;if it is odd there is no additional rounding needed
	mov		ecx, eax
	mov		eax, [edi + 4 * ecx]
	jmp		printMed

evenCount:
	;checking if the remainder in edx will round up or down
	mov		ecx, eax
	mov		eax, [edi + 4 * ecx]
	dec		ecx
	mov		ebx, [edi + 4 * ecx]

	add		eax,ebx
	sub		edx,edx
	mov		ebx,2
	div		ebx
	shr		ebx,1

	cmp		edx,ebx
	jge		plusOne
	jmp		printMed

plusOne:
	;rounding up
	inc		eax

printMed:
	mov       edx, OFFSET dMedian
	call      WriteString
	call      WriteDec
	call      CrLf
	call      CrLf

	pop		ebp
	ret		8
displayMedian ENDP

displayList PROC

push	ebp
mov		ebp, esp
mov		edx, [ebp + 8];		isSorted
mov		ebx, [ebp + 12];	perLine
mov		ecx, [ebp + 16];	userCount
mov		edi, [ebp + 20];	address of randomArr

mov		eax, edx
cmp		eax,0

;checking to see if the array has been sorted or not
je		notSorted

jmp		sorted

notSorted:

	mov		edx, OFFSET dList_u
	call	WriteString
	call	CrLF
	jmp		more

sorted:
	mov		edx, OFFSET dList_s
	call	WriteString
	call	CrLF

more:
	inc		ebx
	cmp		ebx,10
	jg		newLine

	sameLine:	
		mov		eax,[edi]
		call	WriteDec
		mov		edx, OFFSET spacer
		call	WriteString
		add		edi, 4

	
	loop	more
	jmp		return

newLine :
	mov ebx, 1
	call CrLF
	jmp sameLine

return:
	call	CrLF
	call	CrLF

	pop		ebp
	ret		16

displayList ENDP

END main
