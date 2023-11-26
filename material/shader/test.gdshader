shader_type spatial;

render_mode unshaded;

uniform sampler2D depth_texture : hint_depth_texture,filter_nearest;
uniform sampler2D screen_texture : hint_screen_texture,filter_nearest;
vec3 uv_to_view(vec2 uv, float depth, mat4 inv_proj_m)
{
	vec4 position_ndc = vec4((uv * 2.0) - 1.0, depth, 1.0);
	vec4 view_position = inv_proj_m * position_ndc;
	return view_position.xyz / view_position.w;
}
void fragment() {
	float depth = texture(depth_texture, SCREEN_UV).r;
	vec3 vec = uv_to_view(SCREEN_UV,depth,INV_PROJECTION_MATRIX);
	ALBEDO = vec3(-vec.z * 0.001);
}
