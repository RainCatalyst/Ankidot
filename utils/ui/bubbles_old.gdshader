shader_type canvas_item;

uniform vec4 color: source_color;
uniform vec4 wave_color_a: source_color;
uniform vec4 wave_color_b: source_color;

uniform float ratio;
uniform float resolution;
uniform float radius;
uniform float wave;
uniform float wave_amount;
uniform float speed;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec2 uv = vec2(UV.x, UV.y * ratio);// + vec2(TIME, TIME) * speed;
	vec2 cell_uv = fract(uv * resolution);
    vec2 center_offset = cell_uv - 0.5;
    float dist = length(center_offset);

	float aa = fwidth(dist);
	float angle = atan((UV.y + 0.5) / (UV.x + 0.5));
	float inf = sin(TIME * 0.75 + angle * 5.0);

	float wave_inf = 1.0 - smoothstep(0.0, 1.25, abs(UV.y - wave));

	float rad = radius * (1.0 + inf * 0.5);
	rad -= wave_inf * 0.05;
	//rad = mix(rad, 0.0, wave_inf);
	float circle = smoothstep(rad - aa, rad + aa, dist);
	//circle = 1.0;
	vec3 col_a = mix(COLOR.rgb, wave_color_a.rgb, wave_inf);
	vec3 col_b = mix(color.rgb, wave_color_b.rgb, wave_inf);
	COLOR.rgb = mix(col_a, col_b, 0.0);
}