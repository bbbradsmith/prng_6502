#
# Simple spectral test of Galois LFSR RNG
# http://rainwarrior.ca
#

# This tests for correlation between successive pairs or results.
# The resulting image should appear to be evenly distributed noise.

import PIL.Image

def lfsr(seed,eor,MASK,HIGH,iters=8):
    for i in range(iters):
        if seed & HIGH:
            seed = ((seed << 1) ^ eor) & MASK
        else:
            seed = (seed << 1) & MASK
    return seed       

def spectral(name, eor, bits, count, dim=256):
    img = PIL.Image.new("1",(dim,dim),1)
    seed = 1
    MASK = (1<<bits)-1
    HIGH = 1<<(bits-1)
    for i in range(count):
        seed = lfsr(seed,eor,MASK,HIGH)
        x = seed % dim
        seed = lfsr(seed,eor,MASK,HIGH)
        y = seed % dim
        img.putpixel((x,y),0)
    img.save(name+".png")
    print("%s x %d" % (name,count))

spectral("galois16",0x39,16,10000)
spectral("galois24",0x1B,24,10000)
spectral("galois32",0xC5,32,10000)
