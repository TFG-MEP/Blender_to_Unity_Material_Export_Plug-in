Shader "Custom/Shaderchequ_"
{
     Properties
    {
        Mapping002_Location("Location", Vector) = (0.0, 0.0, 0.0)
		Mapping002_Rotation("Rotation", Vector) = (0.0, 0.0, 0.0)
		Mapping002_Scale("Scale", Vector) = (1.0, 1.0, 1.0)
		Mapping_Location("Location", Vector) = (0.0, 0.0, 0.0)
		Mapping_Rotation("Rotation", Vector) = (0.0, 0.0, 0.0)
		Mapping_Scale("Scale", Vector) = (1.0, 1.0, 1.0)
		ImageTexture_Image("Texture", 2D) = "white" {}
		Mapping003_Location("Location", Vector) = (0.0, 0.0, 0.0)
		Mapping003_Rotation("Rotation", Vector) = (0.0, 0.0, 0.0)
		Mapping003_Scale("Scale", Vector) = (1.0, 1.0, 1.0)
		ImageTexture001_Image("Texture", 2D) = "white" {}
		CheckerTexture_Scale("Scale", float) = 4.300000190734863
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

            float3 Mapping002_Location;
			float3 Mapping002_Rotation;
			float3 Mapping002_Scale;
			float3 Mapping_Location;
			float3 Mapping_Rotation;
			float3 Mapping_Scale;
			sampler2D ImageTexture_Image;
			float3 Mapping003_Location;
			float3 Mapping003_Rotation;
			float3 Mapping003_Scale;
			sampler2D ImageTexture001_Image;
			float CheckerTexture_Scale;
			// Add variables

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert(appdata v)
            {
                v2f o;
                o.positionWS = TransformObjectToWorld(v.vertex.xyz);
                o.normalWS = TransformObjectToWorldNormal(v.normal.xyz);
                o.viewDir = normalize(_WorldSpaceCameraPos - o.positionWS);
                o.uv = v.uv;
                o.vertex = TransformWorldToHClip(o.positionWS);

                OUTPUT_LIGHTMAP_UV(v.texcoord1, unity_LightmapST, o.lightmapUV);
                OUTPUT_SH(o.normalWS.xyz, o.vertexSH);

                return o;
            }
            
              float3 mapping( float3 vectore,float3 location, float3 rotation, float3 scale) {
    // Añade la ubicación para la traslación
    vectore += location;

    // Aplica la rotación (en radianes)
    float3 rotated_vector;
    rotated_vector.x = vectore.x * cos(rotation.y) * cos(rotation.z) - vectore.y * (sin(rotation.x) * sin(rotation.z) - cos(rotation.x) * cos(rotation.z) * sin(rotation.y)) + vectore.z * (cos(rotation.x) * sin(rotation.z) + cos(rotation.z) * sin(rotation.x) * sin(rotation.y));
    rotated_vector.y = vectore.x * sin(rotation.y) * cos(rotation.z) + vectore.y * (cos(rotation.x) * cos(rotation.z) + sin(rotation.x) * sin(rotation.y) * sin(rotation.z)) - vectore.z * (cos(rotation.y) * sin(rotation.x) - cos(rotation.x) * sin(rotation.y) * sin(rotation.z));
    rotated_vector.z = -vectore.x * sin(rotation.z) + vectore.y * cos(rotation.z) * sin(rotation.x) + vectore.z * cos(rotation.x) * cos(rotation.y);

    // Aplica la escala
    rotated_vector *= scale;

    return rotated_vector;
}
			// función que crea una textura a partir de un sampler2D
float4 image_texture( float2 texcoord,sampler2D textura){
	float4 colorImage=tex2D(textura, texcoord);
	return colorImage;
}

			float4 checker(float3  ip, float4 color1, float4 color2,float Scale)
{
    ip *= Scale;
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

                float3 Mapping002_Vector = i.positionWS;
				float3 CheckerTexture_Vector = mapping(Mapping002_Vector, Mapping002_Location, Mapping002_Rotation, Mapping002_Scale);
				float3 Mapping_Vector = float3(i.uv,0);
				float3 ImageTexture_Vector = mapping(Mapping_Vector, Mapping_Location, Mapping_Rotation, Mapping_Scale);
				float4 CheckerTexture_Color1 = image_texture(ImageTexture_Vector, ImageTexture_Image);
				float3 Mapping003_Vector = float3(i.uv,0);
				float3 ImageTexture001_Vector = mapping(Mapping003_Vector, Mapping003_Location, Mapping003_Rotation, Mapping003_Scale);
				float4 CheckerTexture_Color2 = image_texture(ImageTexture001_Vector, ImageTexture001_Image);
				float4 MaterialOutput_Surface = checker(CheckerTexture_Vector, CheckerTexture_Color1, CheckerTexture_Color2, CheckerTexture_Scale);
				// Call methods
                //half4 col = tex2D(_MainTex, i.uv);
                
                return MaterialOutput_Surface;
                
            }
            ENDHLSL
        }
    }
}
