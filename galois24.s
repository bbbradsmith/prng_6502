;
; 6502 LFSR PRNG - 24-bit
; Brad Smith, 2019
; http://rainwarrior.ca
;

; A 24-bit Galois LFSR

; Possible feedback values that generates a full 16777215 step sequence:
; $1B = %00011011
; $87 = %10000111
; $B1 = %10110001
; $DB = %11011011
; $F5 = %11110101

; $1B is chosen

.importzp seed

.code

; simple
; 173-181 cycles per call
; 21 bytes

galois24:
	ldx #8
	lda seed+0
:
	asl
	rol seed+1
	rol seed+2
	bcc :+
	eor #$1B
:
	dex
	bne :--
	sta seed+0
	cmp #0
	rts

; unrolled
; 132-140 cycles
; 79 bytes

galois24u:
	lda seed+0
	.repeat 8
		asl
		rol seed+1
		rol seed+2
		bcc :+
			eor #$1B
		:
	.endrepeat
	sta seed+0
	cmp #0
	rts

; overlapped
; 73 cycles
; 38 bytes

galois24o:
	; rotate the middle byte left
	ldx seed+1 ; will move to seed+2 at the end
	; compute seed+1 ($1B>>1 = %1101)
	lda seed+2
	lsr
	lsr
	lsr
	lsr
	sta seed+1 ; reverse: %1011
	lsr
	lsr
	eor seed+1
	lsr
	eor seed+1
	eor seed+0
	sta seed+1
	; compute seed+0 ($1B = %00011011)
	lda seed+2
	asl
	eor seed+2
	asl
	asl
	eor seed+2
	asl
	eor seed+2
	stx seed+2 ; finish rotating byte 1 into 2
	sta seed+0
	rts

; C wrappers

.export _galois24
.export _galois24u
.export _galois24o

_galois24:
	jsr galois24
	ldx #0
	rts

_galois24u:
	jsr galois24u
	ldx #0
	rts

_galois24o:
	jsr galois24o
	ldx #0
	rts
