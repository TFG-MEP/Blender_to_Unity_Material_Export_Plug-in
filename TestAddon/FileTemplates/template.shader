Shader "Custom/ColorShader"
{
     Properties
    {
        // Add properties
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
                float3 normalWS : TEXCOORD2;
                float3 viewDir : TEXCOORD3;
                DECLARE_LIGHTMAP_OR_SH(lightmapUV, vertexSH, 4);
            };

            // Add variables

            sampler2D _MainTex;
            float4 _MainTex_ST;

            fixed4 PrincipledBSDF_BaseColor;
            float PrincipledBSDF_Metallic;
            float PrincipledBSDF_Roughness;

            v2f vert(appdata v)
            {
                v2f o;
                o.positionWS = TransformObjectToWorld(v.vertex.xyz);
                o.normalWS = TransformObjectToWorldNormal(v.normal.xyz);
                o.viewDir = normalize(_WorldSpaceCameraPos - o.positionWS);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.vertex = TransformWorldToHClip(o.positionWS);

                OUTPUT_LIGHTMAP_UV(v.texcoord1, unity_LightmapST, o.lightmapUV);
                OUTPUT_SH(o.normalWS.xyz, o.vertexSH);

                return o;
            }
            
            // Add methods
            fixed4 frag (v2f i) : SV_Target
            {
                // Call methods

                half4 col = tex2D(_MainTex, i.uv);
                InputData inputdata = (InputData)0;
                inputdata.positionWS = i.positionWS;
                inputdata.normalWS = normalize(i.normalWS); //Normalizarlo evita que la luz aparezca como "pixelada"
                inputdata.viewDirectionWS = i.viewDir;
                //bakedGI quiere decir baked global illumiation
                inputdata.bakedGI = SAMPLE_GI(i.lightmapUV, i.vertexSH, inputdata.normalWS);

                SurfaceData surfacedata;
                surfacedata.albedo = PrincipledBSDF_BaseColor;
                surfacedata.specular = 0;
                surfacedata.metallic = PrincipledBSDF_Metallic;
                surfacedata.smoothness = PrincipledBSDF_Roughness;
                surfacedata.normalTS = 0;
                surfacedata.emission = 0;
                surfacedata.occlusion = 1; //"Ambient occlusion"
                surfacedata.alpha = 0;
                surfacedata.clearCoatMask = 0;
                surfacedata.clearCoatSmoothness = 0;

                return UniversalFragmentPBR(inputdata, surfacedata);
                
            }
            ENDHLSL
        }
    }
}
