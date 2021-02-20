Shader "Outlines/BackfaceCullOutline_feature"
{
	Properties{
		_Thickness("Thickness", Range(0.002, 0.08)) = 0.02 // The amount to extrude the outline mesh
		[HDR]_Color("Color", Color) = (1, 1, 1, 1) // The outline color

		[Toggle(USE_SCREEN_SPACE_THICKNESS)] _ScreenSpaceThickness("Screen Space Thickness", Float) = 0
		//Weather or not to use the stencil to hide inner lines
		[Toggle(ENABLE_STENCIL)] _Stencil("Stencil", Float) = 0 

		//should be turned off when stencil is on, otherwise front
		[Enum(UnityEngine.Rendering.CullMode)] _CullMode("Cull Mode", Int) = 0

		// If enabled, this shader will use "smoothed" normals stored in TEXCOORD1 to extrude along
		[Toggle(USE_PRECALCULATED_OUTLINE_NORMALS)]_PrecalculateNormals("Use UV1 normals", Float) = 0
	}
	SubShader{
		Tags { "RenderType" = "Opaque" "RenderPipeline" = "UniversalPipeline" }
		Pass {
			Name "StencilWrite"

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

			// Register our material keywords
			#pragma shader_feature ENABLE_STENCIL

			// Include our logic file
			#include "StencilWrite.hlsl"    

			ENDHLSL
		}
		Pass {
			Name "Outlines"
			// Cull front faces
			Cull [_CullMode]
			ZTest ON
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

			// Register our material keywords
			#pragma shader_feature USE_PRECALCULATED_OUTLINE_NORMALS
			#pragma shader_feature USE_SCREEN_SPACE_THICKNESS

			// Include our logic file
			#include "BackFaceOutlines.hlsl"    

			ENDHLSL
		}
	}
}
