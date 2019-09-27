;
; 6502 LFSR PRNG - 32-bit
; Brad Smith, 2019
; http://rainwarrior.ca
;

; A 32-bit Galois LFSR

; Possible feedback values that generates a full 65535 step sequence:
; $AF = %10101111
; $C5 = %11000101
; $F5 = %11110101

; $C5 is chosen

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
; 94 cycles
; 51 bytes

galois32o:
	; shift everything 1 byte left
	lda seed+3
	ldx seed+2
	stx seed+3
	ldx seed+1
	stx seed+2
	ldx seed+0 ; X = original low byte
	sta seed+0 ; seed+0 = original high byte
	; compute seed+1 ($C5>>1 = %1100010)
	lsr
	sta seed+1 ; reverse: 100011
	lsr
	lsr
	lsr
	lsr
	eor seed+1
	lsr
	eor seed+1
	sta seed+1
	txa
	eor seed+1
	sta seed+1
	; compute seed+0 ($C5 = %11000101)
	lda seed+0
	asl
	eor seed+0
	asl
	asl
	asl
	asl
	eor seed+0
	asl
	asl
	eor seed+0
	sta seed+0
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
