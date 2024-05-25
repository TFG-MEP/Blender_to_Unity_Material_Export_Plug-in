Shader "Custom/Shadermadera_"
{
     Properties
    {
        _NormalTex("Normal Map", 2D) = "bump" {}
        _BoundingBoxMin("minBoundBox", Vector) = (0,0,0)
        _BoundingBoxMax("maxBoundBox", Vector) = (0,0,0)

        BSDFPrincipista_BaseColor("BaseColor", Color) = (0.8429445390077067,0.18663468299629732,0.11042362829696879, 1.0)
		BSDFPrincipista_Subsurface("Subsurface", float) = 0.0
		BSDFPrincipista_SubsurfaceRadius("SubsurfaceRadius", Vector) = (1.0, 0.20000000298023224, 0.10000000149011612)
		BSDFPrincipista_SubsurfaceColor("SubsurfaceColor", Color) = (0.903545437039038,0.903545437039038,0.903545437039038, 1.0)
		BSDFPrincipista_SubsurfaceIOR("SubsurfaceIOR", float) = 1.399999976158142
		BSDFPrincipista_SubsurfaceAnisotropy("SubsurfaceAnisotropy", float) = 0.0
		BSDFPrincipista_Metallic("Metallic", float) = 0.0
		BSDFPrincipista_Specular("Specular", float) = 0.6272727251052856
		BSDFPrincipista_SpecularTint("SpecularTint", float) = 0.0
		BSDFPrincipista_Roughness("Roughness", float) = 0.9409090280532837
		BSDFPrincipista_Anisotropic("Anisotropic", float) = 0.0
		BSDFPrincipista_AnisotropicRotation("AnisotropicRotation", float) = 0.0
		BSDFPrincipista_Sheen("Sheen", float) = 0.0
		BSDFPrincipista_SheenTint("SheenTint", float) = 0.5
		BSDFPrincipista_Clearcoat("Clearcoat", float) = 0.0
		BSDFPrincipista_ClearcoatRoughness("ClearcoatRoughness", float) = 0.029999999329447746
		BSDFPrincipista_IOR("IOR", float) = 1.4500000476837158
		BSDFPrincipista_Transmission("Transmission", float) = 0.0
		BSDFPrincipista_TransmissionRoughness("TransmissionRoughness", float) = 0.0
		BSDFPrincipista_Emission("Emission", Color) = (0.0,0.0,0.0, 1.0)
		BSDFPrincipista_EmissionStrength("EmissionStrength", float) = 1.0
		BSDFPrincipista_Alpha("Alpha", float) = 1.0
		Mezclar_Factor_Float("Factor_Float", float) = 0.5
		Mezclar_Factor_Vector("Factor_Vector", Vector) = (0.5, 0.5, 0.5)
		Mezclar_A_Float("A_Float", float) = 0.0
		Mezclar_B_Float("B_Float", float) = 0.0
		Mezclar_A_Vector("A_Vector", Vector) = (0.0, 0.0, 0.0)
		Mezclar_B_Vector("B_Vector", Vector) = (0.0, 0.0, 0.0)
		Mapeo001_Location("Location", Vector) = (0.0, 0.0, 0.0)
		Mapeo001_Rotation("Rotation", Vector) = (0.0, 0.0, 0.0)
		Mapeo001_Scale("Scale", Vector) = (1.0, 1.0, 1.0)
		VoronoiTexture_W("W", float) = 0.0
		VoronoiTexture_Scale("Scale", float) = 0.7000002861022949
		VoronoiTexture_Smoothness("Smoothness", float) = 1.0
		VoronoiTexture_Exponent("Exponent", float) = 0.5
		VoronoiTexture_Randomness("Randomness", float) = 0.2083333134651184
		Mezclar_B_Color("B_Color", Color) = (0.7297400528407231,0.7297400528407231,0.7297400528407231, 1.0)
		Mezclar_Clamp_Factor("Clamp_Factor", Int) = 1
		Mezclar_Clamp_Result("Clamp_Result", Int) = 0
		BSDFPrincipista_ClearcoatNormal("ClearcoatNormal", Vector) = (0.0, 0.0, 0.0)
		BSDFPrincipista_Tangent("Tangent", Vector) = (0.0, 0.0, 0.0)
		BSDFPrincipista_Weight("Weight", float) = 0.0
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
            struct Mapping_struct {
                float3 Vector;
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
			struct Mix_color_struct {
                float3 Result;
			// add members
            };
			struct Principled_BSDF_struct {
                float4 BSDF;
			// add members
            };
			// Add structs

            float3 BSDFPrincipista_BaseColor;
			float BSDFPrincipista_Subsurface;
			float3 BSDFPrincipista_SubsurfaceRadius;
			float3 BSDFPrincipista_SubsurfaceColor;
			float BSDFPrincipista_SubsurfaceIOR;
			float BSDFPrincipista_SubsurfaceAnisotropy;
			float BSDFPrincipista_Metallic;
			float BSDFPrincipista_Specular;
			float BSDFPrincipista_SpecularTint;
			float BSDFPrincipista_Roughness;
			float BSDFPrincipista_Anisotropic;
			float BSDFPrincipista_AnisotropicRotation;
			float BSDFPrincipista_Sheen;
			float BSDFPrincipista_SheenTint;
			float BSDFPrincipista_Clearcoat;
			float BSDFPrincipista_ClearcoatRoughness;
			float BSDFPrincipista_IOR;
			float BSDFPrincipista_Transmission;
			float BSDFPrincipista_TransmissionRoughness;
			float3 BSDFPrincipista_Emission;
			float BSDFPrincipista_EmissionStrength;
			float BSDFPrincipista_Alpha;
			float Mezclar_Factor_Float;
			float3 Mezclar_Factor_Vector;
			float Mezclar_A_Float;
			float Mezclar_B_Float;
			float3 Mezclar_A_Vector;
			float3 Mezclar_B_Vector;
			float3 Mapeo001_Location;
			float3 Mapeo001_Rotation;
			float3 Mapeo001_Scale;
			float VoronoiTexture_W;
			float VoronoiTexture_Scale;
			float VoronoiTexture_Smoothness;
			float VoronoiTexture_Exponent;
			float VoronoiTexture_Randomness;
			float3 Mezclar_B_Color;
			bool Mezclar_Clamp_Factor;
			bool Mezclar_Clamp_Result;
			float3 BSDFPrincipista_ClearcoatNormal;
			float3 BSDFPrincipista_Tangent;
			float BSDFPrincipista_Weight;
			// Add variables
    
            sampler2D _NormalTex;
            float3 _BoundingBoxMin;
            float3 _BoundingBoxMax;
      
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
            
            Mapping_struct mapping( float3 vectore,float3 location, float3 rotation, float3 scale) {
                		Mapping_struct map;
				// Añade la ubicación para la traslación
				vectore += location;
                rotation *= PI / 180.0;
				// Aplica la rotación (en radianes)
        			 float3 rotated_vector;
        			 rotated_vector.x = vectore.x * cos(rotation.y) * cos(rotation.z) - vectore.y * (sin(rotation.x) * sin(rotation.z) - cos(rotation.x) * cos(rotation.z) * sin(rotation.y)) + vectore.z * (cos(rotation.x) * sin(rotation.z) + cos(rotation.z) * sin(rotation.x) * sin(rotation.y));
        			 rotated_vector.y = vectore.x * sin(rotation.y) * cos(rotation.z) + vectore.y * (cos(rotation.x) * cos(rotation.z) + sin(rotation.x) * sin(rotation.y) * sin(rotation.z)) - vectore.z * (cos(rotation.y) * sin(rotation.x) - cos(rotation.x) * sin(rotation.y) * sin(rotation.z));
        			 rotated_vector.z = -vectore.x * sin(rotation.z) + vectore.y * cos(rotation.z) * sin(rotation.x) + vectore.z * cos(rotation.x) * cos(rotation.y);

        			// Aplica la escala
        			rotated_vector *= scale;

        			map.Vector = rotated_vector;
        
        			return map;
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
                randomness = clamp(randomness,0,1);
                VoronoiTexture_Smoothness=clamp(VoronoiTexture_Smoothness,0,1);                          
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
           
			float3 blending_mix(float3 color_1, float3 color_2, float fac){
                float facm = 1.0f - fac;
                float3 r_col = float3(0,0,0);
                r_col[0] = facm * color_1[0] + fac * color_2[0];
                r_col[1] = facm * color_1[1] + fac * color_2[1];
                r_col[2] = facm * color_1[2] + fac * color_2[2];
                return r_col;
            }
			Mix_color_struct mix_color(float mixFactorFloat, float3 mixFactorVector, float floatA, float floatB, float3 vectorA, float3 vectorB, float3 colorA, float3 colorB, bool clampFactor, bool clampResult) {
		        Mix_color_struct mixed;
                if (clampFactor){
                    mixFactorFloat = clamp(mixFactorFloat, 0.0, 1.0);
                }
                mixed.Result = blending_mix(colorA, colorB, mixFactorFloat);

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
                if(PrincipledBSDF_Normal.x <= 0.0 && PrincipledBSDF_Normal.y <= 0.0 && PrincipledBSDF_Normal.z <= 0.0){
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
			// Add methods
            float4 frag (v2f i) : SV_Target
            {

                float3 Mapeo001_Vector = (i.worldPos - _BoundingBoxMin) /( _BoundingBoxMax - _BoundingBoxMin);;
				Mapping_struct Mapeo_001 = mapping(Mapeo001_Vector, Mapeo001_Location, Mapeo001_Rotation, Mapeo001_Scale);
				float3 VoronoiTexture_Vector = Mapeo_001.Vector;
				Voronoi_Texture_struct Voronoi_Texture = voronoi_3D_F1_function(VoronoiTexture_Vector, VoronoiTexture_W, VoronoiTexture_Scale, VoronoiTexture_Smoothness, VoronoiTexture_Exponent, VoronoiTexture_Randomness, 0);
				float3 Mezclar_A_Color = Voronoi_Texture.Color;
				Mix_color_struct Mezclar = mix_color(Mezclar_Factor_Float, Mezclar_Factor_Vector, Mezclar_A_Float, Mezclar_B_Float, Mezclar_A_Vector, Mezclar_B_Vector, Mezclar_A_Color, Mezclar_B_Color, Mezclar_Clamp_Factor, Mezclar_Clamp_Result);
				float3 BSDFPrincipista_Normal = Mezclar.Result;
				Principled_BSDF_struct BSDF_Principista = principled_bsdf(i, BSDFPrincipista_BaseColor, BSDFPrincipista_Subsurface, BSDFPrincipista_SubsurfaceRadius, BSDFPrincipista_SubsurfaceColor, BSDFPrincipista_SubsurfaceIOR, BSDFPrincipista_SubsurfaceAnisotropy, BSDFPrincipista_Metallic, BSDFPrincipista_Specular, BSDFPrincipista_SpecularTint, BSDFPrincipista_Roughness, BSDFPrincipista_Anisotropic, BSDFPrincipista_AnisotropicRotation, BSDFPrincipista_Sheen, BSDFPrincipista_SheenTint, BSDFPrincipista_Clearcoat, BSDFPrincipista_ClearcoatRoughness, BSDFPrincipista_IOR, BSDFPrincipista_Transmission, BSDFPrincipista_TransmissionRoughness, BSDFPrincipista_Emission, BSDFPrincipista_EmissionStrength, BSDFPrincipista_Alpha, BSDFPrincipista_Normal, BSDFPrincipista_ClearcoatNormal, BSDFPrincipista_Tangent, BSDFPrincipista_Weight);
				float4 MaterialOutput_Surface = BSDF_Principista.BSDF;
				// Call methods
              
                // Add cutoff
                
                return MaterialOutput_Surface;
                
            }
            ENDHLSL
        }
        UsePass "Legacy Shaders/VertexLit/SHADOWCASTER"
    }
}
