shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform float multiplier = 1;
uniform sampler2D gradient;
uniform vec3 rgblum = vec3(0.299,0.587,0.114);

void fragment() {
	vec4 color = texture(SCREEN_TEXTURE, SCREEN_UV);
	float luminance = multiplier * (rgblum.r * color.r + rgblum.g * color.g + rgblum.b * color.b);
	color = texture(gradient, vec2(luminance,0));
	//color.a = 0.0;

	COLOR = color;
}