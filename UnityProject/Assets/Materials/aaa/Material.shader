Shader "Custom/ShaderMaterial_"
{
    Properties
    {
        ImageTexture_Vector("Vector", Vector) = (0.0, 0.0, 0.0)
        ImageTexture_Image("Texture", 2D) = "white" {}
    // Add properties

    }

        SubShader
    {
        Tags
        {
            "RenderType" = "Opaque"
            "RenderPipeline" = "UniversalPipeline"
        }

        LOD 100

        //float4 image_texture(string path){
            //Texture2D tex;
            //Sampler sampler;
          //  return tex.Sample(sampler, uv)
       /// }

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"


            struct appdata_t
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;

            };
            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float3 normal : TEXCOORD1;
                float3 lightDir : TEXCOORD2;
                float3 worldPos : TEXCOORD3;
            };

            fixed3 ImageTexture_Vector;
            sampler2D ImageTexture_Image;
            // Add variables

            v2f vert(appdata_t v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                o.normal = v.normal;
                o.worldPos = mul(unity_ObjectToWorld, v.vertex);
                o.lightDir = normalize(_WorldSpaceLightPos0.xyz - v.vertex.xyz);
                return o;
            }
            // función que crea una textura a partir de un sampler2D
           float4 image_texture(sampler2D textura, float2 texcoord) {
               float4 colorImage = tex2D(textura, texcoord);
               return colorImage;
           }
           float3 mapping(float3 location, float3 rotation, float3 scale, float3 vectore) {
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
           // Add methods
           fixed4 frag(v2f i) : SV_Target
           {
               float3 coordinates = mapping(float3(0,0, 0.0f), float3(0.0f, 0.0f, 0.0f), float3(4.0f, 4.0f, 1.0f), float3(i.uv,0));

               fixed4 MaterialOutput_Surface = image_texture(ImageTexture_Image, coordinates);
           // Call methods
           return MaterialOutput_Surface;
       }
       ENDCG
   }
    }
}
