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

def spectral_lfsr(name, eor, bits, iters, count, dim=256):
    img = PIL.Image.new("1",(dim,dim),1)
    seed = 1
    MASK = (1<<bits)-1
    HIGH = 1<<(bits-1)
    for i in range(count):
        seed = lfsr(seed,eor,MASK,HIGH,iters)
        x = seed % dim
        seed = lfsr(seed,eor,MASK,HIGH,iters)
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

def lcg(seed,m,a,MASK):
    seed = ((seed * m) + a) & MASK
    return seed

def spectral_lcg(name, m, a, shift, bits, count, dim=256):
    img = PIL.Image.new("1",(dim,dim),1)
    seed = 1
    MASK = (1<<bits)-1
    for i in range(count):
        seed = lcg(seed,m,a,MASK)
        x = (seed >> shift) % dim
        seed = lcg(seed,m,a,MASK)
        y = (seed >> shift) % dim
        img.putpixel((x,y),0)
    img.save(name+".png")
    print("%s x %d" % (name,count))

spectral_lfsr("galois8",0x1D,8,1,20000)
spectral_lfsr("galois16",0x39,16,8,20000)
spectral_lfsr("galois24",0x1B,24,8,20000)
spectral_lfsr("galois32",0xC5,32,8,20000)
spectral_xorshift("xorshift798",(7,9,8),8,16,20000)
spectral_lcg("cc65rand",0x01010101,0x31415927,24,32,20000)

spectral_lfsr("galois16_full",0x39,16,8,65535) # a full cycle produces every possible pair except 1
spectral_lfsr("galois16_1",0x39,16,1,20000) # testing with fewer iterations
spectral_lfsr("galois16_2",0x39,16,2,20000)
spectral_lfsr("galois16_3",0x39,16,3,20000)
spectral_lfsr("galois16_4",0x39,16,4,20000)
spectral_lfsr("galois16_5",0x39,16,5,20000)
spectral_lfsr("galois16_6",0x39,16,6,20000)
spectral_lfsr("galois16_7",0x39,16,7,20000)
spectral_lfsr("galois16_8",0x39,16,8,20000)
spectral_lcg("cc65rand_0",0x01010101,0x31415927,0,32,20000) # lower bits of seed have lower entropy
spectral_lcg("cc65rand_1",0x01010101,0x31415927,8,32,20000)
spectral_lcg("cc65rand_2",0x01010101,0x31415927,16,32,20000)
spectral_lcg("cc65rand_3",0x01010101,0x31415927,24,32,20000)
