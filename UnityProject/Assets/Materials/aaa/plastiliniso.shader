Shader "Custom/Shaderplastiliniso_"
{
     Properties
    {
        _NormalTex("Normal Map", 2D) = "bump" {}
        VoronoiTexture_W("W", float) = 0.0
		VoronoiTexture_Scale("Scale", float) = 9.59999942779541
		VoronoiTexture_Smoothness("Smoothness", float) = 1.0
		VoronoiTexture_Exponent("Exponent", float) = 0.0
		VoronoiTexture_Randomness("Randomness", float) = 0.8583333492279053
		// Add properties
    }

    SubShader
    {

        Tags { "RenderType" = "Opaque" "RenderPipeline" = "UniversalRenderPipeline"}
        // Add tags

        LOD 100
        // Add pass properties

        Pass
        {
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag
          
            #include"Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#pragma multi_compile _ _MAIN_LIGHT_SHADOWS
			#pragma multi_compile _ _MAIN_LIGHT_SHADOWS_CASCADE
			#pragma multi_compile _ _SHADOWS_SOFT
			#pragma shader_feature _ALPHATEST_ON
			#pragma multi_compile_local USE_EMISSION_ON __
			#pragma multi_compile _ _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS
			#pragma multi_compile_fragment _ _ADDITIONAL_LIGHT_SHADOWS
			#pragma multi_compile_fragment _ _REFLECTION_PROBE_BLENDING
			#pragma multi_compile_fragment _ _REFLECTION_PROBE_BOX_PROJECTION
			#pragma multi_compile_fragment _ _SHADOWS_SOFT
			#pragma multi_compile_fragment _ _SCREEN_SPACE_OCCLUSION
			#pragma multi_compile _ LIGHTMAP_SHADOW_MIXING
			#pragma multi_compile _ SHADOWS_SHADOWMASK
			#pragma multi_compile _ DIRLIGHTMAP_COMBINED
			#pragma multi_compile _ LIGHTMAP_ON
			#pragma multi_compile _ DYNAMICLIGHTMAP_ON
			//Add includes 
            
            
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
			// Add defines

            
            //Datos de entrada en el vertex shader
            struct appdata
            {
                float4 positionOS : POSITION;
                float2 uv : TEXCOORD0;
                float3 normalOS : NORMAL;
                float4 tangentOS : TANGENT;
                float2 staticLightmapUV : TEXCOORD1;
                float2 dynamicLightmapUV : TEXCOORD2;
            };
            //Datos que se calculan en el vertex shader y se usan en el fragment shader
            struct v2f
            {
                float4 positionCS : SV_POSITION;
                float2 uv : TEXCOORD0;
                float3 positionWS : TEXCOORD1;
                float3 normalWS : TEXCOORD2;
                float4 tangentWS : TEXCOORD3;
                float3 viewDirWS : TEXCOORD4;
                float4 shadowCoord : TEXCOORD5;
                DECLARE_LIGHTMAP_OR_SH(staticLightmapUV, vertexSH, 6);
                #ifdef DYNAMICLIGHTMAP_ON
                float2  dynamicLightmapUV : TEXCOORD7;
                #endif
                float3 worldPos : TEXCOORD8;
                float3 normalOS:TEXCOORD9;
            };
            struct Voronoi_texture{
                float3 Color;
                float Distance;
                float3 Position;
                float W;
            };
			// Add structs

            float VoronoiTexture_W;
			float VoronoiTexture_Scale;
			float VoronoiTexture_Smoothness;
			float VoronoiTexture_Exponent;
			float VoronoiTexture_Randomness;
			// Add variables
    
            sampler2D _NormalTex;
            v2f vert(appdata v)
            {
                v2f o;
                o.worldPos = v.positionOS.xyz;
                VertexPositionInputs vertexInput = GetVertexPositionInputs(v.
                positionOS.xyz);
                VertexNormalInputs normalInput = GetVertexNormalInputs(v.normalOS, 
                v.tangentOS);
                o.normalOS=v.normalOS;
                o.positionWS = vertexInput.positionWS;
                o.positionCS = vertexInput.positionCS;
                o.uv = v.uv;
                o.normalWS = normalInput.normalWS;
                float sign = v.tangentOS.w;
                o.tangentWS = float4(normalInput.tangentWS.xyz, sign);
                o.viewDirWS = GetWorldSpaceNormalizeViewDir(vertexInput.positionWS);
                o.shadowCoord = GetShadowCoord(vertexInput);
                OUTPUT_LIGHTMAP_UV(v.staticLightmapUV, unity_LightmapST, 
                o.staticLightmapUV);

                #ifdef DYNAMICLIGHTMAP_ON
                v.dynamicLightmapUV = v.dynamicLightmapUV.xy * unity_
                DynamicLightmapST.xy + unity_DynamicLightmapST.zw;
                #endif
                OUTPUT_SH(o.normalWS.xyz, o.vertexSH);
                return o;
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
			float hashnoisef3(float3 p)
{
    const uint x = uint(p.x);
    const uint y = uint(p.y);
    const uint z =uint(p.z);
    return hash_uint3(x, y, z) /float(~0u);
}
			float hashnoisef2(float2 p)
{
    const uint x =uint(p.x);
    const uint y = uint(p.y);
    return hash_uint2(x, y) /float(~0u);
}
			float hash_vector2_to_float(float2 k)
{
    return hashnoisef2(float2(k.x, k.y));//??
}
			float hash_vector3_to_float(float3 k)
{
  return hashnoisef3(k);
}
			float3 hash_vector2_to_color(float2 k)
{
  return float3(hash_vector2_to_float(k),
               hash_vector3_to_float(float3(k.x, k.y, 1.0)),
               hash_vector3_to_float(float3(k.x, k.y, 2.0)));
}
			float2 hash_vector2_to_vector2(float2 k)
{
  return float2(hash_vector2_to_float(k), hash_vector3_to_float(float3(k.x, k.y, 1.0)));
}
			float voronoi_distance_f2(float2 a, float2 b, int metric,float exponent)
{
if (metric == 0) {
    return length(a - b);
  }
  else if (metric == 1) {
    return abs(a[0] - b[0]) + abs(a[1] - b[1]) ;
  }
  else if (metric == 2) {
    return max(abs(a[0] - b[0]), abs(a[1] - b[1]));
  }
  else if (metric == 3) {
    return pow(pow(abs(a[0] - b[0]), exponent) + pow(abs(a[1] - b[1]), exponent),
               1.0 / exponent);
  }
  else {
    return 0.0;
  }
               
} 

			            Voronoi_texture voronoi_2D_F1_function(float3 coorde, float VoronoiTexture_W, float sclae,float VoronoiTexture_Smoothness, float VoronoiTexture_Exponent, float randomness,int distance)
            {
                float2 coord=float2(coorde.x,coorde.z);
                coord *= sclae;
                float2 cellPosition = floor(coord);
                float2 localPosition = coord - cellPosition;



                float minDistance = FLT_MAX;
                float2 targetOffset = float2(0.0, 0.0);
                float2 targetPosition = float2(0.0, 0.0);
                for (int j = -1; j <= 1; j++) {
                    for (int i = -1; i <= 1; i++) {
                    float2 cellOffset = float2(i, j);
                    float2 pointPosition = cellOffset + hash_vector2_to_vector2(cellPosition + cellOffset) *
                                                        randomness;
                    float distanceToPoint = voronoi_distance_f2(pointPosition, localPosition,distance,VoronoiTexture_Exponent);
                    if (distanceToPoint < minDistance) {
                        targetOffset = cellOffset;
                        minDistance = distanceToPoint;
                        targetPosition = pointPosition;
                    }
                    }

                }
                Voronoi_texture voro;
                voro.Distance=minDistance;
                voro.Color=hash_vector2_to_color(cellPosition + targetOffset);
                voro.Position=float3(targetPosition + cellPosition,0);
                return voro;

            }        
						float4 float3_to_float4(float3 vec){
                return float4(vec,1);
            }
			// Add methods
            float4 frag (v2f i) : SV_Target
            {

                float3 VoronoiTexture_Vector = (i.worldPos + float3(1,1,1))/2;;
				Voronoi_texture VoronoiTexture = voronoi_2D_F1_function(VoronoiTexture_Vector, VoronoiTexture_W, VoronoiTexture_Scale, VoronoiTexture_Smoothness, VoronoiTexture_Exponent, VoronoiTexture_Randomness, 0);
				float4 MaterialOutput_Surface = float3_to_float4(VoronoiTexture.Color);
				// Call methods
              
                // Add cutoff
                
                return MaterialOutput_Surface;
                
            }
            ENDHLSL
        }
        UsePass "Legacy Shaders/VertexLit/SHADOWCASTER"
    }
}
