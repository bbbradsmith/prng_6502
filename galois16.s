;
; 6502 LFSR PRNG - 16-bit
; Brad Smith, 2019
; http://rainwarrior.ca
;

; A 16-bit Galois LFSR
; $2D is the lowest feedback value that generates a full 65535 step sequence

.importzp seed

.code

; simplest version iterates the LFSR 8 times to generate 8 random bits
; 133-141 cycles per call
; 19 bytes

galois16:
	ldx #8
	lda seed+0
:
	asl        ; shift the register
	rol seed+1
	bcc :+
	eor #$2D   ; apply XOR feedback whenever a 1 bit is shifted out
:
	dex
	bne :--
	sta seed+0
	cmp #0     ; reload flags
	rts

; unrolled version, iterates without using a loop
; 92-100 cycles
; 63 bytes

galois16u:
	lda seed+0
	.repeat 8
		asl
		rol seed+1
		bcc :+
			eor #$2D
		:
	.endrepeat
	sta seed+0
	cmp #0
	rts

; overlapped version, computes all 8 iterations in an overlapping fashion

galois16o:
	; shift everything 1 byte left
	ldx seed+0 ; X = original low byte
	lda seed+1
	sta seed+0 ; seed+0 = original high byte
	; compute seed+1 ($2D>>1 = %0010110)
	lsr
	lsr
	lsr
	pha
	lsr
	lsr
	sta seed+1
	pla
	eor seed+1
	lsr seed+1
	eor seed+1
	sta seed+1
	txa
	eor seed+1
	sta seed+1
	; compute seed+0 ($2D = %00101101)
	lda seed+0 ; original high byte
	asl
	asl
	eor seed+0
	asl
	eor seed+0
	asl
	asl
	eor seed+0
	sta seed+0
	rts

; C wrappers

.export _galois16
.export _galois16u
.export _galois16o

_galois16:
	jsr galois16
	ldx #0
	rts

_galois16u:
	jsr galois16u
	ldx #0
	rts

_galois16o:
	jsr galois16o
	ldx #0
	rts
