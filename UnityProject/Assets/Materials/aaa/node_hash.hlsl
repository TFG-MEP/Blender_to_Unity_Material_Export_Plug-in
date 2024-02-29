#ifndef NODE_HASH_HLSL
#define NODE_HASH_HLSL
#define FLT_MAX 3.402823466e+38  
#define rot(x, k) (((x) << (k)) | ((x) >> (32 - (k))))
#define mix(a, b, c) \
{ \
    a -= c; \
    a ^= rot(c, 4); \
    c += b; \
    b -= a; \
    b ^= rot(a, 6); \
    a += c; \
    c -= b; \
    c ^= rot(b, 8); \
    b += a; \
    a -= c; \
    a ^= rot(c, 16); \
    c += b; \
    b -= a; \
    b ^= rot(a, 19); \
    a += c; \
    c -= b; \
    c ^= rot(b, 4); \
    b += a; \
} \

#define final(a, b, c) \
{ \
    c ^= b; \
    c -= rot(b, 14); \
    a ^= c; \
    a -= rot(c, 11); \
    b ^= a; \
    b -= rot(a, 25); \
    c ^= b; \
    c -= rot(b, 16); \
    a ^= c; \
    a -= rot(c, 4); \
    b ^= a; \
    b -= rot(a, 14); \
    c ^= b; \
    c -= rot(b, 24); \
}        
uint hash_uint(uint kx)
{
    uint a, b, c;
    a = b = c = 0xdeadbeef + (1 << 2) + 13;

    a += kx;
    final(a, b, c);

    return c;
}
uint hash_uint2(uint kx, uint ky)
{
    uint a, b, c;
    a = b = c = 0xdeadbeef + (2 << 2) + 13;

    b += ky;
    a += kx;
    final(a, b, c);

    return c;
}
float hashnoise(float p)
{
    uint x = asuint(p);
    return hash_uint(x) / float(~0u);// ~0u es igual a 4294967295
}
float hashnoise(float2 p)
{
    const uint x =uint(p.x);
    const uint y = uint(p.y);
    return hash_uint2(x, y) /float(~0u);
}
// float voronoi_distance(float a, float b)
// {
// return abs(a - b);
// }
float hash_float_to_float(float k)
{
    return hashnoise(k);

}

float hash_vector2_to_float(float2 k)
{
    return hashnoise(float2(k.x, k.y));//??
}
float4 hash_float_to_color(float k)
{
    return float4(hash_float_to_float(k),
                hash_vector2_to_float(float2(k, 1.0)),
                hash_vector2_to_float(float2(k, 2.0)),1);
}
uint hash_uint3(uint kx, uint ky, uint kz)
{
    uint a, b, c;
    a = b = c = 0xdeadbeef + (3 << 2) + 13;

    c += kz;
    b += ky;
    a += kx;
    final(a, b, c);

    return c;
}
float hashnoise(float3 p)
{
    const uint x = uint(p.x);
    const uint y = uint(p.y);
    const uint z =uint(p.z);
    return hash_uint3(x, y, z) /float(~0u);
}
uint hash_uint4(uint kx, uint ky, uint kz, uint kw)
{
    uint a, b, c;
    a = b = c = 0xdeadbeef + (4 << 2) + 13;

    a += kx;
    b += ky;
    c += kz;
    mix(a, b, c);

    a += kw;
    final(a, b, c);

    return c;
}
float hashnoise(float4 p)
{
    const uint x =uint(p.x);
    const uint y =uint(p.y);
    const uint z = uint(p.z);
    const uint w = uint(p.w);
    return hash_uint4(x, y, z, w) /float(~0u);
}
float hash_vector4_to_float(float4 k)
{
 return hashnoise(float4(k.x, k.y, k.z,k.w));
}

float hash_vector3_to_float(float3 k)
{
  return hashnoise(k);
}

float2 hash_vector2_to_vector2(float2 k)
{
  return float2(hash_vector2_to_float(k), hash_vector3_to_float(float3(k.x, k.y, 1.0)));
}
float3 hash_vector3_to_vector3(float3 k)
{
  return float3(hash_vector3_to_float(k),
                 hash_vector4_to_float(float4(k[0], k[1], k[2], 1.0)),
                 hash_vector4_to_float(float4(k[0], k[1], k[2], 2.0)));
}
float4 hash_vector4_to_vector4(float4 k)
{
    return float4(hash_vector4_to_float(k),
                    hash_vector4_to_float(float4(k.w, k.x, k.y, k.z)),
                    hash_vector4_to_float(float4(k.z, k.w, k.x, k.y)),
                    hash_vector4_to_float(float4(k.y, k.z, k.w, k.x)));
}
float4  hash_vector4_to_color(float4 k)
{
  return float4(hash_vector4_to_float(k),
               hash_vector4_to_float(float4(k.z, k.x, k.w, k.y)),
               hash_vector4_to_float(float4(k.w, k.z, k.y, k.x)),1);
}
float4 hash_vector3_to_color(float3 k)
{
  return float4(hash_vector3_to_float(k),
               hash_vector4_to_float(float4(k[0], k[1], k[2], 1.0)),
               hash_vector4_to_float(float4(k[0], k[1], k[2], 2.0)),1);
}
float4 hash_vector2_to_color(float2 k)
{
  return float4(hash_vector2_to_float(k),
               hash_vector3_to_float(float3(k.x, k.y, 1.0)),
               hash_vector3_to_float(float3(k.x, k.y, 2.0)),1);
}

#endif // NODE_HASH_HLSL