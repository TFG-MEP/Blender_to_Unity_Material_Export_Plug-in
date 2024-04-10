Shader "Custom/ShaderMixPhoto_"
{
     Properties
    {
        _NormalTex("Normal Map", 2D) = "bump" {}
        Mix_Factor_Float("Factor_Float", float) = 0.3199999928474426
		Mix_Factor_Vector("Factor_Vector", Vector) = (0.5, 0.5, 0.5)
		Mix_A_Float("A_Float", float) = 0.0
		Mix_B_Float("B_Float", float) = 0.0
		Mix_A_Vector("A_Vector", Vector) = (0.0, 0.0, 0.0)
		Mix_B_Vector("B_Vector", Vector) = (0.0, 0.0, 0.0)
		Mapping_Location("Location", Vector) = (0.0, 0.0, 0.0)
		Mapping_Rotation("Rotation", Vector) = (0.0, 0.0, 0.0)
		Mapping_Scale("Scale", Vector) = (1.0, 1.0, 1.0)
		Image_Texture_Image("Texture", 2D) = "white" {}
		Mapping001_Location("Location", Vector) = (0.0, 0.0, 0.0)
		Mapping001_Rotation("Rotation", Vector) = (0.0, 0.0, 0.0)
		Mapping001_Scale("Scale", Vector) = (1.0, 1.0, 1.0)
		Image_Texture_001_Image("Texture", 2D) = "white" {}
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
        // Add culling
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
            struct Mapping_struct {
                float3 Vector;
			// add members
            };
			struct Image_Texture_struct {
                float Alpha;
			float3 Color;
			// add members
            };
			struct Mix_color{
                float3 Result;
            };
			// Add structs

            float Mix_Factor_Float;
			float3 Mix_Factor_Vector;
			float Mix_A_Float;
			float Mix_B_Float;
			float3 Mix_A_Vector;
			float3 Mix_B_Vector;
			float3 Mapping_Location;
			float3 Mapping_Rotation;
			float3 Mapping_Scale;
			sampler2D Image_Texture_Image;
			float3 Mapping001_Location;
			float3 Mapping001_Rotation;
			float3 Mapping001_Scale;
			sampler2D Image_Texture_001_Image;
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
            
            Mapping_struct mapping( float3 vectore,float3 location, float3 rotation, float3 scale) {
                		Mapping_struct map;
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
        
        			return map;
      			}
			// función que crea una textura a partir de un sampler2D
			Image_Texture_struct image_texture( float3 texcoord,sampler2D textura){
				Image_Texture_struct tex;
				float4 colorImage=tex2D(textura, texcoord.xy);
				tex.Color=colorImage.xyz;
				tex.Alpha=colorImage.w;
				return tex;
			}

			float3 blending_function(float3 color_1, float3 color_2, float fac){
                float facm = 1.0f - fac;
                float3 r_col = float3(0,0,0);
                r_col[0] = facm * color_1[0] + fac * color_2[0];
                r_col[1] = facm * color_1[1] + fac * color_2[1];
                r_col[2] = facm * color_1[2] + fac * color_2[2];
                return r_col;// Add blending function
            }

            Mix_color mix_color(float mixFactorFloat, float3 mixFactorVector, float floatA, float floatB, float3 vectorA, float3 vectorB, float3 colorA, float3 colorB, bool clampFactor, bool clampResult) {
		        Mix_color mixed;
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

                float3 Mapping_Vector = float3(i.uv,0);
				Mapping_struct Mapping = mapping(Mapping_Vector, Mapping_Location, Mapping_Rotation, Mapping_Scale);
				float3 ImageTexture_Vector = Mapping.Vector;
				Image_Texture_struct Image_Texture = image_texture(ImageTexture_Vector, Image_Texture_Image);
				float3 Mix_A_Color = Image_Texture.Color;
				float3 Mapping001_Vector = float3(i.uv,0);
				Mapping_struct Mapping_001 = mapping(Mapping001_Vector, Mapping001_Location, Mapping001_Rotation, Mapping001_Scale);
				float3 ImageTexture001_Vector = Mapping_001.Vector;
				Image_Texture_struct Image_Texture_001 = image_texture(ImageTexture001_Vector, Image_Texture_001_Image);
				float3 Mix_B_Color = Image_Texture_001.Color;
				Mix_color Mix_color = mix_color(Mix_Factor_Float, Mix_Factor_Vector, Mix_A_Float, Mix_B_Float, Mix_A_Vector, Mix_B_Vector, Mix_A_Color, Mix_B_Color, Mix_Clamp_Factor, Mix_Clamp_Result);
				float4 MaterialOutput_Surface = float3_to_float4(Mix_color.Result);
				// Call methods
              
                // Add cutoff
                
                return MaterialOutput_Surface;
                
            }
            ENDHLSL
        }
        UsePass "Legacy Shaders/VertexLit/SHADOWCASTER"
    }
}
