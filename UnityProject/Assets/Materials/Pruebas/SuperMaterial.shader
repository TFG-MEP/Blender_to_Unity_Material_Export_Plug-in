Shader "Custom/ShaderSuperMaterial_"
{
     Properties
    {
        _NormalTex("Normal Map", 2D) = "bump" {}
        Value_Value("Value", float) = 0.5
		ColorRamp003_Color0("ColorRamp003_Color0", Color) = (0.0,0.11467778307746752,1.0, 1.0)
		ColorRamp003_Pos0("ColorRamp003_Pos0", Float) = 0.0
		ColorRamp003_Color1("ColorRamp003_Color1", Color) = (0.0,1.0,0.06667943911720454, 1.0)
		ColorRamp003_Pos1("ColorRamp003_Pos1", Float) = 1.0
		CheckerTexture002_Color2("Color2", Color) = (0.48115650831128215,0.48115650831128215,0.48115650831128215, 1.0)
		CheckerTexture002_Scale("Scale", float) = 5.0
		Mapping002_Location("Location", Vector) = (0.0, 0.0, 0.0)
		Mapping002_Rotation("Rotation", Vector) = (0.0, 0.0, 0.0)
		Mapping002_Scale("Scale", Vector) = (1.0, 1.0, 1.0)
		ImageTexture003_Image("Texture", 2D) = "white" {}
		PrincipledBSDF_Subsurface("Subsurface", float) = 0.0
		PrincipledBSDF_SubsurfaceRadius("SubsurfaceRadius", Vector) = (0.0, 0.20000000298023224, 0.10000000149011612)
		PrincipledBSDF_SubsurfaceColor("SubsurfaceColor", Color) = (0.0,0.0,0.0, 1.0)
		PrincipledBSDF_SubsurfaceIOR("SubsurfaceIOR", float) = 1.8159637451171875
		PrincipledBSDF_SubsurfaceAnisotropy("SubsurfaceAnisotropy", float) = 0.0
		PrincipledBSDF_Metallic("Metallic", float) = 0.3527272641658783
		PrincipledBSDF_Specular("Specular", float) = 1.0
		PrincipledBSDF_SpecularTint("SpecularTint", float) = 0.0
		PrincipledBSDF_Roughness("Roughness", float) = 0.14727279543876648
		PrincipledBSDF_Anisotropic("Anisotropic", float) = 0.0
		PrincipledBSDF_AnisotropicRotation("AnisotropicRotation", float) = 0.0
		PrincipledBSDF_Sheen("Sheen", float) = 0.0
		PrincipledBSDF_SheenTint("SheenTint", float) = 0.3509090840816498
		PrincipledBSDF_Clearcoat("Clearcoat", float) = 0.0
		PrincipledBSDF_ClearcoatRoughness("ClearcoatRoughness", float) = 0.029999999329447746
		PrincipledBSDF_IOR("IOR", float) = 1.4500000476837158
		PrincipledBSDF_Transmission("Transmission", float) = 0.0
		PrincipledBSDF_TransmissionRoughness("TransmissionRoughness", float) = 0.0
		RGB002_Color("Color", Color) = (0.5906417116331911,0.4815205521079071,0.7297400528407231, 1.0)
		PrincipledBSDF_EmissionStrength("EmissionStrength", float) = 0.5999984741210938
		PrincipledBSDF_Alpha("Alpha", float) = 1.0
		PrincipledBSDF_Normal("Normal", Vector) = (0.0, 0.0, 0.0)
		PrincipledBSDF_ClearcoatNormal("ClearcoatNormal", Vector) = (0.0, 0.0, 0.0)
		PrincipledBSDF_Tangent("Tangent", Vector) = (0.0, 0.0, 0.0)
		PrincipledBSDF_Weight("Weight", float) = 0.0
		// Add properties
        _SrcFactor("SrcFactor", Float) = 5
        _DstFactor("DstFactor", Float) = 10
        _BlendOp("Blend Operation", Float) = 0
    }

    SubShader
    {

        Tags { "RenderType" = "Opaque" "RenderPipeline" = "UniversalRenderPipeline"}
        // Add tags

        LOD 100
        //Blend [_SrcFactor] [_DstFactor]
        //BlendOp [_BlendOp]
        Pass
        {
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag
          
            #include"Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			//Add includes 
           
            //Datos de entrada en el vertex shader
            struct appdata
            {
                float4 positionOS : POSITION;
                float2 uv : TEXCOORD0;
                float3 normalOS : NORMAL;
                float4 tangentOS : TANGENT;
                float2 staticLightmapUV : TEXCOORD1;
                float2 dynamicLightmapUV : TEXCOORD2;
            };
            //Datos que se calculan en el vertex shader y se usan en el fragment shader
            struct v2f
            {
                float4 positionCS : SV_POSITION;
                float2 uv : TEXCOORD0;
                float3 positionWS : TEXCOORD1;
                float3 normalWS : TEXCOORD2;
                float4 tangentWS : TEXCOORD3;
                float3 viewDirWS : TEXCOORD4;
                float4 shadowCoord : TEXCOORD5;
                DECLARE_LIGHTMAP_OR_SH(staticLightmapUV, vertexSH, 6);
                #ifdef DYNAMICLIGHTMAP_ON
                float2  dynamicLightmapUV : TEXCOORD7;
                #endif
                float3 worldPos : TEXCOORD8;
            };
            struct Value{
                float Value;
            };
			struct Color_Ramp{
                float3 Color;
                float Alpha;
            };
			struct Checker{
                float4 Color;
                float Fac;
            };
			struct Mapping{
                float3 Vector;
            };
			struct Image_texture{
    float3 Color;
    float Alpha;
};

			struct RGB_output{
                float4 Color;
            };
			struct BSDF{
                float4 BSDF_output;
            };
			struct Add_shader{
                float4 Shader;
            };
			// Add structs

            float Value_Value;
			float4 ColorRamp003_Color0;
			float ColorRamp003_Pos0;
			float4 ColorRamp003_Color1;
			float ColorRamp003_Pos1;
			float4 CheckerTexture002_Color2;
			float CheckerTexture002_Scale;
			float3 Mapping002_Location;
			float3 Mapping002_Rotation;
			float3 Mapping002_Scale;
			sampler2D ImageTexture003_Image;
			float PrincipledBSDF_Subsurface;
			float3 PrincipledBSDF_SubsurfaceRadius;
			float4 PrincipledBSDF_SubsurfaceColor;
			float PrincipledBSDF_SubsurfaceIOR;
			float PrincipledBSDF_SubsurfaceAnisotropy;
			float PrincipledBSDF_Metallic;
			float PrincipledBSDF_Specular;
			float PrincipledBSDF_SpecularTint;
			float PrincipledBSDF_Roughness;
			float PrincipledBSDF_Anisotropic;
			float PrincipledBSDF_AnisotropicRotation;
			float PrincipledBSDF_Sheen;
			float PrincipledBSDF_SheenTint;
			float PrincipledBSDF_Clearcoat;
			float PrincipledBSDF_ClearcoatRoughness;
			float PrincipledBSDF_IOR;
			float PrincipledBSDF_Transmission;
			float PrincipledBSDF_TransmissionRoughness;
			float4 RGB002_Color;
			float PrincipledBSDF_EmissionStrength;
			float PrincipledBSDF_Alpha;
			float3 PrincipledBSDF_Normal;
			float3 PrincipledBSDF_ClearcoatNormal;
			float3 PrincipledBSDF_Tangent;
			float PrincipledBSDF_Weight;
			// Add variables
    
            sampler2D _NormalTex;
            v2f vert(appdata v)
            {
                v2f o;
                o.worldPos = v.positionOS.xyz;
                VertexPositionInputs vertexInput = GetVertexPositionInputs(v.
                positionOS.xyz);
                VertexNormalInputs normalInput = GetVertexNormalInputs(v.normalOS, 
                v.tangentOS);
                o.positionWS = vertexInput.positionWS;
                o.positionCS = vertexInput.positionCS;
                o.uv = v.uv;
                o.normalWS = normalInput.normalWS;
                float sign = v.tangentOS.w;
                o.tangentWS = float4(normalInput.tangentWS.xyz, sign);
                o.viewDirWS = GetWorldSpaceNormalizeViewDir(vertexInput.positionWS);
                o.shadowCoord = GetShadowCoord(vertexInput);
                OUTPUT_LIGHTMAP_UV(v.staticLightmapUV, unity_LightmapST, 
                o.staticLightmapUV);

                #ifdef DYNAMICLIGHTMAP_ON
                v.dynamicLightmapUV = v.dynamicLightmapUV.xy * unity_
                DynamicLightmapST.xy + unity_DynamicLightmapST.zw;
                #endif
                OUTPUT_SH(o.normalWS.xyz, o.vertexSH);
                return o;
            }
            
            Value value(float input_value)
            {
                Value output_value;
                output_value.Value = input_value;
                return output_value;
            }
			Color_Ramp color_ramp( float at,int numcolors, int interpolate,float4 ramp[30],float pos[30] )
            {
              float f = at;
              int table_size = numcolors;
              f  = clamp(at, 0.0, 1.0) ;
              float4 result=ramp[0];
              Color_Ramp colores;
              if(numcolors>1&&f>=pos[numcolors-1]){
                  colores.Color = ramp[numcolors - 1].xyz;
                  colores.Alpha = ramp[numcolors - 1].w;
                  return colores;
              }
              for (int i = 0; i < numcolors - 1; ++i) {
                  if (f  >= pos[i] && f  <= pos[i + 1]){
                      if (interpolate){
                          result=ramp[i];
                          float t = (f - (float)pos[i])/(pos[i+1]-pos[i]);
                          result = (1.0 - t) * result + t * ramp[i + 1];
                      } 
                      else{
                          result= ramp[i];
                      }
                    
                  }
              }
              colores.Color=result.xyz;
              colores.Alpha=result.w;
              return colores;
            }
						float4 float3_to_float4(float3 vec){
                return float4(vec,1);
            }
			Checker checker(float3  ip, float4 color1, float4 color2,float Scale)
{
    Checker c;
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
        c.Color=color2;
    }
    else {
        c.Color=color1;
    }
    return c;
}

			Mapping mapping( float3 vectore,float3 location, float3 rotation, float3 scale) {
                		Mapping map;
				// Añade la ubicación para la traslación
				vectore += location;

				// Aplica la rotación (en radianes)
        			float3 rotated_vector;
        			rotated_vector.x = vectore.x * cos(rotation.y) * cos(rotation.z) - vectore.y * (sin(rotation.x) * sin(rotation.z) - cos(rotation.x) * cos(rotation.z) * sin(rotation.y)) + vectore.z * (cos(rotation.x) * sin(rotation.z) + cos(rotation.z) * sin(rotation.x) * sin(rotation.y));
        			rotated_vector.y = vectore.x * sin(rotation.y) * cos(rotation.z) + vectore.y * (cos(rotation.x) * cos(rotation.z) + sin(rotation.x) * sin(rotation.y) * sin(rotation.z)) - vectore.z * (cos(rotation.y) * sin(rotation.x) - cos(rotation.x) * sin(rotation.y) * sin(rotation.z));
        			rotated_vector.z = -vectore.x * sin(rotation.z) + vectore.y * cos(rotation.z) * sin(rotation.x) + vectore.z * cos(rotation.x) * cos(rotation.y);

        			// Aplica la escala
        			rotated_vector *= scale;

        			map.Vector = rotated_vector;
        
        			return map;
      			}
			// función que crea una textura a partir de un sampler2D
			Image_texture image_texture( float3 texcoord,sampler2D textura){
				Image_texture tex;
				float4 colorImage=tex2D(textura, texcoord.xy);
				tex.Color=colorImage.xyz;
				tex.Alpha=colorImage.w;
				return tex;
			}

			RGB_output rgb(float4 input_color)
            {
                RGB_output output_color;
                output_color.Color = input_color;
                return output_color;
            }
			BSDF principled_bsdf(v2f i, float4 PrincipledBSDF_BaseColor,float PrincipledBSDF_Subsurface, float3 PrincipledBSDF_SubsurfaceRadius, float4 PrincipledBSDF_SubsurfaceColor,float PrincipledBSDF_SubsurfaceIOR,float PrincipledBSDF_SubsurfaceAnisotropy,
float PrincipledBSDF_Metallic, float PrincipledBSDF_Specular,float PrincipledBSDF_SpecularTint,float PrincipledBSDF_Roughness,float PrincipledBSDF_Anisotropic, float PrincipledBSDF_AnisotropicRotation,float PrincipledBSDF_Sheen, 
float PrincipledBSDF_SheenTint,float PrincipledBSDF_Clearcoat,float PrincipledBSDF_ClearcoatRoughness,float PrincipledBSDF_IOR,float PrincipledBSDF_Transmission,float PrincipledBSDF_TransmissionRoughness,float4 PrincipledBSDF_Emission,
float PrincipledBSDF_EmissionStrength,float PrincipledBSDF_Alpha, float3 PrincipledBSDF_Normal,float3 PrincipledBSDF_ClearcoatNormal, float3 PrincipledBSDF_Tangent, float PrincipledBSDF_Weight)
            { 
                SurfaceData surfacedata;
                surfacedata.albedo = PrincipledBSDF_BaseColor;
                surfacedata.specular = 0;
                surfacedata.metallic = clamp(PrincipledBSDF_Metallic,0,1);
                surfacedata.smoothness = clamp(1-PrincipledBSDF_Roughness,0,1);
                if(PrincipledBSDF_Normal.x==0&&PrincipledBSDF_Normal.y==0&&PrincipledBSDF_Normal.z==0){
                    surfacedata.normalTS = UnpackNormal(tex2D(_NormalTex, i.uv));  
                } 
                else surfacedata.normalTS =PrincipledBSDF_Normal;  
               

                PrincipledBSDF_Emission.rgb *= PrincipledBSDF_EmissionStrength;
                surfacedata.emission = PrincipledBSDF_Emission;
                surfacedata.occlusion = 1; //"Ambient occlusion"
                surfacedata.alpha = clamp(PrincipledBSDF_Alpha,0,1);
                surfacedata.clearCoatMask = 0;
                surfacedata.clearCoatSmoothness = 0;

                // Emission output.
                #if USE_EMISSION_ON
                PrincipledBSDF_Emission.rgb *= PrincipledBSDF_EmissionStrength;
                surfaceData.emission = PrincipledBSDF_Emission;;
                #endif
               
                InputData inputData = (InputData)0;
                // Position input.
                inputData.positionWS = i.positionWS;
                // Normal input.
                float3 bitangent = i.tangentWS.w * cross(i.normalWS, 
                i.tangentWS.xyz);
                inputData.tangentToWorld = float3x3(i.tangentWS.xyz, bitangent, 
                i.normalWS);
                inputData.normalWS = TransformTangentToWorld(surfacedata.normalTS, inputData.
                tangentToWorld);
                inputData.normalWS = NormalizeNormalPerPixel(inputData.normalWS);
                // View direction input.
                inputData.viewDirectionWS = SafeNormalize(i.viewDirWS);
                // Shadow coords.
                inputData.shadowCoord = TransformWorldToShadowCoord 
                (inputData .positionWS);
                // Baked lightmaps.
                #if defined(DYNAMICLIGHTMAP_ON)
                inputData.bakedGI = SAMPLE_GI(i.staticLightmapUV, 
                i.dynamicLightmapUV, i.vertexSH, inputData.normalWS);
             

                #else
                inputData.bakedGI = SAMPLE_GI(i.staticLightmapUV, i.vertexSH, 
                inputData.normalWS);
                #endif
                inputData.normalizedScreenSpaceUV = GetNormalizedScreenSpaceUV(i.
                positionCS);
                inputData.shadowMask = SAMPLE_SHADOWMASK(i.staticLightmapUV);
               

                BSDF output;
                output.BSDF_output= UniversalFragmentPBR(inputData, surfacedata);
                return output;

            }
			Add_shader add_shader(float4 shader1, float4 shader2) {
                Add_shader output;
                output.Shader=shader1+shader2;
                return output;
            }
			// Add methods
            float4 frag (v2f i) : SV_Target
            {

                float3 CheckerTexture002_Vector = i.worldPos;
				Value Value = value(Value_Value);
				float ColorRamp003_Fac = Value.Value;
				float ColorRamp003_pos[30];
				float4 ColorRamp003_ramp[30];
				ColorRamp003_ramp[0]=ColorRamp003_Color0;
				ColorRamp003_pos[0]=ColorRamp003_Pos0;
				ColorRamp003_ramp[1]=ColorRamp003_Color1;
				ColorRamp003_pos[1]=ColorRamp003_Pos1;
				Color_Ramp ColorRamp003 = color_ramp(ColorRamp003_Fac, 2, 1, ColorRamp003_ramp, ColorRamp003_pos);
				float4 CheckerTexture002_Color1 = float3_to_float4(ColorRamp003.Color);
				Checker CheckerTexture002 = checker(CheckerTexture002_Vector, CheckerTexture002_Color1, CheckerTexture002_Color2, CheckerTexture002_Scale);
				float4 AddShader_Shader = CheckerTexture002.Color;
				float3 Mapping002_Vector = float3(i.uv,0);
				Mapping Mapping002 = mapping(Mapping002_Vector, Mapping002_Location, Mapping002_Rotation, Mapping002_Scale);
				float3 ImageTexture003_Vector = Mapping002.Vector;
				Image_texture ImageTexture003 = image_texture(ImageTexture003_Vector, ImageTexture003_Image);
				float4 PrincipledBSDF_BaseColor = float3_to_float4(ImageTexture003.Color);
				RGB_output RGB002 = rgb(RGB002_Color);
				float4 PrincipledBSDF_Emission = RGB002.Color;
				BSDF Principled_BSDF = principled_bsdf(i, PrincipledBSDF_BaseColor, PrincipledBSDF_Subsurface, PrincipledBSDF_SubsurfaceRadius, PrincipledBSDF_SubsurfaceColor, PrincipledBSDF_SubsurfaceIOR, PrincipledBSDF_SubsurfaceAnisotropy, PrincipledBSDF_Metallic, PrincipledBSDF_Specular, PrincipledBSDF_SpecularTint, PrincipledBSDF_Roughness, PrincipledBSDF_Anisotropic, PrincipledBSDF_AnisotropicRotation, PrincipledBSDF_Sheen, PrincipledBSDF_SheenTint, PrincipledBSDF_Clearcoat, PrincipledBSDF_ClearcoatRoughness, PrincipledBSDF_IOR, PrincipledBSDF_Transmission, PrincipledBSDF_TransmissionRoughness, PrincipledBSDF_Emission, PrincipledBSDF_EmissionStrength, PrincipledBSDF_Alpha, PrincipledBSDF_Normal, PrincipledBSDF_ClearcoatNormal, PrincipledBSDF_Tangent, PrincipledBSDF_Weight);
				float4 AddShader_Shader_001 = Principled_BSDF.BSDF_output;
				Add_shader AddShader = add_shader(AddShader_Shader, AddShader_Shader_001);
				float4 MaterialOutput_Surface = AddShader.Shader;
				// Call methods
              
                
                return MaterialOutput_Surface;
                
            }
            ENDHLSL
        }
        UsePass "Legacy Shaders/VertexLit/SHADOWCASTER"
    }
}
