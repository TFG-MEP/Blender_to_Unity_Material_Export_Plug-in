Shader "Custom/Shadercolorramp2_"
{
     Properties
    {
        _NormalTex("Normal Map", 2D) = "bump" {}
        PrincipledBSDF_BaseColor("BaseColor", Color) = (0.903545437039038,0.903545437039038,0.903545437039038, 1.0)
		PrincipledBSDF_Subsurface("Subsurface", float) = 0.0
		PrincipledBSDF_SubsurfaceRadius("SubsurfaceRadius", Vector) = (1.0, 0.20000000298023224, 0.10000000149011612)
		PrincipledBSDF_SubsurfaceColor("SubsurfaceColor", Color) = (0.903545437039038,0.903545437039038,0.903545437039038, 1.0)
		PrincipledBSDF_SubsurfaceIOR("SubsurfaceIOR", float) = 1.399999976158142
		PrincipledBSDF_SubsurfaceAnisotropy("SubsurfaceAnisotropy", float) = 0.0
		PrincipledBSDF_Metallic("Metallic", float) = 0.0
		PrincipledBSDF_Specular("Specular", float) = 0.5
		PrincipledBSDF_SpecularTint("SpecularTint", float) = 0.0
		PrincipledBSDF_Roughness("Roughness", float) = 0.5
		PrincipledBSDF_Anisotropic("Anisotropic", float) = 0.0
		PrincipledBSDF_AnisotropicRotation("AnisotropicRotation", float) = 0.0
		PrincipledBSDF_Sheen("Sheen", float) = 0.0
		PrincipledBSDF_SheenTint("SheenTint", float) = 0.5
		PrincipledBSDF_Clearcoat("Clearcoat", float) = 0.0
		PrincipledBSDF_ClearcoatRoughness("ClearcoatRoughness", float) = 0.029999999329447746
		PrincipledBSDF_IOR("IOR", float) = 1.4500000476837158
		PrincipledBSDF_Transmission("Transmission", float) = 0.0
		PrincipledBSDF_TransmissionRoughness("TransmissionRoughness", float) = 0.0
		PrincipledBSDF_Emission("Emission", Color) = (0.0,0.0,0.0, 1.0)
		PrincipledBSDF_EmissionStrength("EmissionStrength", float) = 6.299999713897705
		PrincipledBSDF_Alpha("Alpha", float) = 1.0
		PrincipledBSDF_Normal("Normal", Vector) = (0.0, 0.0, 0.0)
		PrincipledBSDF_ClearcoatNormal("ClearcoatNormal", Vector) = (0.0, 0.0, 0.0)
		PrincipledBSDF_Tangent("Tangent", Vector) = (0.0, 0.0, 0.0)
		PrincipledBSDF_Weight("Weight", float) = 0.0
		ColorRamp_Color0("ColorRamp_Color0", Color) = (0.1799368623758776,0.06450653869054812,0.11991385051900703, 1.0)
		ColorRamp_Pos0("ColorRamp_Pos0", Float) = 0.0
		ColorRamp_Color1("ColorRamp_Color1", Color) = (0.3728577188262493,0.09726524515799365,0.22852447700537956, 1.0)
		ColorRamp_Pos1("ColorRamp_Pos1", Float) = 0.16363650560379028
		ColorRamp_Color2("ColorRamp_Color2", Color) = (0.6474567704192329,0.1470427699182262,0.032829007155875486, 1.0)
		ColorRamp_Pos2("ColorRamp_Pos2", Float) = 0.39090922474861145
		ColorRamp_Color3("ColorRamp_Color3", Color) = (1.0,0.9225611705129818,0.9292445946807536, 1.0)
		ColorRamp_Pos3("ColorRamp_Pos3", Float) = 0.6272727847099304
		// Add properties
        _SrcFactor("SrcFactor", Float) = 5
        _DstFactor("DstFactor", Float) = 10
        _BlendOp("Blend Operation", Float) = 0
        [Header(UniversalRP Default Shader code)]
    	[Space(20)]
    	_TintColor("TintColor", color) = (1,1,1,1)
    	_MainTex("Texture", 2D) = "white" {}
 	// Toggle control opaque to TransparentCutout
        [Toggle]_AlphaTest("Alpha Test", float) = 0
   	 _Alpha("AlphaClip", Range(0,1)) = 0.5
	 	[Enum(UnityEngine.Rendering.CullMode)] _Cull("Cull Mode", Float) = 1
    }

    SubShader
    {

        Name  "URPDefault"

    	Tags {"RenderPipeline"="UniversalRenderPipeline" "RenderType"="Opaque" "Queue"="Geometry"}
	 
        LOD 300
        Cull [_Cull]
//         Pass
//         {
//             HLSLPROGRAM
//             #pragma vertex vert
//             #pragma fragment frag
          
//             #include"Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
// 			//Add includes 
//             //Datos de entrada en el vertex shader
//             struct appdata
//             {
//                 float4 positionOS : POSITION;
//                 float2 uv : TEXCOORD0;
//                 float3 normalOS : NORMAL;
//                 float4 tangentOS : TANGENT;
//                 float2 staticLightmapUV : TEXCOORD1;
//                 float2 dynamicLightmapUV : TEXCOORD2;
//             };
//             //Datos que se calculan en el vertex shader y se usan en el fragment shader
//             struct v2f
//             {
//                 float4 positionCS : SV_POSITION;
//                 float2 uv : TEXCOORD0;
//                 float3 positionWS : TEXCOORD1;
//                 float3 normalWS : TEXCOORD2;
//                 float4 tangentWS : TEXCOORD3;
//                 float3 viewDirWS : TEXCOORD4;
//                 float4 shadowCoord : TEXCOORD5;
//                 DECLARE_LIGHTMAP_OR_SH(staticLightmapUV, vertexSH, 6);
//                 #ifdef DYNAMICLIGHTMAP_ON
//                 float2  dynamicLightmapUV : TEXCOORD7;
//                 #endif
//                 float3 worldPos : TEXCOORD8;
//             };

//             float4 PrincipledBSDF_BaseColor;
// 			float PrincipledBSDF_Subsurface;
// 			float3 PrincipledBSDF_SubsurfaceRadius;
// 			float4 PrincipledBSDF_SubsurfaceColor;
// 			float PrincipledBSDF_SubsurfaceIOR;
// 			float PrincipledBSDF_SubsurfaceAnisotropy;
// 			float PrincipledBSDF_Metallic;
// 			float PrincipledBSDF_Specular;
// 			float PrincipledBSDF_SpecularTint;
// 			float PrincipledBSDF_Roughness;
// 			float PrincipledBSDF_Anisotropic;
// 			float PrincipledBSDF_AnisotropicRotation;
// 			float PrincipledBSDF_Sheen;
// 			float PrincipledBSDF_SheenTint;
// 			float PrincipledBSDF_Clearcoat;
// 			float PrincipledBSDF_ClearcoatRoughness;
// 			float PrincipledBSDF_IOR;
// 			float PrincipledBSDF_Transmission;
// 			float PrincipledBSDF_TransmissionRoughness;
// 			float4 PrincipledBSDF_Emission;
// 			float PrincipledBSDF_EmissionStrength;
// 			float PrincipledBSDF_Alpha;
// 			float3 PrincipledBSDF_Normal;
// 			float3 PrincipledBSDF_ClearcoatNormal;
// 			float3 PrincipledBSDF_Tangent;
// 			float PrincipledBSDF_Weight;
// 			float4 ColorRamp_Color0;
// 			float ColorRamp_Pos0;
// 			float4 ColorRamp_Color1;
// 			float ColorRamp_Pos1;
// 			float4 ColorRamp_Color2;
// 			float ColorRamp_Pos2;
// 			float4 ColorRamp_Color3;
// 			float ColorRamp_Pos3;
// 			// Add variables
    
//             sampler2D _NormalTex;
//             v2f vert(appdata v)
//             {
//                 v2f o;
//                 o.worldPos = v.positionOS.xyz;
//                 VertexPositionInputs vertexInput = GetVertexPositionInputs(v.
//                 positionOS.xyz);
//                 VertexNormalInputs normalInput = GetVertexNormalInputs(v.normalOS, 
//                 v.tangentOS);
//                 o.positionWS = vertexInput.positionWS;
//                 o.positionCS = vertexInput.positionCS;
//                 o.uv = v.uv;
//                 o.normalWS = normalInput.normalWS;
//                 float sign = v.tangentOS.w;
//                 o.tangentWS = float4(normalInput.tangentWS.xyz, sign);
//                 o.viewDirWS = GetWorldSpaceNormalizeViewDir(vertexInput.positionWS);
//                 o.shadowCoord = GetShadowCoord(vertexInput);
//                 //create the lightmap uv
//                 OUTPUT_LIGHTMAP_UV(v.staticLightmapUV, unity_LightmapST, 
//                 o.staticLightmapUV);

//                 #ifdef DYNAMICLIGHTMAP_ON
//                 v.dynamicLightmapUV = v.dynamicLightmapUV.xy * unity_
//                 DynamicLightmapST.xy + unity_DynamicLightmapST.zw;
//                 #endif
//                 OUTPUT_SH(o.normalWS.xyz, o.vertexSH);
//                 return o;
//             }
            
//             float4 principled_bsdf(v2f i, float4 PrincipledBSDF_BaseColor,float PrincipledBSDF_Subsurface, float3 PrincipledBSDF_SubsurfaceRadius, float4 PrincipledBSDF_SubsurfaceColor,float PrincipledBSDF_SubsurfaceIOR,float PrincipledBSDF_SubsurfaceAnisotropy,
// float PrincipledBSDF_Metallic, float PrincipledBSDF_Specular,float PrincipledBSDF_SpecularTint,float PrincipledBSDF_Roughness,float PrincipledBSDF_Anisotropic, float PrincipledBSDF_AnisotropicRotation,float PrincipledBSDF_Sheen, 
// float PrincipledBSDF_SheenTint,float PrincipledBSDF_Clearcoat,float PrincipledBSDF_ClearcoatRoughness,float PrincipledBSDF_IOR,float PrincipledBSDF_Transmission,float PrincipledBSDF_TransmissionRoughness,float4 PrincipledBSDF_Emission,
// float PrincipledBSDF_EmissionStrength,float PrincipledBSDF_Alpha, float3 PrincipledBSDF_Normal,float3 PrincipledBSDF_ClearcoatNormal, float3 PrincipledBSDF_Tangent, float PrincipledBSDF_Weight)
//             { 
//                 SurfaceData surfacedata;
//                 surfacedata.albedo = PrincipledBSDF_BaseColor;
//                 surfacedata.specular = 0;
//                 surfacedata.metallic = clamp(PrincipledBSDF_Metallic,0,1);
//                 surfacedata.smoothness = clamp(1-PrincipledBSDF_Roughness,0,1);
//                 if(PrincipledBSDF_Normal.x==0&&PrincipledBSDF_Normal.y==0&&PrincipledBSDF_Normal.z==0){
//                     surfacedata.normalTS = UnpackNormal(tex2D(_NormalTex, i.uv));  
//                 } 
//                 else surfacedata.normalTS =PrincipledBSDF_Normal;  
               

//                 PrincipledBSDF_Emission.rgb *= PrincipledBSDF_EmissionStrength;
//                 surfacedata.emission = PrincipledBSDF_Emission;
//                 surfacedata.occlusion = 1; //"Ambient occlusion"
//                 surfacedata.alpha = 1;
//                 surfacedata.clearCoatMask = 0;
//                 surfacedata.clearCoatSmoothness = 0;

//                 // Emission output.
//                 #if USE_EMISSION_ON
//                 PrincipledBSDF_Emission.rgb *= PrincipledBSDF_EmissionStrength;
//                 surfaceData.emission = PrincipledBSDF_Emission;;
//                 #endif
               
//                 InputData inputData = (InputData)0;
//                 // Position input.
//                 inputData.positionWS = i.positionWS;
//                 // Normal input.
//                 float3 bitangent = i.tangentWS.w * cross(i.normalWS, 
//                 i.tangentWS.xyz);
//                 inputData.tangentToWorld = float3x3(i.tangentWS.xyz, bitangent, 
//                 i.normalWS);
//                 inputData.normalWS = TransformTangentToWorld(surfacedata.normalTS, inputData.
//                 tangentToWorld);
//                 inputData.normalWS = NormalizeNormalPerPixel(inputData.normalWS);
//                 // View direction input.
//                 inputData.viewDirectionWS = SafeNormalize(i.viewDirWS);
//                 // Shadow coords.
//                 inputData.shadowCoord = TransformWorldToShadowCoord 
//                 (inputData .positionWS);
//                 // Baked lightmaps.
//                 #if defined(DYNAMICLIGHTMAP_ON)
//                 inputData.bakedGI = SAMPLE_GI(i.staticLightmapUV, 
//                 i.dynamicLightmapUV, i.vertexSH, inputData.normalWS);
             

//                 #else
//                 inputData.bakedGI = SAMPLE_GI(i.staticLightmapUV, i.vertexSH, 
//                 inputData.normalWS);
//                 #endif
//                 inputData.normalizedScreenSpaceUV = GetNormalizedScreenSpaceUV(i.
//                 positionCS);
//                 inputData.shadowMask = SAMPLE_SHADOWMASK(i.staticLightmapUV);
               
//                 return UniversalFragmentPBR(inputData, surfacedata);

//             }
// 			float4 shader_to_RGB(float4 shader){
//     return shader;
// }
// 			float4 color_ramp( float at,int numcolors, int interpolate,float4 ramp[30],float pos[30] )
// {
//               float f = at;
//               int table_size = numcolors;
            
//               f  = clamp(at, 0.0, 1.0) ;
//               float4 result=ramp[0];
//               if(f>=pos[numcolors-1]){
//                   return ramp[numcolors-1];
//               }
      
//               for (int i = 0; i < numcolors - 1; ++i) {
//                   if (f  >= pos[i] && f  <= pos[i + 1]){
//                       if (interpolate){
//                           result=ramp[i];
//                           float t = (f - (float)pos[i])/(pos[i+1]-pos[i]);
//                           result = (1.0 - t) * result + t * ramp[i + 1];
//                       } 
//                       else{
//                           result= ramp[i];
//                       }
                    
//                   }
//               }
                
//               return result;
// }
// 			// Add methods
//             float4 frag (v2f i) : SV_Target
//             {

//                 float4 ShadertoRGB_Shader = principled_bsdf(i, PrincipledBSDF_BaseColor, PrincipledBSDF_Subsurface, PrincipledBSDF_SubsurfaceRadius, PrincipledBSDF_SubsurfaceColor, PrincipledBSDF_SubsurfaceIOR, PrincipledBSDF_SubsurfaceAnisotropy, PrincipledBSDF_Metallic, PrincipledBSDF_Specular, PrincipledBSDF_SpecularTint, PrincipledBSDF_Roughness, PrincipledBSDF_Anisotropic, PrincipledBSDF_AnisotropicRotation, PrincipledBSDF_Sheen, PrincipledBSDF_SheenTint, PrincipledBSDF_Clearcoat, PrincipledBSDF_ClearcoatRoughness, PrincipledBSDF_IOR, PrincipledBSDF_Transmission, PrincipledBSDF_TransmissionRoughness, PrincipledBSDF_Emission, PrincipledBSDF_EmissionStrength, PrincipledBSDF_Alpha, PrincipledBSDF_Normal, PrincipledBSDF_ClearcoatNormal, PrincipledBSDF_Tangent, PrincipledBSDF_Weight);
			
// 				// Call methods
              
                
//                 return ShadertoRGB_Shader;
                
//             }
//             ENDHLSL
//         }
Pass
    	{     	 
       	HLSLPROGRAM

        	#pragma prefer_hlslcc gles
        	#pragma exclude_renderers d3d11_9x
        	#pragma vertex vert
        	#pragma fragment frag
     	 
        	//include fog
        	#pragma multi_compile_fog      	 

        	// GPU Instancing
        	#pragma multi_compile_instancing

        	#pragma multi_compile _ _MAIN_LIGHT_SHADOWS
        	#pragma multi_compile _ _MAIN_LIGHT_SHADOWS_CASCADE
        	#pragma multi_compile _ _SHADOWS_SOFT
        	#pragma shader_feature _ALPHATEST_ON
        	#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
      	 
         	CBUFFER_START(UnityPerMaterial)
         	half4 _TintColor;
         	sampler2D _MainTex;
         	float4 _MainTex_ST;
         	float   _Alpha;
         	CBUFFER_END
       	 
         	struct VertexInput
         	{
            	float4 vertex : POSITION;
            	float2 uv 	: TEXCOORD0;
            	float3 normal : NORMAL;
         	 
            	UNITY_VERTEX_INPUT_INSTANCE_ID                         	 
          	};

        	struct VertexOutput
          	{
           	float4 vertex  	: SV_POSITION;
           	float2 uv      	: TEXCOORD0;
           	float fogCoord 	: TEXCOORD1;
           	float3 normal  	: NORMAL;
                       	 
           	float4 shadowCoord : TEXCOORD2;
        	 
           	//if shader need a view direction, use below code in shader 
            	//float3 WorldSpaceViewDirection : TEXCOORD3;

           	UNITY_VERTEX_INPUT_INSTANCE_ID
           	UNITY_VERTEX_OUTPUT_STEREO
          	};

      	VertexOutput vert(VertexInput v)
        	{
          	VertexOutput o;
          	UNITY_SETUP_INSTANCE_ID(v);
          	UNITY_TRANSFER_INSTANCE_ID(v, o);
          	UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

          	o.vertex = TransformObjectToHClip(v.vertex.xyz);
                     	
          	o.uv = v.uv.xy * _MainTex_ST.xy + _MainTex_ST.zw; ;
          	o.normal = normalize(mul(v.normal, (float3x3)UNITY_MATRIX_I_M));
         	 
          	o.fogCoord = ComputeFogFactor(o.vertex.z);
            	 
          	VertexPositionInputs vertexInput = GetVertexPositionInputs(v.vertex.xyz);
          	o.shadowCoord = GetShadowCoord(vertexInput);
       	 
          	//view direction
          	//o.WorldSpaceViewDirection = _WorldSpaceCameraPos.xyz - mul(GetObjectToWorldMatrix(), float4(v.vertex.xyz, 1.0)).xyz;
 
          	return o;
        	}

        	half4 frag(VertexOutput i) : SV_Target
        	{
          	UNITY_SETUP_INSTANCE_ID(i);
          	UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);
         	 
          	float4 col = tex2D(_MainTex, i.uv) * _TintColor;
          	
              //below texture sampling code does not use in material inspector          	
          	// float4 col = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, i.uv);
         	
          	Light mainLight = GetMainLight(i.shadowCoord);
          	
          	//Lighting Calculate(Lambert)         	 
          	float NdotL = saturate(dot(normalize(_MainLightPosition.xyz), i.normal));       	 
          	float3 ambient = SampleSH(i.normal);        	 

              // half receiveshadow = MainLightRealtimeShadow(i.shadowCoord);
          	// col.rgb *= NdotL * _MainLightColor.rgb * receiveshadow + ambient;

          	col.rgb *= NdotL * _MainLightColor.rgb * mainLight.shadowAttenuation + ambient;
        	 
   		   #if _ALPHATEST_ON
   		   clip(col.a - _Alpha);
   		   #endif

              //apply fog
          	col.rgb = MixFog(col.rgb, i.fogCoord);
        	 

          	return col;       	 
        	}

        	ENDHLSL  
    	}

        Pass
        {
            Name "ShadowCaster"
    
            Tags{"LightMode" = "ShadowCaster"}
    
                Cull Back
    
                HLSLPROGRAM
    
                #pragma prefer_hlslcc gles
                #pragma exclude_renderers d3d11_9x
                #pragma target 2.0
    
                #pragma vertex ShadowPassVertex
                #pragma fragment ShadowPassFragment
                
                #pragma shader_feature _ALPHATEST_ON
    
               // GPU Instancing
                #pragma multi_compile_instancing
              
                #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
                #include "Packages/com.unity.render-pipelines.universal/Shaders/LitInput.hlsl"
                #include "Packages/com.unity.render-pipelines.universal/Shaders/ShadowCasterPass.hlsl"
    
    
                 CBUFFER_START(UnityPerMaterial)
                 half4 _TintColor;
                 sampler2D _MainTex;
                 float4 _MainTex_ST;
                 float   _Alpha;
                 CBUFFER_END
    
                struct VertexInput
                {      	
                float4 vertex : POSITION;
                float4 normal : NORMAL;
                
                #if _ALPHATEST_ON
                float2 uv 	: TEXCOORD0;
                #endif
    
                UNITY_VERTEX_INPUT_INSTANCE_ID 
                 };
              
                struct VertexOutput
                {      	
                float4 vertex : SV_POSITION;
                #if _ALPHATEST_ON
                float2 uv 	: TEXCOORD0;
                #endif
                UNITY_VERTEX_INPUT_INSTANCE_ID      	
                UNITY_VERTEX_OUTPUT_STEREO
     
                 };
    
                VertexOutput ShadowPassVertex(VertexInput v)
                {
                   VertexOutput o;
                   UNITY_SETUP_INSTANCE_ID(v);
                   UNITY_TRANSFER_INSTANCE_ID(v, o);
                  UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);                         	
               
                  float3 positionWS = TransformObjectToWorld(v.vertex.xyz);
                  float3 normalWS   = TransformObjectToWorldNormal(v.normal.xyz);
             
                  float4 positionCS = TransformWorldToHClip(ApplyShadowBias(positionWS, normalWS, _MainLightPosition.xyz));
                  
                  o.vertex = positionCS;
                 #if _ALPHATEST_ON
                  o.uv = v.uv * _MainTex_ST.xy + _MainTex_ST.zw; ;
                 #endif
    
                  return o;
                }
    
                half4 ShadowPassFragment(VertexOutput i) : SV_TARGET
                {  
                    UNITY_SETUP_INSTANCE_ID(i);
                    UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);
                  
                    #if _ALPHATEST_ON
                    float4 col = tex2D(_MainTex, i.uv);
                    clip(col.a - _Alpha);
                    #endif
    
                    return 0;
                }
    
                ENDHLSL
            }
            Pass
            {
                Name "DepthOnly"
                Tags{"LightMode" = "DepthOnly"}
    
                ZWrite On
                ColorMask 0
    
                Cull Back
    
                HLSLPROGRAM
               
                #pragma prefer_hlslcc gles
                #pragma exclude_renderers d3d11_9x
                #pragma target 2.0
       
                // GPU Instancing
                #pragma multi_compile_instancing
    
                #pragma vertex vert
                #pragma fragment frag
                   
                #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
                   
                CBUFFER_START(UnityPerMaterial)
                CBUFFER_END
                   
                struct VertexInput
                {
                    float4 vertex : POSITION;              	 
                    UNITY_VERTEX_INPUT_INSTANCE_ID
                };
    
                    struct VertexOutput
                    {      	 
                    float4 vertex : SV_POSITION;
                     
                    UNITY_VERTEX_INPUT_INSTANCE_ID      	 
                    UNITY_VERTEX_OUTPUT_STEREO            	 
                    };
    
                VertexOutput vert(VertexInput v)
                {
                    VertexOutput o;
                    UNITY_SETUP_INSTANCE_ID(v);
                    UNITY_TRANSFER_INSTANCE_ID(v, o);
                    UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
    
                    o.vertex = TransformObjectToHClip(v.vertex.xyz);
    
                    return o;
                }
    
                half4 frag(VertexOutput IN) : SV_TARGET
                {  	 
                    return 0;
                }
                ENDHLSL
            }
    }
}
