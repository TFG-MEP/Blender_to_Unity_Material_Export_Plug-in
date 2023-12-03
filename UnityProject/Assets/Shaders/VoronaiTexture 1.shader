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

        // La función principal del Vertex Shader
        
            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _CellSize;
            v2f vert(appdata input)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(input.vertex);
                return o;
            }

            // Simple definition of rand2dTo2d
            float2 rand2dTo2d(float2 p)
            {
                return frac(sin(dot(p, float2(12.9898, 78.233))) * 43758.5453);
            }

            float rand1dTo1d(float3 value, float mutator = 0.546) {
                float random = frac(sin(value + mutator) * 143758.5453);
                return random;
            }

            float3 rand1dTo3d(float value) {
                return float3(
                    rand1dTo1d(value, 3.9812),
                    rand1dTo1d(value, 7.1536),
                    rand1dTo1d(value, 5.7241)
                    );
            }
           
            float rand2dTo1d(float2 value, float2 dotDir = float2(12.9898, 78.233)) {
                float2 smallValue = sin(value);
                float random = dot(smallValue, dotDir);
                random = frac(sin(random) * 143758.5453);
                return random;
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
               
                float2 value = i.vertex.xz / _CellSize;
                float2 noise = voronoiNoise(value);
               
                return noise.y;
            }
            ENDCG
        }
    }
}
