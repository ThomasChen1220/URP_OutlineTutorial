#ifndef BACKFACEOUTLINES_INCLUDED
#define BACKFACEOUTLINES_INCLUDED

// Include helper functions from URP
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

// Data from the meshes
struct Attributes {
	float4 positionOS       : POSITION; // Position in object space
	float3 normalOS         : NORMAL; // Normal vector in object space
};

// Output from the vertex function and input to the fragment function
struct VertexOutput {
	float4 positionCS   : SV_POSITION; // Position in clip space
};

// Properties
float _Thickness;
float4 _Color;

VertexOutput Vertex(Attributes input) {
	VertexOutput output = (VertexOutput)0;

	float3 normalOS = input.normalOS;

	float3 posWS = TransformObjectToWorld(input.positionOS);
	float3 normalWS = TransformObjectToWorldNormal(input.normalOS);

	// Extrude the world space position along a normal vector
	posWS = posWS + normalWS * _Thickness;
	// Convert this position to world and clip space
	output.positionCS = TransformWorldToHClip(posWS);

	//float4 posCS = TransformObjectToHClip(input.positionOS);
	//float4 normalCS = TransformObjectToHClip(input.normalOS);

	//// Extrude the world space position along a normal vector
	//posCS = posCS + normalCS * _Thickness;
	//// Convert this position to world and clip space
	//output.positionCS = posCS;

	return output;
}

float4 Fragment(VertexOutput input) : SV_Target{
	return _Color;
}

#endif