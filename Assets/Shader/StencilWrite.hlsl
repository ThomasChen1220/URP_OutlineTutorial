#ifndef STENCILWRITE_INCLUDED
#define STENCILWRITE_INCLUDED

// Include helper functions from URP
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

// Data from the meshes
struct Attributes {
	float4 positionOS       : POSITION; // Position in object space
};

// Output from the vertex function and input to the fragment function
struct VertexOutput {
	float4 positionCS   : SV_POSITION; // Position in clip space
};

// Properties
float4 _StencilColor;

VertexOutput Vertex(Attributes input) {
	VertexOutput output = (VertexOutput)0;

	// Convert this position to world and clip space
	output.positionCS = GetVertexPositionInputs(input.positionOS).positionCS;

	return output;
}

float4 Fragment(VertexOutput input) : SV_Target{
	//return _StencilColor;
	return float4(0,0,0,0);
}

#endif