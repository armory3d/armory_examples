#version 450
in vec4 pos;
in vec3 ipos;
in vec3 irot;
in vec3 iscl;
uniform mat4 LWVP;
void main() {
vec4 spos = vec4(pos.xyz, 1.0);
	float srotx = sin(irot.x);
	float crotx = cos(irot.x);
	float sroty = sin(irot.y);
	float croty = cos(irot.y);
	float srotz = sin(irot.z);
	float crotz = cos(irot.z);
	mat3 mirot = mat3(
	    croty * crotz, srotz, -sroty * crotz,
	    -croty * srotz * crotx + sroty * srotx, crotz * crotx, sroty * srotz * crotx + croty * srotx,
	    croty * srotz * srotx + sroty * crotx, -crotz * srotx, -sroty * srotz * srotx + croty * crotx
	);
	spos.xyz = mirot * spos.xyz;
	spos.xyz *= iscl;
	spos.xyz += ipos;
	gl_Position = LWVP * spos;
}
