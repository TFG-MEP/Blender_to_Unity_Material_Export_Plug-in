Shader "Unlit/Flipbook_shader"
{
    Properties
    {
        _BaseColor("Base Color", Color) = (1, 1, 1, 1)
        _BaseTex("Base Texture", 2D) = "white" {}
        _FlipbookSize("Flipbook Size", Vector) = (1, 1, 0, 0)
        _Speed("Animation Speed", Float) = 1
    }
        SubShader
        {
            Tags { "RenderType" = "Opaque" }
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
                    float4 vertex : POSITION;
                    float2 uv : TEXCOORD0;
                };

                struct v2f
                {
                    float2 uv : TEXCOORD0;
                    float4 vertex : SV_POSITION;
                };

                float4 _BaseColor;
                sampler2D _BaseTex;
                float2 _FlipbookSize;
                float _Speed;

                v2f vert(appdata v)
                {
                    v2f o;
                    float2 tileSize = float2(1.0f, 1.0f) / _FlipbookSize;
                    float width = _FlipbookSize.x;
                    float height = _FlipbookSize.y;
                    float tileCount = width * height;
                    float tileID = floor((_Time.y * _Speed) % tileCount);
                    float tileX = (tileID % width) * tileSize.x;
                    float tileY = (floor(tileID / width)) * tileSize.y;
                    o.uv = float2(v.uv.x / width + tileX, v.uv.y / height + tileY);
                    o.vertex = TransformObjectToHClip(v.vertex);
                    return o;
                }

                half4 frag(v2f i) : SV_Target
                {
                    // Sample the texture
                    half4 textureSample = tex2D(_BaseTex, i.uv);
                    return textureSample * _BaseColor;
                }
                ENDHLSL
            }
        }
            Fallback "Unlit/Color"
}
