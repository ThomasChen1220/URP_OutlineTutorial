Shader "Outlines/BackfaceCullOutline"
{
	Properties{
		_Thickness("Thickness", Float) = 1 // The amount to extrude the outline mesh
		_Color("Color", Color) = (1, 1, 1, 1) // The outline color
	}
	SubShader{
		Tags { "RenderType" = "Opaque" "RenderPipeline" = "UniversalPipeline" }

		Pass {
			Name "Outlines"
			// Cull front faces
			Cull Front

			HLSLPROGRAM
			// Standard URP requirements
			#pragma prefer_hlslcc gles
			#pragma exclude_renderers d3d11_9x

			// Register our functions
			#pragma vertex Vertex
			#pragma fragment Fragment

			// Include our logic file
			#include "BackFaceOutlines.hlsl"    

			ENDHLSL
		}
	}
}
