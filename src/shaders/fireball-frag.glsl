#version 300 es

#define TWO_PI 6.28318530718

precision highp float;

uniform vec4 u_Color;
uniform float u_Time;

in vec4 fs_Pos;

out vec4 out_Col;

// Cosine-based color palette from @iq
// https://www.shadertoy.com/view/ll2GD3
vec3 palette( in float t, in vec3 a, in vec3 b, in vec3 c, in vec3 d )
{
    return a + b*cos( TWO_PI*(c*t+d) );
}


void main()
{
    // vec3 a = vec3(0.5,0.5,0.5);
    // vec3 b = vec3(0.5,0.5,0.5);
    // vec3 c = vec3(1.0,1.0,1.0);
    // vec3 d = vec3(0,0.25,0.25);
    // out_Col = vec4(palette(clamp(fs_Pos.y + sin(u_Time / 100.), 0.0, 1.0), a, b, c, d), 1.);
    out_Col = u_Color;
}
