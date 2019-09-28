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

def xorshift(seed,t,MASK):
    seed = (seed ^ (seed << t[0])) & MASK
    seed = (seed ^ (seed >> t[1])) & MASK
    seed = (seed ^ (seed << t[2])) & MASK
    return seed

def spectral_xorshift(name, t, shift, bits, count, dim=256):
    img = PIL.Image.new("1",(dim,dim),1)
    seed = 1
    MASK = (1<<bits)-1
    for i in range(count):
        seed = xorshift(seed,t,MASK)
        x = (seed >> shift) % dim
        seed = xorshift(seed,t,MASK)
        y = (seed >> shift) % dim
        img.putpixel((x,y),0)
    img.save(name+".png")
    print("%s x %d" % (name,count))

spectral("galois16",0x39,16,20000)
spectral("galois24",0x1B,24,20000)
spectral("galois32",0xC5,32,20000)
spectral_xorshift("xorshift798",(7,9,8),8,16,20000)
