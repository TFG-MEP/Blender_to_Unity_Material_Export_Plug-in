Shader "Custom/Shaderchecker_material_"
{
     Properties
    {
        _MyColor ("Color", Color) = {color_template}
        _Scale ("_Scale", Float) = 6.899999618530273
_Color2 ("_Color2", Color) = (0.0, 0.0, 0.0, 1.0)
_Color1 ("_Color1", Color) = (0.800000011920929, 0.800000011920929, 0.800000011920929, 1.0)
// Add properties
    }

    SubShader
    {
        Tags
        {
            "RenderType" = "Opaque"
            "RenderPipeline" = "UniversalPipe
            
        
        
        line"
        }

        LOD 100

        float4 image_texture(string path){
            Texture2D tex;
            Sampler sampler;
            return tex.Sample(sampler, uv)
        }

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float3 normal : TEXCOORD1;
                float3 lightDir : TEXCOORD2;
            };
            struct appdata_t
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
                float3 worldPos : TEXCOORD1;
            };

            fixed4 _MyColor;
            fixed4 _Color2;
fixed4 _Color1;
// Add variables
            v2f vert (appdata_t v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                o.normal = v.normal;
                o.lightDir = normalize(_WorldSpaceLightPos0.xyz - v.vertex.xyz);
                return o;
            }
            //Add methods
            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 color;
                return color;
            }
            ENDCG
        }
    }
}
