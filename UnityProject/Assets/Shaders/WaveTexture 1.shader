Shader "Unlit/WaveTexture 1"
{
    Properties
    {
        _MainTex("Texture", 2D) = "white" {}
       _Scale("Scale", float) = 2
       _Distortion("Distortion", Range(0, 1)) = 1
    }
        SubShader
       {
           Tags { "RenderType" = "Opaque" }
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
                   float3 normal : TEXCOORD1; // Pasa la normal desde el vértice hasta el fragmento
                   float4 vertex : SV_POSITION;
               };

               sampler2D _MainTex;
               float4 _MainTex_ST;
               float _Scale;
               float _Distortion;
               v2f vert(appdata v)
               {
                   v2f o;
                   o.vertex = UnityObjectToClipPos(v.vertex);
                   o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                   o.normal = UnityObjectToWorldNormal(v.normal);
                   UNITY_TRANSFER_FOG(o,o.vertex);
                   return o;
               }
               float perlin(float3 p)
               {
                   // Implementación de la función de ruido de Perlin aquí...
               }

               float noise_fbm(float3 p, int octaves, float roughness, float persistence, bool normalize)
               {
                   float sum = 0.0f;
                   float amplitude = 1.0f;
                   float frequency = 1.0f;

                   for (int i = 0; i < octaves; ++i)
                   {
                       sum += amplitude * perlin(p * frequency);
                       amplitude *= roughness;
                       frequency *= 2.0f; // Ajusta la frecuencia según el número de octavas
                   }

                   if (normalize)
                   {
                       // Normaliza el resultado para que esté en el rango [0, 1]
                       sum = (sum + octaves) * 0.5f;
                   }

                   return sum * persistence;
               }
             /*  float svm_wave(float3 p, float distortion,float detail,float dscale,float droughness,float phase) {
                   p = (p + 0.000001f) * 0.999999f;

                   float n;

                   n = p.x * 20.0f;
                     
                   n += phase;

                   if (distortion != 0.0f) {
                       n += distortion * (noise_fbm(p * dscale, detail, droughness, 2.0f, true) * 2.0f - 1.0f);
                   }

                   
                   n /= 3.14;
                  return fabs(n - floor(n + 0.5f)) * 2.0f;
               
               }*/
               fixed4 frag(v2f i) : SV_Target
               {
                   float3 normal = normalize(i.normal);
                   float2 value = i.uv * _Scale;
              
                  

                   return 0;
               }
               ENDCG
           }
       }
}
