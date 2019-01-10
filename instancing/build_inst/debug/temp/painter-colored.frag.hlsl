static float4 FragColor;
static float4 fragmentColor;

struct SPIRV_Cross_Input
{
    float4 fragmentColor : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float4 FragColor : SV_Target0;
};

void frag_main()
{
    FragColor = fragmentColor;
}

SPIRV_Cross_Output main(SPIRV_Cross_Input stage_input)
{
    fragmentColor = stage_input.fragmentColor;
    frag_main();
    SPIRV_Cross_Output stage_output;
    stage_output.FragColor = FragColor;
    return stage_output;
}
