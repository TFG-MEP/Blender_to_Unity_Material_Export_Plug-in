float3 float3_to_float4(float3 vec){
    return float4(vec,1);
}
float2 float3_to_float2(float3 vec){
    return vec.xy;
}
float float3_to_float(float3 vec){
    return (vec.x + vec.y + vec.z) / 3.0;
}


float4 float4_to_float3(float4 vec){
    return vec.xyz;
}
float2 float4_to_float2(float4 vec){
    return vec.xy;
}
float float4_to_float(float4 vec){
    return (vec.x + vec.y + vec.z + vec.w) / 4.0;
}


float4 float_to_float4(float val){
    return float4(val, val, val, val);
}
float3 float_to_float3(float val){
    return float3(val,val,val);
}
float2 float_to_float2(float val){
    return float2(val, val);
}

float4 float2_to_float4(float2 vec){
    return float4(vec.x, vec.y, 1, 1);
}
float3 float2_to_float3(float2 vec){
    return float3(vec.x, vec.y,1);
}
float float2_to_float(float2 vec){
    return (vec.x + vec.y) / 2.0;
}













