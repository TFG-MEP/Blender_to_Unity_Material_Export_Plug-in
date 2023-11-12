Shader "Unlit/chequerShader"
{
    Properties
    {
          _MyColor("Color", Color) = (0.8000000715255737, 0.06040734797716141, 0.0, 1.0)
           _MyColor2("Color", Color) = (0.8000000715255737, 0.06040734797716141, 0.0, 1.0)
           _Scale("Scale",Float) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
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
            };

            struct v2f
            {
                float4 position : SV_POSITION;
                float3 worldPos : TEXCOORD1;
                float2 uv : TEXCOORD0;
            };

            fixed4 _MyColor;
            fixed4 _MyColor2;
            float _Scale;
            v2f vert (appdata v)
            {
                v2f o;
                o.position = UnityObjectToClipPos(v.vertex);
                //calculate the position of the vertex in the world
                o.worldPos = mul(unity_ObjectToWorld, v.vertex);
             
            
                return o;
            }
            float4 checker(float3  ip)
            {
                float3 p;
                p[0] = (ip[0] + 0.000001) * 0.999999;
                p[1] = (ip[1] + 0.000001) * 0.999999;
                p[2] = (ip[2] + 0.000001) * 0.999999;

                int xi = (int)abs(floor(p[0]));
                int yi = (int)abs(floor(p[1]));
                int zi = (int)abs(floor(p[2]));
                //SI SON PARES
                if ((xi % 2 == yi % 2) == (zi % 2)) {
                    return _MyColor;
                }
                else {
                    return _MyColor2;
                }
           
             
            }


            fixed4 frag (v2f i) : SV_Target
            {
                
                     
                return checker(i.worldPos* _Scale);
                
                     
                
            }
            ENDCG
        }
    }
}
