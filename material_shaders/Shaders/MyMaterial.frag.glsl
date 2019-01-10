#version 450

in vec3 mpos;
in vec3 normal;

out vec4 fragColor;

void main() {
	// Assuming forward rendering path for simplicity
	vec3 col = (mpos + vec3(1.0)) / 8.0;
	col += normal * 0.1;
	fragColor = vec4(col, 1.0);
}
