Shader "Custom/ColorShader"
{
    Properties
    {
        //[HideInInspector]
        _MyOwnColor ("Color", Color) = (.8, .6, 0, 1)
    }

    SubShader
    {
        Tags
        {
            "RenderType" = "Opaque"
            "RenderPipeline" = "UniversalPipeline"
        }

        LOD 100

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
            };

            fixed4 _MyOwnColor = fixed4(0.8, 0.06, 0.0, 1.0);

            v2f vert (appdata_t v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                o.normal = v.normal;
                o.lightDir = normalize(_WorldSpaceLightPos0.xyz - v.vertex.xyz);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                return _MyOwnColor;
            }
            ENDCG
        }
    }
}
