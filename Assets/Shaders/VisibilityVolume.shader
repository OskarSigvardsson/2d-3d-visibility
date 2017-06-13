Shader "GK/VisibilityVolume"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
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
			
			#include "UnityCG.cginc"

			#define TAU 6.28318530717958647692
			#define PI (TAU/2)
			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			uniform sampler2D _MainTex;
			uniform float4 _MainTex_ST;
            uniform float2 player_position;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				return o;
			}
			
			float frag (v2f i) : SV_Target
			{
                float2 dp = i.uv - player_position;
                float angle = atan2(dp.y, dp.x);
                float x = angle / TAU + 0.5;
                float distSqr = dot(dp, dp);
                float visDist = tex2Dlod(_MainTex, float4(x, 0.0, 0.0, 0.0));

				return step(distSqr, visDist * visDist);
			}
			ENDCG
		}
	}
}
