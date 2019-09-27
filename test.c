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

extern uint8 fastcall galois16(void);
extern uint8 fastcall galois16u(void);
extern uint8 fastcall galois16o(void);

extern uint8 fastcall galois24(void);
extern uint8 fastcall galois24u(void);
extern uint8 fastcall galois24o(void);

extern uint8 fastcall galois32(void);
extern uint8 fastcall galois32u(void);
extern uint8 fastcall galois32o(void);

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
		if (seed != k) { printf(#func0 "/" #func1 ": mismatch at %ld\n",k); return -1; } \
		if (p != q)    { printf(#func0 "/" #func1 ": 8-bit mismatch at %ld\n",j); return -1; } \
	} \
	                     printf(#func0 "/" #func1 ": match\n"); \
}

#define CYCLE_TEST(func,cycles) \
{ \
	seed = 1; \
	for (i=0;i<(cycles##UL+1);++i) \
	{ \
		func(); if (seed==1) break; \
	} \
	if (i==cycles##UL)            printf(#func ": %ld\n",(i+1)); \
	else if (i>=(cycles##UL+1)) { printf(#func ": FAIL\n");      return -1; } \
	else                        { printf(#func ": %ld\n",(i+1)); return -1; } \
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
	printf(#func ": min %ld - %ld max (%ld tests)\n",k,j,cycles); \
}

int main()
{
	printf("Equivalence tests.\n");
	MATCH_TEST(galois16,galois16u,65535);
	MATCH_TEST(galois16,galois16o,65535);
	//MATCH_TEST(galois24,galois24u,16777215);
	MATCH_TEST(galois24,galois24o,16777215);
	//MATCH_TEST(galois32,galois32u,4294967295);

	printf("Cycle tests.\n");
	CYCLE_TEST(galois16,65534);
	CYCLE_TEST(galois24,16777214);
	CYCLE_TEST(galois32,4294967294);
	//CYCLE_TEST(galois16u,65534);
	//CYCLE_TEST(galois16o,65534);


	printf("Distribution tests.\n");
	DISTRIBUTION_TEST(galois16,65535);
	DISTRIBUTION_TEST(galois24,16777215);
	DISTRIBUTION_TEST(galois32,4294967295);

	printf("Complete.\n");
	return 0;
}
