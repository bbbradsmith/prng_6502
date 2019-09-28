#
# Search for xorshift triplets
# http://rainwarrior.ca
#

def xorshift(seed,t,MASK=(1<<16)-1):
    seed = (seed ^ (seed << t[0])) & MASK
    seed = (seed ^ (seed >> t[1])) & MASK
    seed = (seed ^ (seed << t[2])) & MASK
    return seed

for i in range(0,15):
    for j in range(0,15):
        for k in range(0,15):
            seed = 1
            loop = 0
            for c in range(1<<16):
                seed = xorshift(seed,(i,j,k))
                if seed == 0:
                    break
                if seed == 1:
                    loop = c
                    break
            if loop >= (1<<16)-2:
                print("(%2d,%2d,%2d) %d" % (i,j,k,loop))
