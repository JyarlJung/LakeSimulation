shader_type canvas_item;

uniform sampler2D sim_tex;
uniform sampler2D col_tex;
uniform ivec2 size;

uniform float phase = 0.3;
uniform float attenuation = 0.996;
uniform float deltaUV = 0.6;

void fragment() {
	float du = 1.0 / float(size.x);
	float dv = 1.0 / float(size.y);
	vec3 duv = vec3(du, dv, 0) * deltaUV;

	vec3 c = texture(sim_tex, UV).rgb;

	float p = (2.0 * c.r - c.g + phase * (
		texture(sim_tex, fract(1.0 + UV - duv.zy)).r +
		texture(sim_tex, fract(UV + duv.zy)).r +
		texture(sim_tex, fract(1.0 + UV - duv.xz)).r +
		texture(sim_tex, fract(UV + duv.xz)).r - 4.0 * c.r)) * attenuation - 0.0002;
		
	vec2 col_uv = vec2(UV.x, 1.0 - UV.y);
	float col = texture(col_tex, col_uv).r + (texture(col_tex, col_uv).b*0.75);
	float prevCol = texture(sim_tex, UV).b;
	
	if (col > 0.0 && prevCol == 0.0) {
		p += col * 0.5;
	}
	
	if (prevCol > 0.0 && col == 0.0) {
		p -= prevCol * 0.5;
	}
	COLOR = vec4(p, c.r, col, 1.0);
}
