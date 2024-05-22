"""
This Python implementation is based on the XXH64 hashing algorithm as described in the of the original 
implementation for the xxhash Python library, which can be found in a GitHub repository.

Original C implementation repository: https://github.com/Cyan4973/xxHash
"""

# Constants
PRIME64_1 = 0x9E3779B185EBCA87
PRIME64_2 = 0xC2B2AE3D27D4EB4F
PRIME64_3 = 0x165667B19E3779F9
PRIME64_4 = 0x85EBCA77C2B2AE63
PRIME64_5 = 0x27D4EB2F165667C5

mod = 0xFFFFFFFFFFFFFFFF

def round_function(accN, laneN):
    """
    Performs a round function operation.

    Args:
    accN (int): Accumulator value.
    laneN (int): Lane value.

    Returns:
    int: Result of the round function operation.
    """
    accN = (accN + (laneN * PRIME64_2)) & mod
    accN = rol64(accN, 31) & mod
    return (accN * PRIME64_1) & mod

def merge_accumulator(acc, accN):
    """
    Merge accumulator with accN.

    Args:
    acc (int): Accumulator value.
    accN (int): accN value.

    Returns:
    int: Result of the merge operation.
    """
    acc = (acc ^ round_function(0, accN)) & mod
    acc = (acc * PRIME64_1) & mod
    return (acc + PRIME64_4) & mod

def read_64bit_little_endian(data, ptr):
    """
    Reads 8 bytes (64 bits) from the `data` starting at index `ptr` in little endian format
    and construct a 64-bit integer.
    
    Args:
    data (bytes): The byte array from which to read.
    ptr (int): The starting index from which to read.
    
    Returns:
    int: The 64-bit integer constructed from the data.
    """
    return (data[ptr+7] << 56) | (data[ptr+6] << 48) | (data[ptr+5] << 40) | \
           (data[ptr+4] << 32) | (data[ptr+3] << 24) | (data[ptr+2] << 16) | \
           (data[ptr+1] << 8) | data[ptr]

def read_32bit_little_endian(data, ptr):
    """
    Reads 4 bytes (32 bits) from the `data` starting at index `ptr` in little endian format
    and construct a 32-bit integer.
    
    Args:
    data (bytes): The byte array from which to read.
    ptr (int): The starting index from which to read.
    
    Returns:
    int: The 32-bit integer constructed from the data.
    """
    return (data[ptr+3] << 24) | (data[ptr+2] << 16) | (data[ptr+1] << 8) | data[ptr]

def rol64(x, r):
    """
    Perform a 64-bit left rotation.

    Args:
    x (int): Value to be rotated.
    r (int): Number of bits to rotate.

    Returns:
    int: Result of the rotation operation.
    """
    return ((x << r) | (x >> (64 - r))) & mod

def xxh64(input_bytes, seed=0):
    """
    XXH64 hash function.

    Args:
    input_bytes (bytes): Input bytes to be hashed.
    seed (int): Seed value for hashing.

    Returns:
    int: Resulting hash value.
    """

    inputLength = len(input_bytes)

    # Step 1: Initialize internal accumulators
    if inputLength < 32:
        acc = (seed + PRIME64_5) & mod
        remaining_input = input_bytes
        # Go to step 4
    else:
        acc1 = (seed + PRIME64_1 + PRIME64_2) & mod
        acc2 = (seed + PRIME64_2) & mod
        acc3 = (seed + 0) & mod
        acc4 = (seed - PRIME64_1) & mod
        remaining_input = input_bytes

        # Process stripes
        if len(input_bytes) >= 32:
            while len(remaining_input) >= 32:
                lane1 = int.from_bytes(remaining_input[:8], 'little')
                lane2 = int.from_bytes(remaining_input[8:16], 'little')
                lane3 = int.from_bytes(remaining_input[16:24], 'little')
                lane4 = int.from_bytes(remaining_input[24:32], 'little')
                
                # Round 1
                acc1 = (acc1 + (lane1 * PRIME64_2)) & mod
                acc1 = rol64(acc1, 31) & mod
                acc1 = (acc1 * PRIME64_1) & mod
                
                acc2 = (acc2 + (lane2 * PRIME64_2)) & mod
                acc2 = rol64(acc2, 31) & mod
                acc2 = (acc2 * PRIME64_1) & mod
                
                acc3 = (acc3 + (lane3 * PRIME64_2)) & mod
                acc3 = rol64(acc3, 31) & mod
                acc3 = (acc3 * PRIME64_1) & mod
                
                acc4 = (acc4 + (lane4 * PRIME64_2)) & mod
                acc4 = rol64(acc4, 31) & mod
                acc4 = (acc4 * PRIME64_1) & mod
                
                remaining_input = remaining_input[32:]

            # Step 3: Accumulator convergence
            acc = ((rol64(acc1, 1)) + (rol64(acc2, 7)) + (rol64(acc3, 12)) + (rol64(acc4, 18))) & mod
            acc = merge_accumulator(acc, acc1) & mod
            acc = merge_accumulator(acc, acc2) & mod
            acc = merge_accumulator(acc, acc3) & mod
            acc = merge_accumulator(acc, acc4) & mod

    # Step 4: Add input length
    acc = (acc + inputLength) & mod

    # Step 5: Consume remaining input
    remaining_length = len(remaining_input)
    input_ptr = 0
    while remaining_length >= 8:
        lane = read_64bit_little_endian(remaining_input, input_ptr) & mod
        acc = (acc ^ round_function(0, lane)) & mod
        acc = (rol64(acc, 27) * PRIME64_1) & mod
        acc = (acc + PRIME64_4) & mod
        input_ptr += 8
        remaining_length -= 8
    
    if remaining_length >= 4:
        lane = read_32bit_little_endian(remaining_input, input_ptr) & mod
        acc = (acc ^ (lane * PRIME64_1)) & mod
        acc = (rol64(acc, 23) * PRIME64_2) & mod
        acc = (acc + PRIME64_3) & mod
        input_ptr += 4
        remaining_length -= 4
    
    while remaining_length >= 1:
        lane = remaining_input[input_ptr] & mod
        acc = (acc ^ (lane * PRIME64_5)) & mod
        acc = (rol64(acc, 11) * PRIME64_1) & mod
        input_ptr += 1
        remaining_length -= 1
    
    # Step 6: Final mix (avalanche)
    acc = (acc ^ (acc >> 33)) & mod
    acc = (acc * PRIME64_2) & mod
    acc = (acc ^ (acc >> 29)) & mod
    acc = (acc * PRIME64_3) & mod
    acc = (acc ^ (acc >> 32)) & mod

    return acc & mod


def unsigned_to_signed(unsigned_num, bits=64):
    """
    Convert an unsigned number to signed number.

    Args:
    unsigned_num (int): Unsigned number to be converted.
    bits (int): Number of bits representing the number.

    Returns:
    int: Signed number.
    """

    # Check the MSB
    if unsigned_num & (1 << (bits - 1)):
        # Two's complement for negative numbers
        return -((unsigned_num ^ ((1 << bits) - 1)) + 1)
    else:
        # Positive number
        return unsigned_num