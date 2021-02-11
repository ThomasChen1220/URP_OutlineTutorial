Shader "DepthNormal/NormalTexture" {
	Properties{

	}

	SubShader{
		Tags { "RenderType" = "Opaque" }
		Pass {
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			struct v2f {
				float4 pos : SV_POSITION;
				float4 nz : TEXCOORD0;
			};
			v2f vert(appdata_base v) {
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				o.pos = UnityObjectToClipPos(v.vertex);
				o.nz.xyz = COMPUTE_VIEW_NORMAL;
				//o.nz.w = COMPUTE_DEPTH_01;
				return o;
			}
			fixed4 frag(v2f i) : SV_Target {
				//normal = DecodeViewNormalStereo(enc);
				//return EncodeDepthNormal(i.nz.w, i.nz.xyz);
				return float4(i.nz.xyz, 1);
			}
			ENDCG
		}
	}
}