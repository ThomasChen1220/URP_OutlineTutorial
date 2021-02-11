Shader "DepthNormal/DepthTexture" {
	Properties{

	}

	SubShader{
		Tags { "RenderType" = "Opaque" }
		Pass {
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			sampler2D _CameraDepthNormalsTexture;
		sampler2D _CameraDepthTexture;

			struct v2f {
				float4 pos : SV_POSITION;
				half2 uv : TEXCOORD0;
			};

			v2f vert(appdata_base v) {
				v2f o;

				o.pos = UnityObjectToClipPos(v.vertex);

				o.uv = v.texcoord;

				return o;
			}

			half4 frag(v2f i) : SV_Target {
				float depth = SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture, i.uv);
				float linearDepth = Linear01Depth(depth);
				linearDepth = 1 - linearDepth;
				return fixed4(linearDepth, linearDepth, linearDepth, 1.0);

				UNITY_OUTPUT_DEPTH(i.depth);
			}
			ENDCG
		}
	}
}