static float3 wnormal;
static float4 fragColor[2];
static float4 wvpposition;

struct SPIRV_Cross_Input
{
    float3 wnormal : TEXCOORD0;
    float4 wvpposition : TEXCOORD1;
};

struct SPIRV_Cross_Output
{
    float4 fragColor[2] : SV_Target0;
};

float2 octahedronWrap(float2 v)
{
    return (1.0f.xx - abs(v.yx)) * float2((v.x >= 0.0f) ? 1.0f : (-1.0f), (v.y >= 0.0f) ? 1.0f : (-1.0f));
}

float packFloat(float f1, float f2)
{
    return floor(f1 * 100.0f) + min(f2, 0.9900000095367431640625f);
}

float packFloat2(float f1, float f2)
{
    return floor(f1 * 255.0f) + min(f2, 0.9900000095367431640625f);
}

void frag_main()
{
    float3 n = normalize(wnormal);
    float3 basecol = 0.800000011920928955078125f.xxx;
    float roughness = 0.5f;
    float metallic = 0.0f;
    float occlusion = 1.0f;
    float specular = 0.5f;
    n /= ((abs(n.x) + abs(n.y)) + abs(n.z)).xxx;
    float2 _92;
    if (n.z >= 0.0f)
    {
        _92 = n.xy;
    }
    else
    {
        _92 = octahedronWrap(n.xy);
    }
    n = float3(_92.x, _92.y, n.z);
    fragColor[0] = float4(n.xy, packFloat(metallic, roughness), 1.0f);
    fragColor[1] = float4(basecol, packFloat2(occlusion, specular));
}

SPIRV_Cross_Output main(SPIRV_Cross_Input stage_input)
{
    wnormal = stage_input.wnormal;
    wvpposition = stage_input.wvpposition;
    frag_main();
    SPIRV_Cross_Output stage_output;
    stage_output.fragColor = fragColor;
    return stage_output;
}
