Shader "Custom/Shaderchequ_"
{
     Properties
    {
        
        [NoScaleOffset] _HeightMap ("Heights", 2D) = "gray" {}
        ImageTexture_Image("Texture", 2D) = "white" {}
		[Gamma]CheckerTexture_Color2("Color2", Color) = (0.192538621205355,0.13382071079953312,0.4811564105413986, 1.0)
		CheckerTexture_Scale("Scale", float) = 5.0
		PrincipledBSDF_Subsurface("Subsurface", float) = 0.0
		PrincipledBSDF_SubsurfaceRadius("SubsurfaceRadius", Vector) = (1.0, 0.20000000298023224, 0.10000000149011612)
		PrincipledBSDF_SubsurfaceColor("SubsurfaceColor", Color) = (0.903545437039038,0.903545437039038,0.903545437039038, 1.0)
		PrincipledBSDF_SubsurfaceIOR("SubsurfaceIOR", float) = 1.399999976158142
		PrincipledBSDF_SubsurfaceAnisotropy("SubsurfaceAnisotropy", float) = 0.0
		PrincipledBSDF_Metallic("Metallic", float) = 0.0
		PrincipledBSDF_Specular("Specular", float) = 0.5
		PrincipledBSDF_SpecularTint("SpecularTint", float) = 0.0
		PrincipledBSDF_Roughness("Roughness", float) = 0.5
		PrincipledBSDF_Anisotropic("Anisotropic", float) = 0.0
		PrincipledBSDF_AnisotropicRotation("AnisotropicRotation", float) = 0.0
		PrincipledBSDF_Sheen("Sheen", float) = 0.0
		PrincipledBSDF_SheenTint("SheenTint", float) = 0.5
		PrincipledBSDF_Clearcoat("Clearcoat", float) = 0.0
		PrincipledBSDF_ClearcoatRoughness("ClearcoatRoughness", float) = 0.029999999329447746
		PrincipledBSDF_IOR("IOR", float) = 1.4500000476837158
		PrincipledBSDF_Transmission("Transmission", float) = 0.0
		PrincipledBSDF_TransmissionRoughness("TransmissionRoughness", float) = 0.0
		PrincipledBSDF_Emission("Emission", Color) = (0.0,0.0,0.0, 1.0)
		PrincipledBSDF_EmissionStrength("EmissionStrength", float) = 1.0
		PrincipledBSDF_Alpha("Alpha", float) = 1.0
		PrincipledBSDF_Normal("Normal", Vector) = (0.0, 0.0, 0.0)
		PrincipledBSDF_ClearcoatNormal("ClearcoatNormal", Vector) = (0.0, 0.0, 0.0)
		PrincipledBSDF_Tangent("Tangent", Vector) = (0.0, 0.0, 0.0)
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
                float3 normal : TEXCOORD2;
                float3 viewDir : TEXCOORD3;
                float3 worldPos : TEXCOORD4;
                DECLARE_LIGHTMAP_OR_SH(lightmapUV, vertexSH, 5);
            };
            sampler2D _HeightMap;
            sampler2D ImageTexture_Image;
			float4 CheckerTexture_Color2;
			float CheckerTexture_Scale;
			float PrincipledBSDF_Subsurface;
			float3 PrincipledBSDF_SubsurfaceRadius;
			float4 PrincipledBSDF_SubsurfaceColor;
			float PrincipledBSDF_SubsurfaceIOR;
			float PrincipledBSDF_SubsurfaceAnisotropy;
			float PrincipledBSDF_Metallic;
			float PrincipledBSDF_Specular;
			float PrincipledBSDF_SpecularTint;
			float PrincipledBSDF_Roughness;
			float PrincipledBSDF_Anisotropic;
			float PrincipledBSDF_AnisotropicRotation;
			float PrincipledBSDF_Sheen;
			float PrincipledBSDF_SheenTint;
			float PrincipledBSDF_Clearcoat;
			float PrincipledBSDF_ClearcoatRoughness;
			float PrincipledBSDF_IOR;
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
            // float3 bump(v2f i,float invert,float strenght,float distance,float3 height,float3 normal){
            //     normal= normalize(normal);
            //     //distance *= FrontFacing ? invert : -invert;
            // }
            
            // función que crea una textura a partir de un sampler2D
float4 image_texture( float2 texcoord,sampler2D textura){
	float4 colorImage=tex2D(textura, texcoord);
	return colorImage;
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

float4 principled_bsdf(v2f i, float4 PrincipledBSDF_BaseColor,float PrincipledBSDF_Subsurface, float3 PrincipledBSDF_SubsurfaceRadius, float4 PrincipledBSDF_SubsurfaceColor,float PrincipledBSDF_SubsurfaceIOR,float PrincipledBSDF_SubsurfaceAnisotropy,
float PrincipledBSDF_Metallic, float PrincipledBSDF_Specular,float PrincipledBSDF_SpecularTint,float PrincipledBSDF_Roughness,float PrincipledBSDF_Anisotropic, float PrincipledBSDF_AnisotropicRotation,float PrincipledBSDF_Sheen, 
float PrincipledBSDF_SheenTint,float PrincipledBSDF_Clearcoat,float PrincipledBSDF_ClearcoatRoughness,float PrincipledBSDF_IOR,float PrincipledBSDF_Transmission,float PrincipledBSDF_TransmissionRoughness,float4 PrincipledBSDF_Emission,
float PrincipledBSDF_EmissionStrength,float PrincipledBSDF_Alpha, float3 PrincipledBSDF_Normal,float3 PrincipledBSDF_ClearcoatNormal, float3 PrincipledBSDF_Tangent, float PrincipledBSDF_Weight)
{ 
    InputData inputdata = (InputData)0;
    inputdata.positionWS = i.positionWS;
    inputdata.normalWS = normalize(i.normal); //Normalizarlo evita que la luz aparezca como "pixelada"
    inputdata.viewDirectionWS = i.viewDir;
    //bakedGI quiere decir baked global illumiation
    inputdata.bakedGI = SAMPLE_GI(i.lightmapUV, i.vertexSH, inputdata.normalWS);

    SurfaceData surfacedata;
    surfacedata.albedo = PrincipledBSDF_BaseColor;
    surfacedata.specular = 0;
    surfacedata.metallic = clamp(PrincipledBSDF_Metallic,0,1);
    surfacedata.smoothness = clamp(1-PrincipledBSDF_Roughness,0,1);
    surfacedata.normalTS = 0;
    surfacedata.emission = 0;
    surfacedata.occlusion = 1; //"Ambient occlusion"
    surfacedata.alpha = 0;
    surfacedata.clearCoatMask = 0;
    surfacedata.clearCoatSmoothness = 0;

    return UniversalFragmentPBR(inputdata, surfacedata);

}
            void InitializeFragmentNormal(v2f i) {
                i.normal = float3(0, 1, 0);
                i.normal = normalize(i.normal);
            }
			// Add methods
            float4 frag (v2f i) : SV_Target
            {
                InitializeFragmentNormal(i);
                float3 CheckerTexture_Vector =  float3(i.uv,0);
				float3 ImageTexture_Vector = float3(i.uv,0);
				float4 CheckerTexture_Color1 = image_texture(ImageTexture_Vector, ImageTexture_Image);
				float4 PrincipledBSDF_BaseColor = checker(CheckerTexture_Vector, CheckerTexture_Color1, CheckerTexture_Color2, CheckerTexture_Scale);
				float4 MaterialOutput_Surface = principled_bsdf(i, PrincipledBSDF_BaseColor, PrincipledBSDF_Subsurface, PrincipledBSDF_SubsurfaceRadius, PrincipledBSDF_SubsurfaceColor, PrincipledBSDF_SubsurfaceIOR, PrincipledBSDF_SubsurfaceAnisotropy, PrincipledBSDF_Metallic, PrincipledBSDF_Specular, PrincipledBSDF_SpecularTint, PrincipledBSDF_Roughness, PrincipledBSDF_Anisotropic, PrincipledBSDF_AnisotropicRotation, PrincipledBSDF_Sheen, PrincipledBSDF_SheenTint, PrincipledBSDF_Clearcoat, PrincipledBSDF_ClearcoatRoughness, PrincipledBSDF_IOR, PrincipledBSDF_Transmission, PrincipledBSDF_TransmissionRoughness, PrincipledBSDF_Emission, PrincipledBSDF_EmissionStrength, PrincipledBSDF_Alpha, PrincipledBSDF_Normal, PrincipledBSDF_ClearcoatNormal, PrincipledBSDF_Tangent, PrincipledBSDF_Weight);
				// Call methods
                //half4 col = tex2D(_MainTex, i.uv);
                //MaterialOutput_Surface*= tex2D(_HeightMap, i.uv);
                return MaterialOutput_Surface;
                
            }
            ENDHLSL
        }
        UsePass "Legacy Shaders/VertexLit/SHADOWCASTER"
    }
}
