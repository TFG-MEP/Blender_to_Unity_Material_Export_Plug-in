Shader "Custom/CelShadingWithLighting"
{
    Properties
    {
        _BaseColor("Base Color", Color) = (1, 1, 1, 1)
        _ShadowColor("Shadow Color", Color) = (0, 0, 0, 1)

    }

        SubShader
    {
        Tags { "Queue" = "Transparent" }
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
            };

            float4 _BaseColor;
            float4 _ShadowColor;
            v2f vert(appdata_t v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                o.normal = normalize(v.normal);
                o.lightDir = _WorldSpaceLightPos0.xyz;
                return o;
            }

            half4 frag(v2f i) : SV_Target
            {
              
                half3 lightDir = normalize(i.lightDir);
                float3 ambientColor = UNITY_LIGHTMODEL_AMBIENT.rgb;
                half3 normal = normalize(i.normal);
                half ndotl = max(0, dot(normal, lightDir));
                half threshold = 0.5; // Ajusta este valor para controlar la intensidad del sombreado
                half4 shadedColor= (1, 1, 1, 1);;
         
                if (ndotl >= 0.95) { 
                    shadedColor = (1, 1, 1, 1)* (ambientColor,1);
                }
                else if (ndotl >= threshold) {
                    shadedColor = _BaseColor * (ambientColor, 1);;
                }
                else { shadedColor = _ShadowColor * (ambientColor, 1);; }
                //lerp(_BaseColor, _ShadowColor, ndotl < threshold);
                    
                return shadedColor;
            }
            ENDCG
        }
    }
}
