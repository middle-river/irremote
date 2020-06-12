/*
  IR Remote Controller for AGLED ACL-6DG
  2020-06-08
  T. Nakagawa

  MPU: ATtiny2313
  Clock: 1MHz (Internal RC Osc.)
  PD2(INT0): (IN)Switch1
  PD3(INT1): (IN)Switch2
  PD5: (OUT)IR-LED
*/

#define __ASSEMBLER__
#include <avr/io.h>

	.org	0

// interrupt vector
	rjmp	reset
	rjmp	ext_int0
	rjmp	ext_int1
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
	// Stack
	ldi	ZL, RAMEND
	out	_SFR_IO_ADDR(SPL), ZL
	// Constants
	clr	r0
	clr	r1
	com	r1
	ldi	XH, 0xdf
	// I/O
	mov	ZL, r1
	out	_SFR_IO_ADDR(PORTA), ZL
	out	_SFR_IO_ADDR(PORTB), ZL
	mov	ZL, XH
	out	_SFR_IO_ADDR(PORTD), ZL
	com	ZL
	out	_SFR_IO_ADDR(DDRD), ZL
	// Enable power-down sleep mode
	ldi	ZL, (_BV(SE) | _BV(SM0))
	out	_SFR_IO_ADDR(MCUCR), ZL
	// Analog comparator off
	ldi	ZL, _BV(ACD)
	out	_SFR_IO_ADDR(ACSR), ZL
	// Enable interruption
	ldi	ZL, (_BV(INT0) | _BV(INT1))
	out	_SFR_IO_ADDR(GIMSK), ZL
main:
	sei
	sleep
	out	_SFR_IO_ADDR(PORTD), XH
	rjmp	main

// Pulse (38kHz, 1/3 duty, period=YH:YL/38k sec)
pulse:
	inc	YH
	// Flip output
	com	XL
	mov	ZL, XL
	or	ZL, XH
pulse_:	out	_SFR_IO_ADDR(PORTD), ZL  // IR-LED on
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	out	_SFR_IO_ADDR(PORTD), XH  // IR-LED off
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
	dec	YL
	brne	pulse_
	dec	YH
	brne	pulse_
	ret

pulse0:
	ldi	YL, lo8(21)
	ldi	YH, hi8(21)
	rjmp	pulse
pulse1:
	ldi	YL, lo8(23)
	ldi	YH, hi8(23)
	rjmp	pulse
pulse2:
	ldi	YL, lo8(62)
	ldi	YH, hi8(62)
	rjmp	pulse
pulse3:
	ldi	YL, lo8(82)
	ldi	YH, hi8(82)
	rjmp	pulse
pulse4:
	ldi	YL, lo8(169)
	ldi	YH, hi8(169)
	rjmp	pulse
pulse5:
	ldi	YL, lo8(341)
	ldi	YH, hi8(341)
	rjmp	pulse
pulse6:
	ldi	YL, lo8(1787)
	ldi	YH, hi8(1787)
	rjmp	pulse

ext_int0:
	clr	XL
	rcall	pulse5
	rcall	pulse4
	rcall	pulse0
	rcall	pulse2
	rcall	pulse0
	rcall	pulse0
	rcall	pulse0
	rcall	pulse2
	rcall	pulse0
	rcall	pulse0
	rcall	pulse0
	rcall	pulse2
	rcall	pulse0
	rcall	pulse2
	rcall	pulse0
	rcall	pulse2
	rcall	pulse0
	rcall	pulse0
	rcall	pulse0
	rcall	pulse0
	rcall	pulse0
	rcall	pulse2
	rcall	pulse0
	rcall	pulse0
	rcall	pulse0
	rcall	pulse0
	rcall	pulse0
	rcall	pulse2
	rcall	pulse0
	rcall	pulse0
	rcall	pulse0
	rcall	pulse0
	rcall	pulse0
	rcall	pulse0
	rcall	pulse0
	rcall	pulse2
	rcall	pulse0
	rcall	pulse2
	rcall	pulse0
	rcall	pulse2
	rcall	pulse0
	rcall	pulse0
	rcall	pulse0
	rcall	pulse0
	rcall	pulse0
	rcall	pulse0
	rcall	pulse0
	rcall	pulse0
	rcall	pulse0
	rcall	pulse0
	rcall	pulse0
	rcall	pulse0
	rcall	pulse0
	rcall	pulse2
	rcall	pulse0
	rcall	pulse0
	rcall	pulse0
	rcall	pulse0
	rcall	pulse0
	rcall	pulse0
	rcall	pulse0
	rcall	pulse0
	rcall	pulse0
	rcall	pulse0
	rcall	pulse0
	rcall	pulse0
	rcall	pulse1
	rcall	pulse6
	rcall	pulse5
	rcall	pulse3
	rcall	pulse1
	ret

ext_int1:
	clr	XL
	rcall	pulse5
	rcall	pulse4
	rcall	pulse0
	rcall	pulse2
	rcall	pulse0
	rcall	pulse0
	rcall	pulse0
	rcall	pulse2
	rcall	pulse0
	rcall	pulse0
	rcall	pulse0
	rcall	pulse2
	rcall	pulse0
	rcall	pulse2
	rcall	pulse0
	rcall	pulse2
	rcall	pulse0
	rcall	pulse0
	rcall	pulse0
	rcall	pulse0
	rcall	pulse0
	rcall	pulse2
	rcall	pulse0
	rcall	pulse0
	rcall	pulse0
	rcall	pulse0
	rcall	pulse0
	rcall	pulse2
	rcall	pulse0
	rcall	pulse0
	rcall	pulse0
	rcall	pulse0
	rcall	pulse0
	rcall	pulse0
	rcall	pulse0
	rcall	pulse2
	rcall	pulse0
	rcall	pulse2
	rcall	pulse0
	rcall	pulse0
	rcall	pulse0
	rcall	pulse0
	rcall	pulse0
	rcall	pulse0
	rcall	pulse0
	rcall	pulse0
	rcall	pulse0
	rcall	pulse0
	rcall	pulse0
	rcall	pulse0
	rcall	pulse0
	rcall	pulse0
	rcall	pulse0
	rcall	pulse2
	rcall	pulse0
	rcall	pulse0
	rcall	pulse0
	rcall	pulse0
	rcall	pulse0
	rcall	pulse0
	rcall	pulse0
	rcall	pulse0
	rcall	pulse0
	rcall	pulse0
	rcall	pulse0
	rcall	pulse0
	rcall	pulse1
	rcall	pulse6
	rcall	pulse5
	rcall	pulse3
	rcall	pulse1
	ret
