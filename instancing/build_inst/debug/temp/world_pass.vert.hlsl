uniform float4x4 SMVP;

static float4 gl_Position;
static float3 normal;
static float3 nor;
static float3 pos;

struct SPIRV_Cross_Input
{
    float3 nor : TEXCOORD0;
    float3 pos : TEXCOORD1;
};

struct SPIRV_Cross_Output
{
    float3 normal : TEXCOORD0;
    float4 gl_Position : SV_Position;
};

void vert_main()
{
    normal = nor;
    float4 position = mul(float4(pos, 1.0f), SMVP);
    gl_Position = float4(position);
    gl_Position.z = (gl_Position.z + gl_Position.w) * 0.5;
}

SPIRV_Cross_Output main(SPIRV_Cross_Input stage_input)
{
    nor = stage_input.nor;
    pos = stage_input.pos;
    vert_main();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.normal = normal;
    return stage_output;
}
