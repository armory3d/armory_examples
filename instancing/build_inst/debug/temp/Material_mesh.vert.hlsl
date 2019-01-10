uniform float3x3 N;
uniform float4x4 WVP;

static float4 gl_Position;
static float4 pos;
static float3 wnormal;
static float2 nor;
static float3 irot;
static float3 iscl;
static float3 ipos;
static float4 wvpposition;

struct SPIRV_Cross_Input
{
    float3 ipos : TEXCOORD0;
    float3 irot : TEXCOORD1;
    float3 iscl : TEXCOORD2;
    float2 nor : TEXCOORD3;
    float4 pos : TEXCOORD4;
};

struct SPIRV_Cross_Output
{
    float3 wnormal : TEXCOORD0;
    float4 wvpposition : TEXCOORD1;
    float4 gl_Position : SV_Position;
};

// Returns the determinant of a 2x2 matrix.
float SPIRV_Cross_Det2x2(float a1, float a2, float b1, float b2)
{
    return a1 * b2 - b1 * a2;
}

// Returns the inverse of a matrix, by using the algorithm of calculating the classical
// adjoint and dividing by the determinant. The contents of the matrix are changed.
float3x3 SPIRV_Cross_Inverse(float3x3 m)
{
    float3x3 adj;	// The adjoint matrix (inverse after dividing by determinant)

    // Create the transpose of the cofactors, as the classical adjoint of the matrix.
    adj[0][0] =  SPIRV_Cross_Det2x2(m[1][1], m[1][2], m[2][1], m[2][2]);
    adj[0][1] = -SPIRV_Cross_Det2x2(m[0][1], m[0][2], m[2][1], m[2][2]);
    adj[0][2] =  SPIRV_Cross_Det2x2(m[0][1], m[0][2], m[1][1], m[1][2]);

    adj[1][0] = -SPIRV_Cross_Det2x2(m[1][0], m[1][2], m[2][0], m[2][2]);
    adj[1][1] =  SPIRV_Cross_Det2x2(m[0][0], m[0][2], m[2][0], m[2][2]);
    adj[1][2] = -SPIRV_Cross_Det2x2(m[0][0], m[0][2], m[1][0], m[1][2]);

    adj[2][0] =  SPIRV_Cross_Det2x2(m[1][0], m[1][1], m[2][0], m[2][1]);
    adj[2][1] = -SPIRV_Cross_Det2x2(m[0][0], m[0][1], m[2][0], m[2][1]);
    adj[2][2] =  SPIRV_Cross_Det2x2(m[0][0], m[0][1], m[1][0], m[1][1]);

    // Calculate the determinant as a combination of the cofactors of the first row.
    float det = (adj[0][0] * m[0][0]) + (adj[0][1] * m[1][0]) + (adj[0][2] * m[2][0]);

    // Divide the classical adjoint matrix by the determinant.
    // If determinant is zero, matrix is not invertable, so leave it unchanged.
    return (det != 0.0f) ? (adj * (1.0f / det)) : m;
}

void vert_main()
{
    float4 spos = float4(pos.xyz, 1.0f);
    wnormal = normalize(mul(float3(nor, pos.w), N));
    float srotx = sin(irot.x);
    float crotx = cos(irot.x);
    float sroty = sin(irot.y);
    float croty = cos(irot.y);
    float srotz = sin(irot.z);
    float crotz = cos(irot.z);
    float3x3 mirot = float3x3(float3(croty * crotz, srotz, (-sroty) * crotz), float3((((-croty) * srotz) * crotx) + (sroty * srotx), crotz * crotx, ((sroty * srotz) * crotx) + (croty * srotx)), float3(((croty * srotz) * srotx) + (sroty * crotx), (-crotz) * srotx, (((-sroty) * srotz) * srotx) + (croty * crotx)));
    float3 _133 = mul(spos.xyz, mirot);
    spos = float4(_133.x, _133.y, _133.z, spos.w);
    wnormal = mul(wnormal, transpose(SPIRV_Cross_Inverse(mirot)));
    float3 _145 = spos.xyz * iscl;
    spos = float4(_145.x, _145.y, _145.z, spos.w);
    float3 _152 = spos.xyz + ipos;
    spos = float4(_152.x, _152.y, _152.z, spos.w);
    gl_Position = mul(spos, WVP);
    wvpposition = gl_Position;
    gl_Position.z = (gl_Position.z + gl_Position.w) * 0.5;
}

SPIRV_Cross_Output main(SPIRV_Cross_Input stage_input)
{
    pos = stage_input.pos;
    nor = stage_input.nor;
    irot = stage_input.irot;
    iscl = stage_input.iscl;
    ipos = stage_input.ipos;
    vert_main();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.wnormal = wnormal;
    stage_output.wvpposition = wvpposition;
    return stage_output;
}
