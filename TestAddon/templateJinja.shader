Shader "Custom/{{ shader_name }}"
{
    Properties
    {
        {% for property in properties %}
        {{ property.name }} ("{{ property.display_name }}", {{ property.variable }}) = {{ property.value }};
        {% endfor %}
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

           {% for data_type, variable in variables %}
            {{ data_type }} {{ variable }};
            {% endfor %}

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
            {{ methods }}
            fixed4 frag(v2f i) : SV_Target
            {
                fixed4 color;
                // Use the color variable in your shader logic
                // For example: color = {{ color_variable }};
                return color;
            }
            ENDCG
        }
    }
}
