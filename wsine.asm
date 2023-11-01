
;	Weerasekara
.INCLUDE"TN2313ADEF.INC"

		RJMP	RESET
		RETI
		RETI
		RETI
		RETI
		RETI
		RETI
		RETI
		RETI
		RETI
		RETI
		RETI
		RETI
		RJMP	MATCH_A
		RJMP	MATCH_B
		RETI
		RETI
		RETI
		RETI
		RETI
		RETI
;----------- MACRO--------------------------------------
.MACRO	IOLD
		LDI		R16,@1
		OUT		@0,R16
.ENDM
;------------ISR-------------------------------------------
	rcall	pntz
MATCH_A:
		LPM	R4,Z+
		tst	r4		;check for delimiter (=0) (last data)
		breq	match_a-1
		OUT	OCR0B,R4	;update pwm value
		out	portb,r18	;active FET
		reti

MATCH_B:out	portb,r2	;r2=0 ;switch off FETs
		RETI
;-----------------------------------------------------------------
RESET:		IOLD	SPL,RAMEND
		IOLD	DDRB,$FF
		IOLD	TCCR0B,0B00001100	; SELECTING PRESCALER AND SETTING THE MODE( frequency is not set yet)
		IOLD	TIMSK,$07		; UNMASKING INTERRUPTS
		IOLD	TCCR0A,0B00000011	; SETTING FAST PWM MODE (7)
		IOLD	OCR0A,250
		ldi	r18,1	;initial FET
		rcall	pntz
		SEI

MAIN:	clr	r2	;always zero (optional)
	rjmp	main
;------------------------ subroutines ----------------------
;point Z to table base & change FET
pntz:	ldi	ZL,low(tbl<<1)
		ldi	ZH,high(tbl<<1)
		swap	r18		;change active FET
		ret
;-------------------------Look-up Table-------------------------------------------------
tbl:
.DB	5,43,79,114,146,175,199,219,233,242,245,242,233,219,199,175,146,114,79,43,5,0
.exit	;===============================================

