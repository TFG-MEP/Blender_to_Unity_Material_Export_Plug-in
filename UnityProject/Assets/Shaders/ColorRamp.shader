Shader "Custom/ColorRamp"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _MyColor2("Color", Color) = (0.8000000715255737, 0.06040734797716141, 0.0, 1.0)
         _MyColor("Color", Color) = (0.8000000715255737, 0.06040734797716141, 0.0, 1.0)
    }

    SubShader
    {
        Tags { "RenderType"="Opaque" }

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            struct appdata_t
            {
                float4 vertex : POSITION;
                float2 texcoord : TEXCOORD0;
            };

            struct v2f
            {
                float2 texcoord : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            fixed4 _MyColor;
            fixed4 _MyColor2;
            v2f vert (appdata_t v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.texcoord = v.texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float4 colorImage=tex2D(_MainTex, i.texcoord);
           
                float4 outcol = lerp(_MyColor, _MyColor2, colorImage);
          
                return outcol;
            }
            ENDCG
        }
    }
}
