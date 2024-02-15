Shader "Custom/Socorro"
{
     Properties
    {
        RGB_Color("Color", Color) = (0.5,0.30769938230514526,0.01749415509402752, 1.0)
		PrincipledBSDF_Subsurface("Subsurface", float) = 0.0
		PrincipledBSDF_SubsurfaceIOR("SubsurfaceIOR", float) = 1.399999976158142
		PrincipledBSDF_SubsurfaceAnisotropy("SubsurfaceAnisotropy", float) = 0.0
		Value_Value("Value", float) = 0.800000011920929
		PrincipledBSDF_Specular("Specular", float) = 0.5
		PrincipledBSDF_SpecularTint("SpecularTint", float) = 0.0
		Value001_Value("Value", float) = 0.19999998807907104
		PrincipledBSDF_Anisotropic("Anisotropic", float) = 0.0
		PrincipledBSDF_AnisotropicRotation("AnisotropicRotation", float) = 0.0
		PrincipledBSDF_Sheen("Sheen", float) = 0.0
		PrincipledBSDF_SheenTint("SheenTint", float) = 0.5
		PrincipledBSDF_Clearcoat("Clearcoat", float) = 0.0
		PrincipledBSDF_ClearcoatRoughness("ClearcoatRoughness", float) = 0.029999999329447746
		PrincipledBSDF_Transmission("Transmission", float) = 0.0
		PrincipledBSDF_TransmissionRoughness("TransmissionRoughness", float) = 0.0
		PrincipledBSDF_EmissionStrength("EmissionStrength", float) = 1.0
		PrincipledBSDF_Alpha("Alpha", float) = 1.0
		PrincipledBSDF_Weight("Weight", float) = 0.0
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

             float4 RGB_Color;
             float PrincipledBSDF_Subsurface;
             float3 PrincipledBSDF_SubsurfaceRadius;
             float4 PrincipledBSDF_SubsurfaceColor;
             float PrincipledBSDF_SubsurfaceIOR;
             float PrincipledBSDF_SubsurfaceAnisotropy;
             float PrincipledBSDF_Specular;
             float PrincipledBSDF_SpecularTint;
             float3 Value001_Value;
             float3 Value_Value;
             float PrincipledBSDF_Anisotropic;
             float PrincipledBSDF_AnisotropicRotation;
             float PrincipledBSDF_Sheen;
             float PrincipledBSDF_SheenTint;
             float PrincipledBSDF_Clearcoat;
             float PrincipledBSDF_ClearcoatRoughness;
             float PrincipledBSDF_Transmission;
             float PrincipledBSDF_TransmissionRoughness;
             float4 PrincipledBSDF_Emission;
             float PrincipledBSDF_EmissionStrength;
             float PrincipledBSDF_Alpha;
             float3 PrincipledBSDF_Normal;
             float3 PrincipledBSDF_ClearcoatNormal;
             float3 PrincipledBSDF_Tangent;
             float PrincipledBSDF_Weight;
             // Add variables

             sampler2D _MainTex;
             float4 _MainTex_ST;

             float4 PrincipledBSDF_BaseColor;
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

             float4 rgb(float4 input_color)
             {
                 return input_color;
             }
             float value(float input_value)
             {
                 return input_value;
             }
             float4 principled_bsdf(float metallic)
             {
                 return metallic * 1.0;
             }
             // Add methods
             float4 frag(v2f i) : SV_Target
             {
                 PrincipledBSDF_BaseColor = rgb(RGB_Color);
                 PrincipledBSDF_Metallic = value(Value_Value);
                 PrincipledBSDF_Roughness = value(Value001_Value);
                 float4 MaterialOutput_Surface = principled_bsdf(1);

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
