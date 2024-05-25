Shader "Custom/ShaderMix2_"
{
     Properties
    {
        _NormalTex("Normal Map", 2D) = "bump" {}
        Mix001_Factor_Float("Factor_Float", float) = 0.5
		Mix001_Factor_Vector("Factor_Vector", Vector) = (0.5, 0.5, 0.5)
		Mix001_A_Float("A_Float", float) = 0.0
		Mix001_B_Float("B_Float", float) = 1.0
		Mix001_A_Vector("A_Vector", Vector) = (0.0, 0.0, 0.0)
		Mix001_B_Vector("B_Vector", Vector) = (0.0, 0.0, 0.0)
		Mix001_A_Color("A_Color", Color) = (0.7297400528407231,0.7297400528407231,0.7297400528407231, 1.0)
		Mix001_B_Color("B_Color", Color) = (0.7297400528407231,0.7297400528407231,0.7297400528407231, 1.0)
		Mix_001_Clamp_Factor("Clamp_Factor", Int) = 1
		Mix_Factor_Vector("Factor_Vector", Vector) = (0.5, 0.5, 0.5)
		Mix_A_Float("A_Float", float) = 0.0
		Mix_B_Float("B_Float", float) = 0.0
		Mix_A_Vector("A_Vector", Vector) = (0.0, 0.0, 0.0)
		Mix_B_Vector("B_Vector", Vector) = (0.0, 0.0, 0.0)
		Mix_A_Color("A_Color", Color) = (0.14978151076285132,0.14228123254843117,0.7297400528407231, 1.0)
		Mix_B_Color("B_Color", Color) = (0.0,0.7297400528407231,0.03918037516656759, 1.0)
		Mix_Clamp_Factor("Clamp_Factor", Int) = 1
		Mix_Clamp_Result("Clamp_Result", Int) = 0
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
            struct Mix_value_struct {
                float Result;
			// add members
            };
			struct Mix_color_struct {
                float3 Result;
			// add members
            };
			// Add structs

            float Mix001_Factor_Float;
			float3 Mix001_Factor_Vector;
			float Mix001_A_Float;
			float Mix001_B_Float;
			float3 Mix001_A_Vector;
			float3 Mix001_B_Vector;
			float3 Mix001_A_Color;
			float3 Mix001_B_Color;
			bool Mix_001_Clamp_Factor;
			float3 Mix_Factor_Vector;
			float Mix_A_Float;
			float Mix_B_Float;
			float3 Mix_A_Vector;
			float3 Mix_B_Vector;
			float3 Mix_A_Color;
			float3 Mix_B_Color;
			bool Mix_Clamp_Factor;
			bool Mix_Clamp_Result;
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
			float3 blending_function(float3 color_1, float3 color_2, float fac){
                float facm = 1.0f - fac;
                float3 r_col = float3(0,0,0);
                r_col[0] = facm * color_1[0] + fac * color_2[0];
                r_col[1] = facm * color_1[1] + fac * color_2[1];
                r_col[2] = facm * color_1[2] + fac * color_2[2];
                return r_col;// Add blending function
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
						float4 float3_to_float4(float3 vec){
                return float4(vec,1);
            }
			// Add methods
            float4 frag (v2f i) : SV_Target
            {

                Mix_value_struct Mix_001 = mix_float(Mix001_Factor_Float, Mix001_Factor_Vector, Mix001_A_Float, Mix001_B_Float, Mix001_A_Vector, Mix001_B_Vector, Mix001_A_Color, Mix001_B_Color, Mix_001_Clamp_Factor);
				float Mix_Factor_Float = Mix_001.Result;
				Mix_color_struct Mix = mix_color(Mix_Factor_Float, Mix_Factor_Vector, Mix_A_Float, Mix_B_Float, Mix_A_Vector, Mix_B_Vector, Mix_A_Color, Mix_B_Color, Mix_Clamp_Factor, Mix_Clamp_Result);
				float4 MaterialOutput_Surface = float3_to_float4(Mix.Result);
				// Call methods
              
                // Add cutoff
                
                return MaterialOutput_Surface;
                
            }
            ENDHLSL
        }
        UsePass "Legacy Shaders/VertexLit/SHADOWCASTER"
    }
}
