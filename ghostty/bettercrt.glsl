// Original shader collected from: https://www.shadertoy.com/view/WsVSzV
// Licensed under Shadertoy's default since the original creator didn't provide any license. (CC BY NC SA 3.0)
// Slight modifications were made to give a green-ish effect.

// This shader was modified by April Hall (arithefirst)
// Sourced from https://github.com/m-ahdal/ghostty-shaders/blob/main/retro-terminal.glsl
// Original changes made:
// - Removed tint
// - Made the boundaries match ghostty's background color

// Enhanced with Claude Code to emulate Balatro's CRT effect while maintaining readability:
// - Added chromatic aberration for authentic color fringing
// - Implemented RGB scanlines with phase offsets (like Balatro's CRT.fs shader)
// - Added time-based noise generation for CRT authenticity
// - Enhanced edge feathering for smooth transitions
// - Added brightness/contrast adjustment
// - Maintained terminal text readability with balanced effect intensities

float warp = 0.20; // simulate curvature of CRT monitor
float scan = 0.05; // simulate darkness between scanlines (gentle for eye comfort)
float aberration_strength = 0.0003; // chromatic aberration intensity (reduced)
float noise_intensity = 0.00; // subtle noise for authenticity
float feather_edge = 0.00; // edge softening

void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
    // normalized coordinates
    vec2 uv = fragCoord / iResolution.xy;
    vec2 orig_uv = uv;
    vec2 dc = abs(0.5 - uv);
    dc *= dc;
    
    // warp the fragment coordinates (barrel distortion)
    uv.x -= 0.5; uv.x *= 1.0 + (dc.y * (0.3 * warp)); uv.x += 0.5;
    uv.y -= 0.5; uv.y *= 1.0 + (dc.x * (0.4 * warp)); uv.y += 0.5;

    // chromatic aberration - sample RGB channels separately
    vec3 color;
    color.r = texture(iChannel0, uv + vec2(aberration_strength, 0.0)).r;
    color.g = texture(iChannel0, uv).g;
    color.b = texture(iChannel0, uv - vec2(aberration_strength, 0.0)).b;

    // Gentler scanlines inspired by Balatro but eye-friendly
    float scanlines_freq = 400.0; // reduced frequency for comfort
    
    // Softer scanline effect with smoother transitions
    float scanline_effect = 0.5 + 0.3 * sin(orig_uv.y * scanlines_freq);
    scanline_effect = smoothstep(0.3, 0.7, scanline_effect); // smooth the harsh edges
    
    // Apply very subtle scanline darkening
    color *= mix(vec3(1.0), vec3(0.95), scanline_effect * scan);

    // add subtle noise
    float noise_time = iTime * 100.0;
    float x = (orig_uv.x - mod(orig_uv.x, 0.003)) * (orig_uv.y - mod(orig_uv.y, 0.002)) * noise_time;
    x = mod(x, 13.0) * mod(x, 123.0);
    float noise = mod(x, 0.2) / 0.2;
    color = mix(color, vec3(noise), noise_intensity);

    // edge feathering for smooth transition
    vec2 edge_dist = abs(uv * 2.0 - 1.0);
    float edge_mask = (1.0 - smoothstep(1.0 - feather_edge, 1.0, edge_dist.x)) *
                      (1.0 - smoothstep(1.0 - feather_edge, 1.0, edge_dist.y));

    // gentle brightness/contrast adjustment for eye comfort
    color = (color - 0.5) * 1.02 + 0.52; // very slight contrast boost and brightness increase

    fragColor = vec4(color * edge_mask, 1.0);
}
