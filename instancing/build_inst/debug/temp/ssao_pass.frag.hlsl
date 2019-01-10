Texture2D<float4> gbufferD;
SamplerState _gbufferD_sampler;
Texture2D<float4> gbuffer0;
SamplerState _gbuffer0_sampler;
uniform float3 eyeLook;
uniform float2 cameraProj;
uniform float2 screenSize;
uniform float3 eye;
uniform float4x4 invVP;

static float2 texCoord;
static float fragColor;
static float3 viewRay;

struct SPIRV_Cross_Input
{
    float2 texCoord : TEXCOORD0;
    float3 viewRay : TEXCOORD1;
};

struct SPIRV_Cross_Output
{
    float fragColor : SV_Target0;
};

float2 octahedronWrap(float2 v)
{
    return (1.0f.xx - abs(v.yx)) * float2((v.x >= 0.0f) ? 1.0f : (-1.0f), (v.y >= 0.0f) ? 1.0f : (-1.0f));
}

float3 getPosNoEye(float3 eyeLook_1, float3 viewRay_1, float depth, float2 cameraProj_1)
{
    float linearDepth = cameraProj_1.y / (((depth * 0.5f) + 0.5f) - cameraProj_1.x);
    float viewZDist = dot(eyeLook_1, viewRay_1);
    float3 wposition = viewRay_1 * (linearDepth / viewZDist);
    return wposition;
}

float3 getPos2NoEye(float3 eye_1, float4x4 invVP_1, float depth, inout float2 coord)
{
    coord.y = 1.0f - coord.y;
    float4 pos = float4((coord * 2.0f) - 1.0f.xx, depth, 1.0f);
    pos = mul(pos, invVP_1);
    float3 _93 = pos.xyz / pos.w.xxx;
    pos = float4(_93.x, _93.y, _93.z, pos.w);
    return pos.xyz - eye_1;
}

void frag_main()
{
    float depth = (gbufferD.SampleLevel(_gbufferD_sampler, texCoord, 0.0f).x * 2.0f) - 1.0f;
    if (depth == 1.0f)
    {
        fragColor = 1.0f;
        return;
    }
    float2 enc = gbuffer0.SampleLevel(_gbuffer0_sampler, texCoord, 0.0f).xy;
    float3 n;
    n.z = (1.0f - abs(enc.x)) - abs(enc.y);
    float2 _141;
    if (n.z >= 0.0f)
    {
        _141 = enc;
    }
    else
    {
        _141 = octahedronWrap(enc);
    }
    n = float3(_141.x, _141.y, n.z);
    n = normalize(n);
    float3 vray = normalize(viewRay);
    float3 currentPos = getPosNoEye(eyeLook, vray, depth, cameraProj);
    float currentDistance = length(currentPos);
    float currentDistanceA = (currentDistance * 20.0f) * 1.0f;
    float currentDistanceB = currentDistance * 0.0005000000237487256526947021484375f;
    int2 px = int2(texCoord * screenSize);
    float phi = float(((3 * px.x) ^ (px.y + (px.x * px.y))) * 10);
    fragColor = 0.0f;
    for (int i = 0; i < 8; i++)
    {
        float theta = (0.785398185253143310546875f * (float(i) + 0.5f)) + phi;
        float2 k = float2(cos(theta), sin(theta)) / currentDistanceA.xx;
        depth = (gbufferD.SampleLevel(_gbufferD_sampler, texCoord + k, 0.0f).x * 2.0f) - 1.0f;
        float2 param = texCoord + k;
        float3 _253 = getPos2NoEye(eye, invVP, depth, param);
        float3 pos = _253 - currentPos;
        fragColor += (max(0.0f, dot(pos, n) - currentDistanceB) / (dot(pos, pos) + 0.014999999664723873138427734375f));
    }
    fragColor *= 0.037500001490116119384765625f;
    fragColor = 1.0f - fragColor;
}

SPIRV_Cross_Output main(SPIRV_Cross_Input stage_input)
{
    texCoord = stage_input.texCoord;
    viewRay = stage_input.viewRay;
    frag_main();
    SPIRV_Cross_Output stage_output;
    stage_output.fragColor = fragColor;
    return stage_output;
}
