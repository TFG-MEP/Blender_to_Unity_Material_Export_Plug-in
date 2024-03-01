Shader "Custom/waveTexturre_"
{
     Properties
    {
        WaveTexture_Scale("Scale", float) = 5.0
        WaveTexture_Distortion("Distortion", float) = 5.0
        WaveTexture_Detail("Detail", float) = 5.0
        WaveTexture_DetailScale("DetailScale", float) = 5.0
        WaveTexture_DetailRoughness("DetailRoughness", float) = 5.0
        WaveTexture_PhaseOffset("PhaseOffset", float) = 5.0
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
            float WaveTexture_Scale;
            float WaveTexture_Distortion;
            float WaveTexture_Detail;
            float WaveTexture_DetailScale;
            float WaveTexture_DetailRoughness;
            float WaveTexture_PhaseOffset;

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
            float4 rgb_ramp_lookup(float4 ramp[30],int numcolors, float at, int interpolate, int extrapolate)
            {
              float f = at;
              int table_size = numcolors;
            
              if ((f < 0.0 || f > 1.0) && extrapolate) {
                float4 t0, dy;
                if (f < 0.0) {
                  t0 = ramp[0];
                  dy = t0 - ramp[1];
                  f = -f;
                }
                else {
                  t0 = ramp[table_size - 1];
                  dy = t0 - ramp[table_size - 2];
                  f = f - 1.0;
                }
                return t0 + dy * f * (table_size - 1);
              }
            
              f = clamp(at, 0.0, 1.0) * (table_size - 1);
            
              /* clamp int as well in case of NaN */
              int i = (int)f;
              if (i < 0)
                i = 0;
              if (i >= table_size)
                i = table_size - 1;
              float t = f - (float)i;
            
              float4 result = ramp[i];
            
              if (interpolate && t > 0.0)
                result = (1.0 - t) * result + t * ramp[i + 1];
            
              return (result);
            }
			// Add methods
            float4 frag (v2f i) : SV_Target
            {
                float4 ramp[30];
                ramp[0]=float4(0,1,0,1);
                ramp[1]=float4(0,0.0,1,1);
                ramp[2]=float4(1,0.0,0,1);
                return rgb_ramp_lookup( ramp,3, 0.75, 1, 0);
                
            }
            ENDHLSL
        }
        UsePass "Legacy Shaders/VertexLit/SHADOWCASTER"
    }
}
