Shader "Custom/ColorShader"
{
    Properties
    {
        _Color ("Color", Color) = (0.8000000715255737, 0.06040734797716141, 0.0, 1.0)
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
            // ...

            fixed4 _Color;

            void vert (appdata_t v)
            {
                // ...
            }

            fixed4 frag (v2f i) : SV_Target
            {
                return _Color;
            }
            ENDCG
        }
    }
}
