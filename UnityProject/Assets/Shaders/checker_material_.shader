Shader "Custom/Shaderchecker_material_"
{
     Properties
    {
        //_MyColor ("Color", Color) = {color_template}
        _MainTex("Texture", 2D) = "white" {}
        _MainTex2("Texture2", 2D) = "white" {}
        _Scale ("_Scale", Float) = 6.899999618530273
        _Color2 ("_Color2", Color) = (0.0, 0.0, 0.0, 1.0)
        _Color1 ("_Color1", Color) = (0.800000011920929, 0.800000011920929, 0.800000011920929, 1.0)
// Add properties
    }

    SubShader
    {
        Tags
        {
            "RenderType" = "Opaque"
            "RenderPipeline" = "UniversalPipe
            
        
        
        line"
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
            fixed4 _MyColor;
            float _Scale;
            fixed4 _Color2;
            fixed4 _Color1;
            sampler2D _MainTex;
            sampler2D _MainTex2;
// Add variables
            v2f vert (appdata_t v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                o.normal = v.normal;
                o.worldPos = v.vertex.xyz;
                o.lightDir = normalize(_WorldSpaceLightPos0.xyz - v.vertex.xyz);
                o.uv = v.uv;
                return o;
            }
             float4 checker(float3  ip, fixed4 color1, fixed4 color2,float Scale)
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
                    return color1;
                }
                else {
                    return color2;
                }

    
            }
// Add methods
            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 color;
                fixed4 col1 = tex2D(_MainTex, i.uv);
                fixed4 col2 = tex2D(_MainTex2, i.uv);
                color=checker(i.worldPos, col1, col2,_Scale);
// Call methods
                return color;
            }
            ENDCG
        }
    }
}
