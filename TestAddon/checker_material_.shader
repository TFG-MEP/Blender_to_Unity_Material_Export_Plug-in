Shader "Custom/Shaderchecker_material_"
{
    Properties
    {
        
         ("", ) = ;
        
         ("", ) = ;
        
         ("", ) = ;
        
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
            
            f;
            
            l;
            
            o;
            
            a;
            
            t;
            
            4;
            
             ;
            
            c;
            
            h;
            
            e;
            
            c;
            
            k;
            
            e;
            
            r;
            
            (;
            
            f;
            
            l;
            
            o;
            
            a;
            
            t;
            
            3;
            
             ;
            
             ;
            
            i;
            
            p;
            
            ,;
            
             ;
            
            f;
            
            i;
            
            x;
            
            e;
            
            d;
            
            4;
            
             ;
            
            c;
            
            o;
            
            l;
            
            o;
            
            r;
            
            1;
            
            ,;
            
             ;
            
            f;
            
            i;
            
            x;
            
            e;
            
            d;
            
            4;
            
             ;
            
            c;
            
            o;
            
            l;
            
            o;
            
            r;
            
            2;
            
            ,;
            
            f;
            
            l;
            
            o;
            
            a;
            
            t;
            
             ;
            
            S;
            
            c;
            
            a;
            
            l;
            
            e;
            
            );
            
            
;
            
            {;
            
            
;
            
             ;
            
             ;
            
             ;
            
             ;
            
            i;
            
            p;
            
             ;
            
            *;
            
            =;
            
             ;
            
            S;
            
            c;
            
            a;
            
            l;
            
            e;
            
            ;;
            
            
;
            
             ;
            
             ;
            
             ;
            
             ;
            
            f;
            
            l;
            
            o;
            
            a;
            
            t;
            
            3;
            
             ;
            
            p;
            
            ;;
            
            
;
            
             ;
            
             ;
            
             ;
            
             ;
            
            p;
            
            [;
            
            0;
            
            ];
            
             ;
            
            =;
            
             ;
            
            (;
            
            i;
            
            p;
            
            [;
            
            0;
            
            ];
            
             ;
            
            +;
            
             ;
            
            0;
            
            .;
            
            0;
            
            0;
            
            0;
            
            0;
            
            0;
            
            1;
            
            );
            
             ;
            
            *;
            
             ;
            
            0;
            
            .;
            
            9;
            
            9;
            
            9;
            
            9;
            
            9;
            
            9;
            
            ;;
            
            
;
            
             ;
            
             ;
            
             ;
            
             ;
            
            p;
            
            [;
            
            1;
            
            ];
            
             ;
            
            =;
            
             ;
            
            (;
            
            i;
            
            p;
            
            [;
            
            1;
            
            ];
            
             ;
            
            +;
            
             ;
            
            0;
            
            .;
            
            0;
            
            0;
            
            0;
            
            0;
            
            0;
            
            1;
            
            );
            
             ;
            
            *;
            
             ;
            
            0;
            
            .;
            
            9;
            
            9;
            
            9;
            
            9;
            
            9;
            
            9;
            
            ;;
            
            
;
            
             ;
            
             ;
            
             ;
            
             ;
            
            p;
            
            [;
            
            2;
            
            ];
            
             ;
            
            =;
            
             ;
            
            (;
            
            i;
            
            p;
            
            [;
            
            2;
            
            ];
            
             ;
            
            +;
            
             ;
            
            0;
            
            .;
            
            0;
            
            0;
            
            0;
            
            0;
            
            0;
            
            1;
            
            );
            
             ;
            
            *;
            
             ;
            
            0;
            
            .;
            
            9;
            
            9;
            
            9;
            
            9;
            
            9;
            
            9;
            
            ;;
            
            
;
            
            
;
            
             ;
            
             ;
            
             ;
            
             ;
            
            i;
            
            n;
            
            t;
            
             ;
            
            x;
            
            i;
            
             ;
            
            =;
            
             ;
            
            (;
            
            i;
            
            n;
            
            t;
            
            );
            
            a;
            
            b;
            
            s;
            
            (;
            
            f;
            
            l;
            
            o;
            
            o;
            
            r;
            
            (;
            
            p;
            
            [;
            
            0;
            
            ];
            
            );
            
            );
            
            ;;
            
            
;
            
             ;
            
             ;
            
             ;
            
             ;
            
            i;
            
            n;
            
            t;
            
             ;
            
            y;
            
            i;
            
             ;
            
            =;
            
             ;
            
            (;
            
            i;
            
            n;
            
            t;
            
            );
            
            a;
            
            b;
            
            s;
            
            (;
            
            f;
            
            l;
            
            o;
            
            o;
            
            r;
            
            (;
            
            p;
            
            [;
            
            1;
            
            ];
            
            );
            
            );
            
            ;;
            
            
;
            
             ;
            
             ;
            
             ;
            
             ;
            
            i;
            
            n;
            
            t;
            
             ;
            
            z;
            
            i;
            
             ;
            
            =;
            
             ;
            
            (;
            
            i;
            
            n;
            
            t;
            
            );
            
            a;
            
            b;
            
            s;
            
            (;
            
            f;
            
            l;
            
            o;
            
            o;
            
            r;
            
            (;
            
            p;
            
            [;
            
            2;
            
            ];
            
            );
            
            );
            
            ;;
            
            
;
            
             ;
            
             ;
            
             ;
            
             ;
            
            /;
            
            /;
            
            S;
            
            I;
            
             ;
            
            S;
            
            O;
            
            N;
            
             ;
            
            P;
            
            A;
            
            R;
            
            E;
            
            S;
            
            
;
            
             ;
            
             ;
            
             ;
            
             ;
            
            i;
            
            f;
            
             ;
            
            (;
            
            (;
            
            x;
            
            i;
            
             ;
            
            %;
            
             ;
            
            2;
            
             ;
            
            =;
            
            =;
            
             ;
            
            y;
            
            i;
            
             ;
            
            %;
            
             ;
            
            2;
            
            );
            
             ;
            
            =;
            
            =;
            
             ;
            
            (;
            
            z;
            
            i;
            
             ;
            
            %;
            
             ;
            
            2;
            
            );
            
            );
            
             ;
            
            {;
            
            
;
            
             ;
            
             ;
            
             ;
            
             ;
            
             ;
            
             ;
            
             ;
            
             ;
            
            r;
            
            e;
            
            t;
            
            u;
            
            r;
            
            n;
            
             ;
            
            c;
            
            o;
            
            l;
            
            o;
            
            r;
            
            2;
            
            ;;
            
            
;
            
             ;
            
             ;
            
             ;
            
             ;
            
            };
            
            
;
            
             ;
            
             ;
            
             ;
            
             ;
            
            e;
            
            l;
            
            s;
            
            e;
            
             ;
            
            {;
            
            
;
            
             ;
            
             ;
            
             ;
            
             ;
            
             ;
            
             ;
            
             ;
            
             ;
            
            r;
            
            e;
            
            t;
            
            u;
            
            r;
            
            n;
            
             ;
            
            c;
            
            o;
            
            l;
            
            o;
            
            r;
            
            1;
            
            ;;
            
            
;
            
             ;
            
             ;
            
             ;
            
             ;
            
            };
            
            
;
            
            };
            
            
;
            
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