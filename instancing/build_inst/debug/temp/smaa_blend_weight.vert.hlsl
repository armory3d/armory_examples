uniform float2 screenSize;
uniform float2 screenSizeInv;

static float4 gl_Position;
static float2 texCoord;
static float2 pos;
static float2 pixcoord;
static float4 offset0;
static float4 offset1;
static float4 offset2;

struct SPIRV_Cross_Input
{
    float2 pos : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float4 offset0 : TEXCOORD0;
    float4 offset1 : TEXCOORD1;
    float4 offset2 : TEXCOORD2;
    float2 pixcoord : TEXCOORD3;
    float2 texCoord : TEXCOORD4;
    float4 gl_Position : SV_Position;
};

void vert_main()
{
    texCoord = (pos * 0.5f.xx) + 0.5f.xx;
    pixcoord = texCoord * screenSize;
    offset0 = (screenSizeInv.xyxy * float4(-0.25f, -0.125f, 1.25f, -0.125f)) + texCoord.xyxy;
    offset1 = (screenSizeInv.xyxy * float4(-0.125f, -0.25f, -0.125f, 1.25f)) + texCoord.xyxy;
    offset2 = (screenSizeInv.xxyy * float4(-32.0f, 32.0f, -32.0f, 32.0f)) + float4(offset0.xz, offset1.yw);
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
    stage_output.pixcoord = pixcoord;
    stage_output.offset0 = offset0;
    stage_output.offset1 = offset1;
    stage_output.offset2 = offset2;
    return stage_output;
}
