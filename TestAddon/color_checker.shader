Shader "Custom/Shaderchecker_material_"
{
    Properties
    {
        
        _Color1 ("Color1", Color) = (0.7297400528407231, 0.3958274305295952, 0.382399763988146, 1.0)
        
        _Color2 ("Color2", Color) = (0.144577200160612, 0.8153982372211644, 0.3030430164136614, 1.0)
        
        _Scale ("Scale", Float) = 6.899999618530273
        
    }

    SubShader
    {
        Tags
        {
            "RenderType" = "Opaque"
            "RenderPipeline" = "UniversalPipeline"
        }

        LOD 100

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

            
            fixed4 _Color1;
            
            fixed4 _Color2;
            
            float _Scale;
            

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
            
            float4 checker(float3  ip, fixed4 color1, fixed4 color2,float Scale)
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

            
            fixed4 frag(v2f i) : SV_Target
            {
                fixed4 color;
                // Use the color variable in your shader logic
                // For example: color = ;
                
                return color;
            }
            ENDCG
        }
    }
}