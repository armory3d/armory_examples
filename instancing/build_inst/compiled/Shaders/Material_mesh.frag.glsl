#version 450
#include "compiled.inc"
#include "std/gbuffer.glsl"
in vec3 wnormal;
in vec4 wvpposition;
out vec4[2] fragColor;
void main() {
vec3 n = normalize(wnormal);
	vec3 basecol;
	float roughness;
	float metallic;
	float occlusion;
	float specular;
	basecol = vec3(1.0, 0.8361002802848816, 0.04198881983757019);
	roughness = 0.15000000596046448;
	metallic = 0.0;
	occlusion = 1.0;
	specular = 0.5;
	n /= (abs(n.x) + abs(n.y) + abs(n.z));
	n.xy = n.z >= 0.0 ? n.xy : octahedronWrap(n.xy);
	fragColor[0] = vec4(n.xy, packFloat(metallic, roughness), 1.0);
	fragColor[1] = vec4(basecol.rgb, packFloat2(occlusion, specular));
}
