Shader "Custom/voro"
{
     Properties
    {
         voro_Scale("Scale", float) = 5.0
         voro_rand("Rand", float) = 5.0
        // WaveTexture_Distortion("Distortion", float) = 5.0
        // WaveTexture_Detail("Detail", float) = 5.0
        // WaveTexture_DetailScale("DetailScale", float) = 5.0
        // WaveTexture_DetailRoughness("DetailRoughness", float) = 5.0
        // WaveTexture_PhaseOffset("PhaseOffset", float) = 5.0
    }

    SubShader
    {

        Tags { "RenderType" = "Opaque" "RenderPipeline" = "UniversalRenderPipeline" }
        LOD 100

        Pass
        {
            HLSLPROGRAM
            
            #pragma vertex vert
            #pragma fragment frag

            //Aqui importamos el archivo donde tenemos las funciones que 
            //queremos usar para evitar calcular nosotras la iluminacion
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
            #include "node_hash.hlsl"            

            //Datos de entrada en el vertex shader
            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float4 normal : NORMAL;
                float4 texcoord1 : TEXCOORD1; //Coordenadas para el baking de iluminación
            };
            //Datos que se calculan en el vertex shader y se usan en el fragment shader
            struct v2f
            {
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
                float3 positionWS : TEXCOORD1;
                float3 normal : TEXCOORD2;
                float3 viewDir : TEXCOORD3;
                float3 worldPos : TEXCOORD4;
                DECLARE_LIGHTMAP_OR_SH(lightmapUV, vertexSH, 5);
            };
            float voro_Scale;
            float voro_rand;
            // float WaveTexture_Scale;
            // float WaveTexture_Distortion;
            // float WaveTexture_Detail;
            // float WaveTexture_DetailScale;
            // float WaveTexture_DetailRoughness;
            // float WaveTexture_PhaseOffset;

            v2f vert(appdata v)
            {

                v2f o;
                o.worldPos = v.vertex.xyz;
                o.positionWS = TransformObjectToWorld(v.vertex.xyz);
                o.normal = TransformObjectToWorldNormal(v.normal.xyz);
                o.viewDir = normalize(_WorldSpaceCameraPos - o.positionWS);
                o.uv = v.uv;
                o.vertex = TransformWorldToHClip(o.positionWS);

                OUTPUT_LIGHTMAP_UV(v.texcoord1, unity_LightmapST, o.lightmapUV);
                OUTPUT_SH(o.normal.xyz, o.vertexSH);

                return o;
            }
            float voronoi_distance(float3 a, float3 b)
            {
            // if (params.metric == "euclidean") {
                return distance(a, b);
            
            }
            float voronoi_distance(float4 a, float4 b)
            { 
                return distance(a, b);
           
            }
            // // float4 voronoi_f1(float randomness ,float sclae, float coord)
            // // {
            // //     coord *= sclae;
            // //     float2 cellPosition = floor(coord);
            // //     float2 localPosition = coord - cellPosition;
            
            // //     float minDistance = FLT_MAX;
            // //     float2 targetOffset = float2(0.0, 0.0);
            // //     float2 targetPosition = float2(0.0, 0.0);
                
            // //     for (int j = -1; j <= 1; j++) {
            // //         for (int i = -1; i <= 1; i++) {
            // //             float2 cellOffset = float2(i, j);
            // //             float2 pointPosition = cellOffset + hash_float_to_float(cellPosition + cellOffset) * randomness;
            // //             float distanceToPoint = voronoi_distance(length(pointPosition), length(localPosition)); // Calcula la distancia en 2D
            
            // //             if (distanceToPoint < minDistance) {
            // //                 targetOffset = cellOffset;
            // //                 minDistance = distanceToPoint;
            // //                 targetPosition = pointPosition;
            // //             }
            // //         }
            // //     }
                
            // //     float distance = minDistance;
            // // //   octave.Color = 
            // // //   octave.Position = voronoi_position(targetPosition + cellPosition);
            // //   return hash_float_to_color(cellPosition + targetOffset);
            // // }

            float4 voronoi_f1(float randomness ,float sclae, float4 coord)
            {
                coord *= sclae;
                float4 cellPosition = floor(coord);
                float4 localPosition = coord - cellPosition;
              
                float minDistance = FLT_MAX;
                float4 targetOffset = float4(0.0, 0.0, 0.0, 0.0);
                float4 targetPosition = float4(0.0, 0.0, 0.0, 0.0);
                for (int u = -1; u <= 1; u++) {
                  for (int k = -1; k <= 1; k++) {
                    for (int j = -1; j <= 1; j++) {
                      for (int i = -1; i <= 1; i++) {
                        float4 cellOffset = float4(i, j, k, u);
                        float4 pointPosition = cellOffset + hash_vector4_to_vector4(cellPosition + cellOffset) *
                                                                 randomness;
                        float distanceToPoint = voronoi_distance(pointPosition, localPosition);
                        if (distanceToPoint < minDistance) {
                          targetOffset = cellOffset;
                          minDistance = distanceToPoint;
                          targetPosition = pointPosition;
                        }
                      }
                    }
                  }
                }
              
                //VoronoiOutput octave;
                // octave.Distance = minDistance;
                // octave.Position = voronoi_position(targetPosition + cellPosition);
               return hash_vector4_to_color(cellPosition + targetOffset);
            }
            float4 voronoi_f1(float randomness ,float sclae,float3 coord)
            {
                coord *= sclae;
                float3 cellPosition = floor(coord);
                float3 localPosition = coord - cellPosition;

                float minDistance = FLT_MAX;
                float3 targetOffset = float3(0.0, 0.0, 0.0);
                float3 targetPosition = float3(0.0, 0.0, 0.0);
                for (int k = -1; k <= 1; k++) {
                    for (int j = -1; j <= 1; j++) {
                    for (int i = -1; i <= 1; i++) {
                        float3 cellOffset = float3(i, j, k);
                        float3 pointPosition = cellOffset + hash_vector3_to_vector3(cellPosition + cellOffset) *
                                                                randomness;
                        float distanceToPoint = voronoi_distance(pointPosition, localPosition);
                        if (distanceToPoint < minDistance) {
                        targetOffset = cellOffset;
                        minDistance = distanceToPoint;
                        targetPosition = pointPosition;
                        }
                    }
                    }
                }

            // VoronoiOutput octave;
            // octave.Distance = minDistance;
            // octave.Color = 
            // octave.Position = voronoi_position(targetPosition + cellPosition);
                return hash_vector3_to_color(cellPosition + targetOffset);;
            }
			// Add methods
            float4 frag (v2f i) : SV_Target
            {
                
                return voronoi_f1(voro_rand,voro_Scale,i.worldPos);
                
            }
            ENDHLSL
        }
        UsePass "Legacy Shaders/VertexLit/SHADOWCASTER"
    }
}
