#ifndef SOBAL_EDGE_DETECTION_INCLUDED
#define SOBAL_EDGE_DETECTION_INCLUDED


static float2 sobelSamplePoints[9] = {
	float2(-1, 1), float2(0, 1), float2(1, 1),
	float2(-1, 0), float2(0, 0), float2(1, 0),
	float2(-1, -1), float2(0, -1), float2(1, -1),
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
	return LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
	//return Linear01Depth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
}
// This function runs the sobel algorithm over the depth texture
void DepthSobel_float(float2 UV, float Thickness, out float Out) {
	float2 sobel = 0;
	float centerDepth = GetDepth(UV);
	// We can unroll this loop to make it more efficient
	// The compiler is also smart enough to remove the i=4 iteration, which is always zero
	[unroll] for (int i = 0; i < 9; i++) {
		float depth = GetDepth(UV + _MainTex_TexelSize.xy * sobelSamplePoints[i] * Thickness);
		depth = (depth > centerDepth) ? depth : centerDepth;
		sobel += depth * float2(sobelXMatrix[i], sobelYMatrix[i]);
	}
	// Get the final sobel value
	Out = length(sobel);
}

TEXTURE2D(_NormalTexture);
SAMPLER(sampler_NormalTexture);

// This function runs the sobel algorithm over the opaque texture
void NormalsSobel_float(float2 UV, float Thickness, out float Out) {
	Thickness /= 2;
	// We have to run the sobel algorithm over the XYZ channels separately, like color
	float2 sobelX = 0;
	float2 sobelY = 0;
	float2 sobelZ = 0;
	// We can unroll this loop to make it more efficient
	// The compiler is also smart enough to remove the i=4 iteration, which is always zero
	[unroll] for (int i = 0; i < 9; i++) {
		float2 uvPos = UV + _MainTex_TexelSize.xy * sobelSamplePoints[i] * Thickness;
		float3 normal = SAMPLE_TEXTURE2D(_NormalTexture, sampler_NormalTexture, uvPos);
		// Create the kernel for this iteration
		float2 kernel = float2(sobelXMatrix[i], sobelYMatrix[i]);
		// Accumulate samples for each coordinate
		sobelX += normal.x * kernel;
		sobelY += normal.y * kernel;
		sobelZ += normal.z * kernel;
	}
	// Get the final sobel value
	// Combine the XYZ values by taking the one with the largest sobel value
	Out = max(length(sobelX), max(length(sobelY), length(sobelZ)));
}

// This function just return the depth
void DepthTexture_float(float2 UV, out float Out) {
	Out = GetDepth(UV);
}
void NormalTexture_float(float2 UV, out float3 Out) {
	Out = SAMPLE_TEXTURE2D(_NormalTexture, sampler_NormalTexture, UV);
}
void ViewDirectionFromScreenUV_float(float2 In, out float3 Out) {
	// Code by Keijiro Takahashi @_kzr and Ben Golus @bgolus
	// Get the perspective projection
	float2 p11_22 = float2(unity_CameraProjection._11, unity_CameraProjection._22);
	// Convert the uvs into view space by "undoing" projection
	Out = -normalize(float3((In * 2 - 1) / p11_22, -1));
}

#endif