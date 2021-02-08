#ifndef GETMAINLIGHTDIRECTION_INCLUDED
#define GETMAINLIGHTDIRECTION_INCLUDED

void GetMainLightDirection_float(out float3 Out)
{
#ifdef SHADERGRAPH_PREVIEW
	Out = float3(-1, 0, 0);
#else 
	Out = GetMainLight().direction;
#endif
}

#endif