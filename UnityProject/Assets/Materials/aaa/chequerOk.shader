Shader "Tutorial/011_Chessboard"
{
    //show values to edit in inspector
    Properties{
        _Scale ("Pattern Size", Range(0,10)) = 1
        _EvenColor("Color 1", Color) = (0,0,0,1)
        _OddColor("Color 2", Color) = (1,1,1,1)
    }

    SubShader{
        //the material is completely non-transparent and is rendered at the same time as the other opaque geometry
        Tags{ "RenderType"="Opaque" "Queue"="Geometry"}


        Pass{
            CGPROGRAM
            #include "UnityCG.cginc"

            #pragma vertex vert
            #pragma fragment frag

            float _Scale;

            float4 _EvenColor;
            float4 _OddColor;

            struct appdata{
                float4 vertex : POSITION;
            };

            struct v2f{
                float4 position : SV_POSITION;
                float3 worldPos : TEXCOORD0;
                float3 Pos : TEXCOORD1;
            };
            struct Checker{
                float4 Color;
                float Fac;
            };
            v2f vert(appdata v){
                v2f o;
                //calculate the position in clip space to render the object
                o.position = UnityObjectToClipPos(v.vertex);
                //calculate the position of the vertex in the world
                o.worldPos = mul(unity_ObjectToWorld, v.vertex);
                o.Pos=v.vertex.xyz;
                return o;
            }
            Checker checker(float3  ip, float4 color1, float4 color2,float Scale)
            {
                Checker c;
                ip =floor(ip*_Scale);
                float3 p;
                p[0] = (ip[0] + 0.000001) * 0.999999;
                p[1] = (ip[1] + 0.000001) * 0.999999;
                p[2] = (ip[2] + 0.000001) * 0.999999;
            
                int xi = (int)abs(floor(p[0]));
                int yi = (int)abs(floor(p[1]));
                int zi = (int)abs(floor(p[2]));
                //SI SON PARES
                if ((xi % 2 == yi % 2) == (zi % 2)) {
                    c.Color=color2;
                }
                else {
                    c.Color=color1;
                }
                return c;
            }
            
            fixed4 frag(v2f i) : SV_TARGET{
                //scale the position to adjust for shader input and floor the values so we have whole numbers
                float3 adjustedWorldPos = floor(i.worldPos / _Scale);
                //add different dimensions
                Checker check=checker(i.Pos, _OddColor, _EvenColor, _Scale);
                // float chessboard = adjustedWorldPos.x + adjustedWorldPos.y + adjustedWorldPos.z;
                // //divide it by 2 and get the fractional part, resulting in a value of 0 for even and 0.5 for off numbers.
                // chessboard = frac(chessboard * 0.5);
                // //multiply it by 2 to make odd values white instead of grey
                // chessboard *= 2;

                // //interpolate between color for even fields (0) and color for odd fields (1)
                // float4 color = lerp(_EvenColor, _OddColor, chessboard);
                return check.Color;
            }

            ENDCG
        }
    }
    FallBack "Standard" //fallback adds a shadow pass so we get shadows on other objects
}