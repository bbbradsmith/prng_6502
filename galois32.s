;
; 6502 LFSR PRNG - 32-bit
; Brad Smith, 2019
; http://rainwarrior.ca
;

; A 32-bit Galois LFSR
; $AF would be the lowest feedback value that generates a full 4294967295 step sequence,
; but $C5 is used instead because it has fewer bits set (4 is the minimum),
; and has "nicer" behaviour when the RNG is iterated less than the ideal 8 bits.

.importzp seed

; simple
; 213-221 cycles per call
; 23 bytes

.code
galois32:
	ldx #8
	lda seed+0
:
	asl
	rol seed+1
	rol seed+2
	rol seed+3
	bcc :+
	eor #$C5
:
	dex
	bne :--
	sta seed+0
	cmp #0
	rts

; unrolled
; 172-180 cycles
; 95 bytes

galois32u:
	lda seed+0
	.repeat 8
		asl
		rol seed+1
		rol seed+2
		rol seed+3
		bcc :+
			eor #$C5
		:
	.endrepeat
	sta seed+0
	cmp #0
	rts

; overlapped

galois32o:
	; TODO
	rts

; C wrappers

.export _galois32
.export _galois32u
.export _galois32o

_galois32:
	jsr galois32
	ldx #0
	rts

_galois32u:
	jsr galois32u
	ldx #0
	rts

_galois32o:
	jsr galois32o
	ldx #0
	rts
