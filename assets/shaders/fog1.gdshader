shader_type fog;
uniform sampler3D noise;
uniform float p1;

void fog() {
	// Called once for every froxel that is touched by an axis-aligned bounding box
	// of the associated FogVolume. This means that froxels that just barely touch
	// a given FogVolume will still be used.
	vec3 uv = vec3(0.2, 0.2, 0.2) * TIME;
	float detail = texture(noise, WORLD_POSITION).r;
	float value = texture(noise, WORLD_POSITION + uv + detail).r;
	DENSITY = pow(value, 1.0) * 0.5;
	DENSITY = clamp(length(WORLD_POSITION - OBJECT_POSITION) * p1, 0.0, 1.0);
	//DENSITY = 1.0 - step(2.0, length(WORLD_POSITION - OBJECT_POSITION));
	//DENSITY *= step(0.0, -SDF);
	ALBEDO = vec3(1.0);
}
