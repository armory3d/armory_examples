Texture2D<float4> tex;
SamplerState _tex_sampler;

static float2 texCoord;
static float4 fragColor;

struct SPIRV_Cross_Input
{
    float2 texCoord : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float4 fragColor : SV_Target0;
};

float3 tonemapFilmic(float3 color)
{
    float3 x = max(0.0f.xxx, color - 0.0040000001899898052215576171875f.xxx);
    return (x * ((x * 6.19999980926513671875f) + 0.5f.xxx)) / ((x * ((x * 6.19999980926513671875f) + 1.7000000476837158203125f.xxx)) + 0.0599999986588954925537109375f.xxx);
}

void frag_main()
{
    float2 texCo = texCoord;
    float3 _57 = tex.SampleLevel(_tex_sampler, texCo, 0.0f).xyz;
    fragColor = float4(_57.x, _57.y, _57.z, fragColor.w);
    float3 _62 = tonemapFilmic(fragColor.xyz);
    fragColor = float4(_62.x, _62.y, _62.z, fragColor.w);
}

SPIRV_Cross_Output main(SPIRV_Cross_Input stage_input)
{
    texCoord = stage_input.texCoord;
    frag_main();
    SPIRV_Cross_Output stage_output;
    stage_output.fragColor = fragColor;
    return stage_output;
}
