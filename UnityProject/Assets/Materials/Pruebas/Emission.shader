Shader "Custom/ShaderEmission_"
{
     Properties
    {
        _NormalTex("Normal Map", 2D) = "bump" {}
        PrincipledBSDF003_BaseColor("BaseColor", Color) = (1.0,1.0,1.0, 1.0)
		PrincipledBSDF003_Subsurface("Subsurface", float) = 0.0
		PrincipledBSDF003_SubsurfaceRadius("SubsurfaceRadius", Vector) = (1.0, 0.20000000298023224, 0.10000000149011612)
		PrincipledBSDF003_SubsurfaceColor("SubsurfaceColor", Color) = (0.903545437039038,0.903545437039038,0.903545437039038, 1.0)
		PrincipledBSDF003_SubsurfaceIOR("SubsurfaceIOR", float) = 1.399999976158142
		PrincipledBSDF003_SubsurfaceAnisotropy("SubsurfaceAnisotropy", float) = 0.0
		PrincipledBSDF003_Metallic("Metallic", float) = 0.0
		PrincipledBSDF003_Specular("Specular", float) = 0.5
		PrincipledBSDF003_SpecularTint("SpecularTint", float) = 0.0
		PrincipledBSDF003_Roughness("Roughness", float) = 0.5
		PrincipledBSDF003_Anisotropic("Anisotropic", float) = 0.0
		PrincipledBSDF003_AnisotropicRotation("AnisotropicRotation", float) = 0.0
		PrincipledBSDF003_Sheen("Sheen", float) = 0.0
		PrincipledBSDF003_SheenTint("SheenTint", float) = 0.5
		PrincipledBSDF003_Clearcoat("Clearcoat", float) = 0.0
		PrincipledBSDF003_ClearcoatRoughness("ClearcoatRoughness", float) = 0.029999999329447746
		PrincipledBSDF003_IOR("IOR", float) = 1.4500000476837158
		PrincipledBSDF003_Transmission("Transmission", float) = 0.0
		PrincipledBSDF003_TransmissionRoughness("TransmissionRoughness", float) = 0.0
		PrincipledBSDF003_Emission("Emission", Color) = (1.0,1.0,1.0, 1.0)
		PrincipledBSDF003_EmissionStrength("EmissionStrength", float) = 15.0
		PrincipledBSDF003_Alpha("Alpha", float) = 1.0
		PrincipledBSDF003_Normal("Normal", Vector) = (0.0, 0.0, 0.0)
		PrincipledBSDF003_ClearcoatNormal("ClearcoatNormal", Vector) = (0.0, 0.0, 0.0)
		PrincipledBSDF003_Tangent("Tangent", Vector) = (0.0, 0.0, 0.0)
		PrincipledBSDF003_Weight("Weight", float) = 0.0
		// Add properties
        _SrcFactor("SrcFactor", Float) = 5
        _DstFactor("DstFactor", Float) = 10
        _BlendOp("Blend Operation", Float) = 0
    }

    SubShader
    {

        Tags { "RenderType" = "Opaque" "RenderPipeline" = "UniversalRenderPipeline"}
        Tags{ "Queue" = "Transparent" }
		// Add tags

        LOD 100
        ZWrite Off
		Blend SrcAlpha OneMinusSrcAlpha
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
            };
            struct BSDF{
                float4 BSDF_output;
            };
			// Add structs

            float4 PrincipledBSDF003_BaseColor;
			float PrincipledBSDF003_Subsurface;
			float3 PrincipledBSDF003_SubsurfaceRadius;
			float4 PrincipledBSDF003_SubsurfaceColor;
			float PrincipledBSDF003_SubsurfaceIOR;
			float PrincipledBSDF003_SubsurfaceAnisotropy;
			float PrincipledBSDF003_Metallic;
			float PrincipledBSDF003_Specular;
			float PrincipledBSDF003_SpecularTint;
			float PrincipledBSDF003_Roughness;
			float PrincipledBSDF003_Anisotropic;
			float PrincipledBSDF003_AnisotropicRotation;
			float PrincipledBSDF003_Sheen;
			float PrincipledBSDF003_SheenTint;
			float PrincipledBSDF003_Clearcoat;
			float PrincipledBSDF003_ClearcoatRoughness;
			float PrincipledBSDF003_IOR;
			float PrincipledBSDF003_Transmission;
			float PrincipledBSDF003_TransmissionRoughness;
			float4 PrincipledBSDF003_Emission;
			float PrincipledBSDF003_EmissionStrength;
			float PrincipledBSDF003_Alpha;
			float3 PrincipledBSDF003_Normal;
			float3 PrincipledBSDF003_ClearcoatNormal;
			float3 PrincipledBSDF003_Tangent;
			float PrincipledBSDF003_Weight;
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
               

                BSDF output;
                output.BSDF_output= UniversalFragmentPBR(inputData, surfacedata);
                return output;

            }
			// Add methods
            float4 frag (v2f i) : SV_Target
            {

                BSDF Principled_BSDF_003 = principled_bsdf(i, PrincipledBSDF003_BaseColor, PrincipledBSDF003_Subsurface, PrincipledBSDF003_SubsurfaceRadius, PrincipledBSDF003_SubsurfaceColor, PrincipledBSDF003_SubsurfaceIOR, PrincipledBSDF003_SubsurfaceAnisotropy, PrincipledBSDF003_Metallic, PrincipledBSDF003_Specular, PrincipledBSDF003_SpecularTint, PrincipledBSDF003_Roughness, PrincipledBSDF003_Anisotropic, PrincipledBSDF003_AnisotropicRotation, PrincipledBSDF003_Sheen, PrincipledBSDF003_SheenTint, PrincipledBSDF003_Clearcoat, PrincipledBSDF003_ClearcoatRoughness, PrincipledBSDF003_IOR, PrincipledBSDF003_Transmission, PrincipledBSDF003_TransmissionRoughness, PrincipledBSDF003_Emission, PrincipledBSDF003_EmissionStrength, PrincipledBSDF003_Alpha, PrincipledBSDF003_Normal, PrincipledBSDF003_ClearcoatNormal, PrincipledBSDF003_Tangent, PrincipledBSDF003_Weight);
				float4 MaterialOutput_Surface = Principled_BSDF_003.BSDF_output;
				// Call methods
              
                // Add cutoff
                
                return MaterialOutput_Surface;
                
            }
            ENDHLSL
        }
        UsePass "Legacy Shaders/VertexLit/SHADOWCASTER"
    }
}
