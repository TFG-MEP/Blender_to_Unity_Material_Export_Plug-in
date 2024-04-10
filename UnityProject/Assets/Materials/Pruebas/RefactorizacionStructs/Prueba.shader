Shader "Custom/ShaderPrueba_"
{
     Properties
    {
        _NormalTex("Normal Map", 2D) = "bump" {}
        MixShader_Fac("Fac", float) = 0.5
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
		PrincipledBSDF_BaseColor("BaseColor", Color) = (0.903545437039038,0.903545437039038,0.903545437039038, 1.0)
		PrincipledBSDF_Subsurface("Subsurface", float) = 0.0
		PrincipledBSDF_SubsurfaceRadius("SubsurfaceRadius", Vector) = (1.0, 0.20000000298023224, 0.10000000149011612)
		Mix002_Factor_Float("Factor_Float", float) = 10.0
		Mix002_Factor_Vector("Factor_Vector", Vector) = (0.5, 0.5, 0.5)
		Mix002_A_Float("A_Float", float) = 0.0
		Mix002_B_Float("B_Float", float) = 0.0
		Mix002_A_Vector("A_Vector", Vector) = (0.0, 0.0, 0.0)
		Mix002_B_Vector("B_Vector", Vector) = (0.0, 0.0, 0.0)
		RGB_Color("Color", Color) = (0.7297400528407231,0.2573964649041089,0.6918526674863525, 1.0)
		RGB_001_Color("Color", Color) = (0.1974514243039139,0.24688560949763988,0.7297400528407231, 1.0)
		Mix_002_Clamp_Factor("Clamp_Factor", Int) = 0
		Mix_002_Clamp_Result("Clamp_Result", Int) = 0
		PrincipledBSDF_SubsurfaceIOR("SubsurfaceIOR", float) = 1.399999976158142
		PrincipledBSDF_SubsurfaceAnisotropy("SubsurfaceAnisotropy", float) = 0.0
		PrincipledBSDF_Metallic("Metallic", float) = 0.0
		PrincipledBSDF_Specular("Specular", float) = 0.5
		PrincipledBSDF_SpecularTint("SpecularTint", float) = 0.0
		PrincipledBSDF_Roughness("Roughness", float) = 0.5
		PrincipledBSDF_Anisotropic("Anisotropic", float) = 0.0
		PrincipledBSDF_AnisotropicRotation("AnisotropicRotation", float) = 0.0
		PrincipledBSDF_Sheen("Sheen", float) = 0.0
		PrincipledBSDF_SheenTint("SheenTint", float) = 0.5
		PrincipledBSDF_Clearcoat("Clearcoat", float) = 0.0
		PrincipledBSDF_ClearcoatRoughness("ClearcoatRoughness", float) = 0.029999999329447746
		PrincipledBSDF_IOR("IOR", float) = 1.4500000476837158
		PrincipledBSDF_Transmission("Transmission", float) = 0.0
		PrincipledBSDF_TransmissionRoughness("TransmissionRoughness", float) = 0.0
		Mix003_Factor_Float("Factor_Float", float) = 0.20666667819023132
		Mix003_Factor_Vector("Factor_Vector", Vector) = (0.5, 0.5, 0.5)
		Mix003_A_Float("A_Float", float) = 0.0
		Mix003_B_Float("B_Float", float) = 0.0
		Mix003_A_Vector("A_Vector", Vector) = (0.0, 0.0, 0.0)
		Mix003_B_Vector("B_Vector", Vector) = (0.0, 0.0, 0.0)
		Mix_003_Clamp_Factor("Clamp_Factor", Int) = 1
		Mix_003_Clamp_Result("Clamp_Result", Int) = 0
		Mix004_Factor_Float("Factor_Float", float) = 0.5
		Mix004_Factor_Vector("Factor_Vector", Vector) = (0.5, 0.5, 0.5)
		Mix004_A_Float("A_Float", float) = 0.0
		Mix004_B_Float("B_Float", float) = 1.0
		Mix004_A_Vector("A_Vector", Vector) = (0.0, 0.0, 0.0)
		Mix004_B_Vector("B_Vector", Vector) = (0.0, 0.0, 0.0)
		Mix004_A_Color("A_Color", Color) = (0.7297400528407231,0.7297400528407231,0.7297400528407231, 1.0)
		Mix004_B_Color("B_Color", Color) = (0.7297400528407231,0.7297400528407231,0.7297400528407231, 1.0)
		Mix_004_Clamp_Factor("Clamp_Factor", Int) = 1
		PrincipledBSDF_Alpha("Alpha", float) = 1.0
		PrincipledBSDF_Normal("Normal", Vector) = (0.0, 0.0, 0.0)
		PrincipledBSDF_ClearcoatNormal("ClearcoatNormal", Vector) = (0.0, 0.0, 0.0)
		PrincipledBSDF_Tangent("Tangent", Vector) = (0.0, 0.0, 0.0)
		PrincipledBSDF_Weight("Weight", float) = 0.0
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
			struct RGB_struct {
                float3 Color;
			// add members
            };
			struct Mix_color_struct {
                float3 Result;
			// add members
            };
			struct Principled_BSDF_struct {
                float4 BSDF;
			// add members
            };
			struct Mix_shader{
                float4 Shader;
            };
			// Add structs

            float MixShader_Fac;
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
			float3 PrincipledBSDF_BaseColor;
			float PrincipledBSDF_Subsurface;
			float3 PrincipledBSDF_SubsurfaceRadius;
			float Mix002_Factor_Float;
			float3 Mix002_Factor_Vector;
			float Mix002_A_Float;
			float Mix002_B_Float;
			float3 Mix002_A_Vector;
			float3 Mix002_B_Vector;
			float4 RGB_Color;
			float4 RGB_001_Color;
			bool Mix_002_Clamp_Factor;
			bool Mix_002_Clamp_Result;
			float PrincipledBSDF_SubsurfaceIOR;
			float PrincipledBSDF_SubsurfaceAnisotropy;
			float PrincipledBSDF_Metallic;
			float PrincipledBSDF_Specular;
			float PrincipledBSDF_SpecularTint;
			float PrincipledBSDF_Roughness;
			float PrincipledBSDF_Anisotropic;
			float PrincipledBSDF_AnisotropicRotation;
			float PrincipledBSDF_Sheen;
			float PrincipledBSDF_SheenTint;
			float PrincipledBSDF_Clearcoat;
			float PrincipledBSDF_ClearcoatRoughness;
			float PrincipledBSDF_IOR;
			float PrincipledBSDF_Transmission;
			float PrincipledBSDF_TransmissionRoughness;
			float Mix003_Factor_Float;
			float3 Mix003_Factor_Vector;
			float Mix003_A_Float;
			float Mix003_B_Float;
			float3 Mix003_A_Vector;
			float3 Mix003_B_Vector;
			bool Mix_003_Clamp_Factor;
			bool Mix_003_Clamp_Result;
			float Mix004_Factor_Float;
			float3 Mix004_Factor_Vector;
			float Mix004_A_Float;
			float Mix004_B_Float;
			float3 Mix004_A_Vector;
			float3 Mix004_B_Vector;
			float3 Mix004_A_Color;
			float3 Mix004_B_Color;
			bool Mix_004_Clamp_Factor;
			float PrincipledBSDF_Alpha;
			float3 PrincipledBSDF_Normal;
			float3 PrincipledBSDF_ClearcoatNormal;
			float3 PrincipledBSDF_Tangent;
			float PrincipledBSDF_Weight;
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
			RGB_struct rgb(float3 input_color)
            {
                RGB_struct output_color;
                output_color.Color = input_color;
                return output_color;
            }
			float3 blending_function(float3 color_1, float3 color_2, float fac){
                float facm = 1.0f - fac;
                float3 r_col = float3(0,0,0);
                r_col[0] = facm * color_1[0] + fac * color_2[0];
                r_col[1] = facm * color_1[1] + fac * color_2[1];
                r_col[2] = facm * color_1[2] + fac * color_2[2];
                return r_col;
				// Add blending function
            }

            Mix_color_struct mix_color(float mixFactorFloat, float3 mixFactorVector, float floatA, float floatB, float3 vectorA, float3 vectorB, float3 colorA, float3 colorB, bool clampFactor, bool clampResult) {
		        Mix_color_struct mixed;
                if (clampFactor){
                    mixFactorFloat = clamp(mixFactorFloat, 0.0, 1.0);
                }
                mixed.Result = blending_function(colorA, colorB, mixFactorFloat);

                if (clampResult){
                    mixed.Result = clamp(mixed.Result, 0.0, 1.0);
                }
                return mixed;
            }
			Principled_BSDF_struct principled_bsdf(v2f i, float3 PrincipledBSDF_BaseColor,float PrincipledBSDF_Subsurface, float3 PrincipledBSDF_SubsurfaceRadius, float3 PrincipledBSDF_SubsurfaceColor,float PrincipledBSDF_SubsurfaceIOR,float PrincipledBSDF_SubsurfaceAnisotropy,
float PrincipledBSDF_Metallic, float PrincipledBSDF_Specular,float PrincipledBSDF_SpecularTint,float PrincipledBSDF_Roughness,float PrincipledBSDF_Anisotropic, float PrincipledBSDF_AnisotropicRotation,float PrincipledBSDF_Sheen, 
float PrincipledBSDF_SheenTint,float PrincipledBSDF_Clearcoat,float PrincipledBSDF_ClearcoatRoughness,float PrincipledBSDF_IOR,float PrincipledBSDF_Transmission,float PrincipledBSDF_TransmissionRoughness,float3 PrincipledBSDF_Emission,
float PrincipledBSDF_EmissionStrength,float PrincipledBSDF_Alpha, float3 PrincipledBSDF_Normal,float3 PrincipledBSDF_ClearcoatNormal, float3 PrincipledBSDF_Tangent, float PrincipledBSDF_Weight)
            { 
                SurfaceData surfacedata;
                surfacedata.albedo = PrincipledBSDF_BaseColor;
                surfacedata.specular = 0;
                surfacedata.metallic = clamp(PrincipledBSDF_Metallic,0,1);
                surfacedata.smoothness = clamp(1-PrincipledBSDF_Roughness,0,1);
                if(PrincipledBSDF_Normal.x==0&&PrincipledBSDF_Normal.y==0&&PrincipledBSDF_Normal.z==0){
                    surfacedata.normalTS = UnpackNormal(tex2D(_NormalTex, i.uv));  
                } 
                else surfacedata.normalTS =PrincipledBSDF_Normal;  
               

                PrincipledBSDF_Emission.rgb *= PrincipledBSDF_EmissionStrength;
                surfacedata.emission = PrincipledBSDF_Emission;
                surfacedata.occlusion = 1; //"Ambient occlusion"
                surfacedata.alpha = 1;
                surfacedata.clearCoatMask = 0;
                surfacedata.clearCoatSmoothness = 0;

                // Emission output.
                #if USE_EMISSION_ON
                PrincipledBSDF_Emission.rgb *= PrincipledBSDF_EmissionStrength;
                surfaceData.emission = PrincipledBSDF_Emission;;
                #endif
               
                InputData inputData = (InputData)0;
                // Position input.
                inputData.positionWS = i.positionWS;
                // Normal input.
                float3 bitangent = i.tangentWS.w * cross(i.normalWS, 
                i.tangentWS.xyz);
                inputData.tangentToWorld = float3x3(i.tangentWS.xyz, bitangent, 
                i.normalWS);
                inputData.normalWS = TransformTangentToWorld(surfacedata.normalTS, inputData.
                tangentToWorld);
                inputData.normalWS = NormalizeNormalPerPixel(inputData.normalWS);
                // View direction input.
                inputData.viewDirectionWS = SafeNormalize(i.viewDirWS);
                // Shadow coords.
                inputData.shadowCoord = TransformWorldToShadowCoord 
                (inputData .positionWS);
                // Baked lightmaps.
                #if defined(DYNAMICLIGHTMAP_ON)
                inputData.bakedGI = SAMPLE_GI(i.staticLightmapUV, 
                i.dynamicLightmapUV, i.vertexSH, inputData.normalWS);
             

                #else
                inputData.bakedGI = SAMPLE_GI(i.staticLightmapUV, i.vertexSH, 
                inputData.normalWS);
                #endif
                inputData.normalizedScreenSpaceUV = GetNormalizedScreenSpaceUV(i.
                positionCS);
                inputData.shadowMask = SAMPLE_SHADOWMASK(i.staticLightmapUV);
               

                Principled_BSDF_struct output;
                output.BSDF= UniversalFragmentPBR(inputData, surfacedata);
                return output;

            }
			Mix_shader mix_shader(float mixFactor, float4 shader1, float4 shader2) {
        Mix_shader mixed;
		float clampedFactor = clamp(mixFactor, 0.0, 1.0);
        mixed.Shader=lerp(shader1, shader2, clampedFactor);
        mixed.Shader.w = clamp(mixed.Shader.w, 0.0, 1.0);
                return mixed;
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
				float4 MixShader_Shader = float3_to_float4(Voronoi_Texture.Color);
				RGB_struct RGB = rgb(RGB_Color);
				float3 Mix002_A_Color = RGB.Color;
				float3 Mix003_B_Color = RGB.Color;
				RGB_struct RGB_001 = rgb(RGB_001_Color);
				float3 Mix002_B_Color = RGB_001.Color;
				float3 Mix003_A_Color = RGB_001.Color;
				Mix_color_struct Mix_002 = mix_color(Mix002_Factor_Float, Mix002_Factor_Vector, Mix002_A_Float, Mix002_B_Float, Mix002_A_Vector, Mix002_B_Vector, Mix002_A_Color, Mix002_B_Color, Mix_002_Clamp_Factor, Mix_002_Clamp_Result);
				float3 PrincipledBSDF_SubsurfaceColor = Mix_002.Result;
				Mix_color_struct Mix_003 = mix_color(Mix003_Factor_Float, Mix003_Factor_Vector, Mix003_A_Float, Mix003_B_Float, Mix003_A_Vector, Mix003_B_Vector, Mix003_A_Color, Mix003_B_Color, Mix_003_Clamp_Factor, Mix_003_Clamp_Result);
				float3 PrincipledBSDF_Emission = Mix_003.Result;
				Mix_value_struct Mix_004 = mix_float(Mix004_Factor_Float, Mix004_Factor_Vector, Mix004_A_Float, Mix004_B_Float, Mix004_A_Vector, Mix004_B_Vector, Mix004_A_Color, Mix004_B_Color, Mix_004_Clamp_Factor);
				float PrincipledBSDF_EmissionStrength = Mix_004.Result;
				Principled_BSDF_struct Principled_BSDF = principled_bsdf(i, PrincipledBSDF_BaseColor, PrincipledBSDF_Subsurface, PrincipledBSDF_SubsurfaceRadius, PrincipledBSDF_SubsurfaceColor, PrincipledBSDF_SubsurfaceIOR, PrincipledBSDF_SubsurfaceAnisotropy, PrincipledBSDF_Metallic, PrincipledBSDF_Specular, PrincipledBSDF_SpecularTint, PrincipledBSDF_Roughness, PrincipledBSDF_Anisotropic, PrincipledBSDF_AnisotropicRotation, PrincipledBSDF_Sheen, PrincipledBSDF_SheenTint, PrincipledBSDF_Clearcoat, PrincipledBSDF_ClearcoatRoughness, PrincipledBSDF_IOR, PrincipledBSDF_Transmission, PrincipledBSDF_TransmissionRoughness, PrincipledBSDF_Emission, PrincipledBSDF_EmissionStrength, PrincipledBSDF_Alpha, PrincipledBSDF_Normal, PrincipledBSDF_ClearcoatNormal, PrincipledBSDF_Tangent, PrincipledBSDF_Weight);
				float4 MixShader_Shader_001 = Principled_BSDF.BSDF;
				Mix_shader Mix_Shader = mix_shader(MixShader_Fac, MixShader_Shader, MixShader_Shader_001);
				float4 MaterialOutput_Surface = Mix_Shader.Shader;
				// Call methods
              
                // Add cutoff
                
                return MaterialOutput_Surface;
                
            }
            ENDHLSL
        }
        UsePass "Legacy Shaders/VertexLit/SHADOWCASTER"
    }
}
