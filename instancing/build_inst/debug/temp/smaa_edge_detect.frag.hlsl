Texture2D<float4> colorTex;
SamplerState _colorTex_sampler;

static float4 offset0;
static float4 offset1;
static float4 offset2;
static float4 fragColor;
static float2 texCoord;

struct SPIRV_Cross_Input
{
    float4 offset0 : TEXCOORD0;
    float4 offset1 : TEXCOORD1;
    float4 offset2 : TEXCOORD2;
    float2 texCoord : TEXCOORD3;
};

struct SPIRV_Cross_Output
{
    float4 fragColor : SV_Target0;
};

float2 SMAAColorEdgeDetectionPS(float2 texcoord)
{
    float2 threshold = 0.100000001490116119384765625f.xx;
    float3 C = colorTex.SampleLevel(_colorTex_sampler, texcoord, 0.0f).xyz;
    float3 Cleft = colorTex.SampleLevel(_colorTex_sampler, offset0.xy, 0.0f).xyz;
    float3 t = abs(C - Cleft);
    float4 delta;
    delta.x = max(max(t.x, t.y), t.z);
    float3 Ctop = colorTex.SampleLevel(_colorTex_sampler, offset0.zw, 0.0f).xyz;
    t = abs(C - Ctop);
    delta.y = max(max(t.x, t.y), t.z);
    float2 edges = step(threshold, delta.xy);
    if (dot(edges, 1.0f.xx) == 0.0f)
    {
        discard;
    }
    float3 Cright = colorTex.SampleLevel(_colorTex_sampler, offset1.xy, 0.0f).xyz;
    t = abs(C - Cright);
    delta.z = max(max(t.x, t.y), t.z);
    float3 Cbottom = colorTex.SampleLevel(_colorTex_sampler, offset1.zw, 0.0f).xyz;
    t = abs(C - Cbottom);
    delta.w = max(max(t.x, t.y), t.z);
    float2 maxDelta = max(delta.xy, delta.zw);
    float3 Cleftleft = colorTex.SampleLevel(_colorTex_sampler, offset2.xy, 0.0f).xyz;
    t = abs(C - Cleftleft);
    delta.z = max(max(t.x, t.y), t.z);
    float3 Ctoptop = colorTex.SampleLevel(_colorTex_sampler, offset2.zw, 0.0f).xyz;
    t = abs(C - Ctoptop);
    delta.w = max(max(t.x, t.y), t.z);
    maxDelta = max(maxDelta, delta.zw);
    float finalDelta = max(maxDelta.x, maxDelta.y);
    edges *= step(finalDelta.xx, delta.xy * 2.0f);
    return edges;
}

void frag_main()
{
    float2 param = texCoord;
    float2 _204 = SMAAColorEdgeDetectionPS(param);
    fragColor = float4(_204.x, _204.y, fragColor.z, fragColor.w);
}

SPIRV_Cross_Output main(SPIRV_Cross_Input stage_input)
{
    offset0 = stage_input.offset0;
    offset1 = stage_input.offset1;
    offset2 = stage_input.offset2;
    texCoord = stage_input.texCoord;
    frag_main();
    SPIRV_Cross_Output stage_output;
    stage_output.fragColor = fragColor;
    return stage_output;
}
