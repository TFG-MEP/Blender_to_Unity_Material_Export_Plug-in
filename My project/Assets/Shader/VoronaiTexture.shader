Shader "Custom/VoronoiTexture"
{
    Properties
    {      
        _Scale("Scale",Float) = 5
        _Detail("_Detail",Float) = 10
        _roughness("roughness",Float) = 5
        _lacunarity("lacunarity",Float) = 5
        _smoothness("smoothness",Float) = 1
        _exponent("exponent",Float) = 1
        _randomness("randomnesss",Float) = 1
        _max_distance("max_distance",Float) = 1
        _normalize("normalize", Range(0, 1)) = 1
        _feature("feature",Float) = 1
        _metric("metric",Float) = 1
        
    }

        SubShader
    {
        Tags { "Queue" = "Transparent" "RenderType" = "Opaque" }
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define SHD_VORONOI_EUCLIDEAN 0
            #define SHD_VORONOI_MANHATTAN 1
            #define SHD_VORONOI_CHEBYCHEV 2
            #define SHD_VORONOI_MINKOWSKI 3
            #define FLT_MAX 3.40282347e+38
            #define SHD_VORONOI_F1 0
            #define SHD_VORONOI_F2 1
            #define SHD_VORONOI_SMOOTH_F1 2
            #define SHD_VORONOI_DISTANCE_TO_EDGE 3
            #define SHD_VORONOI_N_SPHERE_RADIUS 4
            #include "UnityCG.cginc"

            struct appdata_t
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };
            
            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
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
                int feature;
                int metric;
            };
            struct VoronoiOutput {
                float Distance;
                float3 Color;
                float4 Position;
            };

            float _Scale;
            float _Detail;
            float _roughness;
            float _lacunarity;
            float _smoothness;
            float _exponent;
            float _randomness;
            float _max_distance;
            float _normalize;
            float _feature;
            float _metric;

            v2f vert(appdata_t v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            float voronoi_distance(float a, float b)
            {
                return abs(a - b);
            }
            float voronoi_distance(float2 a, float2 b, VoronoiParams params)
            {
                if (params.metric == SHD_VORONOI_EUCLIDEAN) {
                    return distance(a, b);
                }
                else if (params.metric == SHD_VORONOI_MANHATTAN) {
                    return abs(a.x - b.x) + abs(a.y - b.y);
                }
                else if (params.metric == SHD_VORONOI_CHEBYCHEV) {
                    return max(abs(a.x - b.x), abs(a.y - b.y));
                }
                else if (params.metric == SHD_VORONOI_MINKOWSKI) {
                    return pow(pow(abs(a.x - b.x), params.exponent) + pow(abs(a.y - b.y), params.exponent),
                        1.0 / params.exponent);
                }
                else {
                    return 0.0;
                }
            }
            float2 simpleHash(float value)
            {
                float2 result;
                result.x = frac(sin(dot(value, float2(12.9898, 78.233)) * 43758.5453);
                result.y = frac(cos(dot(value, float2(23.1407, 93.324)) * 34567.8912);
                return result;
            }
          
            float4 voronoi_position(float coord)
            {
                return float4(0.0, 0.0, 0.0, coord);
            }
            VoronoiOutput voronoi_f1(VoronoiParams params, float coord)
            {
                float cellPosition = floor(coord);
                float localPosition = coord - cellPosition;

                float minDistance = 1000;
                float targetOffset = 0.0;
                float targetPosition = 0.0;
                for (int i = -1; i <= 1; i++) {
                    float cellOffset = i;
                    float pointPosition = cellOffset +
                        simpleHash(cellPosition + cellOffset) * params.randomness;
                    float distanceToPoint = voronoi_distance(pointPosition, localPosition);
                    if (distanceToPoint < minDistance) {
                        targetOffset = cellOffset;
                        minDistance = distanceToPoint;
                        targetPosition = pointPosition;
                    }
                }

                VoronoiOutput octave;
                octave.Distance = minDistance;
                octave.Color = simpleHash(cellPosition + targetOffset);
                octave.Position = voronoi_position(targetPosition + cellPosition);
                return octave;
            }
            VoronoiOutput voronoi_f2(VoronoiParams params, float2 coord)
            {
                float2 cellPosition = floor(coord);
                float2 localPosition = coord - cellPosition;

                float distanceF1 = FLT_MAX;
                float distanceF2 = FLT_MAX;
                float2 offsetF1 = float2(0.0, 0.0);
                float2 positionF1 = float2(0.0, 0.0);
                float2 offsetF2 = float2(0.0, 0.0);
                float2 positionF2 = float2(0.0, 0.0);
                for (int j = -1; j <= 1; j++) {
                    for (int i = -1; i <= 1; i++) {
                        float2 cellOffset = float2(i, j);
                        float2 pointPosition = cellOffset + simpleHash(cellPosition + cellOffset) *
                            params.randomness;
                        float distanceToPoint = voronoi_distance(pointPosition, localPosition, params);
                        if (distanceToPoint < distanceF1) {
                            distanceF2 = distanceF1;
                            distanceF1 = distanceToPoint;
                            offsetF2 = offsetF1;
                            offsetF1 = cellOffset;
                            positionF2 = positionF1;
                            positionF1 = pointPosition;
                        }
                        else if (distanceToPoint < distanceF2) {
                            distanceF2 = distanceToPoint;
                            offsetF2 = cellOffset;
                            positionF2 = pointPosition;
                        }
                    }
                }

                VoronoiOutput octave;
                octave.Distance = distanceF2;
                octave.Color = simpleHash(cellPosition + offsetF2);
                octave.Position = voronoi_position(positionF2 + cellPosition);
                return octave;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                float2 uv = i.uv;
                float2 cell = float2(0.0, 0.0);
                float min_dist = 1.0;
                VoronoiParams params_;
                params_.scale = _Scale;
                params_.detail= _Detail;
                params_.roughness= _roughness;
                params_.lacunarity= _lacunarity;
                params_.smoothness= _smoothness;
                params_.exponent= _exponent;
                params_.randomness= _randomness;
                params_.max_distance= _max_distance;
                params_.normalize=true;
                params_.feature= _feature;
                params_.metric = _metric;
   
              
                return(voronoi_f2(params_, uv).Color, 1);
               
              
            }
            ENDCG
        }
    }
}
