import bitstring, random 

def ieee754(flt):
    x = bitstring.BitArray(float=flt, length=32)
    return (x)

a = ieee754(-4.952176E37)
b = ieee754(4.0432099E37)

print(a)
print(b)
print(ieee754(a.float  + b.float))