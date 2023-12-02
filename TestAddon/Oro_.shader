Shader "Custom/ShaderOro_"
{
    Properties
    {
        
        _Color ("Base Color", Color) = (0.5, 0.30769938230514526, 0.01749415509402752, 1.0)
        
        _Metallic ("Metallic", Float) = 0.800000011920929
        
        _Smoothness ("Roughness", Float) = 0.19999998807907104
        
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

            
            fixed4 _Color;
            
            float _Metallic;
            
            float _Smoothness;
            

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
                fixed4 color;
                // Use the color variable in your shader logic
                // For example: color = ;
                
                return color;
            }
            ENDCG
        }
    }
}