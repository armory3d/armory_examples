uniform float2 screenSizeInv;
Texture2D<float4> edgesTex;
SamplerState _edgesTex_sampler;
Texture2D<float4> areaTex;
SamplerState _areaTex_sampler;
Texture2D<float4> searchTex;
SamplerState _searchTex_sampler;
uniform float2 screenSize;

static float4 offset0;
static float4 offset2;
static float4 offset1;
static float4 fragColor;
static float2 texCoord;
static float2 pixcoord;

struct SPIRV_Cross_Input
{
    float4 offset0 : TEXCOORD0;
    float4 offset1 : TEXCOORD1;
    float4 offset2 : TEXCOORD2;
    float2 pixcoord : TEXCOORD3;
    float2 texCoord : TEXCOORD4;
};

struct SPIRV_Cross_Output
{
    float4 fragColor : SV_Target0;
};

static float2 cdw_end;

float4 textureLodA(Texture2D<float4> tex, SamplerState _tex_sampler, inout float2 coord, float lod)
{
    coord.y = 1.0f - coord.y;
    return tex.SampleLevel(_tex_sampler, coord, lod);
}

float2 SMAASearchDiag1(float2 texcoord, float2 dir)
{
    float4 coord = float4(texcoord, -1.0f, 1.0f);
    float3 t = float3(screenSizeInv, 1.0f);
    float cw = coord.w;
    while ((coord.z < 7.0f) && (cw > 0.89999997615814208984375f))
    {
        float3 _186 = (t * float3(dir, 1.0f)) + coord.xyz;
        coord = float4(_186.x, _186.y, _186.z, coord.w);
        float2 param = coord.xy;
        float param_1 = 0.0f;
        float4 _197 = textureLodA(edgesTex, _edgesTex_sampler, param, param_1);
        cdw_end = _197.xy;
        cw = dot(cdw_end, 0.5f.xx);
    }
    coord.w = cw;
    return coord.zw;
}

float4 SMAADecodeDiagBilinearAccess(inout float4 e)
{
    float2 _135 = e.xz * abs((e.xz * 5.0f) - 3.75f.xx);
    e = float4(_135.x, e.y, _135.y, e.w);
    return floor(e + 0.5f.xxxx);
}

float2 SMAAAreaDiag(float2 dist, float2 e, float offset)
{
    float2 texcoord = (20.0f.xx * e) + dist;
    texcoord = (float2(0.0062500000931322574615478515625f, 0.001785714295692741870880126953125f) * texcoord) + float2(0.00312500004656612873077392578125f, 0.0008928571478463709354400634765625f);
    texcoord.x += 0.5f;
    texcoord.y += (0.14285714924335479736328125f * offset);
    return areaTex.SampleLevel(_areaTex_sampler, texcoord, 0.0f).xy;
}

float2 SMAADecodeDiagBilinearAccess(inout float2 e)
{
    e.x *= abs((5.0f * e.x) - 3.75f);
    return floor(e + 0.5f.xx);
}

float2 SMAASearchDiag2(float2 texcoord, float2 dir)
{
    float4 coord = float4(texcoord, -1.0f, 1.0f);
    coord.x += (0.25f * screenSizeInv.x);
    float3 t = float3(screenSizeInv, 1.0f);
    float cw = coord.w;
    while ((coord.z < 7.0f) && (cw > 0.89999997615814208984375f))
    {
        float3 _249 = (t * float3(dir, 1.0f)) + coord.xyz;
        coord = float4(_249.x, _249.y, _249.z, coord.w);
        float2 param = coord.xy;
        float param_1 = 0.0f;
        float4 _256 = textureLodA(edgesTex, _edgesTex_sampler, param, param_1);
        cdw_end = _256.xy;
        float2 param_2 = cdw_end;
        float2 _260 = SMAADecodeDiagBilinearAccess(param_2);
        cdw_end = _260;
        cw = dot(cdw_end, 0.5f.xx);
    }
    coord.w = cw;
    return coord.zw;
}

float2 SMAACalculateDiagWeights(float2 texcoord, float2 e, float4 subsampleIndices)
{
    float2 weights = 0.0f.xx;
    float4 d;
    if (e.x > 0.0f)
    {
        float2 param = texcoord;
        float2 param_1 = float2(-1.0f, 1.0f);
        float2 _315 = SMAASearchDiag1(param, param_1);
        d = float4(_315.x, d.y, _315.y, d.w);
        float dadd = float(cdw_end.y > 0.89999997615814208984375f);
        d.x += dadd;
    }
    else
    {
        d = float4(0.0f.xx.x, d.y, 0.0f.xx.y, d.w);
    }
    float2 param_2 = texcoord;
    float2 param_3 = float2(1.0f, -1.0f);
    float2 _336 = SMAASearchDiag1(param_2, param_3);
    d = float4(d.x, _336.x, d.z, _336.y);
    if ((d.x + d.y) > 2.0f)
    {
        float4 coords = (float4((-d.x) + 0.25f, d.x, d.y, (-d.y) - 0.25f) * screenSizeInv.xyxy) + texcoord.xyxy;
        float2 param_4 = coords.xy + (float2(-1.0f, 0.0f) * screenSizeInv);
        float param_5 = 0.0f;
        float4 _377 = textureLodA(edgesTex, _edgesTex_sampler, param_4, param_5);
        float4 c;
        c = float4(_377.xy.x, _377.xy.y, c.z, c.w);
        float2 param_6 = coords.zw + (float2(1.0f, 0.0f) * screenSizeInv);
        float param_7 = 0.0f;
        float4 _389 = textureLodA(edgesTex, _edgesTex_sampler, param_6, param_7);
        c = float4(c.x, c.y, _389.xy.x, _389.xy.y);
        float4 param_8 = c;
        float4 _395 = SMAADecodeDiagBilinearAccess(param_8);
        c = float4(_395.y, _395.x, _395.w, _395.z);
        float2 cc = (2.0f.xx * c.xz) + c.yw;
        float a1condx = step(0.89999997615814208984375f, d.z);
        float a1condy = step(0.89999997615814208984375f, d.w);
        if (a1condx == 1.0f)
        {
            cc.x = 0.0f;
        }
        if (a1condy == 1.0f)
        {
            cc.y = 0.0f;
        }
        float2 param_9 = d.xy;
        float2 param_10 = cc;
        float param_11 = subsampleIndices.z;
        weights += SMAAAreaDiag(param_9, param_10, param_11);
    }
    float2 param_12 = texcoord;
    float2 param_13 = (-1.0f).xx;
    float2 _439 = SMAASearchDiag2(param_12, param_13);
    d = float4(_439.x, d.y, _439.y, d.w);
    float2 param_14 = texcoord + (float2(1.0f, 0.0f) * screenSizeInv);
    float param_15 = 0.0f;
    float4 _448 = textureLodA(edgesTex, _edgesTex_sampler, param_14, param_15);
    if (_448.x > 0.0f)
    {
        float2 param_16 = texcoord;
        float2 param_17 = 1.0f.xx;
        float2 _457 = SMAASearchDiag2(param_16, param_17);
        d = float4(d.x, _457.x, d.z, _457.y);
        float dadd_1 = float(cdw_end.y > 0.89999997615814208984375f);
        d.y += dadd_1;
    }
    else
    {
        d = float4(d.x, 0.0f.xx.x, d.z, 0.0f.xx.y);
    }
    if ((d.x + d.y) > 2.0f)
    {
        float4 coords_1 = (float4(-d.x, -d.x, d.y, d.y) * screenSizeInv.xyxy) + texcoord.xyxy;
        float2 param_18 = coords_1.xy + (float2(-1.0f, 0.0f) * screenSizeInv);
        float param_19 = 0.0f;
        float4 _507 = textureLodA(edgesTex, _edgesTex_sampler, param_18, param_19);
        float4 c_1;
        c_1.x = _507.y;
        float2 param_20 = coords_1.xy + (float2(0.0f, -1.0f) * screenSizeInv);
        float param_21 = 0.0f;
        float4 _518 = textureLodA(edgesTex, _edgesTex_sampler, param_20, param_21);
        c_1.y = _518.x;
        float2 param_22 = coords_1.zw + (float2(1.0f, 0.0f) * screenSizeInv);
        float param_23 = 0.0f;
        float4 _528 = textureLodA(edgesTex, _edgesTex_sampler, param_22, param_23);
        c_1 = float4(c_1.x, c_1.y, _528.yx.x, _528.yx.y);
        float2 cc_1 = (2.0f.xx * c_1.xz) + c_1.yw;
        float a1condx_1 = step(0.89999997615814208984375f, d.z);
        float a1condy_1 = step(0.89999997615814208984375f, d.w);
        if (a1condx_1 == 1.0f)
        {
            cc_1.x = 0.0f;
        }
        if (a1condy_1 == 1.0f)
        {
            cc_1.y = 0.0f;
        }
        float2 param_24 = d.xy;
        float2 param_25 = cc_1;
        float param_26 = subsampleIndices.w;
        weights += SMAAAreaDiag(param_24, param_25, param_26).yx;
    }
    return weights;
}

float SMAASearchLength(float2 e, float offset)
{
    float2 scale = float2(33.0f, -33.0f);
    float2 bias = float2(66.0f, 33.0f) * float2(offset, 1.0f);
    scale += float2(-1.0f, 1.0f);
    bias += float2(0.5f, -0.5f);
    scale *= float2(0.015625f, 0.0625f);
    bias *= float2(0.015625f, 0.0625f);
    float2 coord = (scale * e) + bias;
    return searchTex.SampleLevel(_searchTex_sampler, coord, 0.0f).x;
}

float SMAASearchXLeft(inout float2 texcoord, float end)
{
    float2 e = float2(0.0f, 1.0f);
    for (;;)
    {
        float _616 = texcoord.x;
        float _617 = end;
        bool _618 = _616 > _617;
        bool _625;
        if (_618)
        {
            _625 = e.y > 0.828100025653839111328125f;
        }
        else
        {
            _625 = _618;
        }
        bool _631;
        if (_625)
        {
            _631 = e.x == 0.0f;
        }
        else
        {
            _631 = _625;
        }
        if (_631)
        {
            float2 param = texcoord;
            float param_1 = 0.0f;
            float4 _635 = textureLodA(edgesTex, _edgesTex_sampler, param, param_1);
            e = _635.xy;
            texcoord = (float2(-2.0f, -0.0f) * screenSizeInv) + texcoord;
            continue;
        }
        else
        {
            break;
        }
    }
    float2 param_2 = e;
    float param_3 = 0.0f;
    float offset = ((-2.007874011993408203125f) * SMAASearchLength(param_2, param_3)) + 3.25f;
    return (screenSizeInv.x * offset) + texcoord.x;
}

float SMAASearchXRight(inout float2 texcoord, float end)
{
    float2 e = float2(0.0f, 1.0f);
    for (;;)
    {
        float _669 = texcoord.x;
        float _670 = end;
        bool _671 = _669 < _670;
        bool _677;
        if (_671)
        {
            _677 = e.y > 0.828100025653839111328125f;
        }
        else
        {
            _677 = _671;
        }
        bool _683;
        if (_677)
        {
            _683 = e.x == 0.0f;
        }
        else
        {
            _683 = _677;
        }
        if (_683)
        {
            float2 param = texcoord;
            float param_1 = 0.0f;
            float4 _687 = textureLodA(edgesTex, _edgesTex_sampler, param, param_1);
            e = _687.xy;
            texcoord = (float2(2.0f, 0.0f) * screenSizeInv) + texcoord;
            continue;
        }
        else
        {
            break;
        }
    }
    float2 param_2 = e;
    float param_3 = 0.5f;
    float offset = ((-2.007874011993408203125f) * SMAASearchLength(param_2, param_3)) + 3.25f;
    return ((-screenSizeInv.x) * offset) + texcoord.x;
}

float2 SMAAArea(float2 dist, float e1, float e2, float offset)
{
    float2 texcoord = (16.0f.xx * floor((float2(e1, e2) * 4.0f) + 0.5f.xx)) + dist;
    texcoord = (float2(0.0062500000931322574615478515625f, 0.001785714295692741870880126953125f) * texcoord) + float2(0.00312500004656612873077392578125f, 0.0008928571478463709354400634765625f);
    texcoord.y = (0.14285714924335479736328125f * offset) + texcoord.y;
    return areaTex.SampleLevel(_areaTex_sampler, texcoord, 0.0f).xy;
}

float2 SMAADetectHorizontalCornerPattern(inout float2 weights, float4 texcoord, float2 d)
{
    float2 leftRight = step(d, d.yx);
    float2 rounding = leftRight * 0.75f;
    rounding /= (leftRight.x + leftRight.y).xx;
    float2 factor = 1.0f.xx;
    float2 param = texcoord.xy + (float2(0.0f, 1.0f) * screenSizeInv);
    float param_1 = 0.0f;
    float4 _866 = textureLodA(edgesTex, _edgesTex_sampler, param, param_1);
    factor.x -= (rounding.x * _866.x);
    float2 param_2 = texcoord.zw + (1.0f.xx * screenSizeInv);
    float param_3 = 0.0f;
    float4 _882 = textureLodA(edgesTex, _edgesTex_sampler, param_2, param_3);
    factor.x -= (rounding.y * _882.x);
    float2 param_4 = texcoord.xy + (float2(0.0f, -2.0f) * screenSizeInv);
    float param_5 = 0.0f;
    float4 _899 = textureLodA(edgesTex, _edgesTex_sampler, param_4, param_5);
    factor.y -= (rounding.x * _899.x);
    float2 param_6 = texcoord.zw + (float2(1.0f, -2.0f) * screenSizeInv);
    float param_7 = 0.0f;
    float4 _916 = textureLodA(edgesTex, _edgesTex_sampler, param_6, param_7);
    factor.y -= (rounding.y * _916.x);
    weights *= clamp(factor, 0.0f.xx, 1.0f.xx);
    return weights;
}

float SMAASearchYUp(inout float2 texcoord, float end)
{
    float2 e = float2(1.0f, 0.0f);
    for (;;)
    {
        float _718 = texcoord.y;
        float _719 = end;
        bool _720 = _718 > _719;
        bool _726;
        if (_720)
        {
            _726 = e.x > 0.828100025653839111328125f;
        }
        else
        {
            _726 = _720;
        }
        bool _732;
        if (_726)
        {
            _732 = e.y == 0.0f;
        }
        else
        {
            _732 = _726;
        }
        if (_732)
        {
            float2 param = texcoord;
            float param_1 = 0.0f;
            float4 _736 = textureLodA(edgesTex, _edgesTex_sampler, param, param_1);
            e = _736.xy;
            texcoord = (float2(-0.0f, -2.0f) * screenSizeInv) + texcoord;
            continue;
        }
        else
        {
            break;
        }
    }
    float2 param_2 = e.yx;
    float param_3 = 0.0f;
    float offset = ((-2.007874011993408203125f) * SMAASearchLength(param_2, param_3)) + 3.25f;
    return (screenSizeInv.y * offset) + texcoord.y;
}

float SMAASearchYDown(inout float2 texcoord, float end)
{
    float2 e = float2(1.0f, 0.0f);
    for (;;)
    {
        float _767 = texcoord.y;
        float _768 = end;
        bool _769 = _767 < _768;
        bool _775;
        if (_769)
        {
            _775 = e.x > 0.828100025653839111328125f;
        }
        else
        {
            _775 = _769;
        }
        bool _781;
        if (_775)
        {
            _781 = e.y == 0.0f;
        }
        else
        {
            _781 = _775;
        }
        if (_781)
        {
            float2 param = texcoord;
            float param_1 = 0.0f;
            float4 _785 = textureLodA(edgesTex, _edgesTex_sampler, param, param_1);
            e = _785.xy;
            texcoord = (float2(0.0f, 2.0f) * screenSizeInv) + texcoord;
            continue;
        }
        else
        {
            break;
        }
    }
    float2 param_2 = e.yx;
    float param_3 = 0.5f;
    float offset = ((-2.007874011993408203125f) * SMAASearchLength(param_2, param_3)) + 3.25f;
    return ((-screenSizeInv.y) * offset) + texcoord.y;
}

float2 SMAADetectVerticalCornerPattern(inout float2 weights, float4 texcoord, float2 d)
{
    float2 leftRight = step(d, d.yx);
    float2 rounding = leftRight * 0.75f;
    rounding /= (leftRight.x + leftRight.y).xx;
    float2 factor = 1.0f.xx;
    float2 param = texcoord.xy + (float2(1.0f, 0.0f) * screenSizeInv);
    float param_1 = 0.0f;
    float4 _958 = textureLodA(edgesTex, _edgesTex_sampler, param, param_1);
    factor.x -= (rounding.x * _958.y);
    float2 param_2 = texcoord.zw + (1.0f.xx * screenSizeInv);
    float param_3 = 0.0f;
    float4 _974 = textureLodA(edgesTex, _edgesTex_sampler, param_2, param_3);
    factor.x -= (rounding.y * _974.y);
    float2 param_4 = texcoord.xy + (float2(-2.0f, 0.0f) * screenSizeInv);
    float param_5 = 0.0f;
    float4 _991 = textureLodA(edgesTex, _edgesTex_sampler, param_4, param_5);
    factor.y -= (rounding.x * _991.y);
    float2 param_6 = texcoord.zw + (float2(-2.0f, 1.0f) * screenSizeInv);
    float param_7 = 0.0f;
    float4 _1008 = textureLodA(edgesTex, _edgesTex_sampler, param_6, param_7);
    factor.y -= (rounding.y * _1008.y);
    weights *= clamp(factor, 0.0f.xx, 1.0f.xx);
    return weights;
}

float4 SMAABlendingWeightCalculationPS(float2 texcoord, float2 pixcoord_1, float4 subsampleIndices)
{
    float4 weights = 0.0f.xxxx;
    float2 param = texcoord;
    float param_1 = 0.0f;
    float4 _1030 = textureLodA(edgesTex, _edgesTex_sampler, param, param_1);
    float2 e = _1030.xy;
    if (e.y > 0.0f)
    {
        float2 param_2 = texcoord;
        float2 param_3 = e;
        float4 param_4 = subsampleIndices;
        float2 _1043 = SMAACalculateDiagWeights(param_2, param_3, param_4);
        weights = float4(_1043.x, _1043.y, weights.z, weights.w);
        if (weights.x == (-weights.y))
        {
            float2 param_5 = offset0.xy;
            float param_6 = offset2.x;
            float _1065 = SMAASearchXLeft(param_5, param_6);
            float3 coords;
            coords.x = _1065;
            coords.y = offset1.y;
            float2 d;
            d.x = coords.x;
            float2 param_7 = coords.xy;
            float param_8 = 0.0f;
            float4 _1080 = textureLodA(edgesTex, _edgesTex_sampler, param_7, param_8);
            float e1 = _1080.x;
            float2 param_9 = offset0.zw;
            float param_10 = offset2.y;
            float _1088 = SMAASearchXRight(param_9, param_10);
            coords.z = _1088;
            d.y = coords.z;
            d = abs(floor(((screenSize.xx * d) + (-pixcoord_1.xx)) + 0.5f.xx));
            float2 sqrt_d = sqrt(d);
            float2 param_11 = coords.zy + (float2(1.0f, 0.0f) * screenSizeInv);
            float param_12 = 0.0f;
            float4 _1117 = textureLodA(edgesTex, _edgesTex_sampler, param_11, param_12);
            float e2 = _1117.x;
            float2 param_13 = sqrt_d;
            float param_14 = e1;
            float param_15 = e2;
            float param_16 = subsampleIndices.y;
            float2 _1128 = SMAAArea(param_13, param_14, param_15, param_16);
            weights = float4(_1128.x, _1128.y, weights.z, weights.w);
            coords.y = texcoord.y;
            float2 param_17 = weights.xy;
            float4 param_18 = coords.xyzy;
            float2 param_19 = d;
            float2 _1142 = SMAADetectHorizontalCornerPattern(param_17, param_18, param_19);
            weights = float4(_1142.x, _1142.y, weights.z, weights.w);
        }
        else
        {
            e.x = 0.0f;
        }
    }
    if (e.x > 0.0f)
    {
        float2 param_20 = offset1.xy;
        float param_21 = offset2.z;
        float _1159 = SMAASearchYUp(param_20, param_21);
        float3 coords_1;
        coords_1.y = _1159;
        coords_1.x = offset0.x;
        float2 d_1;
        d_1.x = coords_1.y;
        float2 param_22 = coords_1.xy;
        float param_23 = 0.0f;
        float4 _1173 = textureLodA(edgesTex, _edgesTex_sampler, param_22, param_23);
        float e1_1 = _1173.y;
        float2 param_24 = offset1.zw;
        float param_25 = offset2.w;
        float _1181 = SMAASearchYDown(param_24, param_25);
        coords_1.z = _1181;
        d_1.y = coords_1.z;
        d_1 = abs(floor(((screenSize.yy * d_1) + (-pixcoord_1.yy)) + 0.5f.xx));
        float2 sqrt_d_1 = sqrt(d_1);
        float2 param_26 = coords_1.xz + (float2(0.0f, 1.0f) * screenSizeInv);
        float param_27 = 0.0f;
        float4 _1209 = textureLodA(edgesTex, _edgesTex_sampler, param_26, param_27);
        float e2_1 = _1209.y;
        float2 param_28 = sqrt_d_1;
        float param_29 = e1_1;
        float param_30 = e2_1;
        float param_31 = subsampleIndices.x;
        float2 _1220 = SMAAArea(param_28, param_29, param_30, param_31);
        weights = float4(weights.x, weights.y, _1220.x, _1220.y);
        coords_1.x = texcoord.x;
        float2 param_32 = weights.zw;
        float4 param_33 = coords_1.xyxz;
        float2 param_34 = d_1;
        float2 _1234 = SMAADetectVerticalCornerPattern(param_32, param_33, param_34);
        weights = float4(weights.x, weights.y, _1234.x, _1234.y);
    }
    return weights;
}

void frag_main()
{
    float2 param = texCoord;
    float2 param_1 = pixcoord;
    float4 param_2 = 0.0f.xxxx;
    float4 _1250 = SMAABlendingWeightCalculationPS(param, param_1, param_2);
    fragColor = _1250;
}

SPIRV_Cross_Output main(SPIRV_Cross_Input stage_input)
{
    offset0 = stage_input.offset0;
    offset2 = stage_input.offset2;
    offset1 = stage_input.offset1;
    texCoord = stage_input.texCoord;
    pixcoord = stage_input.pixcoord;
    frag_main();
    SPIRV_Cross_Output stage_output;
    stage_output.fragColor = fragColor;
    return stage_output;
}
