Texture2D<float4> blendTex;
SamplerState _blendTex_sampler;
Texture2D<float4> colorTex;
SamplerState _colorTex_sampler;
uniform float2 screenSizeInv;

static float4 fragColor;
static float2 texCoord;
static float4 offset;

struct SPIRV_Cross_Input
{
    float4 offset : TEXCOORD0;
    float2 texCoord : TEXCOORD1;
};

struct SPIRV_Cross_Output
{
    float4 fragColor : SV_Target0;
};

float4 textureLodA(Texture2D<float4> tex, SamplerState _tex_sampler, inout float2 coords, float lod)
{
    coords.y = 1.0f - coords.y;
    return tex.SampleLevel(_tex_sampler, coords, lod);
}

float4 SMAANeighborhoodBlendingPS(float2 texcoord, float4 offset_1)
{
    float4 a;
    a.x = blendTex.SampleLevel(_blendTex_sampler, offset_1.xy, 0.0f).w;
    a.y = blendTex.SampleLevel(_blendTex_sampler, offset_1.zw, 0.0f).y;
    float2 _59 = blendTex.SampleLevel(_blendTex_sampler, texcoord, 0.0f).xz;
    a = float4(a.x, a.y, _59.y, _59.x);
    if (dot(a, 1.0f.xxxx) < 9.9999997473787516355514526367188e-06f)
    {
        float4 color = colorTex.SampleLevel(_colorTex_sampler, texcoord, 0.0f);
        return color;
    }
    else
    {
        bool h = max(a.x, a.z) > max(a.y, a.w);
        float4 blendingOffset = float4(0.0f, a.y, 0.0f, a.w);
        float2 blendingWeight = a.yw;
        if (h)
        {
            blendingOffset.x = a.x;
            blendingOffset.y = 0.0f;
            blendingOffset.z = a.z;
            blendingOffset.w = 0.0f;
            blendingWeight.x = a.x;
            blendingWeight.y = a.z;
        }
        blendingWeight /= dot(blendingWeight, 1.0f.xx).xx;
        float2 tc = float2(texcoord.x, 1.0f - texcoord.y);
        float4 blendingCoord = (blendingOffset * float4(screenSizeInv, -screenSizeInv)) + tc.xyxy;
        float2 param = blendingCoord.xy;
        float param_1 = 0.0f;
        float4 _154 = textureLodA(colorTex, _colorTex_sampler, param, param_1);
        float4 color_1 = _154 * blendingWeight.x;
        float2 param_2 = blendingCoord.zw;
        float param_3 = 0.0f;
        float4 _162 = textureLodA(colorTex, _colorTex_sampler, param_2, param_3);
        color_1 += (_162 * blendingWeight.y);
        return color_1;
    }
    return 0.0f.xxxx;
}

void frag_main()
{
    float2 param = texCoord;
    float4 param_1 = offset;
    fragColor = SMAANeighborhoodBlendingPS(param, param_1);
}

SPIRV_Cross_Output main(SPIRV_Cross_Input stage_input)
{
    texCoord = stage_input.texCoord;
    offset = stage_input.offset;
    frag_main();
    SPIRV_Cross_Output stage_output;
    stage_output.fragColor = fragColor;
    return stage_output;
}
