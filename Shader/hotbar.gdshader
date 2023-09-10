// NOTE: Shader automatically converted from Godot Engine 4.1.1.stable's CanvasItemMaterial.

shader_type canvas_item;

uniform vec4 mix_color : source_color;

void fragment(){
	vec4 color = texture(TEXTURE, UV);
	COLOR = mix(color, mix_color, 1);
}
