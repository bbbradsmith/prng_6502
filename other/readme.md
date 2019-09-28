# prng_6502 (other RNGs)

Alternative random number generators for 6502 / NES.

While the recommended RNG at
[prng_6502](https://github.com/bbbradsmith/prng_6502)
is a Galois LFSR method, some other techniques are included here
for the sake of comparison.

## RNGs

| Function    | Width  | Code Size | Cycles        |
| ----------- | ------ | --------- | ------------- |
| xorshift798 | 16-bit | 29 bytes  | 55            |

The
[16-bit xorshift](http://www.retroprogramming.com/2017/07/xorshift-pseudorandom-numbers-in-z80.html)
(7,9,8) is slightly faster and smaller than **galois16o**,
but has noticeably poorer random quality. (The spectral test raises an immediate red flag.)

## License

This code and may be used, reused, and modified for any purpose, commercial or non-commercial.

Attribution in released binaries or documentation is appreciated but not required.

If you'd like to support this project or its author, please visit:
 [Patreon](https://www.patreon.com/rainwarrior)
