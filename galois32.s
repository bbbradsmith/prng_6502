;
; 6502 LFSR PRNG - 32-bit
; Brad Smith, 2019
; http://rainwarrior.ca
;

; A 32-bit Galois LFSR

; Possible feedback values that generate a full 4294967295 step sequence:
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
	ldy #8
	lda seed+0
:
	asl
	rol seed+1
	rol seed+2
	rol seed+3
	bcc :+
	eor #$C5
:
	dey
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
; 83 cycles
; 44 bytes

galois32o:
	; rotate the middle bytes left
	ldy seed+2 ; will move to seed+3 at the end
	lda seed+1
	sta seed+2
	; compute seed+1 ($C5>>1 = %1100010)
	lda seed+3 ; original high byte
	lsr
	sta seed+1 ; reverse: 100011
	lsr
	lsr
	lsr
	lsr
	eor seed+1
	lsr
	eor seed+1
	eor seed+0 ; combine with original low byte
	sta seed+1
	; compute seed+0 ($C5 = %11000101)
	lda seed+3 ; original high byte
	asl
	eor seed+3
	asl
	asl
	asl
	asl
	eor seed+3
	asl
	asl
	eor seed+3
	sty seed+3 ; finish rotating byte 2 into 3
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
