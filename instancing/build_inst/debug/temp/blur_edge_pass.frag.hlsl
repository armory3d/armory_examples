static const float _144[10] = { 0.132571995258331298828125f, 0.12547199428081512451171875f, 0.10637299716472625732421875f, 0.0807799994945526123046875f, 0.0549499988555908203125f, 0.03348200023174285888671875f, 0.018275000154972076416015625f, 0.008933999575674533843994140625f, 0.00391199998557567596435546875f, 0.00153500004671514034271240234375f };

Texture2D<float4> gbuffer0;
SamplerState _gbuffer0_sampler;
Texture2D<float4> tex;
SamplerState _tex_sampler;
uniform float2 dirInv;

static float2 texCoord;
static float fragColor;

struct SPIRV_Cross_Input
{
    float2 texCoord : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float fragColor : SV_Target0;
};

float2 octahedronWrap(float2 v)
{
    return (1.0f.xx - abs(v.yx)) * float2((v.x >= 0.0f) ? 1.0f : (-1.0f), (v.y >= 0.0f) ? 1.0f : (-1.0f));
}

float3 getNor(float2 enc)
{
    float3 n;
    n.z = (1.0f - abs(enc.x)) - abs(enc.y);
    float2 _53;
    if (n.z >= 0.0f)
    {
        _53 = enc;
    }
    else
    {
        _53 = octahedronWrap(enc);
    }
    n = float3(_53.x, _53.y, n.z);
    n = normalize(n);
    return n;
}

void frag_main()
{
    float3 nor = getNor(gbuffer0.SampleLevel(_gbuffer0_sampler, texCoord, 0.0f).xy);
    fragColor = tex.SampleLevel(_tex_sampler, texCoord, 0.0f).x * 0.132571995258331298828125f;
    float weight = 0.132571995258331298828125f;
    for (int i = 1; i < 8; i++)
    {
        float posadd = float(i);
        float3 nor2 = getNor(gbuffer0.SampleLevel(_gbuffer0_sampler, texCoord + (dirInv * float(i)), 0.0f).xy);
        float influenceFactor = step(0.949999988079071044921875f, dot(nor2, nor));
        float col = tex.SampleLevel(_tex_sampler, texCoord + (dirInv * posadd), 0.0f).x;
        float indexable[10] = _144;
        float w = indexable[i] * influenceFactor;
        fragColor += (col * w);
        weight += w;
        nor2 = getNor(gbuffer0.SampleLevel(_gbuffer0_sampler, texCoord - (dirInv * float(i)), 0.0f).xy);
        influenceFactor = step(0.949999988079071044921875f, dot(nor2, nor));
        col = tex.SampleLevel(_tex_sampler, texCoord - (dirInv * posadd), 0.0f).x;
        float indexable_1[10] = _144;
        w = indexable_1[i] * influenceFactor;
        fragColor += (col * w);
        weight += w;
    }
    fragColor /= weight;
}

SPIRV_Cross_Output main(SPIRV_Cross_Input stage_input)
{
    texCoord = stage_input.texCoord;
    frag_main();
    SPIRV_Cross_Output stage_output;
    stage_output.fragColor = fragColor;
    return stage_output;
}
