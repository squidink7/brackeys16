shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform sampler2D noise_texture;

// --- Layer 1: Base Waves (Large, slow movement) ---
uniform vec2 scroll_speed_1 = vec2(0.05, 0.08);
uniform float noise_scale_1 : hint_range(0.5, 10.0) = 3.0;
uniform float weight_1 : hint_range(0.0, 1.0) = 0.5;

// --- Layer 2: Mid Details (Medium scale, contrasting direction) ---
uniform vec2 scroll_speed_2 = vec2(-0.04, 0.03);
uniform float noise_scale_2 : hint_range(0.5, 10.0) = 6.0;
uniform float weight_2 : hint_range(0.0, 1.0) = 0.3;

// --- Layer 3: Fine Ripples (Small scale, faster movement) ---
uniform vec2 scroll_speed_3 = vec2(0.02, -0.06);
uniform float noise_scale_3 : hint_range(0.5, 10.0) = 12.0;
uniform float weight_3 : hint_range(0.0, 1.0) = 0.2;

uniform float distortion_strength : hint_range(0.0, 0.1) = 0.015; 

void fragment() {
	// 1. Calculate the animated UVs for each layer
	vec2 uv1 = (SCREEN_UV * noise_scale_1) + (TIME * scroll_speed_1);
	vec2 uv2 = (SCREEN_UV * noise_scale_2) + (TIME * scroll_speed_2);
	vec2 uv3 = (SCREEN_UV * noise_scale_3) + (TIME * scroll_speed_3);

	// 2. Sample the noise texture for each layer.
	vec4 noise1 = texture(noise_texture, fract(uv1));
	vec4 noise2 = texture(noise_texture, fract(uv2));
	vec4 noise3 = texture(noise_texture, fract(uv3));

	// 3. Blend the noise layers together using a weighted average
	float total_weight = max(0.001, weight_1 + weight_2 + weight_3);
	vec2 combined_noise = (noise1.rg * weight_1 + noise2.rg * weight_2 + noise3.rg * weight_3) / total_weight;

	// 4. Calculate distortion (map 0..1 to -1..1)
	vec2 distortion = (combined_noise * 2.0 - 1.0) * distortion_strength * 1.5;

	// 5. Apply the refraction to the screen
	vec2 distorted_uv = SCREEN_UV + distortion;
	vec4 screen_color = texture(SCREEN_TEXTURE, distorted_uv);

	// 6. Apply the subtle water tint
	float tint_factor = combined_noise.r * 0.05; 
	COLOR = screen_color;
}