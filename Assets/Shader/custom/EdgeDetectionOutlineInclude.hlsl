#ifndef SOBAL_EDGE_DETECTION_INCLUDED
#define SOBAL_EDGE_DETECTION_INCLUDED


static float2 sobelSamplePoints[9] = {
	float2(-1, 1), float2(0, 1), float2(1, 1),
	float2(-1, 0), float2(0, 0), float2(1, 0),
	float2(-1, -1), float2(0, -1), float2(1, -1),
};
static float2 diagSamplePoints[4] = {
	float2(-1, 1),float2(1, 1),float2(1, -1),float2(-1, -1),
};
static float2 axisSamplePoints[4] = {
	float2(-1, 0),float2(0, 1),float2(1, 0),float2(0, -1),
};
// Weights for the x component
static float sobelXMatrix[9] = {
	1, 0, -1,
	2, 0, -2,
	1, 0, -1
};

// Weights for the y component
static float sobelYMatrix[9] = {
	1, 2, 1,
	0, 0, 0,
	-1, -2, -1
};

float GetDepth(float2 UV) {
	//return SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV);
	return Linear01Depth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
}
float4 GetDiagDepths(float2 UV, float Thickness) {
	float4 res;
	res.x = GetDepth(UV + _MainTex_TexelSize.xy * diagSamplePoints[0] * Thickness);
	res.y = GetDepth(UV + _MainTex_TexelSize.xy * diagSamplePoints[1] * Thickness);
	res.z = GetDepth(UV + _MainTex_TexelSize.xy * diagSamplePoints[2] * Thickness);
	res.w = GetDepth(UV + _MainTex_TexelSize.xy * diagSamplePoints[3] * Thickness);
}
float4 GetAxisDepths(float2 UV, float Thickness) {
	float4 res;
	res.x = GetDepth(UV + _MainTex_TexelSize.xy * axisSamplePoints[0] * Thickness);
	res.y = GetDepth(UV + _MainTex_TexelSize.xy * axisSamplePoints[1] * Thickness);
	res.z = GetDepth(UV + _MainTex_TexelSize.xy * axisSamplePoints[2] * Thickness);
	res.w = GetDepth(UV + _MainTex_TexelSize.xy * axisSamplePoints[3] * Thickness);
}
// This function runs the sobel algorithm over the depth texture
void DepthSobel_float(float2 UV, float Thickness, out float Out) {
	float2 sobel = 0;
	// We can unroll this loop to make it more efficient
	// The compiler is also smart enough to remove the i=4 iteration, which is always zero
	[unroll] for (int i = 0; i < 9; i++) {
		float depth = GetDepth(UV + _MainTex_TexelSize.xy * sobelSamplePoints[i] * Thickness);
		sobel += depth * float2(sobelXMatrix[i], sobelYMatrix[i]);
	}
	// Get the final sobel value
	Out = length(sobel);
}

// This function just return the depth
void DepthTexture_float(float2 UV, out float Out) {
	Out = GetDepth(UV);
}
#endif