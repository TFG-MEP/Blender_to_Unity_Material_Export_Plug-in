Shader "Custom/ShaderTestUVs_"
{
     Properties
    {
        _NormalTex("Normal Map", 2D) = "bump" {}
        Mapping_Location("Location", Vector) = (0.0, 0.0, 0.0)
		Mapping_Rotation("Rotation", Vector) = (0.0, 0.0, 0.0)
		Mapping_Scale("Scale", Vector) = (1.0, 1.0, 1.0)
		RGB_Color("Color", Color) = (0.7297400528407231,0.0,0.1367561683414588, 1.0)
		CheckerTexture_Color2("Color2", Color) = (0.0,0.0,0.0, 1.0)
		CheckerTexture_Scale("Scale", float) = 3.0
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
            struct Mapping_struct {
                float3 Vector;
			// add members
            };
			struct RGB_struct {
                float3 Color;
			// add members
            };
			struct Checker_Texture_struct {
                float Fac;
			float3 Color;
			// add members
            };
			// Add structs

            float3 Mapping_Location;
			float3 Mapping_Rotation;
			float3 Mapping_Scale;
			float4 RGB_Color;
			float3 CheckerTexture_Color2;
			float CheckerTexture_Scale;
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
			RGB_struct rgb(float3 input_color)
            {
                RGB_struct output_color;
                output_color.Color = input_color;
                return output_color;
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

						float4 float3_to_float4(float3 vec){
                return float4(vec,1);
            }
			// Add methods
            float4 frag (v2f i) : SV_Target
            {

                float3 Mapping_Vector = float3(i.uv,0);
				Mapping_struct Mapping = mapping(Mapping_Vector, Mapping_Location, Mapping_Rotation, Mapping_Scale);
				float3 CheckerTexture_Vector = Mapping.Vector;
				RGB_struct RGB = rgb(RGB_Color);
				float3 CheckerTexture_Color1 = RGB.Color;
				Checker_Texture_struct Checker_Texture = checker(CheckerTexture_Vector, CheckerTexture_Color1, CheckerTexture_Color2, CheckerTexture_Scale);
				float4 MaterialOutput_Surface = float3_to_float4(Checker_Texture.Color);
				// Call methods
              
                // Add cutoff
                
                return MaterialOutput_Surface;
                
            }
            ENDHLSL
        }
        UsePass "Legacy Shaders/VertexLit/SHADOWCASTER"
    }
}
