static float3 wnormal;
static float3 bposition;
static float4 fragColor[2];
static float4 wvpposition;

struct SPIRV_Cross_Input
{
    float3 bposition : TEXCOORD0;
    float3 wnormal : TEXCOORD1;
    float4 wvpposition : TEXCOORD2;
};

struct SPIRV_Cross_Output
{
    float4 fragColor[2] : SV_Target0;
};

float mod(float x, float y)
{
    return x - y * floor(x / y);
}

float2 mod(float2 x, float2 y)
{
    return x - y * floor(x / y);
}

float3 mod(float3 x, float3 y)
{
    return x - y * floor(x / y);
}

float4 mod(float4 x, float4 y)
{
    return x - y * floor(x / y);
}

float3 tex_checker(float3 co, float3 col1, float3 col2, float scale)
{
    float3 p = (co + 9.9999897429370321333408355712891e-07f.xxx) * scale;
    float xi = abs(floor(p.x));
    float yi = abs(floor(p.y));
    float zi = abs(floor(p.z));
    bool check = (mod(xi, 2.0f) == mod(yi, 2.0f)) == (mod(zi, 2.0f) != 0.0f);
    bool3 _102 = check.xxx;
    return float3(_102.x ? col1.x : col2.x, _102.y ? col1.y : col2.y, _102.z ? col1.z : col2.z);
}

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
    float3 CheckerTexture_Color_res = tex_checker(bposition, 0.800000011920928955078125f.xxx, 0.20000000298023223876953125f.xxx, 2.0f);
    float3 basecol = CheckerTexture_Color_res;
    float roughness = 0.100000001490116119384765625f;
    float metallic = 0.0f;
    float occlusion = 1.0f;
    float specular = 0.5f;
    n /= ((abs(n.x) + abs(n.y)) + abs(n.z)).xxx;
    float2 _145;
    if (n.z >= 0.0f)
    {
        _145 = n.xy;
    }
    else
    {
        _145 = octahedronWrap(n.xy);
    }
    n = float3(_145.x, _145.y, n.z);
    fragColor[0] = float4(n.xy, packFloat(metallic, roughness), 1.0f);
    fragColor[1] = float4(basecol, packFloat2(occlusion, specular));
}

SPIRV_Cross_Output main(SPIRV_Cross_Input stage_input)
{
    wnormal = stage_input.wnormal;
    bposition = stage_input.bposition;
    wvpposition = stage_input.wvpposition;
    frag_main();
    SPIRV_Cross_Output stage_output;
    stage_output.fragColor = fragColor;
    return stage_output;
}
