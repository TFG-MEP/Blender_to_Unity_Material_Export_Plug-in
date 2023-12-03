Shader "Unlit/VoronaiTetxture"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _CellSize("Cell Size", Range(0, 2)) = 2
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _CellSize;
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }
            float rand1dTo1d(float3 value, float mutator = 0.546) {
                float random = frac(sin(value + mutator) * 143758.5453);
                return random;
            }
            float rand2dTo1d(float2 value, float2 dotDir = float2(12.9898, 78.233)) {
                float2 smallValue = sin(value);
                float random = dot(smallValue, dotDir);
                random = frac(sin(random) * 143758.5453);
                return random;
            }
            float2 rand2dTo2d(float2 value) {
                return float2(
                    rand2dTo1d(value, float2(12.989, 78.233)),
                    rand2dTo1d(value, float2(39.346, 11.135))
                    );
            }
            float3 rand1dTo3d(float value) {
                return float3(
                    rand1dTo1d(value, 3.9812),
                    rand1dTo1d(value, 7.1536),
                    rand1dTo1d(value, 5.7241)
                    );
            }
            float2 voronoiNoise(float2 value) {
                float2 baseCell = floor(value);

                float minDistToCell = 10;
                float2 closestCell;
                [unroll]
                for (int x = -1; x <= 1; x++) {
                    [unroll]
                    for (int y = -1; y <= 1; y++) {
                        float2 cell = baseCell + float2(x, y);
                        float2 cellPosition = cell + rand2dTo2d(cell);
                        float2 toCell = cellPosition - value;
                        float distToCell = length(toCell);
                        if (distToCell < minDistToCell) {
                            minDistToCell = distToCell;
                            closestCell = cell;
                        }
                    }
                }
                float random = rand2dTo1d(closestCell);
                return float2(minDistToCell, random);
            }
            fixed4 frag (v2f i) : SV_Target
            {
                float2 value = i.uv / _CellSize;
                float noise = voronoiNoise(value).y;
                float3 color = rand1dTo3d(noise);
                fixed4 result = fixed4(color, 1.0f);

                return result;
            }
            ENDCG
        }
    }
}
