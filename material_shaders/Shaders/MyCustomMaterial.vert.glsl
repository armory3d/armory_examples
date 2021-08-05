#version 450

// Armory uses packed vertex data to preserve memory
in vec4 pos; // pos.xyz, nor.z
in vec2 nor; // nor.xy

uniform mat4 WVP;
uniform mat3 N;
uniform float posUnpack;
uniform float time;
uniform float myParam;

out vec3 mpos;
out vec3 normal;

void main() {
	vec4 p = vec4(pos.xyz, 1.0);

	// Position data is packed into (-1, 1) range
	// Retrieve model position
	mpos = pos.xyz * posUnpack;

	// Unpack normal.z component from pos.w
	normal = N * vec3(nor.xy, pos.w);
	
	p.z += sin((time + mpos.x + mpos.y) * 2.0) * 0.2 * myParam;
	gl_Position = WVP * p;
}
