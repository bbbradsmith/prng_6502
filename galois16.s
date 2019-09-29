;
; 6502 LFSR PRNG - 16-bit
; Brad Smith, 2019
; http://rainwarrior.ca
;

; A 16-bit Galois LFSR

; Possible feedback values that generate a full 65535 step sequence:
; $2D = %00101101
; $39 = %00111001
; $3F = %00111111
; $53 = %01010011
; $BD = %10111101
; $D7 = %11010111

; $39 is chosen for its compact bit pattern

.importzp seed

.code

; simplest version iterates the LFSR 8 times to generate 8 random bits
; 133-141 cycles per call
; 19 bytes

galois16:
	ldy #8
	lda seed+0
:
	asl        ; shift the register
	rol seed+1
	bcc :+
	eor #$39   ; apply XOR feedback whenever a 1 bit is shifted out
:
	dey
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
			eor #$39
		:
	.endrepeat
	sta seed+0
	cmp #0
	rts

; overlapped version, computes all 8 iterations in an overlapping fashion
; 69 cycles
; 35 bytes

galois16o:
	lda seed+1
	tay ; store copy of high byte
	; compute seed+1 ($39>>1 = %11100)
	lsr ; shift to consume zeroes on left...
	lsr
	lsr
	sta seed+1 ; now recreate the remaining bits in reverse order... %111
	lsr
	eor seed+1
	lsr
	eor seed+1
	eor seed+0 ; recombine with original low byte
	sta seed+1
	; compute seed+0 ($39 = %111001)
	tya ; original high byte
	sta seed+0
	asl
	eor seed+0
	asl
	eor seed+0
	asl
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
