;TITLE Assignment 3    (assignment_3.asm)

; Author: Allison Skinner
; Last Modified: 7/26/2020
; OSU email address: skinneal@oregonstate.edu
; Course number/section: CS 271-400
; Assignment Number: 3                Due Date: 7/26/2020
; Description: Calculate composite numbers.
; 1. Get user's name and greets user.
; 2. Prompt user to enter an integer in the range [1-400]
; 3. Verify that 1<=n<=400. If out of range, reprompt user
; 4. Calculate and display all of the composite numbers
; up to and including the nth composite

INCLUDE Irvine32.inc

; Constants
		UPPER_LIMIT	EQU	400
		LOWER_LIMIT	EQU	1
		PAGE_MAX	EQU	50	
		COL_MAX	EQU	10

.data

; Introduction

programmer	BYTE	"Name: Allison Skinner", 0
programTitle	BYTE	"Program Title: Assignment #3 (Composite Numbers)", 0
intro_EC	BYTE	"-------------------------------------------------------------------", 13, 10,
					"**EC: Align output columns.", 0
intro_EC2	BYTE	"**EC: Display more composites one page at a time.", 13, 10,
					"**EC: Increase Program Efficiency by using prime number divisors.", 13, 10,
					"--------------------------------------------------------------------", 0

; User Instructions and Inputs
namePrompt	BYTE	"Please enter your name: ", 0
usersName	BYTE	50 DUP(0)	
usersNameByte	DWORD	?
greetUser	BYTE	"Hello, ", 0

instructions	BYTE	"Enter the amount of composite numbers you would like to see.", 13, 10,
								"I will accept up to 400 composites.", 0
userNumPrompt	BYTE	"Enter the number of composite numbers you would like to display.", 13, 10,
								"[1-400]: ", 0
rangeError	BYTE	"You are out of bounds. Try again. [1-400]", 0
newPagePrompt	BYTE	"Press any key for the next page.", 0

userNum	DWORD	?

; Farewell Message
exitMsg	BYTE	"Thank you. Have a nice day.", 0

; Variables for isComposite/showComposite procedures
columns	DWORD	0	; width per line
testValue	DWORD	4	; Begins at number 4
compCount	DWORD	?
paging	DWORD	?
primes	DWORD	2, 3, 5, 7, 0	; check for prime divisors
colBuffer1	BYTE	"   ", 0	; single digit numbers
colBuffer2	BYTE	"  ", 0	; double digit numbers
colBuffer3	BYTE	" ", 0	; triple digit numbers

.code

introduction PROC

	; Introduction of programmer
		mov	edx, OFFSET programmer
		call WriteString
		call Crlf

	; Display program title
		mov	edx, OFFSET programTitle
		call WriteString
		call Crlf

	;Display extra credit
		mov	edx, OFFSET intro_EC
		call WriteString
		call Crlf

		mov	edx, OFFSET intro_EC2
		call WriteString
		call Crlf

	; Get user's name and store it
		mov edx, OFFSET namePrompt
		call WriteString
		mov edx, OFFSET usersName
		mov ecx, SIZEOF usersName
		call ReadString

	; Greet user
		mov edx, OFFSET greetUser
		call WriteString
		mov edx, OFFSET usersName
		call WriteString
		call Crlf

	; Display instructions
		mov	edx, OFFSET instructions
		call WriteString
		call Crlf

		ret

introduction ENDP

getUserData	PROC
	mov	edx, OFFSET userNumPrompt
	call WriteString
	call ReadInt
	mov userNum, eax
	call validate
	ret

getUserData ENDP

validate	PROC
	cmp eax, LOWER_LIMIT
	jl rangeErrorMsg
	cmp eax, UPPER_LIMIT
	jg rangeErrorMsg
	jmp validated

		rangeErrorMsg:
		mov edx, OFFSET rangeError
		call WriteString
		call Crlf
		call GetUserData

		validated:
		mov compCount, 0
		mov columns, 0
		mov paging, 0
		ret

validate	ENDP

showComposites	PROC
		printComposites:
		mov eax, paging
		cmp eax, PAGE_MAX
		je newPage
		mov eax, userNum
		cmp eax, compCount
		je leaveLoop

		call isComposite
		inc testValue
		mov eax, columns
		cmp eax, COL_MAX
		je newLine
		jmp printComposites

		newLine:
		call Crlf
		mov columns, 0
		jmp printComposites

		newPage:
		mov edx, OFFSET newPagePrompt
		call WriteString

		lookForKey:
		mov	eax, 50
		call Delay
		call ReadKey
		jz lookForKey

		mov paging, 0
		call Crlf
		call Crlf
		jmp printComposites

		leaveLoop:
		ret

showComposites	ENDP

isComposite	PROC
		pushad

	mov eax, testValue
	cmp eax, 5
	je foundComplete
	cmp eax, 7
	je foundComplete
	mov ebx, 0
	mov esi, OFFSET primes

		divisible:
		mov edx, 0
		mov eax, testValue 

		mov ebx, [esi]

		div ebx
		cmp	edx, 0
		jz composites
		inc	esi
		mov	ebx, [esi]
		cmp ebx, 0
		je	foundComplete
		jmp	divisible

		composites:
		mov eax, testValue
		call numPadding
		call WriteDec
		inc CompCount
		inc columns
		inc paging

		foundComplete:
		popad
		ret

isComposite	ENDP

numPadding	PROC
		pushad

	; check numbers in compCount
	mov eax, compCount
	cmp eax, 10
	jl singleDigit
	cmp eax, 100
	jl doubleDigit
	cmp eax, 1000
	jl tripleDigit

		singleDigit:
		mov edx, OFFSET colBuffer1
		call WriteString
		jmp endPadding

		doubleDigit:
		mov edx, OFFSET colBuffer2
		call WriteString
		jmp endPadding

		tripleDigit:
		mov edx, OFFSET colBuffer3
		call WriteString
		jmp endPadding

		endPadding:
		popad
		ret

numPadding	ENDP

farewell	PROC
	call Crlf
	call Crlf
	mov edx, OFFSET exitMsg
	call WriteString
	call Crlf
	ret

farewell	ENDP

main PROC

	call introduction
	call getUserdata
	call showComposites
	call farewell
	exit	

main ENDP

END main
