shader_type spatial;

render_mode blend_add;

uniform vec3 rain_color:source_color;

void fragment() {
	float NdotV = dot(NORMAL,VIEW);
	//vec3 emission = mix(vec3(0.0),texture(screen_texture,SCREEN_UV).rgb,1.0);
	vec3 albedo = mix(vec3(0.0),rain_color,1.0-NdotV);
	ROUGHNESS = 0.01;
	METALLIC = 0.6;
	//EMISSION = emission;
	ALBEDO = albedo;
	// Place fragment code here.
}
