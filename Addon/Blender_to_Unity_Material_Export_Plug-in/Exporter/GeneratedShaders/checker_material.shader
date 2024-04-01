Shader "Custom/Shaderchecker_material_"
{
     Properties
    {
        CheckerTexture_Vector("Vector", Vector) = (0.0, 0.0, 0.0)
		RGB_Color("Color", Color) = (0.7297400528407231,0.3958274305295952,0.382399763988146, 1.0)
		RGB001_Color("Color", Color) = (0.144577200160612,0.8153982372211644,0.3030430164136614, 1.0)
		CheckerTexture_Scale("Scale", float) = 6.899999618530273
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
                float3 worldPos : TEXCOORD4;
                DECLARE_LIGHTMAP_OR_SH(lightmapUV, vertexSH, 5);
            };

            float3 CheckerTexture_Vector;
			float4 RGB_Color;
			float4 RGB001_Color;
			float CheckerTexture_Scale;
			// Add variables

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert(appdata v)
            {
                v2f o;
                o.worldPos = v.vertex.xyz;
                o.positionWS = TransformObjectToWorld(v.vertex.xyz);
                o.normalWS = TransformObjectToWorldNormal(v.normal.xyz);
                o.viewDir = normalize(_WorldSpaceCameraPos - o.positionWS);
                o.uv = v.uv;
                o.vertex = TransformWorldToHClip(o.positionWS);

                OUTPUT_LIGHTMAP_UV(v.texcoord1, unity_LightmapST, o.lightmapUV);
                OUTPUT_SH(o.normalWS.xyz, o.vertexSH);

                return o;
            }
            
            float4 rgb(float4 input_color)
            {
                return input_color;
            }
			float4 checker(float3  ip, float4 color1, float4 color2,float Scale)
{
    ip *= Scale/2;
    float3 p;
    p[0] = (ip[0] + 0.000001) * 0.999999;
    p[1] = (ip[1] + 0.000001) * 0.999999;
    p[2] = (ip[2] + 0.000001) * 0.999999;

    int xi = (int)abs(floor(p[0]));
    int yi = (int)abs(floor(p[1]));
    int zi = (int)abs(floor(p[2]));
    //SI SON PARES
    if ((xi % 2 == yi % 2) == (zi % 2)) {
        return color2;
    }
    else {
        return color1;
    }
}

			// Add methods
            float4 frag (v2f i) : SV_Target
            {

                float4 CheckerTexture_Color1 = rgb(RGB_Color);
				float4 CheckerTexture_Color2 = rgb(RGB001_Color);
				float4 MaterialOutput_Surface = checker(CheckerTexture_Vector, CheckerTexture_Color1, CheckerTexture_Color2, CheckerTexture_Scale);
				// Call methods
                //half4 col = tex2D(_MainTex, i.uv);
                
                return MaterialOutput_Surface;
                
            }
            ENDHLSL
        }
    }
}
