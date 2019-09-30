;
; 6502 LFSR PRNG - 8-bit
; Brad Smith, 2019
; http://rainwarrior.ca
;

; An 8-bit Galois LFSR

; Possible feedback values that generate a full 255 step sequence:
; $1D = %00011101
; $2B = %00101011
; $2D = %00101101
; $4D = %01001101
; $5F = %01011111
; $63 = %01100011
; $65 = %01100101
; $69 = %01101001
; $71 = %01110001
; $87 = %10000111
; $8D = %10001101
; $A9 = %10101001
; $C3 = %11000011
; $CF = %11001111
; $E7 = %11100111
; $F5 = %11110101

; $1D is chosen

.importzp seed

.code

; simple
; 93-101 cycles per call
; 17 bytes

galois8:
	ldy #8
	lda seed+0
:
	asl
	bcc :+
	eor #$1D
:
	dey
	bne :--
	sta seed+0
	cmp #0
	rts

; unrolled
; 52-60 cycles
; 47 bytes

galois8u:
	lda seed+0
	.repeat 8
		asl
		bcc :+
			eor #$1D
		:
	.endrepeat
	sta seed+0
	cmp #0
	rts

; overlapped
; 98 cycles
; 53 bytes

galois8o:
	; broken into two 4-step overlapped iterations
	; seed = (seed << 4) ^ ((seed >> 4) * %11101)
	lda seed+0
	.repeat 2
		tay
		and #$F0
		sta seed+0
		lsr
		lsr
		eor seed+0
		lsr
		eor seed+0
		lsr
		eor seed+0
		sta seed+0
		tya
		asl
		asl
		asl
		asl
		eor seed+0
	.endrepeat
	sta seed+0
	rts

; C wrappers

.export _galois8
.export _galois8u
.export _galois8o

_galois8:
	jsr galois8
	ldx #0
	rts

_galois8u:
	jsr galois8u
	ldx #0
	rts

_galois8o:
	jsr galois8o
	ldx #0
	rts
