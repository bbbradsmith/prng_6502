;
; 6502 Xorshift PRNG
; Brad Smith, 2019
; http://rainwarrior.ca
;

.importzp seed

.code

; xorshift 798
;
; This algorithm was developed by George Marsaglia and John Metcalf,
; creating a maximal-length 16-bit shift register RNG using a series of shift
; and XOR operations.
;
; http://www.retroprogramming.com/2017/07/xorshift-pseudorandom-numbers-in-z80.html
;
; The high level algorithm is:
;
; seed ^= seed << 7;
; seed ^= seed >> 9;
; seed ^= seed << 8;

; 55 cycles
; 29 bytes

xorshift798:
	; seed ^= seed << 7
	lda seed+1
	ror
	lda seed+0
	ror
	eor seed+1
	sta seed+1
	ror
	and #$80
	eor seed+0
	sta seed+0
	; seed ^= seed >> 9
	lda seed+1
	lsr
	eor seed+0
	sta seed+0
	; seed ^= seed << 8
	; lda seed+0
	eor seed+1
	sta seed+1 ; return the high byte
	rts

; C wrappers

.export _xorshift798

_xorshift798:
	jsr xorshift798
	ldx #0
	rts
