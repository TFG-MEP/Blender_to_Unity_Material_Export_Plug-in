Shader "Custom/ShaderMaterial_"
{
     Properties
    {
        RGB_Color("Color", Color) = (0.5793054699897766,0.0,0.2761496305465698, 1.0)
		// Add properties
        
    }

    SubShader
    {
        Tags
        {
            "RenderType" = "Opaque"
            "RenderPipeline" = "UniversalPipeline"
        }

        LOD 100

        //float4 image_texture(string path){
            //Texture2D tex;
            //Sampler sampler;
          //  return tex.Sample(sampler, uv)
       /// }

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            
            struct appdata_t
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
               
            };
            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float3 normal : TEXCOORD1;
                float3 lightDir : TEXCOORD2;
                float3 worldPos : TEXCOORD3;
            };

            fixed4 RGB_Color;
			// Add variables

            v2f vert (appdata_t v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                o.normal = v.normal;
                o.worldPos = mul(unity_ObjectToWorld, v.vertex);
                o.lightDir = normalize(_WorldSpaceLightPos0.xyz - v.vertex.xyz);
                return o;
            }
             fixed4 rgb(fixed4 input_color)
            {
                return input_color;
            }
			// Add methods
            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 MaterialOutput_Surface = rgb(RGB_Color);
				// Call methods
                return MaterialOutput_Surface;
            }
            ENDCG
        }
    }
}
