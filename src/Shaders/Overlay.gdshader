shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture;

vec3 overlay(vec4 prev_color, vec4 current_color) {
	vec3 result;
	result.rgb = mix(2.0 * prev_color.rgb * current_color.rgb, 1.0 - 2.0 * (1.0 - current_color.rgb) * (1.0 - prev_color.rgb), round(prev_color.rgb));
	return result;
}

void fragment() {
	vec4 screen_color = texture(screen_texture, SCREEN_UV);
	COLOR.rgb = overlay(screen_color, COLOR);
}
