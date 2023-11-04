Shader "Custom/Specular"
{
    Properties
    {
        _BaseColor("Base Color", Color) = (1, 1, 1, 1)
    
        _Roughness("Specular", Range(0, 1)) = 0.5
       
    }

        SubShader
    {
        Tags { "RenderType" = "Opaque" }
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
                half3 normal : TEXCOORD3; // Declara una normal en TEXCOORD3
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                half3 normal : TEXCOORD3; // Declara una normal en TEXCOORD3
            };

            float4 _BaseColor;
         
            float _Roughness;
   

            v2f vert(appdata_t v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                o.normal = normalize(v.normal);
                return o;
            }

            half3 CalculateLighting(half3 normal, half3 viewDir, half3 lightDir)
            {
                half NdotL = max(0, dot(normal, lightDir));
                half NdotV = max(0, dot(normal, viewDir));
                half HdotV = max(0, dot(normalize(lightDir + viewDir), normal));

                // Cook-Torrance BRDF
                half3 F0 = lerp(half3(0.04, 0.04, 0.04), _BaseColor.rgb, _BaseColor.rgb);
                half3 spec = (F0 + (1 - F0) * pow(1 - HdotV, 5)) / (4 * NdotL * NdotV + 0.001);
                half3 kS = F0;
                half3 kD = 1 - kS;
             

                // Lambertian diffuse reflection
                half3 diffuse = kD * _BaseColor.rgb / UNITY_PI;

                // Combine diffuse and specular
                return (diffuse + spec) * NdotL;
            }

            half4 frag(v2f i) : SV_Target
            {
                half3 normal = normalize(i.normal);
                
                half3 viewDir = normalize(_WorldSpaceCameraPos - i.vertex.xyz);

                // Lighting calculation
                half3 lighting = CalculateLighting(normal, viewDir, _WorldSpaceLightPos0.xyz);

                // Apply roughness
                lighting *= saturate( _Roughness/10);

                return half4(lighting * _BaseColor,1);
            }
            ENDCG
        }
    }
}
