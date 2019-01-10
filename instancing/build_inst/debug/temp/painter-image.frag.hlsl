Texture2D<float4> tex;
SamplerState _tex_sampler;

static float2 texCoord;
static float4 color;
static float4 FragColor;

struct SPIRV_Cross_Input
{
    float4 color : TEXCOORD0;
    float2 texCoord : TEXCOORD1;
};

struct SPIRV_Cross_Output
{
    float4 FragColor : SV_Target0;
};

void frag_main()
{
    float4 texcolor = tex.Sample(_tex_sampler, texCoord) * color;
    float3 _32 = texcolor.xyz * color.w;
    texcolor = float4(_32.x, _32.y, _32.z, texcolor.w);
    FragColor = texcolor;
}

SPIRV_Cross_Output main(SPIRV_Cross_Input stage_input)
{
    texCoord = stage_input.texCoord;
    color = stage_input.color;
    frag_main();
    SPIRV_Cross_Output stage_output;
    stage_output.FragColor = FragColor;
    return stage_output;
}
