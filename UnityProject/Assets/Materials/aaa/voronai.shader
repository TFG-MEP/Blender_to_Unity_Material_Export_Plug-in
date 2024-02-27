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
            #define FLT_MAX 3.402823466e+38  
            #define rot(x, k) (((x) << (k)) | ((x) >> (32 - (k))))
            #define final(a, b, c) \
            { \
                c ^= b; \
                c -= rot(b, 14); \
                a ^= c; \
                a -= rot(c, 11); \
                b ^= a; \
                b -= rot(a, 25); \
                c ^= b; \
                c -= rot(b, 16); \
                a ^= c; \
                a -= rot(c, 4); \
                b ^= a; \
                b -= rot(a, 14); \
                c ^= b; \
                c -= rot(b, 24); \
            } 
            
            #pragma vertex vert
            #pragma fragment frag

            //Aqui importamos el archivo donde tenemos las funciones que 
            //queremos usar para evitar calcular nosotras la iluminacion
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"            

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
            uint hash_uint(uint kx)
            {
                uint a, b, c;
                a = b = c = 0xdeadbeef + (1 << 2) + 13;

                a += kx;
                final(a, b, c);

                return c;
            }
            uint hash_uint2(uint kx, uint ky)
            {
                uint a, b, c;
                a = b = c = 0xdeadbeef + (2 << 2) + 13;

                b += ky;
                a += kx;
                final(a, b, c);

                return c;
            }
            float hashnoise(float p)
            {
                uint x = asuint(p);
                return hash_uint(x) / 4294967295.0; // ~0u es igual a 4294967295
            }
            float hashnoise(float2 p)
            {
                const uint x =uint(p.x);
                const uint y = uint(p.y);
                return hash_uint2(x, y) / 4294967295.0;
            }
            float voronoi_distance(float a, float b)
            {
            return abs(a - b);
            }
            float hash_float_to_float(float k)
            {
                return hashnoise(k);

            }
          
            float hash_vector2_to_float(float2 k)
            {
                return hashnoise(float2(k.x, k.y));
            }
            float4 hash_float_to_color(float k)
            {
                return float4(hash_float_to_float(k),
                            hash_vector2_to_float(float2(k, 1.0)),
                            hash_vector2_to_float(float2(k, 2.0)),1);
            }
            float4 voronoi_f1(float randomness ,float sclae, float coord)
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
                        float2 pointPosition = cellOffset + hash_float_to_float(cellPosition + cellOffset) * randomness;
                        float distanceToPoint = voronoi_distance(length(pointPosition), length(localPosition)); // Calcula la distancia en 2D
            
                        if (distanceToPoint < minDistance) {
                            targetOffset = cellOffset;
                            minDistance = distanceToPoint;
                            targetPosition = pointPosition;
                        }
                    }
                }
                
                float distance = minDistance;
            //   octave.Color = 
            //   octave.Position = voronoi_position(targetPosition + cellPosition);
              return hash_float_to_color(cellPosition + targetOffset);
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
