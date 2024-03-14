Shader "Custom/Shaderfoto_"
{
     Properties
    {
        _NormalTex("Normal Map", 2D) = "bump" {}
        Mapping002_Location("Location", Vector) = (0.0, 0.0, 0.0)
		Mapping002_Rotation("Rotation", Vector) = (0.0, 0.0, 0.0)
		Mapping002_Scale("Scale", Vector) = (1.0, 1.0, 1.0)
		ImageTexture003_Image("Texture", 2D) = "white" {}
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
          
            #include"Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
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

			// Add methods
            float4 frag (v2f i) : SV_Target
            {

                float3 Mapping002_Vector = float3(i.uv,0);
				Mapping Mapping002 = mapping(Mapping002_Vector, Mapping002_Location, Mapping002_Rotation, Mapping002_Scale);
				float3 ImageTexture003_Vector = Mapping002.Vector;
				Image_texture ImageTexture003 = image_texture(ImageTexture003_Vector, ImageTexture003_Image);
				float4 MaterialOutput_Surface = float3_to_float4(ImageTexture003.Color);
				// Call methods
              
                
                return MaterialOutput_Surface;
                
            }
            ENDHLSL
        }
        UsePass "Legacy Shaders/VertexLit/SHADOWCASTER"
    }
}
