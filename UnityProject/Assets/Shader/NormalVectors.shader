Shader "Custom/NORMALvector"
{
    Properties
    {
        _MainTex("Main Tex", 2D) = "white" {}
        _BumpMap("Bump Map", 2D) = "bump" {}
    }

        SubShader
    {
        Tags { "RenderType" = "Opaque" "RenderPipeline" = "UniversalPipeline" }

        Pass
        {
            Tags
            {
                "LightMode" = "UniversalForward"
            }
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

        // Estructura de entrada
        struct appdata_t {
            float4 vertex : POSITION;
            float2 uv_MainTex : TEXCOORD0;
            float2 uv_BumpMap : TEXCOORD1;
        };

    // Estructura de salida
    struct v2f {
        float2 uv_MainTex : TEXCOORD0;
        float3 normal : TEXCOORD1;
        float4 vertex : SV_POSITION;
     
    };

    // Declaración de texturas
    sampler2D _MainTex;
    sampler2D _BumpMap;

    // Función de vértice
    v2f vert(appdata_t v) {
        v2f o;
        o.vertex = TransformObjectToHClip(v.vertex);
        o.uv_MainTex = v.uv_MainTex;
     
        o.normal = float3(0, 0, 0); // Inicializa la normal a cero
        return o;
    }

   
    half4 frag(v2f i) : SV_Target{
        half4 col = tex2D(_MainTex, i.uv_MainTex);
        half3 normal = UnpackNormal(tex2D(_BumpMap, i.normal));

        // Aplica la textura y la normal al resultado
        half3 lightDirection = normalize(float3(0, 0, 1)); // Dirección de la luz (en este caso, luz hacia adelante)
        half3 lighting = max(0, dot(normal, lightDirection));
        col.rgb *= lighting;

        return col;
    }

    ENDHLSL
}
    }
}
