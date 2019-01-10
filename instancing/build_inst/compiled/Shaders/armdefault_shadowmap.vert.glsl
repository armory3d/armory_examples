#version 450
in vec4 pos;
uniform mat4 LWVP;
void main() {
vec4 spos = vec4(pos.xyz, 1.0);
	gl_Position = LWVP * spos;
}
