//checking enum in fragment is not ideal but this is for debug so I just leave it like that
Shader "DepthNormal/DepthNormalColor" {
	Properties{
		[KeywordEnum(Depth, Normal, DepthNormal, Color)] _Mode("mode", Float) = 0
	}

	SubShader{

		Tags { "RenderType" = "Opaque" }
		Pass {
			CGPROGRAM
			#pragma multi_compile_fwdbase

			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			sampler2D _DepthTexture;
			sampler2D _DepthNormalsTexture;
		
			float _Mode;

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
			fixed4 frag(v2f i) : SV_Target {
				if (_Mode == 0) {
					return tex2D(_DepthTexture, i.uv);
				}
				else if (_Mode <= 1) {
					return 0;
				}
				else if (_Mode <= 2) {
					return tex2D(_DepthNormalsTexture, i.uv);
				}
				else {
					return 1;
				}
			}
			ENDCG
		}
	}
}