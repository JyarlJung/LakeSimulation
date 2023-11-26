
shader_type spatial;
render_mode unshaded, blend_add;
uniform vec4 albedo = vec4(1.0,1.0,1.0,1.0);
uniform sampler2D albedo_texture;
uniform float Saturation: hint_range(0.5,1) = 1.0;
uniform float PulseRate = 5.0;
uniform float PulseIntensity = 0.1;
uniform float Opacity : hint_range(0,1) = 1.0;
uniform sampler2D screen_textur:hint_screen_texture;
uniform float lod: hint_range(0.0, 5) = 0.0;
void vertex() {
	// Pulsating angular frequency: time * rate * 2pi
	float pulse_freq = TIME*PulseRate*6.2831853;
	// Pulsating amplitude: sine wave shifted and scaled to range 0.0 - 1.0
	float pulse_val = 0.5*(sin(pulse_freq)+1.0);
	// Sine^4 causes the wave to have strong fast peaks with larger intervals
	pulse_val = pow(pulse_val, 4);
	// Move the vertices along their own normals,
	// Using the generated wave and PulseIntensity
	VERTEX += NORMAL*(pulse_val*PulseIntensity);
}

void fragment() {
	// Color/texture is straight forward
	vec4 albedo_tex = texture(albedo_texture,UV);
	vec3 view = VIEW;
	view = normalize(view);
	float NdotV = pow(dot(NORMAL,view),5.0);
	ALBEDO = albedo.rgb * albedo_tex.rgb * NdotV;
	
	// How much is this normal aligned to camera:
	float normal_dot = dot(NORMAL, vec3(0,0,1));
	// Avoid negative numbers:
	normal_dot = max(normal_dot, 1.0);
	// Find the angle given normal Z as sin (in range 0.0 - pi/4)
	// And convert to range 0.0 - 1.0 (where pi/4 ~= 0.785398)
	float arc = asin(normal_dot*Saturation)/0.785398;
	// Power causes the values to smooth towards zero
	arc = pow(arc,10);
	// Starting value for alpha uses our angle, 
	// albedo alpha channel and the opacity parameter
	float alpha_value = arc*albedo.a*Opacity;
	// Opacity limits the maximum value
	alpha_value = min(Opacity, alpha_value);
	// Finally apply the alpha
	ALPHA = (alpha_value);
	
	vec4 color = texture(screen_textur, SCREEN_UV, lod);
	//ALBEDO = color.rgb;
}