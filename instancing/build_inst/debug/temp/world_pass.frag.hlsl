uniform float3 H;
uniform float3 A;
uniform float3 B;
uniform float3 C;
uniform float3 D;
uniform float3 E;
uniform float3 F;
uniform float3 G;
uniform float3 I;
uniform float3 hosekSunDirection;
uniform float3 Z;
uniform float envmapStrength;

static float3 normal;
static float4 fragColor;

struct SPIRV_Cross_Input
{
    float3 normal : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float4 fragColor : SV_Target0;
};

float3 hosekWilkie(float cos_theta, float gamma, float cos_gamma)
{
    float3 chi = (1.0f + (cos_gamma * cos_gamma)).xxx / pow((1.0f.xxx + (H * H)) - (H * (2.0f * cos_gamma)), 1.5f.xxx);
    return (1.0f.xxx + (A * exp(B / (cos_theta + 0.00999999977648258209228515625f).xxx))) * ((((C + (D * exp(E * gamma))) + (F * (cos_gamma * cos_gamma))) + (G * chi)) + (I * sqrt(cos_theta)));
}

void frag_main()
{
    float3 n = normalize(normal);
    float phi = acos(n.z);
    float theta = atan2(-n.y, n.x) + 3.1415927410125732421875f;
    float cos_theta = clamp(n.z, 0.0f, 1.0f);
    float cos_gamma = dot(n, hosekSunDirection);
    float gamma_val = acos(cos_gamma);
    float param = cos_theta;
    float param_1 = gamma_val;
    float param_2 = cos_gamma;
    float3 _136 = (Z * hosekWilkie(param, param_1, param_2)) * envmapStrength;
    fragColor = float4(_136.x, _136.y, _136.z, fragColor.w);
}

SPIRV_Cross_Output main(SPIRV_Cross_Input stage_input)
{
    normal = stage_input.normal;
    frag_main();
    SPIRV_Cross_Output stage_output;
    stage_output.fragColor = fragColor;
    return stage_output;
}
