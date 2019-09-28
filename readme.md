# prng_6502

Random number generators for 6502 / NES.

## Description

This is a small collection of a family of random number generators
suitable for use with the NES or other 6502 CPU platforms.

Each of them implements a
[linear feedback shift register](http://en.wikipedia.org/wiki/Linear-feedback_shift_register)
(LFSR) in Galois form, which is iterated 8 times to produce
an 8-bit pseudo-random number.

Three widths of LFSR are provided:
* 16-bit requires 2 bytes of state, and will repeat after 65535 numbers.
* 24-bit requires 3 bytes, and repeats after 16777215 calls.
* 32-bit requires 4 bytes, and repeats after 4294967295 calls.

The 16-bit version is a minimal suitable RNG for general purpose use,
but if your program generates larger batches of numbers (e.g. 50 or more)
it might benefit from the longer 24 or 32-bit sequences.

## Usage

Initialize the zero page **seed** variable to any value other than 0.
The size of **seed** is 2-4 bits, depending on the width of LFSR chosen.

Simply **jsr** to one of the RNG functions.
An 8-bit result will be returned in the **A** register (with flags),
and the **Y** register will be clobbered.

Do not mix RNGs of different width in the same program, unless you can
give them each separate **seed** state storage. (If desired, the simple
and overlapped versions _can_ be used with the same seed state.)

The provided source code is for the
[CC65](https://cc65.github.io/)
assembler, but should be easily portable to other 6502 assembly dialects.

## Performance

| Function  | Width  | Code Size | Cycles        |
| --------- | ------ | --------- | ------------- |
| galois16  | 16-bit | 19 bytes  | 133-141 (137) |
| galois24  | 24-bit | 21 bytes  | 173-181 (177) |
| galois32  | 32-bit | 23 bytes  | 213-221 (217) |
| galois16o | 16-bit | 35 bytes  | 69            |
| galois24o | 24-bit | 38 bytes  | 73            |
| galois32o | 32-bit | 44 bytes  | 83            |

(The cycle timing includes the **jsr** and **rts** instructions.)

The simple verions of these RNG routines have the smallest code,
and vary in timing by +/- 4 cycles.

The overlapped versions are slightly larger, but more than twice as fast.

In the source there are also unrolled-loop versions included for comparison,
but these are all larger and slower than their overlapped counterparts.

Though there are many methods for generating pseudo-random numbers,
the LFSR is chosen here because it can be done efficiently with the 6502 CPU.
When iterated once per bit of output, a maximal-length LFSR is a very
suitable general purpose pseudo-random number generators, with a number of
good properties, like well behaved distribution.
They are not
[cryptographically secure](http://en.wikipedia.org/wiki/Cryptographically_secure_pseudorandom_number_generator),
of course, but this is not normally an important requirement for this platform.

## Notes

This research was directly prompted by
[jroatch](https://github.com/jroatch)
who showed me
[an efficient 32-bit RNG implementation](http://forums.nesdev.com/viewtopic.php?p=196569#p196569).
My resulting 32-bit PRNG ened up being extremely similar,
partly because there is really only one viable 32-bit polynomial.

The simple versions can be adapted to take **Y** as a parameter, rather than
always generating 8 bits. If a lower number of bits is needed
(e.g. a 50/50 choice only needs 1 bit), this can be used for a faster
result, breaking even with the overlapped version around 4 or 5 bits.

Though there are generally many XOR-feedback values that can generate a maximal
length LFSR, the ones selected here were chosen to have as few bits as necessary,
and in a compact arrangement that makes the computation faster.

* **galois16.s** - 16-bit RNG implementations.
* **galois24.s** - 24-bit RNG implementations.
* **galois32.s** - 32-bit RNG implementations.
* **common.s** - Shared state storage and variables.
* **utils/polyfind.cpp** - A simple program to search for viable XOR-feedback values.
* **utils/spectral.py** - A 2D spectral test for diagnosting RNG result correlation problems.
* **test.c**/**.cfg**/**.bat** - A CC65 unit test for verifying the correctness of this program.

## License

This code and may be used, reused, and modified for any purpose, commercial or non-commercial.

Attribution in released binaries or documentation is appreciated but not required.

If redistributing a modified version of this source code, please correctly attribute both the original author and the work of the modifying author.

If you'd like to support this project or its author, please visit:
 [Patreon](https://www.patreon.com/rainwarrior)
