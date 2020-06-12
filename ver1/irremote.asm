; Remote Controller for リモコンセントVII
; 2010/12/01
; T. Nakagawa

; CPU Clock: 1MHz (Internal RC Osc.)
; PD[01456]: IR-LED
; INT0: ON
; INT1: OFF

.include "tn2313def.inc"

.def	irled_off=r16
.def	irled_on=r17

; interrupt vector
	rjmp	reset
	rjmp	int_on
	rjmp	int_off
	reti
	reti
	reti
	reti
	reti
	reti
	reti
	reti
	reti
	reti
	reti
	reti
	reti
	reti
	reti
	reti

reset:
	; stack
	ldi	ZL, RAMEND
	out	SPL, ZL
	; register
	ldi	irled_off, 0x0c
	ldi	irled_on, 0x73
	; I/O
	ldi	ZL, 0xff
	out	PORTA, ZL
	out	PORTB, ZL
	ldi	ZL, 0x73
	out	DDRD, ZL
	ldi	ZL, 0x0c
	out	PORTD, ZL
	; sleep mode(power-down)
	ldi	ZL, (EXP2(SE) | EXP2(SM0))
	out	MCUCR, ZL
	; analog comparator off
	ldi	ZL, EXP2(ACD)
	out	ACSR, ZL
	; interruption enable
	ldi	ZL, (EXP2(INT0) | EXP2(INT1))
	out	GIMSK, ZL
main:
	sei
	sleep
	cli
main0:	in	ZL, PIND
	cpi	ZL, 0x0c
	brne	main0
	rjmp	main

; ONスイッチによる割り込み
int_on:
	rcall	ir_header
	rcall	ir_L
	rcall	ir_L
	rcall	ir_S
	rcall	ir_S
	rcall	ir_L
	rcall	ir_L
	rcall	ir_S
	rcall	ir_L
	rcall	ir_S
	rcall	ir_S
	rcall	ir_S
	rcall	ir_L
	rcall	ir_L
	rcall	ir_S
	rcall	ir_S
	rcall	ir_S
	rcall	ir_S
	rcall	ir_S
	rcall	ir_S
	rcall	ir_S
	rcall	ir_L
	rcall	ir_S
	rcall	ir_S
	rcall	ir_S
	rcall	ir_trailer
	reti

; OFFスイッチによる割り込み
int_off:
	rcall	ir_header
	rcall	ir_L
	rcall	ir_L
	rcall	ir_S
	rcall	ir_S
	rcall	ir_L
	rcall	ir_L
	rcall	ir_S
	rcall	ir_L
	rcall	ir_S
	rcall	ir_S
	rcall	ir_S
	rcall	ir_L
	rcall	ir_S
	rcall	ir_L
	rcall	ir_S
	rcall	ir_S
	rcall	ir_S
	rcall	ir_S
	rcall	ir_S
	rcall	ir_S
	rcall	ir_S
	rcall	ir_L
	rcall	ir_S
	rcall	ir_S
	rcall	ir_trailer
	reti

; 赤外線の送信(H:580us, L:880us)
ir_header:
	rcall	lpulse
	ldi	ZL, 88
	rcall	wait10us
	ret

; 赤外線の送信(H:300us, L:?)
ir_trailer:
	rjmp	ir_L

; 赤外線の送信(H:300us, L:880us)
ir_S:
	rcall	spulse
	ldi	ZL, 88
	rcall	wait10us
	ret

; 赤外線の送信(H:300us, L:2050us)
ir_L:
	rcall	spulse
	ldi	ZL, 205
	rcall	wait10us
	ret

; 580usのON(38kHz, 1/3 duty)=H=8.77us/L=17.54usのパルス21個
lpulse:
	ldi	ZL, 21
lpls0:	out	PORTD, irled_on
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	out	PORTD, irled_off
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	dec	ZL
	brne	lpls0
	ret

; 300usのON(38kHz, 1/3 duty)=H=8.77us/L=17.54usのパルス11個
spulse:
	ldi	ZL, 11
spls0:	out	PORTD, irled_on
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	out	PORTD, irled_off
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	dec	ZL
	brne	spls0
	ret

; 10usのウェイト
wait10us:
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	dec	ZL
	brne	wait10us
	ret
