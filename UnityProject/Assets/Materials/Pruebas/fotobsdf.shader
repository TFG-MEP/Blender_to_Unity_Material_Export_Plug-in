Shader "Custom/Shaderfotobsdf_"
{
     Properties
    {
        _NormalTex("Normal Map", 2D) = "bump" {}
        Mapping002_Location("Location", Vector) = (0.0, 0.0, 0.0)
		Mapping002_Rotation("Rotation", Vector) = (0.0, 0.0, 0.0)
		Mapping002_Scale("Scale", Vector) = (1.0, 1.0, 1.0)
		ImageTexture003_Image("Texture", 2D) = "white" {}
		PrincipledBSDF001_Subsurface("Subsurface", float) = 0.0
		PrincipledBSDF001_SubsurfaceRadius("SubsurfaceRadius", Vector) = (1.0, 0.20000000298023224, 0.10000000149011612)
		PrincipledBSDF001_SubsurfaceColor("SubsurfaceColor", Color) = (0.1772529709968061,0.24307256888881068,0.9035454676387557, 1.0)
		PrincipledBSDF001_SubsurfaceIOR("SubsurfaceIOR", float) = 1.8159637451171875
		PrincipledBSDF001_SubsurfaceAnisotropy("SubsurfaceAnisotropy", float) = 0.0
		PrincipledBSDF001_Metallic("Metallic", float) = 0.3527272641658783
		PrincipledBSDF001_Specular("Specular", float) = 1.0
		PrincipledBSDF001_SpecularTint("SpecularTint", float) = 0.0
		PrincipledBSDF001_Roughness("Roughness", float) = 0.14727279543876648
		PrincipledBSDF001_Anisotropic("Anisotropic", float) = 0.0
		PrincipledBSDF001_AnisotropicRotation("AnisotropicRotation", float) = 0.0
		PrincipledBSDF001_Sheen("Sheen", float) = 0.0
		PrincipledBSDF001_SheenTint("SheenTint", float) = 0.3509090840816498
		PrincipledBSDF001_Clearcoat("Clearcoat", float) = 0.0
		PrincipledBSDF001_ClearcoatRoughness("ClearcoatRoughness", float) = 0.029999999329447746
		PrincipledBSDF001_IOR("IOR", float) = 1.4500000476837158
		PrincipledBSDF001_Transmission("Transmission", float) = 0.0
		PrincipledBSDF001_TransmissionRoughness("TransmissionRoughness", float) = 0.0
		PrincipledBSDF001_Emission("Emission", Color) = (0.0,0.0,0.0, 1.0)
		PrincipledBSDF001_EmissionStrength("EmissionStrength", float) = 0.2999984920024872
		PrincipledBSDF001_Alpha("Alpha", float) = 1.0
		PrincipledBSDF001_Normal("Normal", Vector) = (0.0, 0.0, 0.0)
		PrincipledBSDF001_ClearcoatNormal("ClearcoatNormal", Vector) = (0.0, 0.0, 0.0)
		PrincipledBSDF001_Tangent("Tangent", Vector) = (0.0, 0.0, 0.0)
		PrincipledBSDF001_Weight("Weight", float) = 0.0
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
        //Blend [_SrcFactor] [_DstFactor]
        //BlendOp [_BlendOp]
        Pass
        {
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile _ _MAIN_LIGHT_SHADOWS
            #pragma multi_compile _ _MAIN_LIGHT_SHADOWS_CASCADE
            #pragma multi_compile _ _SHADOWS_SOFT
            #pragma shader_feature _ALPHATEST_ON
            #include"Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
          
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			//Add includes 
            #include "utils.hlsl"
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
            };
            struct Mapping{
                float3 Vector;
		float3 Location;
		float3 Rotation;
		float3 Scale;
            };
			struct Image_texture{
    float3 Color;
    float Alpha;
};

			// Add structs

            float3 Mapping002_Location;
			float3 Mapping002_Rotation;
			float3 Mapping002_Scale;
			sampler2D ImageTexture003_Image;
			float PrincipledBSDF001_Subsurface;
			float3 PrincipledBSDF001_SubsurfaceRadius;
			float4 PrincipledBSDF001_SubsurfaceColor;
			float PrincipledBSDF001_SubsurfaceIOR;
			float PrincipledBSDF001_SubsurfaceAnisotropy;
			float PrincipledBSDF001_Metallic;
			float PrincipledBSDF001_Specular;
			float PrincipledBSDF001_SpecularTint;
			float PrincipledBSDF001_Roughness;
			float PrincipledBSDF001_Anisotropic;
			float PrincipledBSDF001_AnisotropicRotation;
			float PrincipledBSDF001_Sheen;
			float PrincipledBSDF001_SheenTint;
			float PrincipledBSDF001_Clearcoat;
			float PrincipledBSDF001_ClearcoatRoughness;
			float PrincipledBSDF001_IOR;
			float PrincipledBSDF001_Transmission;
			float PrincipledBSDF001_TransmissionRoughness;
			float4 PrincipledBSDF001_Emission;
			float PrincipledBSDF001_EmissionStrength;
			float PrincipledBSDF001_Alpha;
			float3 PrincipledBSDF001_Normal;
			float3 PrincipledBSDF001_ClearcoatNormal;
			float3 PrincipledBSDF001_Tangent;
			float PrincipledBSDF001_Weight;
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
            
            Mapping mapping( float3 vectore,float3 location, float3 rotation, float3 scale) {
                		Mapping map;
				// Añade la ubicación para la traslación
				vectore += location;

				// Aplica la rotación (en radianes)
        			float3 rotated_vector;
        			rotated_vector.x = vectore.x * cos(rotation.y) * cos(rotation.z) - vectore.y * (sin(rotation.x) * sin(rotation.z) - cos(rotation.x) * cos(rotation.z) * sin(rotation.y)) + vectore.z * (cos(rotation.x) * sin(rotation.z) + cos(rotation.z) * sin(rotation.x) * sin(rotation.y));
        			rotated_vector.y = vectore.x * sin(rotation.y) * cos(rotation.z) + vectore.y * (cos(rotation.x) * cos(rotation.z) + sin(rotation.x) * sin(rotation.y) * sin(rotation.z)) - vectore.z * (cos(rotation.y) * sin(rotation.x) - cos(rotation.x) * sin(rotation.y) * sin(rotation.z));
        			rotated_vector.z = -vectore.x * sin(rotation.z) + vectore.y * cos(rotation.z) * sin(rotation.x) + vectore.z * cos(rotation.x) * cos(rotation.y);

        			// Aplica la escala
        			rotated_vector *= scale;

        			map.Vector = rotated_vector;
        			map.Location = location;
        			map.Rotation = rotation;
        			map.Scale = scale;
        
        			return map;
      			}
			// función que crea una textura a partir de un sampler2D
			Image_texture image_texture( float3 texcoord,sampler2D textura){
				Image_texture tex;
				float4 colorImage=tex2D(textura, texcoord.xy);
				tex.Color=colorImage.xyz;
				tex.Alpha=colorImage.w;
				return tex;
			}

			float4 principled_bsdf(v2f i, float4 PrincipledBSDF_BaseColor,float PrincipledBSDF_Subsurface, float3 PrincipledBSDF_SubsurfaceRadius, float4 PrincipledBSDF_SubsurfaceColor,float PrincipledBSDF_SubsurfaceIOR,float PrincipledBSDF_SubsurfaceAnisotropy,
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
                surfacedata.alpha = clamp(PrincipledBSDF_Alpha,0,1);
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
               
                return UniversalFragmentPBR(inputData, surfacedata);

            }
			// Add methods
            float4 frag (v2f i) : SV_Target
            {

                float3 Mapping002_Vector = float3(i.uv,0);
				Mapping Mapping002 = mapping(Mapping002_Vector, Mapping002_Location, Mapping002_Rotation, Mapping002_Scale);
				float3 ImageTexture003_Vector = Mapping002.Vector;
				Image_texture ImageTexture003 = image_texture(ImageTexture003_Vector, ImageTexture003_Image);
				float4 PrincipledBSDF001_BaseColor = float3_to_float4(ImageTexture003.Color);
				float4 MaterialOutput_Surface = principled_bsdf(i, PrincipledBSDF001_BaseColor, PrincipledBSDF001_Subsurface, PrincipledBSDF001_SubsurfaceRadius, PrincipledBSDF001_SubsurfaceColor, PrincipledBSDF001_SubsurfaceIOR, PrincipledBSDF001_SubsurfaceAnisotropy, PrincipledBSDF001_Metallic, PrincipledBSDF001_Specular, PrincipledBSDF001_SpecularTint, PrincipledBSDF001_Roughness, PrincipledBSDF001_Anisotropic, PrincipledBSDF001_AnisotropicRotation, PrincipledBSDF001_Sheen, PrincipledBSDF001_SheenTint, PrincipledBSDF001_Clearcoat, PrincipledBSDF001_ClearcoatRoughness, PrincipledBSDF001_IOR, PrincipledBSDF001_Transmission, PrincipledBSDF001_TransmissionRoughness, PrincipledBSDF001_Emission, PrincipledBSDF001_EmissionStrength, PrincipledBSDF001_Alpha, PrincipledBSDF001_Normal, PrincipledBSDF001_ClearcoatNormal, PrincipledBSDF001_Tangent, PrincipledBSDF001_Weight);
				// Call methods
              
                
                return MaterialOutput_Surface;
                
            }
            ENDHLSL
        }
        UsePass "Legacy Shaders/VertexLit/SHADOWCASTER"
    }
}
