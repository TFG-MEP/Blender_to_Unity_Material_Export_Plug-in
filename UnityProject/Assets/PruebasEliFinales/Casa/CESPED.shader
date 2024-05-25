Shader "Custom/ShaderCESPED_"
{
     Properties
    {
        _NormalTex("Normal Map", 2D) = "bump" {}
        _BoundingBoxMin("minBoundBox", Vector) = (0,0,0)
        _BoundingBoxMax("maxBoundBox", Vector) = (0,0,0)

        BSDFPrincipista_BaseColor("BaseColor", Color) = (0.44995472033945194,0.6941939216056251,0.33314101681040365, 1.0)
		BSDFPrincipista_Subsurface("Subsurface", float) = 0.0
		BSDFPrincipista_SubsurfaceRadius("SubsurfaceRadius", Vector) = (1.0, 0.20000000298023224, 0.10000000149011612)
		BSDFPrincipista_SubsurfaceColor("SubsurfaceColor", Color) = (0.903545437039038,0.903545437039038,0.903545437039038, 1.0)
		BSDFPrincipista_SubsurfaceIOR("SubsurfaceIOR", float) = 1.399999976158142
		BSDFPrincipista_SubsurfaceAnisotropy("SubsurfaceAnisotropy", float) = 0.0
		BSDFPrincipista_Metallic("Metallic", float) = 0.0
		BSDFPrincipista_Specular("Specular", float) = 0.3781512677669525
		BSDFPrincipista_SpecularTint("SpecularTint", float) = 0.0
		BSDFPrincipista_Roughness("Roughness", float) = 0.5882353186607361
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
		BSDFPrincipista_Normal("Normal", Vector) = (0.0, 0.0, 0.0)
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
			float3 BSDFPrincipista_Normal;
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
