shader_type spatial;
uniform sampler2D noise;

//uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_linear_mipmap;varying vec3 uv1_triplanar_pos;
varying vec3 uv1_triplanar_pos;
varying vec3 uv1_power_normal;
uniform float uv1_blend_sharpness;
uniform vec3 uv1_scale;
uniform vec3 uv1_offset;

varying vec3 uv2_triplanar_pos;
varying vec3 uv2_power_normal;
uniform float uv2_blend_sharpness;
uniform vec3 uv2_scale;
uniform vec3 uv2_offset;
//uniform sampler2D texture_albedo : source_color,filter_linear_mipmap,repeat_enable;
uniform sampler2D texture_albedo : source_color,filter_linear_mipmap;

void vertex() {
	// Called for every vertex the material is visible on.
	vec3 normal = MODEL_NORMAL_MATRIX * NORMAL;
	uv1_power_normal=pow(abs(normal),vec3(uv1_blend_sharpness));
	uv1_triplanar_pos = (MODEL_MATRIX * vec4(VERTEX, 1.0f)).xyz * uv1_scale + uv1_offset;
	uv1_power_normal/=dot(uv1_power_normal,vec3(1.0));
	uv1_triplanar_pos *= vec3(1.0,-1.0, 1.0);

	uv2_power_normal=pow(abs(NORMAL), vec3(uv2_blend_sharpness));
	uv2_triplanar_pos = VERTEX * uv2_scale + uv2_offset;
	uv2_power_normal/=dot(uv2_power_normal,vec3(1.0));
	uv2_triplanar_pos *= vec3(1.0,-1.0, 1.0);
}

vec4 triplanar_texture(sampler2D p_sampler,vec3 p_weights,vec3 p_triplanar_pos) {
	vec4 samp=vec4(0.0);
	samp+= texture(p_sampler,p_triplanar_pos.xy) * p_weights.z;
	samp+= texture(p_sampler,p_triplanar_pos.xz) * p_weights.y;
	samp+= texture(p_sampler,p_triplanar_pos.zy * vec2(-1.0,1.0)) * p_weights.x;
	return samp;
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec3 uv = vec3(0.2, 0.0, 0.0)*TIME;
	float detail = texture(noise, UV).r;
	float color = texture(noise, UV + uv.rg + detail).r;
	//vec4 albedo_tex = triplanar_texture(texture_albedo,uv1_power_normal,uv1_triplanar_pos);
	vec3 albedo_tex = triplanar_texture(texture_albedo,uv2_power_normal,uv2_triplanar_pos).rgb;
	vec3 albedo_2 = triplanar_texture(texture_albedo,uv2_power_normal,uv2_triplanar_pos + uv + detail).rgb;
	ALBEDO = albedo_2;
	//ALBEDO = vec3(color);
	METALLIC = float(albedo_2.r);
	ROUGHNESS = float(albedo_2.r);
	//NORMAL = vec3(0,1,0);cos(TIME/2.0)
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
