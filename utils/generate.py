#
# Generates sequence files to be used with PractRand
# http://rainwarrior.ca
#

def lfsr(eor,MASK,HIGH,iters=8):
    global seed
    for i in range(iters):
        if seed & HIGH:
            seed = ((seed << 1) ^ eor) & MASK
        else:
            seed = (seed << 1) & MASK
    return seed & 0xFF

def xorshift(t,shift,MASK):
    global seed
    seed = (seed ^ (seed << t[0])) & MASK
    seed = (seed ^ (seed >> t[1])) & MASK
    seed = (seed ^ (seed << t[2])) & MASK
    return (seed >> shift) & 0xFF

def generate_lfsr(name,eor,bits,count):
    global seed
    f = open(name+".rnd","wb")
    seed = 1
    MASK = (1<<bits)-1
    HIGH = 1<<(bits-1)
    for i in range(count):
        f.write(bytes([lfsr(eor,MASK,HIGH)]))
    f.close()
    print("%s x %d" % (name,count))

def generate_xorshift(name,t,shift,bits,count):
    global seed
    f = open(name+".rnd","wb")
    seed = 1
    MASK = (1<<bits)-1
    for i in range(count):
        f.write(bytes([xorshift(t,shift,MASK)]))
    f.close()
    print("%s x %d" % (name,count))

generate_lfsr("galois16",0x39,16,1<<16)
generate_lfsr("galois24",0x1B,24,1<<24)
generate_lfsr("galois32",0xC5,32,1<<24)
generate_xorshift("xorshift798",(7,9,8),8,16,1<<16)
