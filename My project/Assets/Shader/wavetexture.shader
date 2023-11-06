Shader "Custom/WaveTexture"
{
    Properties
    {
        _Frequency("Frequency", Range(0.1, 10.0)) = 5.0
        _Amplitude("Amplitude", Range(0.0, 1.0)) = 0.5
        _Phase("Phase", Range(0.0, 1.0)) = 0.0
        _Color("Wave Color", Color) = (1, 1, 1, 1)
    }

        SubShader
    {
        Tags
        {
            "RenderType" = "Opaque"
            "Queue" = "Geometry"
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
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            float _Frequency;
            float _Amplitude;
            float _Phase;
            float4 _Color;

            v2f vert(appdata_t v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }
            float wave_texture(float2 uv, float scale, float distortion, float detail, float detail_scale, float detail_roughness, float phase_offset)
            {
                float2 p = uv * scale;
                float f = sin(dot(p, float2(12.9898, 78.233))) * 43758.5453123;
                float rmd = frac(f);
                float t = rmd * 2.0 - 1.0;
                float fscale = pow(2.0, -detail);
                float amp = 1.0;
                float maxamp = 1.0;
                float sum = 0.0;
                int n = (int)detail;
                for (int i = 0; i <= n; i++) {
                    sum += t * amp;
                    maxamp += amp;
                    amp *= clamp(detail_roughness, 0.0, 1.0);
                    fscale *= 2.0;
                    t = rmd * fscale;
                    rmd = frac(f * fscale);
                }
                sum /= maxamp;
                sum = pow(abs(sum), detail_scale) * sign(sum);
                sum += distortion * (rmd * 2.0 - 1.0);
                sum = sin(sum + phase_offset);
                return sum;
            }
            fixed4 frag(v2f i) : SV_Target
            {
                // Calcula la onda procedural
                float waveValue = wave_texture(i.uv, 1, 13,3, 4.0,1, 0);
                return (waveValue, waveValue, waveValue,1);
            }
            ENDCG
        }
    }
}
