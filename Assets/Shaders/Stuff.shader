// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "GK/Stuff" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic ("Metallic", Range(0,1)) = 0.0
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200

		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard fullforwardshadows vertex:vert

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0
        #define LUMA_VECTOR float4(0.2126, 0.7152, 0.0722, 0.0)

        #include "UnityCG.cginc"

		sampler2D _MainTex;

		struct Input {
			float2 uv_MainTex;
            float2 vis;
		};

		half _Glossiness;
		half _Metallic;
		fixed4 _Color;

        uniform sampler2D visibilityTexture;
        uniform sampler2D cumulativeVisibilityTexture;
        uniform float4x4 visibilityTransform;

		// Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
		// See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
		// #pragma instancing_options assumeuniformscaling
		UNITY_INSTANCING_CBUFFER_START(Props)
			// put more per-instance properties here
		UNITY_INSTANCING_CBUFFER_END

        void vert (inout appdata_full v, out Input o) {
            UNITY_INITIALIZE_OUTPUT(Input,o);
            //o.uv_Visibility = mul(visibilityTransform, mul(unity_ObjectToWorld, v.vertex));
            //v.vertex.xyz += float3(2, 0, 0);
            o.vis = mul(visibilityTransform, mul(unity_ObjectToWorld, v.vertex)).xy;
            //o.uv_Visibility = mul(unity_ObjectToWorld, v.vertex).xz;
            //o.vis = v.vertex.xz;
        }

		void surf (Input IN, inout SurfaceOutputStandard o) {

            fixed visibility = tex2Dlod(visibilityTexture, float4(IN.vis, 0.0, 0.0)).r;
            fixed cumulativeVisibility = tex2Dlod(cumulativeVisibilityTexture, float4(IN.vis, 0.0, 0.0)).r;

			fixed4 color = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            fixed greyColor = dot(color, LUMA_VECTOR);
            fixed4 grey = fixed4(greyColor, greyColor, greyColor, 1.0);
            fixed4 black = fixed4(0.0, 0.0, 0.0, 1.0);


            //o.Albedo = fixed3(IN.vis.xy, 0.0);
            //o.Albedo = fixed3(visibility, visibility, visibility);
            //o.Albedo = black.rgb;
            //o.Albedo = color.rgb;
            //o.Albedo = black * (1 - cumulativeVisibility) + cumulativeVisibility * grey;
			o.Albedo = lerp(lerp(black, grey, cumulativeVisibility), color, visibility).rgb;
            //o.Albedo = grey;
            //o.Albedo = fixed4(0.0, 0.0, 1.0, 1.0);

			//o.Metallic = _Metallic;
			//o.Smoothness = _Glossiness;
			o.Alpha = 1.0f;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
