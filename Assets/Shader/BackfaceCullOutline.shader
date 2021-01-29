Shader "Outlines/BackfaceCullOutline"
{
	Properties{
		_Thickness("Thickness", Float) = 1 // The amount to extrude the outline mesh
		_Color("Color", Color) = (1, 1, 1, 1) // The outline color
		//_StencilColor("StencilColor", Color) = (1 ,1, 1, 1) 
	}
	SubShader{
		Tags { "RenderType" = "Opaque" "RenderPipeline" = "UniversalPipeline" }
		Pass {
			Name "StencilWrite"

			//ZTest NotEqual
			Stencil
			{
				Ref 1
				Comp always
				Pass replace
				//ZFail keep
			}

			HLSLPROGRAM
			// Standard URP requirements
			#pragma prefer_hlslcc gles
			#pragma exclude_renderers d3d11_9x

			// Register our functions
			#pragma vertex Vertex
			#pragma fragment Fragment

			// Include our logic file
			#include "StencilWrite.hlsl"    

			ENDHLSL
		}
		Pass {
			Name "Outlines"
			// Cull front faces
			Cull Front

			Stencil
			{
				Ref 1
				Comp notequal
				Fail keep
				Pass replace
			}

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
