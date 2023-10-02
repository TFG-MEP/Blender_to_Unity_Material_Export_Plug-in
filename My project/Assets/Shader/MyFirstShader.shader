Shader "Unlit/MyShaderWithMovingTexture"
{
    Properties
    {
        _BaseColor("Base Color", Color) = (1, 1, 1, 1)
        _BaseTex("Base Texture", 2D) = "white" {}
        _ScrollSpeed("Scroll Speed", Range(-10, 10)) = 1
    }

        SubShader
        {
            Tags
            {
                "RenderType" = "Opaque"
                "Queue" = "Geometry"
                "RenderPipeline" = "UniversalPipeline"
            }
            LOD 100

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

                struct appdata
                {
                    float4 positionOS : POSITION;
                    float2 uv : TEXCOORD0;
                };

                struct v2f
                {
                    float4 positionCS : SV_POSITION;
                    float2 uv : TEXCOORD0;
                };

                sampler2D _BaseTex; // Declaración de la textura
                float4 _BaseTex_ST;
                float4 _BaseColor;
                float _ScrollSpeed;

                v2f vert(appdata v)
                {
                    v2f o;
                    o.positionCS = TransformObjectToHClip(v.positionOS);

                    // Aplicar movimiento a las coordenadas de textura en la dirección horizontal (u)
                    o.uv = v.uv + float2(_Time.y * _ScrollSpeed, 0);
                    o.uv = TRANSFORM_TEX(o.uv, _BaseTex);

                    return o;
                }

                float4 frag(v2f i) : SV_TARGET
                {
                    float4 textureSample = tex2D(_BaseTex, i.uv);
               
                    return textureSample * _BaseColor;
                }
                ENDHLSL
            }
        }
            Fallback "Unlit/Color"
}
