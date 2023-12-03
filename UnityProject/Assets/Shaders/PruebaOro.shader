Shader "Custom/PruebaOro"
{
    Properties
    {
        _Color("Color", Color) = (0.5, 0.308, 0.017, 1)
        _Metallic("Metallic", Range(0.0, 1.0)) = 0.8
        _Smoothness("Smoothness", Range(0.0, 1.0)) = 0.8
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

            float4 _Color;
            float _Metallic;
            float _Roughness;

            v2f vert(appdata_t v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                o.normal = v.normal;
                o.worldPos = mul(unity_ObjectToWorld, v.vertex);
                o.lightDir = normalize(_WorldSpaceLightPos0.xyz - v.vertex.xyz);
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                fixed4 color = _Color;
            // Use the color variable in your shader logic
            // For example: color = {{ color_variable }};
            // Apply properties
            color.rgb *= _Color.rgb;
            color.a *= _Color.a;
            // Your shader logic here...
            return color;
        }
        ENDCG
    }
    }
}
