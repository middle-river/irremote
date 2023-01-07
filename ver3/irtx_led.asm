/*
  IR Remote Controller for Yselect YLLS-06J2.
  2023-01-07
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
	ldi	YL, lo8(20)
	ldi	YH, hi8(20)
	rjmp	pulse
pulse1:
	ldi	YL, lo8(22)
	ldi	YH, hi8(22)
	rjmp	pulse
pulse2:
	ldi	YL, lo8(62)
	ldi	YH, hi8(62)
	rjmp	pulse
pulse3:
	ldi	YL, lo8(169)
	ldi	YH, hi8(169)
	rjmp	pulse
pulse4:
	ldi	YL, lo8(340)
	ldi	YH, hi8(340)
	rjmp	pulse

// Power.
ext_int0:
	clr	XL
	rcall	pulse4
	rcall	pulse3
	rcall	pulse1
	rcall	pulse0
	rcall	pulse1
	rcall	pulse2
	rcall	pulse1
	rcall	pulse0
	rcall	pulse1
	rcall	pulse2
	rcall	pulse1
	rcall	pulse2
	rcall	pulse1
	rcall	pulse0
	rcall	pulse1
	rcall	pulse0
	rcall	pulse1
	rcall	pulse2
	rcall	pulse1
	rcall	pulse2
	rcall	pulse1
	rcall	pulse0
	rcall	pulse1
	rcall	pulse2
	rcall	pulse1
	rcall	pulse0
	rcall	pulse1
	rcall	pulse0
	rcall	pulse1
	rcall	pulse0
	rcall	pulse1
	rcall	pulse2
	rcall	pulse1
	rcall	pulse0
	rcall	pulse1
	rcall	pulse0
	rcall	pulse1
	rcall	pulse0
	rcall	pulse1
	rcall	pulse2
	rcall	pulse1
	rcall	pulse0
	rcall	pulse1
	rcall	pulse0
	rcall	pulse1
	rcall	pulse0
	rcall	pulse1
	rcall	pulse0
	rcall	pulse1
	rcall	pulse0
	rcall	pulse1
	rcall	pulse2
	rcall	pulse1
	rcall	pulse2
	rcall	pulse1
	rcall	pulse0
	rcall	pulse1
	rcall	pulse2
	rcall	pulse1
	rcall	pulse2
	rcall	pulse1
	rcall	pulse2
	rcall	pulse1
	rcall	pulse2
	rcall	pulse1
	rcall	pulse2
	rcall	pulse1
	ret

// Small.
ext_int1:
	clr	XL
	rcall	pulse4
	rcall	pulse3
	rcall	pulse1
	rcall	pulse0
	rcall	pulse1
	rcall	pulse2
	rcall	pulse1
	rcall	pulse0
	rcall	pulse1
	rcall	pulse2
	rcall	pulse1
	rcall	pulse2
	rcall	pulse1
	rcall	pulse0
	rcall	pulse1
	rcall	pulse0
	rcall	pulse1
	rcall	pulse2
	rcall	pulse1
	rcall	pulse2
	rcall	pulse1
	rcall	pulse0
	rcall	pulse1
	rcall	pulse2
	rcall	pulse1
	rcall	pulse0
	rcall	pulse1
	rcall	pulse0
	rcall	pulse1
	rcall	pulse0
	rcall	pulse1
	rcall	pulse2
	rcall	pulse1
	rcall	pulse0
	rcall	pulse1
	rcall	pulse0
	rcall	pulse1
	rcall	pulse0
	rcall	pulse1
	rcall	pulse0
	rcall	pulse1
	rcall	pulse2
	rcall	pulse1
	rcall	pulse0
	rcall	pulse1
	rcall	pulse0
	rcall	pulse1
	rcall	pulse0
	rcall	pulse1
	rcall	pulse2
	rcall	pulse1
	rcall	pulse2
	rcall	pulse1
	rcall	pulse2
	rcall	pulse1
	rcall	pulse2
	rcall	pulse1
	rcall	pulse0
	rcall	pulse1
	rcall	pulse2
	rcall	pulse1
	rcall	pulse2
	rcall	pulse1
	rcall	pulse2
	rcall	pulse1
	rcall	pulse0
	rcall	pulse1
	ret
