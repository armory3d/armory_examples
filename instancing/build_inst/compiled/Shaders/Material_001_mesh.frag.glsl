#version 450
#include "compiled.inc"
#include "std/gbuffer.glsl"
in vec3 wnormal;
in vec4 wvpposition;
in vec3 bposition;
out vec4[2] fragColor;

vec3 tex_checker(const vec3 co, const vec3 col1, const vec3 col2, const float scale) {
    // Prevent precision issues on unit coordinates
    vec3 p = (co + 0.000001 * 0.999999) * scale;
    float xi = abs(floor(p.x));
    float yi = abs(floor(p.y));
    float zi = abs(floor(p.z));
    bool check = ((mod(xi, 2.0) == mod(yi, 2.0)) == bool(mod(zi, 2.0)));
    return check ? col1 : col2;
}
float tex_checker_f(const vec3 co, const float scale) {
    vec3 p = (co + 0.000001 * 0.999999) * scale;
    float xi = abs(floor(p.x));
    float yi = abs(floor(p.y));
    float zi = abs(floor(p.z));
    return float((mod(xi, 2.0) == mod(yi, 2.0)) == bool(mod(zi, 2.0)));
}
void main() {
vec3 n = normalize(wnormal);
	vec3 basecol;
	float roughness;
	float metallic;
	float occlusion;
	float specular;
	vec3 CheckerTexture_Color_res = tex_checker(bposition, vec3(0.800000011920929, 0.800000011920929, 0.800000011920929), vec3(0.20000000298023224, 0.20000000298023224, 0.20000000298023224), 2.0);
	basecol = CheckerTexture_Color_res;
	roughness = 0.10000000149011612;
	metallic = 0.0;
	occlusion = 1.0;
	specular = 0.5;
	n /= (abs(n.x) + abs(n.y) + abs(n.z));
	n.xy = n.z >= 0.0 ? n.xy : octahedronWrap(n.xy);
	fragColor[0] = vec4(n.xy, packFloat(metallic, roughness), 1.0);
	fragColor[1] = vec4(basecol.rgb, packFloat2(occlusion, specular));
}
