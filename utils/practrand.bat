REM PractRand tests: http://pracrand.sourceforge.net/

REM Generate basline comparisons with a cryptographically secure RNG
RNG_output hc256 65536 > ref16.rnd
RNG_output hc256 16777216 > ref24.rnd
RNG_output hc256 16777216 > ref32.rnd

REM Run generate.py to prepare the sequences to measure
RNG_test stdin8 -a -tlmax 64KB < ref16.rnd
RNG_test stdin8 -a -tlmax 64KB < galois16.rnd
RNG_test stdin8 -a -tlmax 64KB < xorshift798.rnd
RNG_test stdin8 -a -tlmax 16384KB < ref24.rnd
RNG_test stdin8 -a -tlmax 16384KB < galois24.rnd
RNG_test stdin8 -a -tlmax 16384KB < ref32.rnd
RNG_test stdin8 -a -tlmax 16384KB < galois32.rnd
