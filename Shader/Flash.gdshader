shader_type canvas_item;

uniform float flash_state : hint_range(0.0, 1.0);

void fragment(){
	vec4 color = texture(TEXTURE, UV);
	COLOR = mix(color, vec4(1,1,1,1), flash_state);
	COLOR.a = color.a;
}
