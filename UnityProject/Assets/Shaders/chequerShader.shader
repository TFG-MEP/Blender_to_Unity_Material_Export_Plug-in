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
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            fixed4 _MyColor;
            fixed4 _MyColor2;
            float _Scale;
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
             
            
                return o;
            }
            float checker(float4  ip)
            {
                float3 p;
                p[0] = (ip[0] + 0.000001) * 0.999999;
                p[1] = (ip[1] + 0.000001) * 0.999999;
                p[2] = (ip[2] + 0.000001) * 0.999999;

                int xi = (int)abs(floor(p[0]));
                int yi = (int)abs(floor(p[1]));
                int zi = (int)abs(floor(p[2]));

                if ((xi % 2 == yi % 2) == (zi % 2)) {
                    return 1.0;
                }
                else {
                    return 0.0;
                }
            }


            fixed4 frag (v2f i) : SV_Target
            {
                 float Fac = checker(i.vertex* _Scale);
                  if (Fac == 1.0)  return _MyColor;
                     
                
                  else  return _MyColor2;
                     
                
            }
            ENDCG
        }
    }
}
