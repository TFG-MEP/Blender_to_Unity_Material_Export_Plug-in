Shader "Custom/ShaderBOTONES038_"
{
     Properties
    {
        _NormalTex("Normal Map", 2D) = "bump" {}
        ImageTexture_Image("Texture", 2D) = "white" {}
		ColorRamp001_Color0("ColorRamp001_Color0", Color) = (0.0,0.0,0.0, 1.0)
		ColorRamp001_Pos0("ColorRamp001_Pos0", Float) = 0.0
		ColorRamp001_Color1("ColorRamp001_Color1", Color) = (0.47606508754072585,0.2784987647093726,0.8589480733182241, 1.0)
		ColorRamp001_Pos1("ColorRamp001_Pos1", Float) = 0.40454554557800293
		ColorRamp001_Color2("ColorRamp001_Color2", Color) = (0.19997104024963674,0.6797701125117255,0.8031450625529216, 1.0)
		ColorRamp001_Pos2("ColorRamp001_Pos2", Float) = 0.5840908885002136
		ColorRamp001_Color3("ColorRamp001_Color3", Color) = (0.6666758144352377,0.8944286953321116,0.31289055631932633, 1.0)
		ColorRamp001_Pos3("ColorRamp001_Pos3", Float) = 0.7931815981864929
		ColorRamp001_Color4("ColorRamp001_Color4", Color) = (1.0,1.0,1.0, 1.0)
		ColorRamp001_Pos4("ColorRamp001_Pos4", Float) = 1.0
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
            struct Image_texture{
    float3 Color;
    float Alpha;
};

			struct Color_Ramp{
                float3 Color;
                float Alpha;
            };
			// Add structs

            sampler2D ImageTexture_Image;
			float4 ColorRamp001_Color0;
			float ColorRamp001_Pos0;
			float4 ColorRamp001_Color1;
			float ColorRamp001_Pos1;
			float4 ColorRamp001_Color2;
			float ColorRamp001_Pos2;
			float4 ColorRamp001_Color3;
			float ColorRamp001_Pos3;
			float4 ColorRamp001_Color4;
			float ColorRamp001_Pos4;
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

			float float3_to_float(float3 vec){
    return (vec.x + vec.y + vec.z) / 3.0;
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
						float4 float3_to_float4(float3 vec){
                return float4(vec,1);
            }
			// Add methods
            float4 frag (v2f i) : SV_Target
            {

                float3 ImageTexture_Vector = float3(i.uv,0);
				Image_texture ImageTexture = image_texture(ImageTexture_Vector, ImageTexture_Image);
				float ColorRamp001_Fac = float3_to_float(ImageTexture.Color);
				float ColorRamp001_pos[30];
				float4 ColorRamp001_ramp[30];
				ColorRamp001_ramp[0]=ColorRamp001_Color0;
				ColorRamp001_pos[0]=ColorRamp001_Pos0;
				ColorRamp001_ramp[1]=ColorRamp001_Color1;
				ColorRamp001_pos[1]=ColorRamp001_Pos1;
				ColorRamp001_ramp[2]=ColorRamp001_Color2;
				ColorRamp001_pos[2]=ColorRamp001_Pos2;
				ColorRamp001_ramp[3]=ColorRamp001_Color3;
				ColorRamp001_pos[3]=ColorRamp001_Pos3;
				ColorRamp001_ramp[4]=ColorRamp001_Color4;
				ColorRamp001_pos[4]=ColorRamp001_Pos4;
				Color_Ramp ColorRamp001 = color_ramp(ColorRamp001_Fac, 5, 1, ColorRamp001_ramp, ColorRamp001_pos);
				float4 MaterialOutput_Surface = float3_to_float4(ColorRamp001.Color);
				// Call methods
              
                // Add cutoff
                
                return MaterialOutput_Surface;
                
            }
            ENDHLSL
        }
        UsePass "Legacy Shaders/VertexLit/SHADOWCASTER"
    }
}
