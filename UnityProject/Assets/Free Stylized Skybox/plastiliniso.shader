Shader "Custom/Shaderplastiliniso_"
{
     Properties
    {
        _NormalTex("Normal Map", 2D) = "bump" {}
        Mix_Factor_Float("Factor_Float", float) = 0.3083333373069763
		Mix_Factor_Vector("Factor_Vector", Vector) = (0.5, 0.5, 0.5)
		Mix_A_Float("A_Float", float) = 0.0
		Mix_B_Float("B_Float", float) = 0.0
		Mix_A_Vector("A_Vector", Vector) = (0.0, 0.0, 0.0)
		Mix_B_Vector("B_Vector", Vector) = (0.0, 0.0, 0.0)
		ImageTexture_Image("Texture", 2D) = "white" {}
		VoronoiTexture_W("W", float) = 0.0
		VoronoiTexture_Scale("Scale", float) = 6.899999618530273
		VoronoiTexture_Smoothness("Smoothness", float) = 1.0
		VoronoiTexture_Exponent("Exponent", float) = 0.5
		VoronoiTexture_Randomness("Randomness", float) = 0.8583333492279053
		ColorRamp_Color0("ColorRamp_Color0", Color) = (0.5365116405941641,0.32034707081298514,0.10367877809675653, 1.0)
		ColorRamp_Pos0("ColorRamp_Pos0", Float) = 0.0
		ColorRamp_Color1("ColorRamp_Color1", Color) = (1.0,0.6381665605498105,0.4656674491150077, 1.0)
		ColorRamp_Pos1("ColorRamp_Pos1", Float) = 1.0
		PrincipledBSDF_Subsurface("Subsurface", float) = 0.0
		PrincipledBSDF_SubsurfaceRadius("SubsurfaceRadius", Vector) = (1.0, 0.20000000298023224, 0.10000000149011612)
		PrincipledBSDF_SubsurfaceColor("SubsurfaceColor", Color) = (0.903545437039038,0.903545437039038,0.903545437039038, 1.0)
		PrincipledBSDF_SubsurfaceIOR("SubsurfaceIOR", float) = 1.399999976158142
		PrincipledBSDF_SubsurfaceAnisotropy("SubsurfaceAnisotropy", float) = 0.0
		PrincipledBSDF_Metallic("Metallic", float) = 0.0
		PrincipledBSDF_Specular("Specular", float) = 0.5
		PrincipledBSDF_SpecularTint("SpecularTint", float) = 0.0
		PrincipledBSDF_Roughness("Roughness", float) = 1.0
		PrincipledBSDF_Anisotropic("Anisotropic", float) = 0.0
		PrincipledBSDF_AnisotropicRotation("AnisotropicRotation", float) = 0.0
		PrincipledBSDF_Sheen("Sheen", float) = 0.0
		PrincipledBSDF_SheenTint("SheenTint", float) = 0.5
		PrincipledBSDF_Clearcoat("Clearcoat", float) = 0.0
		PrincipledBSDF_ClearcoatRoughness("ClearcoatRoughness", float) = 0.029999999329447746
		PrincipledBSDF_IOR("IOR", float) = 1.4500000476837158
		PrincipledBSDF_Transmission("Transmission", float) = 0.0
		PrincipledBSDF_TransmissionRoughness("TransmissionRoughness", float) = 0.0
		PrincipledBSDF_Emission("Emission", Color) = (0.3950716053092199,0.23934050519856023,0.0, 1.0)
		PrincipledBSDF_EmissionStrength("EmissionStrength", float) = 0.0
		PrincipledBSDF_Alpha("Alpha", float) = 1.0
		NormalMap_Strength("Strength", float) = 1.0
		ImageTexture001_Image("Texture", 2D) = "white" {}
		PrincipledBSDF_ClearcoatNormal("ClearcoatNormal", Vector) = (0.0, 0.0, 0.0)
		PrincipledBSDF_Tangent("Tangent", Vector) = (0.0, 0.0, 0.0)
		PrincipledBSDF_Weight("Weight", float) = 0.0
		// Add properties
        _SrcFactor("SrcFactor", Float) = 5
        _DstFactor("DstFactor", Float) = 10
        _BlendOp("Blend Operation", Float) = 0
    }

    SubShader
    {

        Tags { "RenderType" = "Opaque" "RenderPipeline" = "UniversalRenderPipeline"}
        // Add tags

        LOD 100
        // Add pass properties
        //Blend [_SrcFactor] [_DstFactor]
        //BlendOp [_BlendOp]
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
            struct Image_texture{
    float3 Color;
    float Alpha;
};

			struct Voronoi_texture{
                float3 Color;
                float Distance;
                float3 Position;
                float W;
            };
			struct Mix_float{
                float4 Result;
            };
			struct Mix_vector{
                float3 Result;
            };
			struct Mix_color{
                float4 Result;
            };
			struct Color_Ramp{
                float3 Color;
                float Alpha;
            };
			struct Normal_map{
                float3 Normal;
            };
			struct BSDF{
                float4 BSDF_output;
            };
			// Add structs

            float Mix_Factor_Float;
			float3 Mix_Factor_Vector;
			float Mix_A_Float;
			float Mix_B_Float;
			float3 Mix_A_Vector;
			float3 Mix_B_Vector;
			sampler2D ImageTexture_Image;
			float VoronoiTexture_W;
			float VoronoiTexture_Scale;
			float VoronoiTexture_Smoothness;
			float VoronoiTexture_Exponent;
			float VoronoiTexture_Randomness;
			float4 ColorRamp_Color0;
			float ColorRamp_Pos0;
			float4 ColorRamp_Color1;
			float ColorRamp_Pos1;
			float PrincipledBSDF_Subsurface;
			float3 PrincipledBSDF_SubsurfaceRadius;
			float4 PrincipledBSDF_SubsurfaceColor;
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
			float4 PrincipledBSDF_Emission;
			float PrincipledBSDF_EmissionStrength;
			float PrincipledBSDF_Alpha;
			float NormalMap_Strength;
			sampler2D ImageTexture001_Image;
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
            
            // función que crea una textura a partir de un sampler2D
			Image_texture image_texture( float3 texcoord,sampler2D textura){
				Image_texture tex;
				float4 colorImage=tex2D(textura, texcoord.xy);
				tex.Color=colorImage.xyz;
				tex.Alpha=colorImage.w;
				return tex;
			}

						float4 float3_to_float4(float3 vec){
                return float4(vec,1);
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
			float voronoi_distance_f3(float3 a, float3 b)
{
    return length(a - b);           
} 
			                
            Voronoi_texture voronoi_f1_3D_function(float3 coord, float VoronoiTexture_W, float sclae,float VoronoiTexture_Smoothness, float VoronoiTexture_Exponent, float randomness)
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
                            float distanceToPoint = voronoi_distance_f3(pointPosition, localPosition);
                            if (distanceToPoint < minDistance) {
                                targetOffset = cellOffset;
                                minDistance = distanceToPoint;
                                targetPosition = pointPosition;
                            }
                        }
                    }
                }
                Voronoi_texture voro;
                voro.Distance=minDistance;
                voro.Color=hash_vector3_to_color(cellPosition + targetOffset);
                voro.Position=targetPosition + cellPosition;
                return voro;
            }
           
			Mix_float mix_float(float mixFactorFloat, float3 mixFactorVector, float floatA, float floatB, float3 vectorA, float3 vectorB, float4 colorA, float4 colorB) {
		        Mix_float mixed;
                float clampedFactor = clamp(mixFactorFloat, 0.0, 1.0);
                mixed.Result=lerp(floatA, floatB, clampedFactor);
                mixed.Result.w = clamp(mixed.Result.w, 0.0, 1.0);
                return mixed;
            }
			Mix_vector mix_vector(float mixFactorFloat, float3 mixFactorVector, float floatA, float floatB, float3 vectorA, float3 vectorB, float4 colorA, float4 colorB) {
		         Mix_vector mixed;
                 float clampedFactor = clamp(mixFactorVector, 0.0, 1.0);
                 mixed.Result=lerp(vectorA, vectorB, clampedFactor);
                return mixed;
            }
			Mix_color mix_color(float mixFactorFloat, float3 mixFactorVector, float floatA, float floatB, float3 vectorA, float3 vectorB, float4 colorA, float4 colorB) {
		        Mix_color mixed;
                float clampedFactor = clamp(mixFactorFloat, 0.0, 1.0);
                mixed.Result=lerp(colorA, colorB, clampedFactor);
                mixed.Result.w = clamp(mixed.Result.w, 0.0, 1.0);
                return mixed;
            }
				float float4_to_float(float4 vec){
                return (vec.x + vec.y + vec.z+vec.w) / 4.0;
            }
			Color_Ramp color_ramp( float at,int numcolors, int interpolate,float4 ramp[30],float pos[30] )
            {
              float f = at;
              int table_size = numcolors;
              f  = clamp(at, 0.0, 1.0) ;
              float4 result=ramp[0];
              Color_Ramp colores;
              if(numcolors>1&&f>=pos[numcolors-1]){
                  colores.Color = ramp[numcolors - 1].xyz;
                  colores.Alpha = ramp[numcolors - 1].w;
                  return colores;
              }
              for (int i = 0; i < numcolors - 1; ++i) {
                  if (f  >= pos[i] && f  <= pos[i + 1]){
                      if (interpolate){
                          result=ramp[i];
                          float t = (f - (float)pos[i])/(pos[i+1]-pos[i]);
                          result = (1.0 - t) * result + t * ramp[i + 1];
                      } 
                      else{
                          result= ramp[i];
                      }
                    
                  }
              }
              colores.Color=result.xyz;
              colores.Alpha=result.w;
              return colores;
            }
			 Normal_map normal_map(float strenght,float4 color){
                float3 normal=UnpackNormal(color);
                normal.rg*=strenght;
                Normal_map output;
                output.Normal=normal;
                return output;
}
			BSDF principled_bsdf(v2f i, float4 PrincipledBSDF_BaseColor,float PrincipledBSDF_Subsurface, float3 PrincipledBSDF_SubsurfaceRadius, float4 PrincipledBSDF_SubsurfaceColor,float PrincipledBSDF_SubsurfaceIOR,float PrincipledBSDF_SubsurfaceAnisotropy,
float PrincipledBSDF_Metallic, float PrincipledBSDF_Specular,float PrincipledBSDF_SpecularTint,float PrincipledBSDF_Roughness,float PrincipledBSDF_Anisotropic, float PrincipledBSDF_AnisotropicRotation,float PrincipledBSDF_Sheen, 
float PrincipledBSDF_SheenTint,float PrincipledBSDF_Clearcoat,float PrincipledBSDF_ClearcoatRoughness,float PrincipledBSDF_IOR,float PrincipledBSDF_Transmission,float PrincipledBSDF_TransmissionRoughness,float4 PrincipledBSDF_Emission,
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
               

                BSDF output;
                output.BSDF_output= UniversalFragmentPBR(inputData, surfacedata);
                return output;

            }
			// Add methods
            float4 frag (v2f i) : SV_Target
            {

                float3 ImageTexture_Vector = float3(i.uv,0);
				Image_texture ImageTexture = image_texture(ImageTexture_Vector, ImageTexture_Image);
				float4 Mix_A_Color = float3_to_float4(ImageTexture.Color);
				float3 VoronoiTexture_Vector = (i.worldPos + float3(1,1,1))/2;;
				Voronoi_texture VoronoiTexture = voronoi_f1_3D_function(VoronoiTexture_Vector, VoronoiTexture_W, VoronoiTexture_Scale, VoronoiTexture_Smoothness, VoronoiTexture_Exponent, VoronoiTexture_Randomness);
				float4 Mix_B_Color = float3_to_float4(VoronoiTexture.Color);
				Mix_float Mix_float = mix_float(Mix_Factor_Float, Mix_Factor_Vector, Mix_A_Float, Mix_B_Float, Mix_A_Vector, Mix_B_Vector, Mix_A_Color, Mix_B_Color);
				Mix_vector Mix_float_vector = mix_vector(Mix_Factor_Float, Mix_Factor_Vector, Mix_A_Float, Mix_B_Float, Mix_A_Vector, Mix_B_Vector, Mix_A_Color, Mix_B_Color);
				Mix_color Mix_float_vector_color = mix_color(Mix_Factor_Float, Mix_Factor_Vector, Mix_A_Float, Mix_B_Float, Mix_A_Vector, Mix_B_Vector, Mix_A_Color, Mix_B_Color);
				float ColorRamp_Fac = float4_to_float(Mix_float_vector_color.Result);
				float ColorRamp_pos[30];
				float4 ColorRamp_ramp[30];
				ColorRamp_ramp[0]=ColorRamp_Color0;
				ColorRamp_pos[0]=ColorRamp_Pos0;
				ColorRamp_ramp[1]=ColorRamp_Color1;
				ColorRamp_pos[1]=ColorRamp_Pos1;
				Color_Ramp ColorRamp = color_ramp(ColorRamp_Fac, 2, 1, ColorRamp_ramp, ColorRamp_pos);
				float4 PrincipledBSDF_BaseColor = float3_to_float4(ColorRamp.Color);
				float3 ImageTexture001_Vector = float3(i.uv,0);
				Image_texture ImageTexture001 = image_texture(ImageTexture001_Vector, ImageTexture001_Image);
				float4 NormalMap_Color = float3_to_float4(ImageTexture001.Color);
				Normal_map NormalMap = normal_map(NormalMap_Strength, NormalMap_Color);
				float3 PrincipledBSDF_Normal = NormalMap.Normal;
				BSDF Principled_BSDF = principled_bsdf(i, PrincipledBSDF_BaseColor, PrincipledBSDF_Subsurface, PrincipledBSDF_SubsurfaceRadius, PrincipledBSDF_SubsurfaceColor, PrincipledBSDF_SubsurfaceIOR, PrincipledBSDF_SubsurfaceAnisotropy, PrincipledBSDF_Metallic, PrincipledBSDF_Specular, PrincipledBSDF_SpecularTint, PrincipledBSDF_Roughness, PrincipledBSDF_Anisotropic, PrincipledBSDF_AnisotropicRotation, PrincipledBSDF_Sheen, PrincipledBSDF_SheenTint, PrincipledBSDF_Clearcoat, PrincipledBSDF_ClearcoatRoughness, PrincipledBSDF_IOR, PrincipledBSDF_Transmission, PrincipledBSDF_TransmissionRoughness, PrincipledBSDF_Emission, PrincipledBSDF_EmissionStrength, PrincipledBSDF_Alpha, PrincipledBSDF_Normal, PrincipledBSDF_ClearcoatNormal, PrincipledBSDF_Tangent, PrincipledBSDF_Weight);
				float4 MaterialOutput_Surface = Principled_BSDF.BSDF_output;
				// Call methods
              
                // Add cutoff
                
                return MaterialOutput_Surface;
                
            }
            ENDHLSL
        }
        UsePass "Legacy Shaders/VertexLit/SHADOWCASTER"
    }
}
