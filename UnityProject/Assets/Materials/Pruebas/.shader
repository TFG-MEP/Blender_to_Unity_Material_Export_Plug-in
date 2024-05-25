Shader "Custom/Shader_"
{
     Properties
    {
        _NormalTex("Normal Map", 2D) = "bump" {}
        PrincipledBSDF002_BaseColor("BaseColor", Color) = (1.0,1.0,1.0, 1.0)
		PrincipledBSDF002_Subsurface("Subsurface", float) = 0.0
		PrincipledBSDF002_SubsurfaceRadius("SubsurfaceRadius", Vector) = (1.0, 0.20000000298023224, 0.10000000149011612)
		PrincipledBSDF002_SubsurfaceColor("SubsurfaceColor", Color) = (0.903545437039038,0.903545437039038,0.903545437039038, 1.0)
		PrincipledBSDF002_SubsurfaceIOR("SubsurfaceIOR", float) = 1.399999976158142
		PrincipledBSDF002_SubsurfaceAnisotropy("SubsurfaceAnisotropy", float) = 0.0
		PrincipledBSDF002_Metallic("Metallic", float) = 0.0
		PrincipledBSDF002_Specular("Specular", float) = 0.5
		PrincipledBSDF002_SpecularTint("SpecularTint", float) = 0.0
		PrincipledBSDF002_Roughness("Roughness", float) = 0.5
		PrincipledBSDF002_Anisotropic("Anisotropic", float) = 0.0
		PrincipledBSDF002_AnisotropicRotation("AnisotropicRotation", float) = 0.0
		PrincipledBSDF002_Sheen("Sheen", float) = 0.0
		PrincipledBSDF002_SheenTint("SheenTint", float) = 0.5
		PrincipledBSDF002_Clearcoat("Clearcoat", float) = 0.0
		PrincipledBSDF002_ClearcoatRoughness("ClearcoatRoughness", float) = 0.029999999329447746
		PrincipledBSDF002_IOR("IOR", float) = 1.4500000476837158
		PrincipledBSDF002_Transmission("Transmission", float) = 0.0
		PrincipledBSDF002_TransmissionRoughness("TransmissionRoughness", float) = 0.0
		PrincipledBSDF002_Emission("Emission", Color) = (0.0,0.0,0.0, 1.0)
		PrincipledBSDF002_EmissionStrength("EmissionStrength", float) = 1.0
		PrincipledBSDF002_Alpha("Alpha", float) = 1.0
		NormalMap_Strength("Strength", float) = 1.0
		Mapping003_Location("Location", Vector) = (0.0, 0.0, 0.0)
		Mapping003_Rotation("Rotation", Vector) = (0.0, 0.0, 0.0)
		Mapping003_Scale("Scale", Vector) = (1.0, 1.0, 1.0)
		ImageTexture004_Image("Texture", 2D) = "white" {}
		PrincipledBSDF002_ClearcoatNormal("ClearcoatNormal", Vector) = (0.0, 0.0, 0.0)
		PrincipledBSDF002_Tangent("Tangent", Vector) = (0.0, 0.0, 0.0)
		PrincipledBSDF002_Weight("Weight", float) = 0.0
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
            struct Mapping{
                float3 Vector;
            };
			struct Image_texture{
    float3 Color;
    float Alpha;
};

			struct Normal_map{
                float3 Normal;
            };
			struct BSDF{
                float4 BSDF_output;
            };
			// Add structs

            float4 PrincipledBSDF002_BaseColor;
			float PrincipledBSDF002_Subsurface;
			float3 PrincipledBSDF002_SubsurfaceRadius;
			float4 PrincipledBSDF002_SubsurfaceColor;
			float PrincipledBSDF002_SubsurfaceIOR;
			float PrincipledBSDF002_SubsurfaceAnisotropy;
			float PrincipledBSDF002_Metallic;
			float PrincipledBSDF002_Specular;
			float PrincipledBSDF002_SpecularTint;
			float PrincipledBSDF002_Roughness;
			float PrincipledBSDF002_Anisotropic;
			float PrincipledBSDF002_AnisotropicRotation;
			float PrincipledBSDF002_Sheen;
			float PrincipledBSDF002_SheenTint;
			float PrincipledBSDF002_Clearcoat;
			float PrincipledBSDF002_ClearcoatRoughness;
			float PrincipledBSDF002_IOR;
			float PrincipledBSDF002_Transmission;
			float PrincipledBSDF002_TransmissionRoughness;
			float4 PrincipledBSDF002_Emission;
			float PrincipledBSDF002_EmissionStrength;
			float PrincipledBSDF002_Alpha;
			float NormalMap_Strength;
			float3 Mapping003_Location;
			float3 Mapping003_Rotation;
			float3 Mapping003_Scale;
			sampler2D ImageTexture004_Image;
			float3 PrincipledBSDF002_ClearcoatNormal;
			float3 PrincipledBSDF002_Tangent;
			float PrincipledBSDF002_Weight;
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

						float4 float3_to_float4(float3 vec){
                return float4(vec,1);
            }
			 Normal_map normal_map(float strenght,float4 color){
                float3 normal=UnpackNormal(color);
                normal.rg*=strenght;
                Normal_map output;
                output.Normal=normal;
                return output;
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
			// Add methods
            float4 frag (v2f i) : SV_Target
            {

                float3 Mapping003_Vector = float3(i.uv,0);
				Mapping Mapping003 = mapping(Mapping003_Vector, Mapping003_Location, Mapping003_Rotation, Mapping003_Scale);
				float3 ImageTexture004_Vector = Mapping003.Vector;
				Image_texture ImageTexture004 = image_texture(ImageTexture004_Vector, ImageTexture004_Image);
				float4 NormalMap_Color = float3_to_float4(ImageTexture004.Color);
				Normal_map NormalMap = normal_map(NormalMap_Strength, NormalMap_Color);
				float3 PrincipledBSDF002_Normal = NormalMap.Normal;
				BSDF Principled_BSDF_002 = principled_bsdf(i, PrincipledBSDF002_BaseColor, PrincipledBSDF002_Subsurface, PrincipledBSDF002_SubsurfaceRadius, PrincipledBSDF002_SubsurfaceColor, PrincipledBSDF002_SubsurfaceIOR, PrincipledBSDF002_SubsurfaceAnisotropy, PrincipledBSDF002_Metallic, PrincipledBSDF002_Specular, PrincipledBSDF002_SpecularTint, PrincipledBSDF002_Roughness, PrincipledBSDF002_Anisotropic, PrincipledBSDF002_AnisotropicRotation, PrincipledBSDF002_Sheen, PrincipledBSDF002_SheenTint, PrincipledBSDF002_Clearcoat, PrincipledBSDF002_ClearcoatRoughness, PrincipledBSDF002_IOR, PrincipledBSDF002_Transmission, PrincipledBSDF002_TransmissionRoughness, PrincipledBSDF002_Emission, PrincipledBSDF002_EmissionStrength, PrincipledBSDF002_Alpha, PrincipledBSDF002_Normal, PrincipledBSDF002_ClearcoatNormal, PrincipledBSDF002_Tangent, PrincipledBSDF002_Weight);
				float4 MaterialOutput_Surface = Principled_BSDF_002.BSDF_output;
				// Call methods
              
                
                return MaterialOutput_Surface;
                
            }
            ENDHLSL
        }
        UsePass "Legacy Shaders/VertexLit/SHADOWCASTER"
    }
}
