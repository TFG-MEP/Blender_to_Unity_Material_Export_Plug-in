Shader "Custom/CelShad"
{
    Properties
    {
        _BaseColor("Base Color", Color) = (1, 1, 1, 1)
        _ShadowColor("Shadow Color", Color) = (0, 0, 0, 1)
        _AmbientColor("Ambient Color", Color) = (0.4,0.4,0.4,1)
        _SpecularColor("Specular Color", Color) = (0.9,0.9,0.9,1)
        _Glossiness("Glossiness", Float) = 32
        _RimColor("Rim Color", Color) = (1,1,1,1)
        _RimAmount("Rim Amount", Range(0, 1)) = 0.716
        _RimThreshold("Rim Threshold", Range(0, 1)) = 0.1

    }

        SubShader
    {
        Tags { "Queue" = "Transparent" }
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_fwdbase
            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            #include "AutoLight.cginc"
            struct appdata_t
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
                SHADOW_COORDS(2)
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
           
                float3 lightDir : TEXCOORD2;
                float3 worldNormal : NORMAL;
                float3 viewDir : TEXCOORD1;
            };

            float4 _BaseColor;
            float4 _AmbientColor;
            float _Glossiness;
            float4 _SpecularColor;
            float4 _RimColor;
            float _RimAmount;
            // Matching variable.
            float _RimThreshold;
            v2f vert(appdata_t v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
     
                o.lightDir = _WorldSpaceLightPos0.xyz;
                o.worldNormal = UnityObjectToWorldNormal(v.normal);
                o.viewDir = WorldSpaceViewDir(v.vertex);
                TRANSFER_SHADOW(o)
                return o;
            }

            half4 frag(v2f i) : SV_Target
            {
                 float3 normal = normalize(i.worldNormal);

                 float NdotL = dot(_WorldSpaceLightPos0, normal);
                 float shadow = SHADOW_ATTENUATION(i);
                 float lightIntensity = smoothstep(0, 0.01, NdotL * shadow);
                 float4 light = lightIntensity * _LightColor0;
                // Add to the fragment shader, above the line sampling _MainTex.
             float3 viewDir = normalize(i.viewDir);

             float3 halfVector = normalize(_WorldSpaceLightPos0 + viewDir);
             float NdotH = dot(normal, halfVector);

             float specularIntensity = pow(NdotH * lightIntensity, _Glossiness * _Glossiness);
              
             float specularIntensitySmooth = smoothstep(0.005, 0.01, specularIntensity);
             float4 specular = specularIntensitySmooth * _SpecularColor;
             float4 rimDot = 1 - dot(viewDir, normal);

            float rimIntensity = smoothstep(_RimAmount - 0.01, _RimAmount + 0.01, rimDot);
             float4 rim = rimIntensity * _RimColor;
             //float rimIntensity = rimDot * pow(NdotL, _RimThreshold);
             return _BaseColor  * (_AmbientColor + light + specular+ rim);
              
            }
            ENDCG
        }
        UsePass "Legacy Shaders/VertexLit/SHADOWCASTER"
    }
}
