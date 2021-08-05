#version 450

in vec3 mpos;
in vec3 normal;

// Color of each fragment on the screen
out vec4 fragColor;

void main() {
    // Shadeless red color
    //fragColor = vec4(1.0,0.0,0.0,0.0);

    // Assuming forward rendering path for simplicity
	vec3 col = (mpos + vec3(1.0)) / 8.0;
	col += normal * 0.1;
	fragColor = vec4(col, 1.0);
}
