uniform float3x3 N;
uniform float4x4 WVP;

static float4 gl_Position;
static float4 pos;
static float3 wnormal;
static float2 nor;
static float4 wvpposition;

struct SPIRV_Cross_Input
{
    float2 nor : TEXCOORD0;
    float4 pos : TEXCOORD1;
};

struct SPIRV_Cross_Output
{
    float3 wnormal : TEXCOORD0;
    float4 wvpposition : TEXCOORD1;
    float4 gl_Position : SV_Position;
};

void vert_main()
{
    float4 spos = float4(pos.xyz, 1.0f);
    wnormal = normalize(mul(float3(nor, pos.w), N));
    gl_Position = mul(spos, WVP);
    wvpposition = gl_Position;
    gl_Position.z = (gl_Position.z + gl_Position.w) * 0.5;
}

SPIRV_Cross_Output main(SPIRV_Cross_Input stage_input)
{
    pos = stage_input.pos;
    nor = stage_input.nor;
    vert_main();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.wnormal = wnormal;
    stage_output.wvpposition = wvpposition;
    return stage_output;
}
