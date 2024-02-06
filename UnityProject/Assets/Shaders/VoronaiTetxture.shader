Shader "Unlit/VoronaiTetxture"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
       _CellSize("Cell Size", float) = 2
       _Randomness("Randomness", Range(0, 1)) = 1
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
                float3 normal : NORMAL; // Agrega la normal aquí
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float3 normal : TEXCOORD1;
                float3 worldPos:TEXCOORD2;// Pasa la normal desde el vértice hasta el fragmento
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _CellSize;
            float _Randomness;
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.normal = UnityObjectToWorldNormal(v.normal);
                o.worldPos = v.vertex.xyz;
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
            struct VoronoiOutput {
                float distance;
                float3 color;
                float4 position;
            };  
            struct VoronoiParams {
                float scale;
                float detail;
                float roughness;
                float lacunarity;
                float smoothness;
                float exponent;
                float randomness;
                float max_distance;
                bool normalize;
            };
            float4 voronoi_position(const float coord)
            {
                return float4(0.0f, 0.0f, 0.0f, coord);
            }
            float hash_float_to_float(float k)
            {
                return frac(sin(k * 12.9898) * 43758.5453);
            }
            VoronoiOutput voronoi_f1(float2 coord, VoronoiParams params) {
                //floor toma la parte entera-> encontrar la posición de la celda más cercana a las coordenadas iniciales.
                float2 cellPosition = floor(coord);
                //almacena la posición local dentro de esta celda.
                float2 localPosition = coord - cellPosition;

                float minDistance = 10;
                float2 closestCell;
                float targetOffset = 0.0f;
                float targetPosition = 0.0f;
                //Se itera a través de un bucle anidado para explorar las celdas cercanas.
                //Para cada celda vecina, se calcula una posición aleatoria y se compara su distancia con las coordenadas iniciales.
                //Se actualiza minDistance y se almacena la posición de la celda más cercana(closestCell) y la posición objetivo(targetPosition).
                [unroll]
                for (int j = -1; j <= 1; j++) {
                    [unroll]
                    for (int i = -1; i <= 1; i++) {
                        float cellOffset = i;
                        float pointPosition = cellOffset + hash_float_to_float(cellPosition + cellOffset) * params.randomness;
                        float2 cell = cellPosition + float2(j, i);
                        float2 cellPosition1 = cell + rand2dTo2d(cell);

                        float2 toCell = cellPosition1 - coord;
                        float distanceToPoint = length(toCell);
                        if (distanceToPoint < minDistance) {
                            minDistance = distanceToPoint;
                            closestCell = cell;
                            targetPosition = cellPosition1;
                        }
                    }
                }
                VoronoiOutput octave;
                octave.distance = minDistance;
                octave.position = voronoi_position(targetPosition + cellPosition);
                float random = rand2dTo1d(closestCell);
                octave.color = rand1dTo3d(random);
               
                return octave;
            }
            fixed4 frag (v2f i) : SV_Target
            {
                float3 normal = normalize(i.normal);
                float2 value = i.worldPos.xz*_CellSize;
                VoronoiParams parameters;
                parameters.randomness = _Randomness;
                VoronoiOutput noise = voronoi_f1(value,parameters);
                
                fixed4 result = fixed4(noise.color, 1.0f);

                return result;
            }
            ENDCG
        }
    }
}
