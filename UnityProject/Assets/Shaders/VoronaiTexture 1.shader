Shader "Unlit/VoronaiTexture1"
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
            // Simple definition of rand2dTo2d
            float2 rand2dTo2d(float2 p)
            {
                return frac(sin(dot(p, float2(12.9898, 78.233))) * 43758.5453);
            }

            /*float voronoiNoise(float2 value) {
                float2 cell = floor(value);
                float2 cellPosition = cell + rand2dTo2d(cell);
                float2 toCell = cellPosition - value;
                float distToCell = length(toCell);
                return distToCell;
            }*/
            float rand2dTo1d(float2 p)
            {
                p = frac(sin(dot(p, float2(12.9898, 78.233))) * 43758.5453);
                return p.x + p.y * 0.1; // Ajusta según tus necesidades
            }
            float voronoiNoise(float2 value) {
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
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                float2 noise = voronoiNoise(i.uv / _CellSize);
               // float3 color = rand1dTo3d(noise);
                return noise.y;
            }
            ENDCG
        }
    }
}
