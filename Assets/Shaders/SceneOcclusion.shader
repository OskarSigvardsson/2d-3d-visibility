Shader "GK/SceneOcclusion"
{
	Properties
	{
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" "DisableBatching" = "True"}
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float4 normal : NORMAL;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
			};


			v2f vert (appdata v)
			{
				v2f o;
				//o.vertex = UnityObjectToClipPos(v.vertex);
				//o.vertex = UnityObjectToClipPos(v.vertex - v.normal);
				o.vertex = UnityObjectToClipPos(0.99 * v.vertex);
				return o;
			}

			fixed frag (v2f i) : SV_Target
			{
				return 1.0;
			}
			ENDCG
		}
	}
}
