Shader "Custom/Shadertaza_"
{
     Properties
    {
        _NormalTex("Normal Map", 2D) = "bump" {}
        _BoundingBoxMin("minBoundBox", Vector) = (0,0,0)
        _BoundingBoxMax("maxBoundBox", Vector) = (0,0,0)

        PrincipledBSDF_BaseColor("BaseColor", Color) = (0.28058353344873166,0.7650333567589396,0.6037410976730537, 1.0)
		PrincipledBSDF_Subsurface("Subsurface", float) = 0.0
		PrincipledBSDF_SubsurfaceRadius("SubsurfaceRadius", Vector) = (1.0, 0.20000000298023224, 0.10000000149011612)
		PrincipledBSDF_SubsurfaceColor("SubsurfaceColor", Color) = (0.903545437039038,0.903545437039038,0.903545437039038, 1.0)
		PrincipledBSDF_SubsurfaceIOR("SubsurfaceIOR", float) = 1.0099999904632568
		PrincipledBSDF_SubsurfaceAnisotropy("SubsurfaceAnisotropy", float) = 0.0
		PrincipledBSDF_Metallic("Metallic", float) = 0.0
		PrincipledBSDF_Specular("Specular", float) = 0.0
		PrincipledBSDF_SpecularTint("SpecularTint", float) = 0.0
		PrincipledBSDF_Roughness("Roughness", float) = 0.0
		PrincipledBSDF_Anisotropic("Anisotropic", float) = 0.0
		PrincipledBSDF_AnisotropicRotation("AnisotropicRotation", float) = 0.0
		PrincipledBSDF_Sheen("Sheen", float) = 0.6909091472625732
		PrincipledBSDF_SheenTint("SheenTint", float) = 0.5
		PrincipledBSDF_Clearcoat("Clearcoat", float) = 0.0
		PrincipledBSDF_ClearcoatRoughness("ClearcoatRoughness", float) = 0.029999999329447746
		PrincipledBSDF_IOR("IOR", float) = 1.0
		PrincipledBSDF_Transmission("Transmission", float) = 0.0
		PrincipledBSDF_TransmissionRoughness("TransmissionRoughness", float) = 0.0
		PrincipledBSDF_Emission("Emission", Color) = (1.0,1.0,1.0, 1.0)
		PrincipledBSDF_EmissionStrength("EmissionStrength", float) = 0.0
		PrincipledBSDF_Alpha("Alpha", float) = 1.0
		PrincipledBSDF_Normal("Normal", Vector) = (0.0, 0.0, 0.0)
		PrincipledBSDF_ClearcoatNormal("ClearcoatNormal", Vector) = (0.0, 0.0, 0.0)
		PrincipledBSDF_Tangent("Tangent", Vector) = (0.0, 0.0, 0.0)
		PrincipledBSDF_Weight("Weight", float) = 0.0
		Color_Ramp_Color0("Color_Ramp_Color0", Color) = (0.3300617463385116,0.32697017493025815,0.3236767030864317, 1.0)
		Color_Ramp_Pos0("Color_Ramp_Pos0", Float) = 0.0
		Color_Ramp_Color1("Color_Ramp_Color1", Color) = (0.4819817980016533,0.5465043737464518,0.5219573809625057, 1.0)
		Color_Ramp_Pos1("Color_Ramp_Pos1", Float) = 0.10909092426300049
		Color_Ramp_Color2("Color_Ramp_Color2", Color) = (0.7390949807676755,0.7050049428577994,0.6759979144081085, 1.0)
		Color_Ramp_Pos2("Color_Ramp_Pos2", Float) = 0.17954549193382263
		Color_Ramp_Color3("Color_Ramp_Color3", Color) = (1.0,0.8893634107856322,0.8216774727928182, 1.0)
		Color_Ramp_Pos3("Color_Ramp_Pos3", Float) = 0.3954545855522156
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
			struct Shader_to_RGB_struct {
                float Alpha;
			float3 Color;
			// add members
            };
			struct Color_Ramp_struct {
                float Alpha;
			float3 Color;
			// add members
            };
			// Add structs

            float3 PrincipledBSDF_BaseColor;
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
			float4 Color_Ramp_Color0;
			float Color_Ramp_Pos0;
			float4 Color_Ramp_Color1;
			float Color_Ramp_Pos1;
			float4 Color_Ramp_Color2;
			float Color_Ramp_Pos2;
			float4 Color_Ramp_Color3;
			float Color_Ramp_Pos3;
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
			Shader_to_RGB_struct shader_to_RGB(float4 shader){
    Shader_to_RGB_struct output;
    output.Color=shader.xyz;
    output.Alpha=shader.w;
    return output;
}
			float float3_to_float(float3 vec){
    return (vec.x + vec.y + vec.z) / 3.0;
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
                  if (f  >= pos[i] && f  < pos[i + 1]){
                      if (interpolate){
                          result=ramp[i];
                          float t = (f - (float)pos[i])/(pos[i+1]-pos[i]);
                          result = (1.0 - t) * result + t * ramp[i + 1];
                      } 
                      else{
                          result= ramp[i+1];
                      }
                    
                  }
              }
              colores.Color=result.xyz;
              colores.Alpha=result.w;
              return colores;
            }
						float4 float3_to_float4(float3 vec){
                return float4(vec,1);
            }
			// Add methods
            float4 frag (v2f i) : SV_Target
            {

                Principled_BSDF_struct Principled_BSDF = principled_bsdf(i, PrincipledBSDF_BaseColor, PrincipledBSDF_Subsurface, PrincipledBSDF_SubsurfaceRadius, PrincipledBSDF_SubsurfaceColor, PrincipledBSDF_SubsurfaceIOR, PrincipledBSDF_SubsurfaceAnisotropy, PrincipledBSDF_Metallic, PrincipledBSDF_Specular, PrincipledBSDF_SpecularTint, PrincipledBSDF_Roughness, PrincipledBSDF_Anisotropic, PrincipledBSDF_AnisotropicRotation, PrincipledBSDF_Sheen, PrincipledBSDF_SheenTint, PrincipledBSDF_Clearcoat, PrincipledBSDF_ClearcoatRoughness, PrincipledBSDF_IOR, PrincipledBSDF_Transmission, PrincipledBSDF_TransmissionRoughness, PrincipledBSDF_Emission, PrincipledBSDF_EmissionStrength, PrincipledBSDF_Alpha, PrincipledBSDF_Normal, PrincipledBSDF_ClearcoatNormal, PrincipledBSDF_Tangent, PrincipledBSDF_Weight);
				float4 ShadertoRGB_Shader = Principled_BSDF.BSDF;
				Shader_to_RGB_struct Shader_to_RGB = shader_to_RGB(ShadertoRGB_Shader);
				float ColorRamp_Fac = float3_to_float(Shader_to_RGB.Color);
				float Color_Ramp_pos[30];
				float4 Color_Ramp_ramp[30];
				Color_Ramp_ramp[0]=Color_Ramp_Color0;
				Color_Ramp_pos[0]=Color_Ramp_Pos0;
				Color_Ramp_ramp[1]=Color_Ramp_Color1;
				Color_Ramp_pos[1]=Color_Ramp_Pos1;
				Color_Ramp_ramp[2]=Color_Ramp_Color2;
				Color_Ramp_pos[2]=Color_Ramp_Pos2;
				Color_Ramp_ramp[3]=Color_Ramp_Color3;
				Color_Ramp_pos[3]=Color_Ramp_Pos3;
				Color_Ramp_struct Color_Ramp = color_ramp(ColorRamp_Fac, 4, 0, Color_Ramp_ramp, Color_Ramp_pos);
				float4 MaterialOutput_Surface = float3_to_float4(Color_Ramp.Color);
				// Call methods
              
                // Add cutoff
                
                return MaterialOutput_Surface;
                
            }
            ENDHLSL
        }
        UsePass "Legacy Shaders/VertexLit/SHADOWCASTER"
    }
}
