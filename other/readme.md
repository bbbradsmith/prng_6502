# prng_6502 (other RNGs)

Alternative random number generators for 6502 / NES.

While the recommended RNG at
[prng_6502](https://github.com/bbbradsmith/prng_6502)
is a Galois LFSR method, some other techniques are included here
for the sake of comparison.

## RNGs

| Function    | Width  | Code Size | Cycles        |
| ----------- | ------ | --------- | ------------- |
| galois8     | 8-bit  | 17 bytes  | 93-101 (97)   |
| galois8u    | 8-bit  | 47 bytes  | 52-60 (56)    |
| galois8o    | 8-bit  | 53 bytes  | 98            |
| xorshift798 | 16-bit | 29 bytes  | 55            |
| [CC65 rand()](https://github.com/cc65/cc65/blob/master/libsrc/common/rand.s) | 32-bit | 44 bytes | 73 |

The **galois8** RNGs are an 8-bit version of the Galois LFSR.
The sequence is only 255 steps long, and the quality of the output is very poor.
At this width the overlapped methods become inefficient, and unrolling is faster.
If reduced to fewer iterations, it might be acceptable for generating numbers of
1, 2, or 4 bits in a desperately minimal situation, but the 8-bit result is terrible.

The
[16-bit xorshift](http://www.retroprogramming.com/2017/07/xorshift-pseudorandom-numbers-in-z80.html)
(7,9,8) is slightly faster and smaller than **galois16o**,
but has noticeably poorer random quality. The spectral test raises an immediate red flag.

CC65 has an
[LCG](http://en.wikipedia.org/wiki/Linear_congruential_generator)
RNG technique for its
[rand()](https://github.com/cc65/cc65/blob/master/libsrc/common/rand.s)
library function. The quality of its output is good:
in my estimation it falls roughly halfway between **galois24o** and **galois32o**.
Unlike LFSR style RNGs, a seed of 0 is acceptable, and its overall period is 1 step longer.

## License

This code and may be used, reused, and modified for any purpose, commercial or non-commercial.

Attribution in released binaries or documentation is appreciated but not required.

If you'd like to support this project or its author, please visit:
 [Patreon](https://www.patreon.com/rainwarrior)
