shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform sampler2D noise_texture;

uniform vec2 scroll_speed = vec2(0.05, 0.08);
uniform float noise_scale : hint_range(0.5, 10.0) = 3.0;

uniform float distortion_strength : hint_range(0.0, 0.05) = 0.005;
uniform vec4 water_tint : source_color = vec4(0.75, 0.85, 1.0, 0.02);

void fragment() {
    // 1. Calculate the raw animated UVs
    vec2 raw_noise_uv = (UV * noise_scale) + (TIME * scroll_speed);

    // 2. Force the UVs to wrap around using fract().
    // This ensures the texture repeats infinitely across the screen 
    // and never scrolls off the edge.
    vec2 noise_uv = fract(raw_noise_uv);

    // 3. Sample the noise texture
    vec4 noise = texture(noise_texture, noise_uv);

    // 4. Calculate distortion (map 0..1 to -1..1)
    vec2 distortion = (noise.rg * 2.0 - 1.0) * distortion_strength;

    // 5. Apply the refraction to the screen
    vec2 distorted_uv = UV + distortion;
    vec4 screen_color = texture(SCREEN_TEXTURE, distorted_uv);

    // 6. Apply the subtle water tint
    COLOR = mix(screen_color, water_tint, water_tint.a);
}