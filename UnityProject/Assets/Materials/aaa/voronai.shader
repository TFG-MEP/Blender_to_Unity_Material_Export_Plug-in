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
                float3 globalPos : TEXCOORD4;
                float3 worldPos:TEXCOORD6;
                DECLARE_LIGHTMAP_OR_SH(lightmapUV, vertexSH, 5);
            };
            float voro_Scale;
            float voro_rand;

            v2f vert(appdata v)
            {
                v2f o;
                o.globalPos =  TransformObjectToHClip(v.vertex.xyz);
                o.positionWS = TransformObjectToWorld(v.vertex.xyz);
                o.normal = TransformObjectToWorldNormal(v.normal.xyz);
                o.viewDir = normalize(_WorldSpaceCameraPos - o.positionWS);
                o.uv = v.uv;
                o.worldPos=v.vertex.xyz;
                o.vertex = TransformWorldToHClip(o.positionWS);
                OUTPUT_LIGHTMAP_UV(v.texcoord1, unity_LightmapST, o.lightmapUV);
                OUTPUT_SH(o.normal.xyz, o.vertexSH);
                return o;
            }
            float voronoi_distance(float3 a, float3 b)
            {
              return length(a - b);           
            } 
            float voronoi_distance(float2 a, float2 b)
            {
              return length(a - b);           
            } 
            float4 voronoi_f1(float randomness ,float sclae, float2 coord)
            {
                coord *= sclae;
                float2 cellPosition = floor(coord);
                float2 localPosition = coord - cellPosition;

                float minDistance = FLT_MAX;
                float2 targetOffset = float2(0.0, 0.0);
                float2 targetPosition = float2(0.0, 0.0);
                for (int j = -1; j <= 1; j++) {
                    for (int i = -1; i <= 1; i++) {
                    float2 cellOffset = float2(i, j);
                    float2 pointPosition = cellOffset + hash_vector2_to_vector2(cellPosition + cellOffset) *
                                                        randomness;
                    float distanceToPoint = voronoi_distance(pointPosition, localPosition);
                    if (distanceToPoint < minDistance) {
                        targetOffset = cellOffset;
                        minDistance = distanceToPoint;
                        targetPosition = pointPosition;
                    }
                    }
                }

            // VoronoiOutput octave;
            // octave.Distance = minDistance;
            // octave.Color = 
            // octave.Position = voronoi_position(targetPosition + cellPosition);
            return hash_vector2_to_color(cellPosition + targetOffset);;
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
                return hash_vector3_to_color(cellPosition + targetOffset);
            }
           
            
			// Add methods
            float4 frag (v2f i) : SV_Target
            {
                float3 CheckerTexture_Vector = (i.worldPos + float3(1,1,1))/2;
                return voronoi_f1(voro_rand,voro_Scale, CheckerTexture_Vector );
                
            }
            ENDHLSL
        }
        UsePass "Legacy Shaders/VertexLit/SHADOWCASTER"
    }
}
