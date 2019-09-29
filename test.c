//
// CC65 Sim65 RNG test suite
// http://rainwarrior.ca
//

// This is not a thorough random number generator test suite.
// It is merely a unit test for verifying that the code is correct,
// using a couple of brute-force methods to compare.
//
// The main goal of this test is to make sure that the (complicated) overlapped
// LFSR implemtations match the simple versions.

#include <stdint.h>
#include <stdio.h>

typedef uint8_t uint8;
typedef uint16_t uint16;
typedef uint32_t uint32;

// found in common.s
extern uint32 seed;
extern uint32 i;
extern uint32 j;
extern uint32 k;
extern uint32 l;
extern uint8 p;
extern uint8 q;
extern uint8 r;
extern uint8 s;
#pragma zpsym("seed")
#pragma zpsym("i");
#pragma zpsym("j");
#pragma zpsym("k");
#pragma zpsym("l");
#pragma zpsym("p");
#pragma zpsym("q");
#pragma zpsym("r");
#pragma zpsym("s");

// primary RNGs

extern uint8 fastcall galois16(void);
extern uint8 fastcall galois16u(void);
extern uint8 fastcall galois16o(void);

extern uint8 fastcall galois24(void);
extern uint8 fastcall galois24u(void);
extern uint8 fastcall galois24o(void);

extern uint8 fastcall galois32(void);
extern uint8 fastcall galois32u(void);
extern uint8 fastcall galois32o(void);

// other RNGs

extern uint8 fastcall galois8(void);
extern uint8 fastcall galois8u(void);
extern uint8 fastcall galois8o(void);
extern uint8 fastcall xorshift798(void);

uint32 counter[256];

#define MATCH_TEST(func0,func1,cycles) \
{ \
	seed = 1; \
	for (i=0;i<cycles##UL;++i) \
	{ \
		j = seed; \
		p = func0(); \
		k = seed; \
		seed = j; \
		q = func1(); \
		if (seed != k) { printf("%-12s = %-12s: mismatch at %lX\n",      #func0,#func1,j); return -1; } \
		if (p != q)    { printf("%-12s = %-12s: 8-bit mismatch at %lX\n",#func0,#func1,j); return -1; } \
	} \
	                     printf("%-12s = %-12s: match (%lu)\n",#func0,#func1,cycles##UL); \
}

#define CYCLE_TEST(func,cycles) \
{ \
	seed = 1; \
	for (i=0;i<(cycles##UL+1);++i) \
	{ \
		func(); if (seed==1) break; \
	} \
	if (i==cycles##UL)            printf("%-12s: %lu\n",#func,(i+1)); \
	else if (i>=(cycles##UL+1)) { printf("%-12s: FAIL\n",#func);       return -1; } \
	else                        { printf("%-12s: %lu\n",#func,(i+1)); return -1; } \
}

#define DISTRIBUTION_TEST(func,cycles) \
{ \
	seed = 1; \
	for (i=0;i<256;++i) counter[i] = 0; \
	for (i=0;i<cycles##UL;++i) ++counter[func()]; \
	j = 0; k = UINT32_MAX; \
	for (i=0;i<256;++i) \
	{ \
		if (counter[i] > j) j = counter[i]; \
		if (counter[i] < k) k = counter[i]; \
	} \
	printf("%-12s: min %5lu - %5lu max (%lu)\n",#func,k,j,cycles##UL); \
}

uint8 xorshift798c() // C version for verification of correctness
{
	seed ^= seed << 7; seed &= 0xFFFF;
	seed ^= seed >> 9; seed &= 0xFFFF;
	seed ^= seed << 8; seed &= 0xFFFF;
	return seed >> 8;
}

int tests()
{
	printf("Equivalence tests:\n");
	MATCH_TEST(galois16 ,galois16u,65535); // verify that unrolled matches simple
	MATCH_TEST(galois16u,galois16o,65535); // verify that overlapped matches unrolled
	MATCH_TEST(galois24 ,galois24u,16777215);
	MATCH_TEST(galois24u,galois24o,16777215);
	MATCH_TEST(galois32 ,galois32u,17000000); // an incomplete cycle, but still a pretty good verification
	MATCH_TEST(galois32u,galois32o,17000000);
	//MATCH_TEST(galois32 ,galois32u,4294967295); // these take several hours to complete
	//MATCH_TEST(galois32 ,galois32o,4294967295);
	MATCH_TEST(galois8,galois8u,255);
	MATCH_TEST(galois8u,galois8o,255);
	MATCH_TEST(xorshift798c,xorshift798,65535);

	printf("Cycle tests:\n");
	CYCLE_TEST(galois16o,65534);
	CYCLE_TEST(galois24o,16777214);
	//CYCLE_TEST(galois32o,4294967294); // several hours
	CYCLE_TEST(galois8u,254);
	CYCLE_TEST(xorshift798,65534);

	// maximal cycle automatically ensures even distribution,
	// but these will demonstrate uniformity with shorter cycles.
	printf("Distribution tests:\n");
	DISTRIBUTION_TEST(galois16o,25600);
	DISTRIBUTION_TEST(galois24o,2560000);
	DISTRIBUTION_TEST(galois32o,2560000);
	DISTRIBUTION_TEST(galois8u,128);
	DISTRIBUTION_TEST(xorshift798,25600);

	return 0; // success
}

int main()
{
	if (tests())
	{
		printf("Failed.\n");
		return -1;
	}
	printf("Success.\n");
	return 0;
}
