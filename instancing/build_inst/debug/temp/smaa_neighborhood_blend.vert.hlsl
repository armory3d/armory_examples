uniform float2 screenSizeInv;

static float4 gl_Position;
static float2 texCoord;
static float2 pos;
static float4 offset;

struct SPIRV_Cross_Input
{
    float2 pos : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float4 offset : TEXCOORD0;
    float2 texCoord : TEXCOORD1;
    float4 gl_Position : SV_Position;
};

void vert_main()
{
    texCoord = (pos * 0.5f.xx) + 0.5f.xx;
    texCoord.y = 1.0f - texCoord.y;
    offset = (screenSizeInv.xyxy * float4(1.0f, 0.0f, 0.0f, -1.0f)) + texCoord.xyxy;
    gl_Position = float4(pos, 0.0f, 1.0f);
    gl_Position.z = (gl_Position.z + gl_Position.w) * 0.5;
}

SPIRV_Cross_Output main(SPIRV_Cross_Input stage_input)
{
    pos = stage_input.pos;
    vert_main();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.texCoord = texCoord;
    stage_output.offset = offset;
    return stage_output;
}
