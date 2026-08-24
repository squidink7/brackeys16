shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform float blur_amount = 0.25;

void fragment()
{
	vec4 screen = textureLod(SCREEN_TEXTURE, SCREEN_UV, blur_amount);
    COLOR = screen;
	COLOR  = vec4(COLOR.r, COLOR.g, COLOR.b, 0);
}