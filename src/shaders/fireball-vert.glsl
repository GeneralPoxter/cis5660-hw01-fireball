#version 300 es

#define PI 3.141592653589793
#define HALF_PI 1.5707963267948966

precision highp float;

uniform mat4 u_Model;
uniform mat4 u_ModelInvTr;
uniform mat4 u_ViewProj;
uniform float u_Time;

in vec4 vs_Pos;
in vec4 vs_Nor;

out vec4 fs_Pos;

// Triangle wave
float triangle(float t, float period) {
    float p2 = period / 2.0;
    return abs(mod(t, period) - p2) / p2;
}

// FBM noise from @deanthecoder
// https://www.shadertoy.com/view/mdy3R1
float sum2(vec2 v) { return dot(v, vec2(1)); }

float n31(vec3 p) {
        const vec3 s = vec3(7, 157, 113);
        vec3 ip = floor(p);
        p = fract(p);
        p = p * p * (3. - 2. * p);
        vec4 h = vec4(0, s.yz, sum2(s.yz)) + dot(ip, s);
        h = mix(fract(sin(h) * 43758.545), fract(sin(h + s.x) * 43758.545), p.x);
        h.xy = mix(h.xz, h.yw, p.y);
        return mix(h.x, h.y, p.z);
}

float fbm(vec3 p, int octaves, float roughness) {
        float sum = 0.,
              amp = 1.,
              tot = 0.;
        roughness = clamp(roughness, 0., 1.);
        for (int i = 0; i < octaves; i++) {
                sum += amp * n31(p);
                tot += amp;
                amp *= roughness;
                p *= 2.;
        }
        return sum / tot;
}
// End of borrowed code

// Easing function from @glslify
// https://github.com/glslify/glsl-easings/tree/master
float backInOut(float t) {
  float f = t < 0.5
    ? 2.0 * t
    : 1.0 - (2.0 * t - 1.0);

  float g = pow(f, 3.0) - f * sin(f * PI);

  return t < 0.5
    ? 0.5 * g
    : 0.5 * (1.0 - g) + 0.5;
}
// End of borrowed code

void main() {
    vec3 pos = vs_Pos.xyz;
    float noiseAnim = 1.0 + 0.1 * triangle(u_Time, 1000.);
    pos += 0.3 * fbm(pos * 10. * noiseAnim, 8, 3.) * vs_Nor.xyz;
    float flameAnim = 0.4 + 1.8 * backInOut(triangle(u_Time, 200.));
    pos += 0.3 * vec3(
        sin(pos.x) * cos(pos.x),
        mix(0., flameAnim * tan(pos.y) * sin(pos.y), smoothstep(0.0, 0.8, pos.y)),
        sin(pos.z) * cos(pos.z)
    ) * vs_Nor.xyz;
    fs_Pos = vec4(pos, 1.);
    gl_Position = u_ViewProj * u_Model * fs_Pos;
}
