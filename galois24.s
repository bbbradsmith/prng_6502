;
; 6502 LFSR PRNG - 24-bit
; Brad Smith, 2019
; http://rainwarrior.ca
;

; A 24-bit Galois LFSR
; $1B is the lowest feedback value that generates a full 16777215 step sequence

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
; 84 cycles
; 45 bytes

galois24o:
	; shift everything 1 byte left
	lda seed+2
	ldx seed+1
	stx seed+2
	ldx seed+0 ; X = original low byte
	sta seed+0 ; seed+0 = original high byte
	; compute seed+1 ($1B>>1 = %1101)
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
	sta seed+1
	txa
	eor seed+1
	sta seed+1
	; compute seed+0 ($1B = %00011011)
	lda seed+0
	asl
	eor seed+0
	asl
	asl
	eor seed+0
	asl
	eor seed+0
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
