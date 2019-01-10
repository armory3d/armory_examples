TextureCube<float4> shadowMapPoint[1];
SamplerComparisonState _shadowMapPoint_sampler[1];
uniform float2 lightProj;
uniform float4 shirr[7];
Texture2D<float4> gbuffer0;
SamplerState _gbuffer0_sampler;
Texture2D<float4> gbuffer1;
SamplerState _gbuffer1_sampler;
Texture2D<float4> gbufferD;
SamplerState _gbufferD_sampler;
uniform float3 eye;
uniform float3 eyeLook;
uniform float2 cameraProj;
Texture2D<float4> senvmapBrdf;
SamplerState _senvmapBrdf_sampler;
uniform int envmapNumMipmaps;
Texture2D<float4> senvmapRadiance;
SamplerState _senvmapRadiance_sampler;
uniform float envmapStrength;
Texture2D<float4> ssaotex;
SamplerState _ssaotex_sampler;
uniform float3 pointPos;
uniform float3 pointCol;
uniform float pointBias;
uniform float4 casData[20];

static float2 texCoord;
static float3 viewRay;
static float4 fragColor;

struct SPIRV_Cross_Input
{
    float2 texCoord : TEXCOORD0;
    float3 viewRay : TEXCOORD1;
};

struct SPIRV_Cross_Output
{
    float4 fragColor : SV_Target0;
};

float2 octahedronWrap(float2 v)
{
    return (1.0f.xx - abs(v.yx)) * float2((v.x >= 0.0f) ? 1.0f : (-1.0f), (v.y >= 0.0f) ? 1.0f : (-1.0f));
}

float2 unpackFloat(float f)
{
    return float2(floor(f) / 100.0f, frac(f));
}

float2 unpackFloat2(float f)
{
    return float2(floor(f) / 255.0f, frac(f));
}

float3 surfaceAlbedo(float3 baseColor, float metalness)
{
    return lerp(baseColor, 0.0f.xxx, metalness.xxx);
}

float3 surfaceF0(float3 baseColor, float metalness)
{
    return lerp(0.039999999105930328369140625f.xxx, baseColor, metalness.xxx);
}

float3 getPos(float3 eye_1, float3 eyeLook_1, float3 viewRay_1, float depth, float2 cameraProj_1)
{
    float linearDepth = cameraProj_1.y / (((depth * 0.5f) + 0.5f) - cameraProj_1.x);
    float viewZDist = dot(eyeLook_1, viewRay_1);
    float3 wposition = eye_1 + (viewRay_1 * (linearDepth / viewZDist));
    return wposition;
}

float3 shIrradiance(float3 nor)
{
    float3 cl00 = float3(shirr[0].x, shirr[0].y, shirr[0].z);
    float3 cl1m1 = float3(shirr[0].w, shirr[1].x, shirr[1].y);
    float3 cl10 = float3(shirr[1].z, shirr[1].w, shirr[2].x);
    float3 cl11 = float3(shirr[2].y, shirr[2].z, shirr[2].w);
    float3 cl2m2 = float3(shirr[3].x, shirr[3].y, shirr[3].z);
    float3 cl2m1 = float3(shirr[3].w, shirr[4].x, shirr[4].y);
    float3 cl20 = float3(shirr[4].z, shirr[4].w, shirr[5].x);
    float3 cl21 = float3(shirr[5].y, shirr[5].z, shirr[5].w);
    float3 cl22 = float3(shirr[6].x, shirr[6].y, shirr[6].z);
    return ((((((((((cl22 * 0.429042994976043701171875f) * ((nor.y * nor.y) - ((-nor.z) * (-nor.z)))) + (((cl20 * 0.743125021457672119140625f) * nor.x) * nor.x)) + (cl00 * 0.88622701168060302734375f)) - (cl20 * 0.2477079927921295166015625f)) + (((cl2m2 * 0.85808598995208740234375f) * nor.y) * (-nor.z))) + (((cl21 * 0.85808598995208740234375f) * nor.y) * nor.x)) + (((cl2m1 * 0.85808598995208740234375f) * (-nor.z)) * nor.x)) + ((cl11 * 1.02332794666290283203125f) * nor.y)) + ((cl1m1 * 1.02332794666290283203125f) * (-nor.z))) + ((cl10 * 1.02332794666290283203125f) * nor.x);
}

float getMipFromRoughness(float roughness, float numMipmaps)
{
    return roughness * numMipmaps;
}

float2 envMapEquirect(float3 normal)
{
    float phi = acos(normal.z);
    float theta = atan2(-normal.y, normal.x) + 3.1415927410125732421875f;
    return float2(theta / 6.283185482025146484375f, phi / 3.1415927410125732421875f);
}

float3 lambertDiffuseBRDF(float3 albedo, float nl)
{
    return albedo * max(0.0f, nl);
}

float d_ggx(float nh, float a)
{
    float a2 = a * a;
    float denom = pow(((nh * nh) * (a2 - 1.0f)) + 1.0f, 2.0f);
    return (a2 * 0.3183098733425140380859375f) / denom;
}

float v_smithschlick(float nl, float nv, float a)
{
    return 1.0f / (((nl * (1.0f - a)) + a) * ((nv * (1.0f - a)) + a));
}

float3 f_schlick(float3 f0, float vh)
{
    return f0 + ((1.0f.xxx - f0) * exp2((((-5.554729938507080078125f) * vh) - 6.9831600189208984375f) * vh));
}

float3 specularBRDF(float3 f0, float roughness, float nl, float nh, float nv, float vh)
{
    float a = roughness * roughness;
    return (f_schlick(f0, vh) * (d_ggx(nh, a) * clamp(v_smithschlick(nl, nv, a), 0.0f, 1.0f))) / 4.0f.xxx;
}

float attenuate(float dist)
{
    return 1.0f / (dist * dist);
}

float lpToDepth(inout float3 lp, float2 lightProj_1)
{
    lp = abs(lp);
    float zcomp = max(lp.x, max(lp.y, lp.z));
    zcomp = lightProj_1.x - (lightProj_1.y / zcomp);
    return (zcomp * 0.5f) + 0.5f;
}

float PCFCube(TextureCube<float4> shadowMapCube, SamplerComparisonState _shadowMapCube_sampler, float3 lp, inout float3 ml, float bias, float2 lightProj_1, float3 n)
{
    float3 param = lp - ((n * bias) * 80.0f);
    float _293 = lpToDepth(param, lightProj_1);
    float compare = _293;
    ml += ((n * bias) * 80.0f);
    float4 _306 = float4(ml, compare);
    float result = shadowMapCube.SampleCmp(_shadowMapCube_sampler, _306.xyz, _306.w);
    float4 _318 = float4(ml + 0.001000000047497451305389404296875f.xxx, compare);
    result += shadowMapCube.SampleCmp(_shadowMapCube_sampler, _318.xyz, _318.w);
    float4 _332 = float4(ml + float3(-0.001000000047497451305389404296875f, 0.001000000047497451305389404296875f, 0.001000000047497451305389404296875f), compare);
    result += shadowMapCube.SampleCmp(_shadowMapCube_sampler, _332.xyz, _332.w);
    float4 _345 = float4(ml + float3(0.001000000047497451305389404296875f, -0.001000000047497451305389404296875f, 0.001000000047497451305389404296875f), compare);
    result += shadowMapCube.SampleCmp(_shadowMapCube_sampler, _345.xyz, _345.w);
    float4 _358 = float4(ml + float3(0.001000000047497451305389404296875f, 0.001000000047497451305389404296875f, -0.001000000047497451305389404296875f), compare);
    result += shadowMapCube.SampleCmp(_shadowMapCube_sampler, _358.xyz, _358.w);
    float4 _371 = float4(ml + float3(-0.001000000047497451305389404296875f, -0.001000000047497451305389404296875f, 0.001000000047497451305389404296875f), compare);
    result += shadowMapCube.SampleCmp(_shadowMapCube_sampler, _371.xyz, _371.w);
    float4 _384 = float4(ml + float3(0.001000000047497451305389404296875f, -0.001000000047497451305389404296875f, -0.001000000047497451305389404296875f), compare);
    result += shadowMapCube.SampleCmp(_shadowMapCube_sampler, _384.xyz, _384.w);
    float4 _397 = float4(ml + float3(-0.001000000047497451305389404296875f, 0.001000000047497451305389404296875f, -0.001000000047497451305389404296875f), compare);
    result += shadowMapCube.SampleCmp(_shadowMapCube_sampler, _397.xyz, _397.w);
    float4 _410 = float4(ml + (-0.001000000047497451305389404296875f).xxx, compare);
    result += shadowMapCube.SampleCmp(_shadowMapCube_sampler, _410.xyz, _410.w);
    return result / 9.0f;
}

float3 sampleLight(float3 p, float3 n, float3 v, float dotNV, float3 lp, float3 lightCol, float3 albedo, float rough, float spec, float3 f0, int index, float bias)
{
    float3 ld = lp - p;
    float3 l = normalize(ld);
    float3 h = normalize(v + l);
    float dotNH = dot(n, h);
    float dotVH = dot(v, h);
    float dotNL = dot(n, l);
    float3 direct = lambertDiffuseBRDF(albedo, dotNL) + (specularBRDF(f0, rough, dotNL, dotNH, dotNV, dotVH) * spec);
    direct *= lightCol;
    direct *= attenuate(distance(p, lp));
    float3 param = -l;
    float _466 = PCFCube(shadowMapPoint[0], _shadowMapPoint_sampler[0], ld, param, bias, lightProj, n);
    direct *= _466;
    return direct;
}

void frag_main()
{
    float4 g0 = gbuffer0.SampleLevel(_gbuffer0_sampler, texCoord, 0.0f);
    float3 n;
    n.z = (1.0f - abs(g0.x)) - abs(g0.y);
    float2 _653;
    if (n.z >= 0.0f)
    {
        _653 = g0.xy;
    }
    else
    {
        _653 = octahedronWrap(g0.xy);
    }
    n = float3(_653.x, _653.y, n.z);
    n = normalize(n);
    float2 metrough = unpackFloat(g0.z);
    float4 g1 = gbuffer1.SampleLevel(_gbuffer1_sampler, texCoord, 0.0f);
    float2 occspec = unpackFloat2(g1.w);
    float3 albedo = surfaceAlbedo(g1.xyz, metrough.x);
    float3 f0 = surfaceF0(g1.xyz, metrough.x);
    float depth = (gbufferD.SampleLevel(_gbufferD_sampler, texCoord, 0.0f).x * 2.0f) - 1.0f;
    float3 p = getPos(eye, eyeLook, normalize(viewRay), depth, cameraProj);
    float3 v = normalize(eye - p);
    float dotNV = max(dot(n, v), 0.0f);
    float2 envBRDF = senvmapBrdf.SampleLevel(_senvmapBrdf_sampler, float2(metrough.y, 1.0f - dotNV), 0.0f).xy;
    float3 envl = shIrradiance(n);
    float3 reflectionWorld = reflect(-v, n);
    float lod = getMipFromRoughness(metrough.y, float(envmapNumMipmaps));
    float3 prefilteredColor = senvmapRadiance.SampleLevel(_senvmapRadiance_sampler, envMapEquirect(reflectionWorld), lod).xyz;
    envl *= albedo;
    envl += (((prefilteredColor * ((f0 * envBRDF.x) + envBRDF.y.xxx)) * 1.5f) * occspec.y);
    envl *= (envmapStrength * occspec.x);
    fragColor = float4(envl.x, envl.y, envl.z, fragColor.w);
    float3 _797 = fragColor.xyz * ssaotex.SampleLevel(_ssaotex_sampler, texCoord, 0.0f).x;
    fragColor = float4(_797.x, _797.y, _797.z, fragColor.w);
    int param = 0;
    float param_1 = pointBias;
    float3 _821 = fragColor.xyz + sampleLight(p, n, v, dotNV, pointPos, pointCol, albedo, metrough.y, occspec.y, f0, param, param_1);
    fragColor = float4(_821.x, _821.y, _821.z, fragColor.w);
}

SPIRV_Cross_Output main(SPIRV_Cross_Input stage_input)
{
    texCoord = stage_input.texCoord;
    viewRay = stage_input.viewRay;
    frag_main();
    SPIRV_Cross_Output stage_output;
    stage_output.fragColor = fragColor;
    return stage_output;
}
