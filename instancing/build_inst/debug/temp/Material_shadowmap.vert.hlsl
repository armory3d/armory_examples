uniform float4x4 LWVP;

static float4 gl_Position;
static float4 pos;
static float3 irot;
static float3 iscl;
static float3 ipos;

struct SPIRV_Cross_Input
{
    float3 ipos : TEXCOORD0;
    float3 irot : TEXCOORD1;
    float3 iscl : TEXCOORD2;
    float4 pos : TEXCOORD3;
};

struct SPIRV_Cross_Output
{
    float4 gl_Position : SV_Position;
};

void vert_main()
{
    float4 spos = float4(pos.xyz, 1.0f);
    float srotx = sin(irot.x);
    float crotx = cos(irot.x);
    float sroty = sin(irot.y);
    float croty = cos(irot.y);
    float srotz = sin(irot.z);
    float crotz = cos(irot.z);
    float3x3 mirot = float3x3(float3(croty * crotz, srotz, (-sroty) * crotz), float3((((-croty) * srotz) * crotx) + (sroty * srotx), crotz * crotx, ((sroty * srotz) * crotx) + (croty * srotx)), float3(((croty * srotz) * srotx) + (sroty * crotx), (-crotz) * srotx, (((-sroty) * srotz) * srotx) + (croty * crotx)));
    float3 _116 = mul(spos.xyz, mirot);
    spos = float4(_116.x, _116.y, _116.z, spos.w);
    float3 _123 = spos.xyz * iscl;
    spos = float4(_123.x, _123.y, _123.z, spos.w);
    float3 _130 = spos.xyz + ipos;
    spos = float4(_130.x, _130.y, _130.z, spos.w);
    gl_Position = mul(spos, LWVP);
    gl_Position.z = (gl_Position.z + gl_Position.w) * 0.5;
}

SPIRV_Cross_Output main(SPIRV_Cross_Input stage_input)
{
    pos = stage_input.pos;
    irot = stage_input.irot;
    iscl = stage_input.iscl;
    ipos = stage_input.ipos;
    vert_main();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    return stage_output;
}
