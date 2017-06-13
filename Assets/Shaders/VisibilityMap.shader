Shader "GK/VisibilityMap"
{
	Properties
	{
		_MainTex ("Occlusion texture", 2D) = "white" {}
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

			#define TAU 6.28318530717958647692
			#define PI (TAU/2)
			#define STEP_COUNT (1024)
			#define STEP (sqrt(2) * (1.0 / STEP_COUNT))

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				float2 uv : TEXCOORD0;
			};

			uniform float2 player_position;
            uniform float4 _MainTex_ST;
			uniform sampler2D _MainTex;

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				return o;
			}

			float frag (v2f i) : SV_Target
			{
				float angle = PI * ((2.0 * i.uv) + 1);
                float cosa = cos(angle);
                float sina = sin(angle);

                float occlusion = 0.0;
                float dist = 0.0;
				for (int i = 0; i < STEP_COUNT; i++) {
					float2 p = player_position + float2(dist * cosa, dist * sina);

					occlusion += tex2Dlod(_MainTex, float4(p, 0.0, 0.0)).r;

					if (occlusion >= 0.99) {
						return dist;
					}

                    dist += STEP;
				}

				return 1000.0;
			}
			ENDCG
		}
	}
}
