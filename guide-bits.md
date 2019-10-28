# Bit manipulations
Version: 0.1.0  
Date: 28 October 2019  
Status: Draft  
Type: Guide  
ID: 3G  


## Overview
Data can be packed more compactly than even the smallest primitive type allow by
manipulating the individual bytes of the numbers. For example, an 8 bit unsigned
integer (`uint8_t`) can contain the number from 0-255, 8 boolean falgs, 4 two
bit numbers (0-3), a combination of 3-bit numbers (0-8) and two bit number, 2
4-bit numbers (0-15), or any combination of these. In gneeral, the smallest
on-wire primitive type in modern programming languages are at least 8 bits wide,
even boolean type which can only hold two states. In a bandwidth constrained
application like long-distance radio signaling, every bit matters, and thus Bit
manipulation become a handy method to pack more dath in much less space.

## Basic Operations

To manipulate numerical data types at the bit level, we must resort to binary
operators such as AND(&), OR(|), XOR(|), and NOT(~). These follow the following
truth tables (A,B are inputs, Y is the output):

**NOT**

|Y|A|
|-|-|
|0|1|
|1|0|

**AND**

|Y|A|B|
|-|-|-|
|0|0|0|
|0|0|1|
|0|1|0|
|1|1|1|

**OR**

|Y|A|B|
|-|-|-|
|0|0|0|
|1|0|1|
|1|1|0|
|1|1|1|

**XOR**

|Y|A|B|
|-|-|-|
|0|0|0|
|1|0|1|
|1|1|0|
|0|1|1|

These operations can be used formally to do boolean algebra. However, froma
practical perspective, for data packing purposes, each of these operator have
somewhat specific functions. An AND opertor serves as a mask, allowing specific
bits form a number to be "selected". For instance:

```
IN        = 0b010100111
MASK      = 0b000010100 # "selecting" bits 5 and 3
IN & MASK = 0b000000100
```

And the OR operator can be used to "set" bits

```
IN           = 0b00100000
SETBITS      = 0b00100001
IN | SETBITS = 0b00100001
```

To unset bits, a combination and & and ~ can be used.

Additioanlly, there are the left shift`(<<)` and right shift`(<<)` operators, 
which "move" the number over a set number of bits and fill the rest of zeroes.
For example:

```
0b00011 << 3 = 0b00011000
0b1010011 >> 4 = 0b101
```

# Recipies

**Bit Flag Setting**

```
IN |= PATTERN << n
```

Where `IN` is an input variable, `PATTERN` is the pattern that need to get set,
and `n` is the nbumber of bits into the input where the pattern should get set.
For instance:

```
IN = 0b000110011
        ~^
```

and we want to set the two underlined bits to 111, we'd do

```
IN |= 0b11 << 6
```

It is important to note that his can only set bits, if a bit is already one it
cannot be converted to a zero.

**Bit Flag Clearing**

To clear bits, we follow the following recipe

```
IN &= ~(PATTERN << n)
```

For example:

```
IN = 0b0001010011
          ~~^
```

and we want to clear the three underlined bits (set them back to zero), we'd use

```
IN &= ~(0b111 << 4)
```

**Reading bits**

```
OUT = IN & MASK
```

For exmaple, to read the 3 msot significant bits from `0b0101100`, we'd use

```
OUT = IN & 0b1110000
# or
OUT = IN & 0b111 << 4
# OUT = 0b0100000
```
However the issue here is that the extracted bits will still be in their
original columns, and thus will be as large as the originals. To remedy this, we
can right shift byt the number of bits to make the LSB of the masked output to
be in the 2^0 place.

```
OUT = (IN & MASK) >> n
```

```
OUT = (IN & 0b1110000) >> n
# out = 0b010
```

Thus, the easiest way to set a number of bits that might contains ones to a
custom patters is to first *clear* thos bits, then *set* using the OR operator. 

**Toggling**

Finally, toggling is pretty similar tot eh other two, except we use the Xor
operator instead of OR or AND:

```
IN ^= (PATTERN << n)
```

For example:

```
IN = 0b00110011
       ~~^
```

To toggle the three underlined bytes, we'd use:

```
IN ^= (0b111 << 5)
# IN = 0b11010011
```
