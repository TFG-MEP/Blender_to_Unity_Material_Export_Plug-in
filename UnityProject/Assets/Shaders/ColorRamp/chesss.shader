Shader "Custom/Shaderchesss_"
{
     Properties
    {
        _NormalTex("Normal Map", 2D) = "bump" {}
        ImageTexture_Image("Texture", 2D) = "white" {}
		ColorRamp_Color0("ColorRamp_Color0", Color) = (0.1799368623758776,0.06450653869054812,0.11991385051900703, 1.0)
		ColorRamp_Pos0("ColorRamp_Pos0", Float) = 0.0
		ColorRamp_Color1("ColorRamp_Color1", Color) = (0.3728577188262493,0.09726524515799365,0.22852447700537956, 1.0)
		ColorRamp_Pos1("ColorRamp_Pos1", Float) = 0.16363650560379028
		ColorRamp_Color2("ColorRamp_Color2", Color) = (0.6474567704192329,0.1470427699182262,0.032829007155875486, 1.0)
		ColorRamp_Pos2("ColorRamp_Pos2", Float) = 0.39090922474861145
		ColorRamp_Color3("ColorRamp_Color3", Color) = (1.0,0.9225611705129818,0.9292445946807536, 1.0)
		ColorRamp_Pos3("ColorRamp_Pos3", Float) = 0.8454543948173523
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
        Blend [_SrcFactor] [_DstFactor]
        BlendOp [_BlendOp]
        Pass
        {
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag
          
            #include"Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			//Add includes 
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

            sampler2D ImageTexture_Image;
			float4 ColorRamp_Color0;
			float ColorRamp_Pos0;
			float4 ColorRamp_Color1;
			float ColorRamp_Pos1;
			float4 ColorRamp_Color2;
			float ColorRamp_Pos2;
			float4 ColorRamp_Color3;
			float ColorRamp_Pos3;
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
            //add structs

            
            // función que crea una textura a partir de un sampler2D
float4 image_texture( float2 texcoord,sampler2D textura){
	float4 colorImage=tex2D(textura, texcoord);
	return colorImage;
}

			float4 color_ramp( float at,int numcolors, int interpolate,float4 ramp[30],float pos[30] )
{
              float f = at;
              int table_size = numcolors;
            
              f  = clamp(at, 0.0, 1.0) ;
              float4 result=ramp[0];
              if(numcolors>1&&f>=pos[numcolors-1]){
                  return ramp[numcolors-1];
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
                
              return result;
}
float4 color_ramp(float4 at,int numcolors, int interpolate,float4 ramp[30],float pos[30] )
{

            
             float gray = (at.r + at.g + at.b) / 3.0;

            // Normalize grayscale value to the range [0, 1]
            gray = gray > 1.0 ? 1.0 : (gray < 0.0 ? 0.0 : gray);
            float f = gray;
             
              float4 result=ramp[0];
              if(numcolors>1&&f>=pos[numcolors-1]){
                  return ramp[numcolors-1];
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
                
              return result;
}   
			// Add methods
            float4 frag (v2f i) : SV_Target
            {

                float3 ImageTexture_Vector = float3(i.uv,0);
				Image_Texture imageTexture = image_texture(ImageTexture_Vector, ImageTexture_Image);
				float ColorRamp_pos[30];
				float4 ColorRamp_ramp[30];
				ColorRamp_ramp[0]=ColorRamp_Color0;
				ColorRamp_pos[0]=ColorRamp_Pos0;
				ColorRamp_ramp[1]=ColorRamp_Color1;
				ColorRamp_pos[1]=ColorRamp_Pos1;
				ColorRamp_ramp[2]=ColorRamp_Color2;
				ColorRamp_pos[2]=ColorRamp_Pos2;
				ColorRamp_ramp[3]=ColorRamp_Color3;
				ColorRamp_pos[3]=ColorRamp_Pos3;


                
                ColorRamp_Fac=Image_Texture.alpha;
				float4 MaterialOutput_Surface = color_ramp(ColorRamp_Fac, 4, 0, ColorRamp_ramp, ColorRamp_pos);
				// Call methods
              
                
                return MaterialOutput_Surface;
                
            }
            ENDHLSL
        }
        UsePass "Legacy Shaders/VertexLit/SHADOWCASTER"
    }
}
