Shader "Custom/ShaderMaterial001_"
{
     Properties
    {
        _NormalTex("Normal Map", 2D) = "bump" {}
        _BoundingBoxMin("minBoundBox", Vector) = (0,0,0)
        _BoundingBoxMax("maxBoundBox", Vector) = (0,0,0)

        CheckerTexture_Color1("Color1", Color) = (0.903545437039038,0.903545437039038,0.903545437039038, 1.0)
		CheckerTexture_Color2("Color2", Color) = (0.0,0.0,0.0, 1.0)
		CheckerTexture_Scale("Scale", float) = -2.0
		Mix001_Factor_Vector("Factor_Vector", Vector) = (0.5, 0.5, 0.5)
		Mix001_A_Float("A_Float", float) = 0.0
		Mix001_B_Float("B_Float", float) = 0.0
		Mix001_A_Vector("A_Vector", Vector) = (0.0, 0.0, 0.0)
		Mix001_B_Vector("B_Vector", Vector) = (0.0, 0.0, 0.0)
		VoronoiTexture_W("W", float) = 0.0
		VoronoiTexture_Scale("Scale", float) = 4.799997806549072
		VoronoiTexture_Smoothness("Smoothness", float) = 1.0
		VoronoiTexture_Exponent("Exponent", float) = 0.5
		VoronoiTexture_Randomness("Randomness", float) = 1.0
		Mix_Factor_Vector("Factor_Vector", Vector) = (0.5, 0.5, 0.5)
		Mix_A_Float("A_Float", float) = 0.0
		Mix_B_Float("B_Float", float) = 0.0
		Mix_A_Vector("A_Vector", Vector) = (0.0, 0.0, 0.0)
		Mix_B_Vector("B_Vector", Vector) = (0.0, 0.0, 0.0)
		ColorRamp001_Fac("Fac", float) = 0.5
		Color_Ramp_001_Color0("Color_Ramp_001_Color0", Color) = (0.8358557933693598,0.0,0.8072931555550341, 1.0)
		Color_Ramp_001_Pos0("Color_Ramp_001_Pos0", Float) = 0.0
		Color_Ramp_001_Color1("Color_Ramp_001_Color1", Color) = (0.0,0.49714522001474903,1.0, 1.0)
		Color_Ramp_001_Pos1("Color_Ramp_001_Pos1", Float) = 1.0
		ColorRamp_Fac("Fac", float) = 0.5
		Color_Ramp_Color0("Color_Ramp_Color0", Color) = (0.0,0.0,0.0, 1.0)
		Color_Ramp_Pos0("Color_Ramp_Pos0", Float) = 0.0
		Color_Ramp_Color1("Color_Ramp_Color1", Color) = (1.0,0.5881032470607931,0.0880431544325326, 1.0)
		Color_Ramp_Pos1("Color_Ramp_Pos1", Float) = 0.4509098529815674
		Mix_Clamp_Factor("Clamp_Factor", Int) = 1
		Mix_Clamp_Result("Clamp_Result", Int) = 0
		Mapping_Location("Location", Vector) = (0.0, 0.0, 0.0)
		Mapping_Rotation("Rotation", Vector) = (0.0, 0.6143558621406555, 0.2338740974664688)
		Mapping_Scale("Scale", Vector) = (1.0, 1.0, 1.0)
		CheckerTexture001_Color1("Color1", Color) = (0.903545437039038,0.903545437039038,0.903545437039038, 1.0)
		CheckerTexture001_Color2("Color2", Color) = (0.0,0.0,0.0, 1.0)
		CheckerTexture001_Scale("Scale", float) = 48.599998474121094
		Color_Ramp_002_Color0("Color_Ramp_002_Color0", Color) = (1.0,1.0,1.0, 1.0)
		Color_Ramp_002_Pos0("Color_Ramp_002_Pos0", Float) = 0.0
		Color_Ramp_002_Color1("Color_Ramp_002_Color1", Color) = (1.0,0.0,0.610068917564705, 1.0)
		Color_Ramp_002_Pos1("Color_Ramp_002_Pos1", Float) = 1.0
		Mix_001_Clamp_Factor("Clamp_Factor", Int) = 1
		Mix_001_Clamp_Result("Clamp_Result", Int) = 0
		PrincipledBSDF_Subsurface("Subsurface", float) = 0.0
		PrincipledBSDF_SubsurfaceRadius("SubsurfaceRadius", Vector) = (1.0, 0.20000000298023224, 0.10000000149011612)
		PrincipledBSDF_SubsurfaceColor("SubsurfaceColor", Color) = (0.903545437039038,0.903545437039038,0.903545437039038, 1.0)
		PrincipledBSDF_SubsurfaceIOR("SubsurfaceIOR", float) = 1.399999976158142
		PrincipledBSDF_SubsurfaceAnisotropy("SubsurfaceAnisotropy", float) = 0.0
		PrincipledBSDF_Metallic("Metallic", float) = 0.8999999761581421
		PrincipledBSDF_Specular("Specular", float) = 0.5
		PrincipledBSDF_SpecularTint("SpecularTint", float) = 0.0
		PrincipledBSDF_Roughness("Roughness", float) = 0.19818180799484253
		PrincipledBSDF_Anisotropic("Anisotropic", float) = 0.0
		PrincipledBSDF_AnisotropicRotation("AnisotropicRotation", float) = 0.0
		PrincipledBSDF_Sheen("Sheen", float) = 0.0
		PrincipledBSDF_SheenTint("SheenTint", float) = 0.5
		PrincipledBSDF_Clearcoat("Clearcoat", float) = 0.0
		PrincipledBSDF_ClearcoatRoughness("ClearcoatRoughness", float) = 0.029999999329447746
		PrincipledBSDF_IOR("IOR", float) = 1.4500000476837158
		PrincipledBSDF_Transmission("Transmission", float) = 0.0
		PrincipledBSDF_TransmissionRoughness("TransmissionRoughness", float) = 0.0
		PrincipledBSDF_Emission("Emission", Color) = (0.0,0.0,0.0, 1.0)
		PrincipledBSDF_EmissionStrength("EmissionStrength", float) = 1.0
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
            struct Checker_Texture_struct {
                float Fac;
			float3 Color;
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
			struct Color_Ramp_struct {
                float Alpha;
			float3 Color;
			// add members
            };
			struct Mix_color_struct {
                float3 Result;
			// add members
            };
			struct Mapping_struct {
                float3 Vector;
			// add members
            };
			struct Principled_BSDF_struct {
                float4 BSDF;
			// add members
            };
			// Add structs

            float3 CheckerTexture_Color1;
			float3 CheckerTexture_Color2;
			float CheckerTexture_Scale;
			float3 Mix001_Factor_Vector;
			float Mix001_A_Float;
			float Mix001_B_Float;
			float3 Mix001_A_Vector;
			float3 Mix001_B_Vector;
			float VoronoiTexture_W;
			float VoronoiTexture_Scale;
			float VoronoiTexture_Smoothness;
			float VoronoiTexture_Exponent;
			float VoronoiTexture_Randomness;
			float3 Mix_Factor_Vector;
			float Mix_A_Float;
			float Mix_B_Float;
			float3 Mix_A_Vector;
			float3 Mix_B_Vector;
			float ColorRamp001_Fac;
			float4 Color_Ramp_001_Color0;
			float Color_Ramp_001_Pos0;
			float4 Color_Ramp_001_Color1;
			float Color_Ramp_001_Pos1;
			float ColorRamp_Fac;
			float4 Color_Ramp_Color0;
			float Color_Ramp_Pos0;
			float4 Color_Ramp_Color1;
			float Color_Ramp_Pos1;
			bool Mix_Clamp_Factor;
			bool Mix_Clamp_Result;
			float3 Mapping_Location;
			float3 Mapping_Rotation;
			float3 Mapping_Scale;
			float3 CheckerTexture001_Color1;
			float3 CheckerTexture001_Color2;
			float CheckerTexture001_Scale;
			float4 Color_Ramp_002_Color0;
			float Color_Ramp_002_Pos0;
			float4 Color_Ramp_002_Color1;
			float Color_Ramp_002_Pos1;
			bool Mix_001_Clamp_Factor;
			bool Mix_001_Clamp_Result;
			float PrincipledBSDF_Subsurface;
			float3 PrincipledBSDF_SubsurfaceRadius;
			float3 PrincipledBSDF_SubsurfaceColor;
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
			float3 PrincipledBSDF_Emission;
			float PrincipledBSDF_EmissionStrength;
			float PrincipledBSDF_Alpha;
			float3 PrincipledBSDF_Normal;
			float3 PrincipledBSDF_ClearcoatNormal;
			float3 PrincipledBSDF_Tangent;
			float PrincipledBSDF_Weight;
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
            
            Checker_Texture_struct checker(float3  ip, float3 color1, float3 color2,float Scale)
{
    Checker_Texture_struct c;
    ip *= Scale;
    float3 p;
    p[0] = (ip[0] + 0.000001) * 0.999999;
    p[1] = (ip[1] + 0.000001) * 0.999999;
    p[2] = (ip[2] + 0.000001) * 0.999999;

    int xi = (int)abs(floor(p[0]));
    int yi = (int)abs(floor(p[1]));
    int zi = (int)abs(floor(p[2]));
    //SI SON PARES
    if ((xi % 2 == yi % 2) == (zi % 2)) {
        c.Color=color1;
    }
    else {
        c.Color=color2;
    }
    return c;
}

			float float3_to_float(float3 vec){
    return (vec.x + vec.y + vec.z) / 3.0;
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
           
			Color_Ramp_struct color_ramp( float at,int numcolors, int interpolate,float4 ramp[30],float pos[30] )
            {
              float f = at;
              int table_size = numcolors;
              f  = clamp(at, 0.0, 1.0) ;
              float4 result=ramp[0];
              Color_Ramp_struct colores;
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

                float3 CheckerTexture_Vector = (i.worldPos - _BoundingBoxMin) /( _BoundingBoxMax - _BoundingBoxMin);;
				Checker_Texture_struct Checker_Texture = checker(CheckerTexture_Vector, CheckerTexture_Color1, CheckerTexture_Color2, CheckerTexture_Scale);
				float Mix001_Factor_Float = float3_to_float(Checker_Texture.Color);
				float3 VoronoiTexture_Vector = (i.worldPos - _BoundingBoxMin) /( _BoundingBoxMax - _BoundingBoxMin);;
				Voronoi_Texture_struct Voronoi_Texture = voronoi_3D_F1_function(VoronoiTexture_Vector, VoronoiTexture_W, VoronoiTexture_Scale, VoronoiTexture_Smoothness, VoronoiTexture_Exponent, VoronoiTexture_Randomness, 0);
				float Mix_Factor_Float = Voronoi_Texture.Distance;
				float Color_Ramp_001_pos[30];
				float4 Color_Ramp_001_ramp[30];
				Color_Ramp_001_ramp[0]=Color_Ramp_001_Color0;
				Color_Ramp_001_pos[0]=Color_Ramp_001_Pos0;
				Color_Ramp_001_ramp[1]=Color_Ramp_001_Color1;
				Color_Ramp_001_pos[1]=Color_Ramp_001_Pos1;
				Color_Ramp_struct Color_Ramp_001 = color_ramp(ColorRamp001_Fac, 2, 1, Color_Ramp_001_ramp, Color_Ramp_001_pos);
				float3 Mix_A_Color = Color_Ramp_001.Color;
				float Color_Ramp_pos[30];
				float4 Color_Ramp_ramp[30];
				Color_Ramp_ramp[0]=Color_Ramp_Color0;
				Color_Ramp_pos[0]=Color_Ramp_Pos0;
				Color_Ramp_ramp[1]=Color_Ramp_Color1;
				Color_Ramp_pos[1]=Color_Ramp_Pos1;
				Color_Ramp_struct Color_Ramp = color_ramp(ColorRamp_Fac, 2, 0, Color_Ramp_ramp, Color_Ramp_pos);
				float3 Mix_B_Color = Color_Ramp.Color;
				Mix_color_struct Mix = mix_color(Mix_Factor_Float, Mix_Factor_Vector, Mix_A_Float, Mix_B_Float, Mix_A_Vector, Mix_B_Vector, Mix_A_Color, Mix_B_Color, Mix_Clamp_Factor, Mix_Clamp_Result);
				float3 Mix001_A_Color = Mix.Result;
				float3 Mapping_Vector = (i.worldPos - _BoundingBoxMin) /( _BoundingBoxMax - _BoundingBoxMin);;
				Mapping_struct Mapping = mapping(Mapping_Vector, Mapping_Location, Mapping_Rotation, Mapping_Scale);
				float3 CheckerTexture001_Vector = Mapping.Vector;
				Checker_Texture_struct Checker_Texture_001 = checker(CheckerTexture001_Vector, CheckerTexture001_Color1, CheckerTexture001_Color2, CheckerTexture001_Scale);
				float ColorRamp002_Fac = float3_to_float(Checker_Texture_001.Color);
				float Color_Ramp_002_pos[30];
				float4 Color_Ramp_002_ramp[30];
				Color_Ramp_002_ramp[0]=Color_Ramp_002_Color0;
				Color_Ramp_002_pos[0]=Color_Ramp_002_Pos0;
				Color_Ramp_002_ramp[1]=Color_Ramp_002_Color1;
				Color_Ramp_002_pos[1]=Color_Ramp_002_Pos1;
				Color_Ramp_struct Color_Ramp_002 = color_ramp(ColorRamp002_Fac, 2, 1, Color_Ramp_002_ramp, Color_Ramp_002_pos);
				float3 Mix001_B_Color = Color_Ramp_002.Color;
				Mix_color_struct Mix_001 = mix_color(Mix001_Factor_Float, Mix001_Factor_Vector, Mix001_A_Float, Mix001_B_Float, Mix001_A_Vector, Mix001_B_Vector, Mix001_A_Color, Mix001_B_Color, Mix_001_Clamp_Factor, Mix_001_Clamp_Result);
				float3 PrincipledBSDF_BaseColor = Mix_001.Result;
				Principled_BSDF_struct Principled_BSDF = principled_bsdf(i, PrincipledBSDF_BaseColor, PrincipledBSDF_Subsurface, PrincipledBSDF_SubsurfaceRadius, PrincipledBSDF_SubsurfaceColor, PrincipledBSDF_SubsurfaceIOR, PrincipledBSDF_SubsurfaceAnisotropy, PrincipledBSDF_Metallic, PrincipledBSDF_Specular, PrincipledBSDF_SpecularTint, PrincipledBSDF_Roughness, PrincipledBSDF_Anisotropic, PrincipledBSDF_AnisotropicRotation, PrincipledBSDF_Sheen, PrincipledBSDF_SheenTint, PrincipledBSDF_Clearcoat, PrincipledBSDF_ClearcoatRoughness, PrincipledBSDF_IOR, PrincipledBSDF_Transmission, PrincipledBSDF_TransmissionRoughness, PrincipledBSDF_Emission, PrincipledBSDF_EmissionStrength, PrincipledBSDF_Alpha, PrincipledBSDF_Normal, PrincipledBSDF_ClearcoatNormal, PrincipledBSDF_Tangent, PrincipledBSDF_Weight);
				float4 MaterialOutput_Surface = Principled_BSDF.BSDF;
				// Call methods
              
                // Add cutoff
                
                return MaterialOutput_Surface;
                
            }
            ENDHLSL
        }
        UsePass "Legacy Shaders/VertexLit/SHADOWCASTER"
    }
}
