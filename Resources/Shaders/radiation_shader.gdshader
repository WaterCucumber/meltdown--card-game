shader_type canvas_item;

uniform vec4 modulate: source_color;

float tint(float offset, float speed, float max_value, float amplitude)
{
	return amplitude * (sin(offset + speed * 0.5 * TIME) /
			(max_value + 1.0)
			+ max_value / 2.0);
}

void vertex() {
	vec2 pos = VERTEX;
	float x = tint(1,10,0,tint(1,1,1,5));
	pos += vec2(x,1) * tint(1,10,0,tint(1,1,1,10));  // Смещение по X и Y
	VERTEX = pos;
}

void fragment()
{
	vec2 offsetted_uv = UV;
	vec4 color = COLOR;
	float multiplier = 0.5 * tint(0, 5, tint(PI / 2.0, 0.1, 1.0, 1), 1) + 0.75 * tint(PI / 2.0, 1, 1, 0.8);

	float x = offsetted_uv.x + tint(0, 1.0, 1.0, 1);
	float y = offsetted_uv.y + tint(PI / 2.0, tint(PI / 2.0, 0.1, 1.0, 1), 1.0, 1);
	offsetted_uv = vec2(x, y);
	vec4 new_color = texture(TEXTURE, offsetted_uv);

	new_color = color + vec4(multiplier) * vec4(1,1,0,1);
	color = new_color;

	COLOR = color * modulate;
}
