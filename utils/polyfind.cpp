//
// Simple program to brute-force search for maximum-period polynomials
// to use with Galois LFSR RNGs
//
// http://rainwarrior.ca
//

#include <cstdio>
#include <cstdint>
typedef uint32_t uint32;

const int VISIT_MAX = 1024;
bool visited[VISIT_MAX];

// brute force LFSR period test
template <int B>
inline bool test_lfsr(uint32 eor)
{
	//printf("%02X\n",eor);
	for (int i=0; i<VISIT_MAX; ++i) visited[i] = false;

	const uint32 MASK = (1ULL<<B)-1;
	uint32 count = MASK;
	uint32 seed = 1;
	while (count)
	{
		seed = (seed & (1<<(B-1))) ?
			(((seed << 1) ^ eor) & MASK) :
			((seed << 1) & MASK);

		if (seed == 1) break;

		if (seed < VISIT_MAX)
		{
			if (visited[seed]) break;
			visited[seed] = true;
		}
		
		--count;
	}
	return (seed == 1) && (count == 1);
}

template <int B>
inline void find_lfsrs()
{
	printf("%d-bit LFSR polynomials:\n",B);
	for (uint32 eor = 0; eor < 256; ++eor)
	{
		if (test_lfsr<B>(eor))
		{
			printf("%02X = %%",eor);
			for (int i=7;i>=0;--i) printf("%01d",(eor>>i)&1);
			printf("\n");
		}
	}
}

int main()
{
	find_lfsrs<8>();
	find_lfsrs<16>();
	find_lfsrs<24>();
	find_lfsrs<32>();
	return 0;
}
