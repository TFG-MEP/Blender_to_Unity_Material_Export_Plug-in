Shader "Custom/ShaderMixDoble_"
{
     Properties
    {
        _NormalTex("Normal Map", 2D) = "bump" {}
        VoronoiTexture_W("W", float) = 0.0
		Mix_Factor_Float("Factor_Float", float) = 0.5
		Mix_Factor_Vector("Factor_Vector", Vector) = (0.5, 0.5, 0.5)
		Mix_A_Float("A_Float", float) = 0.0
		Mix_B_Float("B_Float", float) = 10.0
		Mix_A_Vector("A_Vector", Vector) = (0.0, 0.0, 0.0)
		Mix_B_Vector("B_Vector", Vector) = (0.0, 0.0, 0.0)
		Mix_A_Color("A_Color", Color) = (0.7297400528407231,0.7297400528407231,0.7297400528407231, 1.0)
		Mix_B_Color("B_Color", Color) = (0.7297400528407231,0.7297400528407231,0.7297400528407231, 1.0)
		Mix_Clamp_Factor("Clamp_Factor", Int) = 1
		VoronoiTexture_Smoothness("Smoothness", float) = 1.0
		VoronoiTexture_Exponent("Exponent", float) = 0.5
		Mix001_Factor_Float("Factor_Float", float) = 0.10000000149011612
		Mix001_Factor_Vector("Factor_Vector", Vector) = (0.5, 0.5, 0.5)
		Mix001_A_Float("A_Float", float) = 0.0
		Mix001_B_Float("B_Float", float) = 5.0
		Mix001_A_Vector("A_Vector", Vector) = (0.0, 0.0, 0.0)
		Mix001_B_Vector("B_Vector", Vector) = (0.0, 0.0, 0.0)
		Mix001_A_Color("A_Color", Color) = (0.7297400528407231,0.7297400528407231,0.7297400528407231, 1.0)
		Mix001_B_Color("B_Color", Color) = (0.7297400528407231,0.7297400528407231,0.7297400528407231, 1.0)
		Mix_001_Clamp_Factor("Clamp_Factor", Int) = 1
		// Add properties
    }

    SubShader
    {

        Tags { "RenderType" = "Opaque" "RenderPipeline" = "UniversalRenderPipeline"}
        // Add tags

        LOD 100
        // Add pass properties
        Cull Off
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
            struct Mix_value_struct {
                float Result;
			// add members
            };
			struct Voronoi_Texture_struct {
                float Radius;
			float W;
			float3 Position;
			float3 Color;
			float Distance;
			// add members
            };
			// Add structs

            float VoronoiTexture_W;
			float Mix_Factor_Float;
			float3 Mix_Factor_Vector;
			float Mix_A_Float;
			float Mix_B_Float;
			float3 Mix_A_Vector;
			float3 Mix_B_Vector;
			float3 Mix_A_Color;
			float3 Mix_B_Color;
			bool Mix_Clamp_Factor;
			float VoronoiTexture_Smoothness;
			float VoronoiTexture_Exponent;
			float Mix001_Factor_Float;
			float3 Mix001_Factor_Vector;
			float Mix001_A_Float;
			float Mix001_B_Float;
			float3 Mix001_A_Vector;
			float3 Mix001_B_Vector;
			float3 Mix001_A_Color;
			float3 Mix001_B_Color;
			bool Mix_001_Clamp_Factor;
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
            
            Mix_value_struct mix_float(float mixFactorFloat, float3 mixFactorVector, float floatA, float floatB, float3 vectorA, float3 vectorB, float3 colorA, float3 colorB, bool clampFactor) {
		        Mix_value_struct mixed;
                if (clampFactor){
                    mixFactorFloat = clamp(mixFactorFloat, 0.0, 1.0);
                }
                mixed.Result=lerp(floatA, floatB, mixFactorFloat);
                return mixed;
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
			float hashnoisef4(float4 p)
{
    const uint x =uint(p.x);
    const uint y =uint(p.y);
    const uint z = uint(p.z);
    const uint w = uint(p.w);
    return hash_uint4(x, y, z, w) /float(~0u);
}
			float hash_vector4_to_float(float4 k)
{
 return hashnoisef4(float4(k.x, k.y, k.z,k.w));
}
			float hash_vector3_to_float(float3 k)
{
  return hashnoisef3(k);
}
			float3 hash_vector3_to_color(float3 k)
{
  return float3(hash_vector3_to_float(k),
               hash_vector4_to_float(float4(k[0], k[1], k[2], 1.0)),
               hash_vector4_to_float(float4(k[0], k[1], k[2], 2.0)));
}
			float3 hash_vector3_to_vector3(float3 k)
{
  return float3(hash_vector3_to_float(k),
                 hash_vector4_to_float(float4(k[0], k[1], k[2], 1.0)),
                 hash_vector4_to_float(float4(k[0], k[1], k[2], 2.0)));
}
			float voronoi_distance_f3(float3 a, float3 b, int metric,float exponent)
{
if (metric == 0) {
    return length(a - b);
  }
  else if (metric == 1) {
    return abs(a[0] - b[0]) + abs(a[1] - b[1]) + abs(a[2] - b[2]);
  }
  else if (metric == 2) {
    return max(abs(a[0] - b[0]), max(abs(a[1] - b[1]), abs(a[2] - b[2])));
  }
  else if (metric == 3) {
    return pow(pow(abs(a[0] - b[0]), exponent) + pow(abs(a[1] - b[1]), exponent) +
                   pow(abs(a[2] - b[2]), exponent),
               1.0 / exponent);
  }
  else {
    return 0.0;
  }
               
} 

			                
            Voronoi_Texture_struct voronoi_3D_F1_function(float3 coord, float VoronoiTexture_W, float sclae,float VoronoiTexture_Smoothness, float VoronoiTexture_Exponent, float randomness,int distance)
            {                               
                coord *= sclae;
                float3 cellPosition = floor(coord);
                float3 localPosition = coord - cellPosition;

                float minDistance = FLT_MAX;
                float3 targetOffset = float3(0.0, 0.0, 0.0);
                float3 targetPosition = float3(0.0, 0.0, 0.0);
                for (int k = -1; k <= 1; k++) {
                    for (int j = -1; j <= 1; j++) {
                        for (int i = -1; i <= 1; i++) {
                            float3 cellOffset = float3(i, j, k);
                            float3 pointPosition = cellOffset + hash_vector3_to_vector3(cellPosition + cellOffset) *
                                                                    randomness;
                            float distanceToPoint = voronoi_distance_f3(pointPosition, localPosition,distance,VoronoiTexture_Exponent);
                            if (distanceToPoint < minDistance) {
                                targetOffset = cellOffset;
                                minDistance = distanceToPoint;
                                targetPosition = pointPosition;
                            }
                        }
                    }
                }
                Voronoi_Texture_struct voro;
                voro.Distance=minDistance;
                voro.Color=hash_vector3_to_color(cellPosition + targetOffset);
                voro.Position=targetPosition + cellPosition;
                return voro;
            }
           
						float4 float3_to_float4(float3 vec){
                return float4(vec,1);
            }
			// Add methods
            float4 frag (v2f i) : SV_Target
            {

                float3 VoronoiTexture_Vector = (i.worldPos + float3(1,1,1))/2;;
				Mix_value_struct Mix = mix_float(Mix_Factor_Float, Mix_Factor_Vector, Mix_A_Float, Mix_B_Float, Mix_A_Vector, Mix_B_Vector, Mix_A_Color, Mix_B_Color, Mix_Clamp_Factor);
				float VoronoiTexture_Scale = Mix.Result;
				Mix_value_struct Mix_001 = mix_float(Mix001_Factor_Float, Mix001_Factor_Vector, Mix001_A_Float, Mix001_B_Float, Mix001_A_Vector, Mix001_B_Vector, Mix001_A_Color, Mix001_B_Color, Mix_001_Clamp_Factor);
				float VoronoiTexture_Randomness = Mix_001.Result;
				Voronoi_Texture_struct Voronoi_Texture = voronoi_3D_F1_function(VoronoiTexture_Vector, VoronoiTexture_W, VoronoiTexture_Scale, VoronoiTexture_Smoothness, VoronoiTexture_Exponent, VoronoiTexture_Randomness, 0);
				float4 MaterialOutput_Surface = float3_to_float4(Voronoi_Texture.Color);
				// Call methods
              
                // Add cutoff
                
                return MaterialOutput_Surface;
                
            }
            ENDHLSL
        }
        UsePass "Legacy Shaders/VertexLit/SHADOWCASTER"
    }
}
